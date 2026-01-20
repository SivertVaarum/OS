
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000e117          	auipc	sp,0xe
    80000004:	de813103          	ld	sp,-536(sp) # 8000dde8 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    800001d4:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <end+0xffffffff7ffd7557>
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
    800002e8:	b4c70713          	addi	a4,a4,-1204 # 80015e30 <timer_scratch>
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
    8000032c:	4e878793          	addi	a5,a5,1256 # 80008810 <timervec>
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
    8000047c:	af850513          	addi	a0,a0,-1288 # 80015f70 <cons>
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
    800004a6:	ace50513          	addi	a0,a0,-1330 # 80015f70 <cons>
    800004aa:	00001097          	auipc	ra,0x1
    800004ae:	e38080e7          	jalr	-456(ra) # 800012e2 <release>
        return -1;
    800004b2:	57fd                	li	a5,-1
    800004b4:	aa25                	j	800005ec <consoleread+0x196>
      }
      sleep(&cons.r, &cons.lock);
    800004b6:	00016597          	auipc	a1,0x16
    800004ba:	aba58593          	addi	a1,a1,-1350 # 80015f70 <cons>
    800004be:	00016517          	auipc	a0,0x16
    800004c2:	b4a50513          	addi	a0,a0,-1206 # 80016008 <cons+0x98>
    800004c6:	00003097          	auipc	ra,0x3
    800004ca:	f42080e7          	jalr	-190(ra) # 80003408 <sleep>
    while(cons.r == cons.w){
    800004ce:	00016797          	auipc	a5,0x16
    800004d2:	aa278793          	addi	a5,a5,-1374 # 80015f70 <cons>
    800004d6:	0987a703          	lw	a4,152(a5)
    800004da:	00016797          	auipc	a5,0x16
    800004de:	a9678793          	addi	a5,a5,-1386 # 80015f70 <cons>
    800004e2:	09c7a783          	lw	a5,156(a5)
    800004e6:	faf702e3          	beq	a4,a5,8000048a <consoleread+0x34>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800004ea:	00016797          	auipc	a5,0x16
    800004ee:	a8678793          	addi	a5,a5,-1402 # 80015f70 <cons>
    800004f2:	0987a783          	lw	a5,152(a5)
    800004f6:	2781                	sext.w	a5,a5
    800004f8:	0017871b          	addiw	a4,a5,1
    800004fc:	0007069b          	sext.w	a3,a4
    80000500:	00016717          	auipc	a4,0x16
    80000504:	a7070713          	addi	a4,a4,-1424 # 80015f70 <cons>
    80000508:	08d72c23          	sw	a3,152(a4)
    8000050c:	07f7f793          	andi	a5,a5,127
    80000510:	2781                	sext.w	a5,a5
    80000512:	00016717          	auipc	a4,0x16
    80000516:	a5e70713          	addi	a4,a4,-1442 # 80015f70 <cons>
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
    80000548:	a2c78793          	addi	a5,a5,-1492 # 80015f70 <cons>
    8000054c:	0987a783          	lw	a5,152(a5)
    80000550:	37fd                	addiw	a5,a5,-1
    80000552:	0007871b          	sext.w	a4,a5
    80000556:	00016797          	auipc	a5,0x16
    8000055a:	a1a78793          	addi	a5,a5,-1510 # 80015f70 <cons>
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
    800005d0:	9a450513          	addi	a0,a0,-1628 # 80015f70 <cons>
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
    80000608:	96c50513          	addi	a0,a0,-1684 # 80015f70 <cons>
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
    8000067a:	8fa78793          	addi	a5,a5,-1798 # 80015f70 <cons>
    8000067e:	0a07a783          	lw	a5,160(a5)
    80000682:	37fd                	addiw	a5,a5,-1
    80000684:	0007871b          	sext.w	a4,a5
    80000688:	00016797          	auipc	a5,0x16
    8000068c:	8e878793          	addi	a5,a5,-1816 # 80015f70 <cons>
    80000690:	0ae7a023          	sw	a4,160(a5)
      consputc(BACKSPACE);
    80000694:	10000513          	li	a0,256
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	cdc080e7          	jalr	-804(ra) # 80000374 <consputc>
    while(cons.e != cons.w &&
    800006a0:	00016797          	auipc	a5,0x16
    800006a4:	8d078793          	addi	a5,a5,-1840 # 80015f70 <cons>
    800006a8:	0a07a703          	lw	a4,160(a5)
    800006ac:	00016797          	auipc	a5,0x16
    800006b0:	8c478793          	addi	a5,a5,-1852 # 80015f70 <cons>
    800006b4:	09c7a783          	lw	a5,156(a5)
    800006b8:	18f70463          	beq	a4,a5,80000840 <consoleintr+0x24a>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800006bc:	00016797          	auipc	a5,0x16
    800006c0:	8b478793          	addi	a5,a5,-1868 # 80015f70 <cons>
    800006c4:	0a07a783          	lw	a5,160(a5)
    800006c8:	37fd                	addiw	a5,a5,-1
    800006ca:	2781                	sext.w	a5,a5
    800006cc:	07f7f793          	andi	a5,a5,127
    800006d0:	2781                	sext.w	a5,a5
    800006d2:	00016717          	auipc	a4,0x16
    800006d6:	89e70713          	addi	a4,a4,-1890 # 80015f70 <cons>
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
    800006f2:	88278793          	addi	a5,a5,-1918 # 80015f70 <cons>
    800006f6:	0a07a703          	lw	a4,160(a5)
    800006fa:	00016797          	auipc	a5,0x16
    800006fe:	87678793          	addi	a5,a5,-1930 # 80015f70 <cons>
    80000702:	09c7a783          	lw	a5,156(a5)
    80000706:	12f70f63          	beq	a4,a5,80000844 <consoleintr+0x24e>
      cons.e--;
    8000070a:	00016797          	auipc	a5,0x16
    8000070e:	86678793          	addi	a5,a5,-1946 # 80015f70 <cons>
    80000712:	0a07a783          	lw	a5,160(a5)
    80000716:	37fd                	addiw	a5,a5,-1
    80000718:	0007871b          	sext.w	a4,a5
    8000071c:	00016797          	auipc	a5,0x16
    80000720:	85478793          	addi	a5,a5,-1964 # 80015f70 <cons>
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
    80000744:	83078793          	addi	a5,a5,-2000 # 80015f70 <cons>
    80000748:	0a07a703          	lw	a4,160(a5)
    8000074c:	00016797          	auipc	a5,0x16
    80000750:	82478793          	addi	a5,a5,-2012 # 80015f70 <cons>
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
    80000790:	00015797          	auipc	a5,0x15
    80000794:	7e078793          	addi	a5,a5,2016 # 80015f70 <cons>
    80000798:	0a07a783          	lw	a5,160(a5)
    8000079c:	2781                	sext.w	a5,a5
    8000079e:	0017871b          	addiw	a4,a5,1
    800007a2:	0007069b          	sext.w	a3,a4
    800007a6:	00015717          	auipc	a4,0x15
    800007aa:	7ca70713          	addi	a4,a4,1994 # 80015f70 <cons>
    800007ae:	0ad72023          	sw	a3,160(a4)
    800007b2:	07f7f793          	andi	a5,a5,127
    800007b6:	2781                	sext.w	a5,a5
    800007b8:	fec42703          	lw	a4,-20(s0)
    800007bc:	0ff77713          	zext.b	a4,a4
    800007c0:	00015697          	auipc	a3,0x15
    800007c4:	7b068693          	addi	a3,a3,1968 # 80015f70 <cons>
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
    800007f2:	78278793          	addi	a5,a5,1922 # 80015f70 <cons>
    800007f6:	0a07a703          	lw	a4,160(a5)
    800007fa:	00015797          	auipc	a5,0x15
    800007fe:	77678793          	addi	a5,a5,1910 # 80015f70 <cons>
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
    8000081a:	75a78793          	addi	a5,a5,1882 # 80015f70 <cons>
    8000081e:	0a07a703          	lw	a4,160(a5)
    80000822:	00015797          	auipc	a5,0x15
    80000826:	74e78793          	addi	a5,a5,1870 # 80015f70 <cons>
    8000082a:	08e7ae23          	sw	a4,156(a5)
        wakeup(&cons.r);
    8000082e:	00015517          	auipc	a0,0x15
    80000832:	7da50513          	addi	a0,a0,2010 # 80016008 <cons+0x98>
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
    8000084e:	72650513          	addi	a0,a0,1830 # 80015f70 <cons>
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
    80000878:	6fc50513          	addi	a0,a0,1788 # 80015f70 <cons>
    8000087c:	00001097          	auipc	ra,0x1
    80000880:	9d2080e7          	jalr	-1582(ra) # 8000124e <initlock>

  uartinit();
    80000884:	00000097          	auipc	ra,0x0
    80000888:	490080e7          	jalr	1168(ra) # 80000d14 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000088c:	00026797          	auipc	a5,0x26
    80000890:	88478793          	addi	a5,a5,-1916 # 80026110 <devsw>
    80000894:	00000717          	auipc	a4,0x0
    80000898:	bc270713          	addi	a4,a4,-1086 # 80000456 <consoleread>
    8000089c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000089e:	00026797          	auipc	a5,0x26
    800008a2:	87278793          	addi	a5,a5,-1934 # 80026110 <devsw>
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
    80000934:	38068693          	addi	a3,a3,896 # 8000dcb0 <digits>
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
    800009f2:	2c270713          	addi	a4,a4,706 # 8000dcb0 <digits>
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
    80000a56:	5c678793          	addi	a5,a5,1478 # 80016018 <pr>
    80000a5a:	4f9c                	lw	a5,24(a5)
    80000a5c:	fcf42e23          	sw	a5,-36(s0)
  if(locking)
    80000a60:	fdc42783          	lw	a5,-36(s0)
    80000a64:	2781                	sext.w	a5,a5
    80000a66:	cb89                	beqz	a5,80000a78 <printf+0x44>
    acquire(&pr.lock);
    80000a68:	00015517          	auipc	a0,0x15
    80000a6c:	5b050513          	addi	a0,a0,1456 # 80016018 <pr>
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
    80000c74:	3a850513          	addi	a0,a0,936 # 80016018 <pr>
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
    80000c9a:	38278793          	addi	a5,a5,898 # 80016018 <pr>
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
    80000cd2:	13278793          	addi	a5,a5,306 # 8000de00 <panicked>
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
    80000cf2:	32a50513          	addi	a0,a0,810 # 80016018 <pr>
    80000cf6:	00000097          	auipc	ra,0x0
    80000cfa:	558080e7          	jalr	1368(ra) # 8000124e <initlock>
  pr.locking = 1;
    80000cfe:	00015797          	auipc	a5,0x15
    80000d02:	31a78793          	addi	a5,a5,794 # 80016018 <pr>
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
    80000d78:	2c450513          	addi	a0,a0,708 # 80016038 <uart_tx_lock>
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
    80000da0:	29c50513          	addi	a0,a0,668 # 80016038 <uart_tx_lock>
    80000da4:	00000097          	auipc	ra,0x0
    80000da8:	4da080e7          	jalr	1242(ra) # 8000127e <acquire>

  if(panicked){
    80000dac:	0000d797          	auipc	a5,0xd
    80000db0:	05478793          	addi	a5,a5,84 # 8000de00 <panicked>
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
    80000dc2:	27a58593          	addi	a1,a1,634 # 80016038 <uart_tx_lock>
    80000dc6:	0000d517          	auipc	a0,0xd
    80000dca:	04a50513          	addi	a0,a0,74 # 8000de10 <uart_tx_r>
    80000dce:	00002097          	auipc	ra,0x2
    80000dd2:	63a080e7          	jalr	1594(ra) # 80003408 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000dd6:	0000d797          	auipc	a5,0xd
    80000dda:	03a78793          	addi	a5,a5,58 # 8000de10 <uart_tx_r>
    80000dde:	639c                	ld	a5,0(a5)
    80000de0:	02078713          	addi	a4,a5,32
    80000de4:	0000d797          	auipc	a5,0xd
    80000de8:	02478793          	addi	a5,a5,36 # 8000de08 <uart_tx_w>
    80000dec:	639c                	ld	a5,0(a5)
    80000dee:	fcf708e3          	beq	a4,a5,80000dbe <uartputc+0x30>
  }
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000df2:	0000d797          	auipc	a5,0xd
    80000df6:	01678793          	addi	a5,a5,22 # 8000de08 <uart_tx_w>
    80000dfa:	639c                	ld	a5,0(a5)
    80000dfc:	8bfd                	andi	a5,a5,31
    80000dfe:	fec42703          	lw	a4,-20(s0)
    80000e02:	0ff77713          	zext.b	a4,a4
    80000e06:	00015697          	auipc	a3,0x15
    80000e0a:	24a68693          	addi	a3,a3,586 # 80016050 <uart_tx_buf>
    80000e0e:	97b6                	add	a5,a5,a3
    80000e10:	00e78023          	sb	a4,0(a5)
  uart_tx_w += 1;
    80000e14:	0000d797          	auipc	a5,0xd
    80000e18:	ff478793          	addi	a5,a5,-12 # 8000de08 <uart_tx_w>
    80000e1c:	639c                	ld	a5,0(a5)
    80000e1e:	00178713          	addi	a4,a5,1
    80000e22:	0000d797          	auipc	a5,0xd
    80000e26:	fe678793          	addi	a5,a5,-26 # 8000de08 <uart_tx_w>
    80000e2a:	e398                	sd	a4,0(a5)
  uartstart();
    80000e2c:	00000097          	auipc	ra,0x0
    80000e30:	086080e7          	jalr	134(ra) # 80000eb2 <uartstart>
  release(&uart_tx_lock);
    80000e34:	00015517          	auipc	a0,0x15
    80000e38:	20450513          	addi	a0,a0,516 # 80016038 <uart_tx_lock>
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
    80000e68:	f9c78793          	addi	a5,a5,-100 # 8000de00 <panicked>
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
    80000ebe:	f4e78793          	addi	a5,a5,-178 # 8000de08 <uart_tx_w>
    80000ec2:	6398                	ld	a4,0(a5)
    80000ec4:	0000d797          	auipc	a5,0xd
    80000ec8:	f4c78793          	addi	a5,a5,-180 # 8000de10 <uart_tx_r>
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
    80000eee:	f2678793          	addi	a5,a5,-218 # 8000de10 <uart_tx_r>
    80000ef2:	639c                	ld	a5,0(a5)
    80000ef4:	8bfd                	andi	a5,a5,31
    80000ef6:	00015717          	auipc	a4,0x15
    80000efa:	15a70713          	addi	a4,a4,346 # 80016050 <uart_tx_buf>
    80000efe:	97ba                	add	a5,a5,a4
    80000f00:	0007c783          	lbu	a5,0(a5)
    80000f04:	fef42623          	sw	a5,-20(s0)
    uart_tx_r += 1;
    80000f08:	0000d797          	auipc	a5,0xd
    80000f0c:	f0878793          	addi	a5,a5,-248 # 8000de10 <uart_tx_r>
    80000f10:	639c                	ld	a5,0(a5)
    80000f12:	00178713          	addi	a4,a5,1
    80000f16:	0000d797          	auipc	a5,0xd
    80000f1a:	efa78793          	addi	a5,a5,-262 # 8000de10 <uart_tx_r>
    80000f1e:	e398                	sd	a4,0(a5)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000f20:	0000d517          	auipc	a0,0xd
    80000f24:	ef050513          	addi	a0,a0,-272 # 8000de10 <uart_tx_r>
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
    80000fc0:	07c50513          	addi	a0,a0,124 # 80016038 <uart_tx_lock>
    80000fc4:	00000097          	auipc	ra,0x0
    80000fc8:	2ba080e7          	jalr	698(ra) # 8000127e <acquire>
  uartstart();
    80000fcc:	00000097          	auipc	ra,0x0
    80000fd0:	ee6080e7          	jalr	-282(ra) # 80000eb2 <uartstart>
  release(&uart_tx_lock);
    80000fd4:	00015517          	auipc	a0,0x15
    80000fd8:	06450513          	addi	a0,a0,100 # 80016038 <uart_tx_lock>
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
    80001002:	07250513          	addi	a0,a0,114 # 80016070 <kmem>
    80001006:	00000097          	auipc	ra,0x0
    8000100a:	248080e7          	jalr	584(ra) # 8000124e <initlock>
  freerange(end, (void*)PHYSTOP);
    8000100e:	47c5                	li	a5,17
    80001010:	01b79593          	slli	a1,a5,0x1b
    80001014:	00026517          	auipc	a0,0x26
    80001018:	29450513          	addi	a0,a0,660 # 800272a8 <end>
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
    800010a6:	20678793          	addi	a5,a5,518 # 800272a8 <end>
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
    800010e6:	f8e50513          	addi	a0,a0,-114 # 80016070 <kmem>
    800010ea:	00000097          	auipc	ra,0x0
    800010ee:	194080e7          	jalr	404(ra) # 8000127e <acquire>
  r->next = kmem.freelist;
    800010f2:	00015797          	auipc	a5,0x15
    800010f6:	f7e78793          	addi	a5,a5,-130 # 80016070 <kmem>
    800010fa:	6f98                	ld	a4,24(a5)
    800010fc:	fe843783          	ld	a5,-24(s0)
    80001100:	e398                	sd	a4,0(a5)
  kmem.freelist = r;
    80001102:	00015797          	auipc	a5,0x15
    80001106:	f6e78793          	addi	a5,a5,-146 # 80016070 <kmem>
    8000110a:	fe843703          	ld	a4,-24(s0)
    8000110e:	ef98                	sd	a4,24(a5)
  release(&kmem.lock);
    80001110:	00015517          	auipc	a0,0x15
    80001114:	f6050513          	addi	a0,a0,-160 # 80016070 <kmem>
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
    80001136:	f3e50513          	addi	a0,a0,-194 # 80016070 <kmem>
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	144080e7          	jalr	324(ra) # 8000127e <acquire>
  r = kmem.freelist;
    80001142:	00015797          	auipc	a5,0x15
    80001146:	f2e78793          	addi	a5,a5,-210 # 80016070 <kmem>
    8000114a:	6f9c                	ld	a5,24(a5)
    8000114c:	fef43423          	sd	a5,-24(s0)
  if(r)
    80001150:	fe843783          	ld	a5,-24(s0)
    80001154:	cb89                	beqz	a5,80001166 <kalloc+0x3c>
    kmem.freelist = r->next;
    80001156:	fe843783          	ld	a5,-24(s0)
    8000115a:	6398                	ld	a4,0(a5)
    8000115c:	00015797          	auipc	a5,0x15
    80001160:	f1478793          	addi	a5,a5,-236 # 80016070 <kmem>
    80001164:	ef98                	sd	a4,24(a5)
  release(&kmem.lock);
    80001166:	00015517          	auipc	a0,0x15
    8000116a:	f0a50513          	addi	a0,a0,-246 # 80016070 <kmem>
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
    80001880:	186080e7          	jalr	390(ra) # 80003a02 <trapinit>
    trapinithart();  // install kernel trap vector
    80001884:	00002097          	auipc	ra,0x2
    80001888:	1a8080e7          	jalr	424(ra) # 80003a2c <trapinithart>
    plicinit();      // set up interrupt controller
    8000188c:	00007097          	auipc	ra,0x7
    80001890:	fae080e7          	jalr	-82(ra) # 8000883a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001894:	00007097          	auipc	ra,0x7
    80001898:	fca080e7          	jalr	-54(ra) # 8000885e <plicinithart>
    binit();         // buffer cache
    8000189c:	00003097          	auipc	ra,0x3
    800018a0:	b84080e7          	jalr	-1148(ra) # 80004420 <binit>
    iinit();         // inode table
    800018a4:	00003097          	auipc	ra,0x3
    800018a8:	3ba080e7          	jalr	954(ra) # 80004c5e <iinit>
    fileinit();      // file table
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	d98080e7          	jalr	-616(ra) # 80006644 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800018b4:	00007097          	auipc	ra,0x7
    800018b8:	07e080e7          	jalr	126(ra) # 80008932 <virtio_disk_init>
    userinit();      // first user process
    800018bc:	00001097          	auipc	ra,0x1
    800018c0:	30a080e7          	jalr	778(ra) # 80002bc6 <userinit>
    __sync_synchronize();
    800018c4:	0330000f          	fence	rw,rw
    started = 1;
    800018c8:	00014797          	auipc	a5,0x14
    800018cc:	7c878793          	addi	a5,a5,1992 # 80016090 <started>
    800018d0:	4705                	li	a4,1
    800018d2:	c398                	sw	a4,0(a5)
    800018d4:	a0a9                	j	8000191e <main+0x116>
  } else {
    while(started == 0)
    800018d6:	0001                	nop
    800018d8:	00014797          	auipc	a5,0x14
    800018dc:	7b878793          	addi	a5,a5,1976 # 80016090 <started>
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
    80001912:	11e080e7          	jalr	286(ra) # 80003a2c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001916:	00007097          	auipc	ra,0x7
    8000191a:	f48080e7          	jalr	-184(ra) # 8000885e <plicinithart>
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
    80001a6e:	3ae78793          	addi	a5,a5,942 # 8000de18 <kernel_pagetable>
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
    80001a92:	38a78793          	addi	a5,a5,906 # 8000de18 <kernel_pagetable>
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
    80001ccc:	fff78713          	addi	a4,a5,-1 # ffffffffffffefff <end+0xffffffff7ffd7d57>
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
    8000210e:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffd7d58>
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
    8000266e:	e2e78793          	addi	a5,a5,-466 # 80016498 <proc>
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
    800026a2:	dfa78793          	addi	a5,a5,-518 # 80016498 <proc>
    800026a6:	40f707b3          	sub	a5,a4,a5
    800026aa:	4037d713          	srai	a4,a5,0x3
    800026ae:	00009797          	auipc	a5,0x9
    800026b2:	c0a78793          	addi	a5,a5,-1014 # 8000b2b8 <etext+0x2b8>
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
    80002702:	00019797          	auipc	a5,0x19
    80002706:	79678793          	addi	a5,a5,1942 # 8001be98 <pid_lock>
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
    8000272e:	76e50513          	addi	a0,a0,1902 # 8001be98 <pid_lock>
    80002732:	fffff097          	auipc	ra,0xfffff
    80002736:	b1c080e7          	jalr	-1252(ra) # 8000124e <initlock>
  initlock(&wait_lock, "wait_lock");
    8000273a:	00009597          	auipc	a1,0x9
    8000273e:	a9658593          	addi	a1,a1,-1386 # 8000b1d0 <etext+0x1d0>
    80002742:	00019517          	auipc	a0,0x19
    80002746:	76e50513          	addi	a0,a0,1902 # 8001beb0 <wait_lock>
    8000274a:	fffff097          	auipc	ra,0xfffff
    8000274e:	b04080e7          	jalr	-1276(ra) # 8000124e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002752:	00014797          	auipc	a5,0x14
    80002756:	d4678793          	addi	a5,a5,-698 # 80016498 <proc>
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
    80002786:	d1678793          	addi	a5,a5,-746 # 80016498 <proc>
    8000278a:	40f707b3          	sub	a5,a4,a5
    8000278e:	4037d713          	srai	a4,a5,0x3
    80002792:	00009797          	auipc	a5,0x9
    80002796:	b2678793          	addi	a5,a5,-1242 # 8000b2b8 <etext+0x2b8>
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
    800027d4:	6c878793          	addi	a5,a5,1736 # 8001be98 <pid_lock>
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
    8000282e:	86e78793          	addi	a5,a5,-1938 # 80016098 <cpus>
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
    8000288e:	60e50513          	addi	a0,a0,1550 # 8001be98 <pid_lock>
    80002892:	fffff097          	auipc	ra,0xfffff
    80002896:	9ec080e7          	jalr	-1556(ra) # 8000127e <acquire>
  pid = nextpid;
    8000289a:	0000b797          	auipc	a5,0xb
    8000289e:	40678793          	addi	a5,a5,1030 # 8000dca0 <nextpid>
    800028a2:	439c                	lw	a5,0(a5)
    800028a4:	fef42623          	sw	a5,-20(s0)
  nextpid = nextpid + 1;
    800028a8:	0000b797          	auipc	a5,0xb
    800028ac:	3f878793          	addi	a5,a5,1016 # 8000dca0 <nextpid>
    800028b0:	439c                	lw	a5,0(a5)
    800028b2:	2785                	addiw	a5,a5,1
    800028b4:	0007871b          	sext.w	a4,a5
    800028b8:	0000b797          	auipc	a5,0xb
    800028bc:	3e878793          	addi	a5,a5,1000 # 8000dca0 <nextpid>
    800028c0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800028c2:	00019517          	auipc	a0,0x19
    800028c6:	5d650513          	addi	a0,a0,1494 # 8001be98 <pid_lock>
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
    800028ec:	bb078793          	addi	a5,a5,-1104 # 80016498 <proc>
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
    8000292e:	56e78793          	addi	a5,a5,1390 # 8001be98 <pid_lock>
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
    80002bde:	24678793          	addi	a5,a5,582 # 8000de20 <initproc>
    80002be2:	fe843703          	ld	a4,-24(s0)
    80002be6:	e398                	sd	a4,0(a5)
  
  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002be8:	fe843783          	ld	a5,-24(s0)
    80002bec:	6bbc                	ld	a5,80(a5)
    80002bee:	03400613          	li	a2,52
    80002bf2:	0000b597          	auipc	a1,0xb
    80002bf6:	0d658593          	addi	a1,a1,214 # 8000dcc8 <initcode>
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
    80002c48:	116080e7          	jalr	278(ra) # 80005d5a <namei>
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
    80002de8:	90e080e7          	jalr	-1778(ra) # 800066f2 <filedup>
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
    80002e24:	1be080e7          	jalr	446(ra) # 80004fde <idup>
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
    80002e6c:	04850513          	addi	a0,a0,72 # 8001beb0 <wait_lock>
    80002e70:	ffffe097          	auipc	ra,0xffffe
    80002e74:	40e080e7          	jalr	1038(ra) # 8000127e <acquire>
  np->parent = p;
    80002e78:	fd843783          	ld	a5,-40(s0)
    80002e7c:	fe043703          	ld	a4,-32(s0)
    80002e80:	ff98                	sd	a4,56(a5)
  release(&wait_lock);
    80002e82:	00019517          	auipc	a0,0x19
    80002e86:	02e50513          	addi	a0,a0,46 # 8001beb0 <wait_lock>
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
    80002ed4:	5c878793          	addi	a5,a5,1480 # 80016498 <proc>
    80002ed8:	fef43423          	sd	a5,-24(s0)
    80002edc:	a081                	j	80002f1c <reparent+0x58>
    if(pp->parent == p){
    80002ede:	fe843783          	ld	a5,-24(s0)
    80002ee2:	7f9c                	ld	a5,56(a5)
    80002ee4:	fd843703          	ld	a4,-40(s0)
    80002ee8:	02f71463          	bne	a4,a5,80002f10 <reparent+0x4c>
      pp->parent = initproc;
    80002eec:	0000b797          	auipc	a5,0xb
    80002ef0:	f3478793          	addi	a5,a5,-204 # 8000de20 <initproc>
    80002ef4:	6398                	ld	a4,0(a5)
    80002ef6:	fe843783          	ld	a5,-24(s0)
    80002efa:	ff98                	sd	a4,56(a5)
      wakeup(initproc);
    80002efc:	0000b797          	auipc	a5,0xb
    80002f00:	f2478793          	addi	a5,a5,-220 # 8000de20 <initproc>
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
    80002f24:	f7878793          	addi	a5,a5,-136 # 8001be98 <pid_lock>
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
    80002f56:	ece78793          	addi	a5,a5,-306 # 8000de20 <initproc>
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
    80002fa4:	00003097          	auipc	ra,0x3
    80002fa8:	7b4080e7          	jalr	1972(ra) # 80006758 <fileclose>
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
    80002fda:	0e8080e7          	jalr	232(ra) # 800060be <begin_op>
  iput(p->cwd);
    80002fde:	fe043783          	ld	a5,-32(s0)
    80002fe2:	1507b783          	ld	a5,336(a5)
    80002fe6:	853e                	mv	a0,a5
    80002fe8:	00002097          	auipc	ra,0x2
    80002fec:	1d0080e7          	jalr	464(ra) # 800051b8 <iput>
  end_op();
    80002ff0:	00003097          	auipc	ra,0x3
    80002ff4:	190080e7          	jalr	400(ra) # 80006180 <end_op>
  p->cwd = 0;
    80002ff8:	fe043783          	ld	a5,-32(s0)
    80002ffc:	1407b823          	sd	zero,336(a5)

  acquire(&wait_lock);
    80003000:	00019517          	auipc	a0,0x19
    80003004:	eb050513          	addi	a0,a0,-336 # 8001beb0 <wait_lock>
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
    80003050:	e6450513          	addi	a0,a0,-412 # 8001beb0 <wait_lock>
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
    80003090:	e2450513          	addi	a0,a0,-476 # 8001beb0 <wait_lock>
    80003094:	ffffe097          	auipc	ra,0xffffe
    80003098:	1ea080e7          	jalr	490(ra) # 8000127e <acquire>

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    8000309c:	fe042223          	sw	zero,-28(s0)
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800030a0:	00013797          	auipc	a5,0x13
    800030a4:	3f878793          	addi	a5,a5,1016 # 80016498 <proc>
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
    80003126:	d8e50513          	addi	a0,a0,-626 # 8001beb0 <wait_lock>
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
    80003154:	d6050513          	addi	a0,a0,-672 # 8001beb0 <wait_lock>
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
    80003188:	d1478793          	addi	a5,a5,-748 # 8001be98 <pid_lock>
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
    800031ac:	d0850513          	addi	a0,a0,-760 # 8001beb0 <wait_lock>
    800031b0:	ffffe097          	auipc	ra,0xffffe
    800031b4:	132080e7          	jalr	306(ra) # 800012e2 <release>
      return -1;
    800031b8:	57fd                	li	a5,-1
    800031ba:	a821                	j	800031d2 <wait+0x15e>
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800031bc:	00019597          	auipc	a1,0x19
    800031c0:	cf458593          	addi	a1,a1,-780 # 8001beb0 <wait_lock>
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
    80003204:	29878793          	addi	a5,a5,664 # 80016498 <proc>
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
    80003254:	5ac080e7          	jalr	1452(ra) # 800037fc <swtch>

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
    80003282:	c1a78793          	addi	a5,a5,-998 # 8001be98 <pid_lock>
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
    8000334e:	4b2080e7          	jalr	1202(ra) # 800037fc <swtch>
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
    800033d8:	8d078793          	addi	a5,a5,-1840 # 8000dca4 <first.1>
    800033dc:	439c                	lw	a5,0(a5)
    800033de:	cf81                	beqz	a5,800033f6 <forkret+0x3e>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    800033e0:	0000b797          	auipc	a5,0xb
    800033e4:	8c478793          	addi	a5,a5,-1852 # 8000dca4 <first.1>
    800033e8:	0007a023          	sw	zero,0(a5)
    fsinit(ROOTDEV);
    800033ec:	4505                	li	a0,1
    800033ee:	00001097          	auipc	ra,0x1
    800033f2:	4de080e7          	jalr	1246(ra) # 800048cc <fsinit>
  }

  usertrapret();
    800033f6:	00000097          	auipc	ra,0x0
    800033fa:	7b8080e7          	jalr	1976(ra) # 80003bae <usertrapret>
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
    80003494:	00878793          	addi	a5,a5,8 # 80016498 <proc>
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
    80003504:	99878793          	addi	a5,a5,-1640 # 8001be98 <pid_lock>
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
    8000352a:	f7278793          	addi	a5,a5,-142 # 80016498 <proc>
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
    800035a4:	8f878793          	addi	a5,a5,-1800 # 8001be98 <pid_lock>
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
    80003736:	d6678793          	addi	a5,a5,-666 # 80016498 <proc>
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
    80003760:	5a470713          	addi	a4,a4,1444 # 8000dd00 <states.0>
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
    8000377a:	58a70713          	addi	a4,a4,1418 # 8000dd00 <states.0>
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
    800037e8:	6b478793          	addi	a5,a5,1716 # 8001be98 <pid_lock>
    800037ec:	f4f76ae3          	bltu	a4,a5,80003740 <procdump+0x26>
  }
}
    800037f0:	0001                	nop
    800037f2:	0001                	nop
    800037f4:	60e2                	ld	ra,24(sp)
    800037f6:	6442                	ld	s0,16(sp)
    800037f8:	6105                	addi	sp,sp,32
    800037fa:	8082                	ret

00000000800037fc <swtch>:
    800037fc:	00153023          	sd	ra,0(a0)
    80003800:	00253423          	sd	sp,8(a0)
    80003804:	e900                	sd	s0,16(a0)
    80003806:	ed04                	sd	s1,24(a0)
    80003808:	03253023          	sd	s2,32(a0)
    8000380c:	03353423          	sd	s3,40(a0)
    80003810:	03453823          	sd	s4,48(a0)
    80003814:	03553c23          	sd	s5,56(a0)
    80003818:	05653023          	sd	s6,64(a0)
    8000381c:	05753423          	sd	s7,72(a0)
    80003820:	05853823          	sd	s8,80(a0)
    80003824:	05953c23          	sd	s9,88(a0)
    80003828:	07a53023          	sd	s10,96(a0)
    8000382c:	07b53423          	sd	s11,104(a0)
    80003830:	0005b083          	ld	ra,0(a1)
    80003834:	0085b103          	ld	sp,8(a1)
    80003838:	6980                	ld	s0,16(a1)
    8000383a:	6d84                	ld	s1,24(a1)
    8000383c:	0205b903          	ld	s2,32(a1)
    80003840:	0285b983          	ld	s3,40(a1)
    80003844:	0305ba03          	ld	s4,48(a1)
    80003848:	0385ba83          	ld	s5,56(a1)
    8000384c:	0405bb03          	ld	s6,64(a1)
    80003850:	0485bb83          	ld	s7,72(a1)
    80003854:	0505bc03          	ld	s8,80(a1)
    80003858:	0585bc83          	ld	s9,88(a1)
    8000385c:	0605bd03          	ld	s10,96(a1)
    80003860:	0685bd83          	ld	s11,104(a1)
    80003864:	8082                	ret

0000000080003866 <r_sstatus>:
{
    80003866:	1101                	addi	sp,sp,-32
    80003868:	ec22                	sd	s0,24(sp)
    8000386a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000386c:	100027f3          	csrr	a5,sstatus
    80003870:	fef43423          	sd	a5,-24(s0)
  return x;
    80003874:	fe843783          	ld	a5,-24(s0)
}
    80003878:	853e                	mv	a0,a5
    8000387a:	6462                	ld	s0,24(sp)
    8000387c:	6105                	addi	sp,sp,32
    8000387e:	8082                	ret

0000000080003880 <w_sstatus>:
{
    80003880:	1101                	addi	sp,sp,-32
    80003882:	ec22                	sd	s0,24(sp)
    80003884:	1000                	addi	s0,sp,32
    80003886:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000388a:	fe843783          	ld	a5,-24(s0)
    8000388e:	10079073          	csrw	sstatus,a5
}
    80003892:	0001                	nop
    80003894:	6462                	ld	s0,24(sp)
    80003896:	6105                	addi	sp,sp,32
    80003898:	8082                	ret

000000008000389a <r_sip>:
{
    8000389a:	1101                	addi	sp,sp,-32
    8000389c:	ec22                	sd	s0,24(sp)
    8000389e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sip" : "=r" (x) );
    800038a0:	144027f3          	csrr	a5,sip
    800038a4:	fef43423          	sd	a5,-24(s0)
  return x;
    800038a8:	fe843783          	ld	a5,-24(s0)
}
    800038ac:	853e                	mv	a0,a5
    800038ae:	6462                	ld	s0,24(sp)
    800038b0:	6105                	addi	sp,sp,32
    800038b2:	8082                	ret

00000000800038b4 <w_sip>:
{
    800038b4:	1101                	addi	sp,sp,-32
    800038b6:	ec22                	sd	s0,24(sp)
    800038b8:	1000                	addi	s0,sp,32
    800038ba:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sip, %0" : : "r" (x));
    800038be:	fe843783          	ld	a5,-24(s0)
    800038c2:	14479073          	csrw	sip,a5
}
    800038c6:	0001                	nop
    800038c8:	6462                	ld	s0,24(sp)
    800038ca:	6105                	addi	sp,sp,32
    800038cc:	8082                	ret

00000000800038ce <w_sepc>:
{
    800038ce:	1101                	addi	sp,sp,-32
    800038d0:	ec22                	sd	s0,24(sp)
    800038d2:	1000                	addi	s0,sp,32
    800038d4:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800038d8:	fe843783          	ld	a5,-24(s0)
    800038dc:	14179073          	csrw	sepc,a5
}
    800038e0:	0001                	nop
    800038e2:	6462                	ld	s0,24(sp)
    800038e4:	6105                	addi	sp,sp,32
    800038e6:	8082                	ret

00000000800038e8 <r_sepc>:
{
    800038e8:	1101                	addi	sp,sp,-32
    800038ea:	ec22                	sd	s0,24(sp)
    800038ec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800038ee:	141027f3          	csrr	a5,sepc
    800038f2:	fef43423          	sd	a5,-24(s0)
  return x;
    800038f6:	fe843783          	ld	a5,-24(s0)
}
    800038fa:	853e                	mv	a0,a5
    800038fc:	6462                	ld	s0,24(sp)
    800038fe:	6105                	addi	sp,sp,32
    80003900:	8082                	ret

0000000080003902 <w_stvec>:
{
    80003902:	1101                	addi	sp,sp,-32
    80003904:	ec22                	sd	s0,24(sp)
    80003906:	1000                	addi	s0,sp,32
    80003908:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000390c:	fe843783          	ld	a5,-24(s0)
    80003910:	10579073          	csrw	stvec,a5
}
    80003914:	0001                	nop
    80003916:	6462                	ld	s0,24(sp)
    80003918:	6105                	addi	sp,sp,32
    8000391a:	8082                	ret

000000008000391c <r_satp>:
{
    8000391c:	1101                	addi	sp,sp,-32
    8000391e:	ec22                	sd	s0,24(sp)
    80003920:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003922:	180027f3          	csrr	a5,satp
    80003926:	fef43423          	sd	a5,-24(s0)
  return x;
    8000392a:	fe843783          	ld	a5,-24(s0)
}
    8000392e:	853e                	mv	a0,a5
    80003930:	6462                	ld	s0,24(sp)
    80003932:	6105                	addi	sp,sp,32
    80003934:	8082                	ret

0000000080003936 <r_scause>:
{
    80003936:	1101                	addi	sp,sp,-32
    80003938:	ec22                	sd	s0,24(sp)
    8000393a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000393c:	142027f3          	csrr	a5,scause
    80003940:	fef43423          	sd	a5,-24(s0)
  return x;
    80003944:	fe843783          	ld	a5,-24(s0)
}
    80003948:	853e                	mv	a0,a5
    8000394a:	6462                	ld	s0,24(sp)
    8000394c:	6105                	addi	sp,sp,32
    8000394e:	8082                	ret

0000000080003950 <r_stval>:
{
    80003950:	1101                	addi	sp,sp,-32
    80003952:	ec22                	sd	s0,24(sp)
    80003954:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003956:	143027f3          	csrr	a5,stval
    8000395a:	fef43423          	sd	a5,-24(s0)
  return x;
    8000395e:	fe843783          	ld	a5,-24(s0)
}
    80003962:	853e                	mv	a0,a5
    80003964:	6462                	ld	s0,24(sp)
    80003966:	6105                	addi	sp,sp,32
    80003968:	8082                	ret

000000008000396a <intr_on>:
{
    8000396a:	1141                	addi	sp,sp,-16
    8000396c:	e406                	sd	ra,8(sp)
    8000396e:	e022                	sd	s0,0(sp)
    80003970:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003972:	00000097          	auipc	ra,0x0
    80003976:	ef4080e7          	jalr	-268(ra) # 80003866 <r_sstatus>
    8000397a:	87aa                	mv	a5,a0
    8000397c:	0027e793          	ori	a5,a5,2
    80003980:	853e                	mv	a0,a5
    80003982:	00000097          	auipc	ra,0x0
    80003986:	efe080e7          	jalr	-258(ra) # 80003880 <w_sstatus>
}
    8000398a:	0001                	nop
    8000398c:	60a2                	ld	ra,8(sp)
    8000398e:	6402                	ld	s0,0(sp)
    80003990:	0141                	addi	sp,sp,16
    80003992:	8082                	ret

0000000080003994 <intr_off>:
{
    80003994:	1141                	addi	sp,sp,-16
    80003996:	e406                	sd	ra,8(sp)
    80003998:	e022                	sd	s0,0(sp)
    8000399a:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000399c:	00000097          	auipc	ra,0x0
    800039a0:	eca080e7          	jalr	-310(ra) # 80003866 <r_sstatus>
    800039a4:	87aa                	mv	a5,a0
    800039a6:	9bf5                	andi	a5,a5,-3
    800039a8:	853e                	mv	a0,a5
    800039aa:	00000097          	auipc	ra,0x0
    800039ae:	ed6080e7          	jalr	-298(ra) # 80003880 <w_sstatus>
}
    800039b2:	0001                	nop
    800039b4:	60a2                	ld	ra,8(sp)
    800039b6:	6402                	ld	s0,0(sp)
    800039b8:	0141                	addi	sp,sp,16
    800039ba:	8082                	ret

00000000800039bc <intr_get>:
{
    800039bc:	1101                	addi	sp,sp,-32
    800039be:	ec06                	sd	ra,24(sp)
    800039c0:	e822                	sd	s0,16(sp)
    800039c2:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    800039c4:	00000097          	auipc	ra,0x0
    800039c8:	ea2080e7          	jalr	-350(ra) # 80003866 <r_sstatus>
    800039cc:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    800039d0:	fe843783          	ld	a5,-24(s0)
    800039d4:	8b89                	andi	a5,a5,2
    800039d6:	00f037b3          	snez	a5,a5
    800039da:	0ff7f793          	zext.b	a5,a5
    800039de:	2781                	sext.w	a5,a5
}
    800039e0:	853e                	mv	a0,a5
    800039e2:	60e2                	ld	ra,24(sp)
    800039e4:	6442                	ld	s0,16(sp)
    800039e6:	6105                	addi	sp,sp,32
    800039e8:	8082                	ret

00000000800039ea <r_tp>:
{
    800039ea:	1101                	addi	sp,sp,-32
    800039ec:	ec22                	sd	s0,24(sp)
    800039ee:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    800039f0:	8792                	mv	a5,tp
    800039f2:	fef43423          	sd	a5,-24(s0)
  return x;
    800039f6:	fe843783          	ld	a5,-24(s0)
}
    800039fa:	853e                	mv	a0,a5
    800039fc:	6462                	ld	s0,24(sp)
    800039fe:	6105                	addi	sp,sp,32
    80003a00:	8082                	ret

0000000080003a02 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003a02:	1141                	addi	sp,sp,-16
    80003a04:	e406                	sd	ra,8(sp)
    80003a06:	e022                	sd	s0,0(sp)
    80003a08:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003a0a:	00008597          	auipc	a1,0x8
    80003a0e:	8b658593          	addi	a1,a1,-1866 # 8000b2c0 <etext+0x2c0>
    80003a12:	00018517          	auipc	a0,0x18
    80003a16:	4b650513          	addi	a0,a0,1206 # 8001bec8 <tickslock>
    80003a1a:	ffffe097          	auipc	ra,0xffffe
    80003a1e:	834080e7          	jalr	-1996(ra) # 8000124e <initlock>
}
    80003a22:	0001                	nop
    80003a24:	60a2                	ld	ra,8(sp)
    80003a26:	6402                	ld	s0,0(sp)
    80003a28:	0141                	addi	sp,sp,16
    80003a2a:	8082                	ret

0000000080003a2c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003a2c:	1141                	addi	sp,sp,-16
    80003a2e:	e406                	sd	ra,8(sp)
    80003a30:	e022                	sd	s0,0(sp)
    80003a32:	0800                	addi	s0,sp,16
  w_stvec((uint64)kernelvec);
    80003a34:	00005797          	auipc	a5,0x5
    80003a38:	d4c78793          	addi	a5,a5,-692 # 80008780 <kernelvec>
    80003a3c:	853e                	mv	a0,a5
    80003a3e:	00000097          	auipc	ra,0x0
    80003a42:	ec4080e7          	jalr	-316(ra) # 80003902 <w_stvec>
}
    80003a46:	0001                	nop
    80003a48:	60a2                	ld	ra,8(sp)
    80003a4a:	6402                	ld	s0,0(sp)
    80003a4c:	0141                	addi	sp,sp,16
    80003a4e:	8082                	ret

0000000080003a50 <usertrap>:
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void
usertrap(void)
{
    80003a50:	7179                	addi	sp,sp,-48
    80003a52:	f406                	sd	ra,40(sp)
    80003a54:	f022                	sd	s0,32(sp)
    80003a56:	ec26                	sd	s1,24(sp)
    80003a58:	1800                	addi	s0,sp,48
  int which_dev = 0;
    80003a5a:	fc042e23          	sw	zero,-36(s0)

  if((r_sstatus() & SSTATUS_SPP) != 0)
    80003a5e:	00000097          	auipc	ra,0x0
    80003a62:	e08080e7          	jalr	-504(ra) # 80003866 <r_sstatus>
    80003a66:	87aa                	mv	a5,a0
    80003a68:	1007f793          	andi	a5,a5,256
    80003a6c:	cb89                	beqz	a5,80003a7e <usertrap+0x2e>
    panic("usertrap: not from user mode");
    80003a6e:	00008517          	auipc	a0,0x8
    80003a72:	85a50513          	addi	a0,a0,-1958 # 8000b2c8 <etext+0x2c8>
    80003a76:	ffffd097          	auipc	ra,0xffffd
    80003a7a:	214080e7          	jalr	532(ra) # 80000c8a <panic>

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);
    80003a7e:	00005797          	auipc	a5,0x5
    80003a82:	d0278793          	addi	a5,a5,-766 # 80008780 <kernelvec>
    80003a86:	853e                	mv	a0,a5
    80003a88:	00000097          	auipc	ra,0x0
    80003a8c:	e7a080e7          	jalr	-390(ra) # 80003902 <w_stvec>

  struct proc *p = myproc();
    80003a90:	fffff097          	auipc	ra,0xfffff
    80003a94:	db6080e7          	jalr	-586(ra) # 80002846 <myproc>
    80003a98:	fca43823          	sd	a0,-48(s0)
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
    80003a9c:	fd043783          	ld	a5,-48(s0)
    80003aa0:	6fa4                	ld	s1,88(a5)
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	e46080e7          	jalr	-442(ra) # 800038e8 <r_sepc>
    80003aaa:	87aa                	mv	a5,a0
    80003aac:	ec9c                	sd	a5,24(s1)
  
  if(r_scause() == 8){
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	e88080e7          	jalr	-376(ra) # 80003936 <r_scause>
    80003ab6:	872a                	mv	a4,a0
    80003ab8:	47a1                	li	a5,8
    80003aba:	04f71163          	bne	a4,a5,80003afc <usertrap+0xac>
    // system call

    if(killed(p))
    80003abe:	fd043503          	ld	a0,-48(s0)
    80003ac2:	00000097          	auipc	ra,0x0
    80003ac6:	b30080e7          	jalr	-1232(ra) # 800035f2 <killed>
    80003aca:	87aa                	mv	a5,a0
    80003acc:	c791                	beqz	a5,80003ad8 <usertrap+0x88>
      exit(-1);
    80003ace:	557d                	li	a0,-1
    80003ad0:	fffff097          	auipc	ra,0xfffff
    80003ad4:	468080e7          	jalr	1128(ra) # 80002f38 <exit>

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;
    80003ad8:	fd043783          	ld	a5,-48(s0)
    80003adc:	6fbc                	ld	a5,88(a5)
    80003ade:	6f98                	ld	a4,24(a5)
    80003ae0:	fd043783          	ld	a5,-48(s0)
    80003ae4:	6fbc                	ld	a5,88(a5)
    80003ae6:	0711                	addi	a4,a4,4
    80003ae8:	ef98                	sd	a4,24(a5)

    // an interrupt will change sepc, scause, and sstatus,
    // so enable only now that we're done with those registers.
    intr_on();
    80003aea:	00000097          	auipc	ra,0x0
    80003aee:	e80080e7          	jalr	-384(ra) # 8000396a <intr_on>

    syscall();
    80003af2:	00000097          	auipc	ra,0x0
    80003af6:	66c080e7          	jalr	1644(ra) # 8000415e <syscall>
    80003afa:	a885                	j	80003b6a <usertrap+0x11a>
  } else if((which_dev = devintr()) != 0){
    80003afc:	00000097          	auipc	ra,0x0
    80003b00:	34e080e7          	jalr	846(ra) # 80003e4a <devintr>
    80003b04:	87aa                	mv	a5,a0
    80003b06:	fcf42e23          	sw	a5,-36(s0)
    80003b0a:	fdc42783          	lw	a5,-36(s0)
    80003b0e:	2781                	sext.w	a5,a5
    80003b10:	efa9                	bnez	a5,80003b6a <usertrap+0x11a>
    // ok
  } else {
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003b12:	00000097          	auipc	ra,0x0
    80003b16:	e24080e7          	jalr	-476(ra) # 80003936 <r_scause>
    80003b1a:	872a                	mv	a4,a0
    80003b1c:	fd043783          	ld	a5,-48(s0)
    80003b20:	5b9c                	lw	a5,48(a5)
    80003b22:	863e                	mv	a2,a5
    80003b24:	85ba                	mv	a1,a4
    80003b26:	00007517          	auipc	a0,0x7
    80003b2a:	7c250513          	addi	a0,a0,1986 # 8000b2e8 <etext+0x2e8>
    80003b2e:	ffffd097          	auipc	ra,0xffffd
    80003b32:	f06080e7          	jalr	-250(ra) # 80000a34 <printf>
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003b36:	00000097          	auipc	ra,0x0
    80003b3a:	db2080e7          	jalr	-590(ra) # 800038e8 <r_sepc>
    80003b3e:	84aa                	mv	s1,a0
    80003b40:	00000097          	auipc	ra,0x0
    80003b44:	e10080e7          	jalr	-496(ra) # 80003950 <r_stval>
    80003b48:	87aa                	mv	a5,a0
    80003b4a:	863e                	mv	a2,a5
    80003b4c:	85a6                	mv	a1,s1
    80003b4e:	00007517          	auipc	a0,0x7
    80003b52:	7ca50513          	addi	a0,a0,1994 # 8000b318 <etext+0x318>
    80003b56:	ffffd097          	auipc	ra,0xffffd
    80003b5a:	ede080e7          	jalr	-290(ra) # 80000a34 <printf>
    setkilled(p);
    80003b5e:	fd043503          	ld	a0,-48(s0)
    80003b62:	00000097          	auipc	ra,0x0
    80003b66:	a56080e7          	jalr	-1450(ra) # 800035b8 <setkilled>
  }

  if(killed(p))
    80003b6a:	fd043503          	ld	a0,-48(s0)
    80003b6e:	00000097          	auipc	ra,0x0
    80003b72:	a84080e7          	jalr	-1404(ra) # 800035f2 <killed>
    80003b76:	87aa                	mv	a5,a0
    80003b78:	c791                	beqz	a5,80003b84 <usertrap+0x134>
    exit(-1);
    80003b7a:	557d                	li	a0,-1
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	3bc080e7          	jalr	956(ra) # 80002f38 <exit>

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2)
    80003b84:	fdc42783          	lw	a5,-36(s0)
    80003b88:	0007871b          	sext.w	a4,a5
    80003b8c:	4789                	li	a5,2
    80003b8e:	00f71663          	bne	a4,a5,80003b9a <usertrap+0x14a>
    yield();
    80003b92:	fffff097          	auipc	ra,0xfffff
    80003b96:	7dc080e7          	jalr	2012(ra) # 8000336e <yield>

  usertrapret();
    80003b9a:	00000097          	auipc	ra,0x0
    80003b9e:	014080e7          	jalr	20(ra) # 80003bae <usertrapret>
}
    80003ba2:	0001                	nop
    80003ba4:	70a2                	ld	ra,40(sp)
    80003ba6:	7402                	ld	s0,32(sp)
    80003ba8:	64e2                	ld	s1,24(sp)
    80003baa:	6145                	addi	sp,sp,48
    80003bac:	8082                	ret

0000000080003bae <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003bae:	715d                	addi	sp,sp,-80
    80003bb0:	e486                	sd	ra,72(sp)
    80003bb2:	e0a2                	sd	s0,64(sp)
    80003bb4:	fc26                	sd	s1,56(sp)
    80003bb6:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	c8e080e7          	jalr	-882(ra) # 80002846 <myproc>
    80003bc0:	fca43c23          	sd	a0,-40(s0)

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();
    80003bc4:	00000097          	auipc	ra,0x0
    80003bc8:	dd0080e7          	jalr	-560(ra) # 80003994 <intr_off>

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003bcc:	00006717          	auipc	a4,0x6
    80003bd0:	43470713          	addi	a4,a4,1076 # 8000a000 <_trampoline>
    80003bd4:	00006797          	auipc	a5,0x6
    80003bd8:	42c78793          	addi	a5,a5,1068 # 8000a000 <_trampoline>
    80003bdc:	8f1d                	sub	a4,a4,a5
    80003bde:	040007b7          	lui	a5,0x4000
    80003be2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003be4:	07b2                	slli	a5,a5,0xc
    80003be6:	97ba                	add	a5,a5,a4
    80003be8:	fcf43823          	sd	a5,-48(s0)
  w_stvec(trampoline_uservec);
    80003bec:	fd043503          	ld	a0,-48(s0)
    80003bf0:	00000097          	auipc	ra,0x0
    80003bf4:	d12080e7          	jalr	-750(ra) # 80003902 <w_stvec>

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003bf8:	fd843783          	ld	a5,-40(s0)
    80003bfc:	6fa4                	ld	s1,88(a5)
    80003bfe:	00000097          	auipc	ra,0x0
    80003c02:	d1e080e7          	jalr	-738(ra) # 8000391c <r_satp>
    80003c06:	87aa                	mv	a5,a0
    80003c08:	e09c                	sd	a5,0(s1)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003c0a:	fd843783          	ld	a5,-40(s0)
    80003c0e:	63b4                	ld	a3,64(a5)
    80003c10:	fd843783          	ld	a5,-40(s0)
    80003c14:	6fbc                	ld	a5,88(a5)
    80003c16:	6705                	lui	a4,0x1
    80003c18:	9736                	add	a4,a4,a3
    80003c1a:	e798                	sd	a4,8(a5)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003c1c:	fd843783          	ld	a5,-40(s0)
    80003c20:	6fbc                	ld	a5,88(a5)
    80003c22:	00000717          	auipc	a4,0x0
    80003c26:	e2e70713          	addi	a4,a4,-466 # 80003a50 <usertrap>
    80003c2a:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003c2c:	fd843783          	ld	a5,-40(s0)
    80003c30:	6fa4                	ld	s1,88(a5)
    80003c32:	00000097          	auipc	ra,0x0
    80003c36:	db8080e7          	jalr	-584(ra) # 800039ea <r_tp>
    80003c3a:	87aa                	mv	a5,a0
    80003c3c:	f09c                	sd	a5,32(s1)

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
    80003c3e:	00000097          	auipc	ra,0x0
    80003c42:	c28080e7          	jalr	-984(ra) # 80003866 <r_sstatus>
    80003c46:	fca43423          	sd	a0,-56(s0)
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003c4a:	fc843783          	ld	a5,-56(s0)
    80003c4e:	eff7f793          	andi	a5,a5,-257
    80003c52:	fcf43423          	sd	a5,-56(s0)
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003c56:	fc843783          	ld	a5,-56(s0)
    80003c5a:	0207e793          	ori	a5,a5,32
    80003c5e:	fcf43423          	sd	a5,-56(s0)
  w_sstatus(x);
    80003c62:	fc843503          	ld	a0,-56(s0)
    80003c66:	00000097          	auipc	ra,0x0
    80003c6a:	c1a080e7          	jalr	-998(ra) # 80003880 <w_sstatus>

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003c6e:	fd843783          	ld	a5,-40(s0)
    80003c72:	6fbc                	ld	a5,88(a5)
    80003c74:	6f9c                	ld	a5,24(a5)
    80003c76:	853e                	mv	a0,a5
    80003c78:	00000097          	auipc	ra,0x0
    80003c7c:	c56080e7          	jalr	-938(ra) # 800038ce <w_sepc>

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003c80:	fd843783          	ld	a5,-40(s0)
    80003c84:	6bbc                	ld	a5,80(a5)
    80003c86:	00c7d713          	srli	a4,a5,0xc
    80003c8a:	57fd                	li	a5,-1
    80003c8c:	17fe                	slli	a5,a5,0x3f
    80003c8e:	8fd9                	or	a5,a5,a4
    80003c90:	fcf43023          	sd	a5,-64(s0)

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80003c94:	00006717          	auipc	a4,0x6
    80003c98:	40870713          	addi	a4,a4,1032 # 8000a09c <userret>
    80003c9c:	00006797          	auipc	a5,0x6
    80003ca0:	36478793          	addi	a5,a5,868 # 8000a000 <_trampoline>
    80003ca4:	8f1d                	sub	a4,a4,a5
    80003ca6:	040007b7          	lui	a5,0x4000
    80003caa:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003cac:	07b2                	slli	a5,a5,0xc
    80003cae:	97ba                	add	a5,a5,a4
    80003cb0:	faf43c23          	sd	a5,-72(s0)
  ((void (*)(uint64))trampoline_userret)(satp);
    80003cb4:	fb843783          	ld	a5,-72(s0)
    80003cb8:	fc043503          	ld	a0,-64(s0)
    80003cbc:	9782                	jalr	a5
}
    80003cbe:	0001                	nop
    80003cc0:	60a6                	ld	ra,72(sp)
    80003cc2:	6406                	ld	s0,64(sp)
    80003cc4:	74e2                	ld	s1,56(sp)
    80003cc6:	6161                	addi	sp,sp,80
    80003cc8:	8082                	ret

0000000080003cca <kerneltrap>:

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
void 
kerneltrap()
{
    80003cca:	7139                	addi	sp,sp,-64
    80003ccc:	fc06                	sd	ra,56(sp)
    80003cce:	f822                	sd	s0,48(sp)
    80003cd0:	f426                	sd	s1,40(sp)
    80003cd2:	0080                	addi	s0,sp,64
  int which_dev = 0;
    80003cd4:	fc042e23          	sw	zero,-36(s0)
  uint64 sepc = r_sepc();
    80003cd8:	00000097          	auipc	ra,0x0
    80003cdc:	c10080e7          	jalr	-1008(ra) # 800038e8 <r_sepc>
    80003ce0:	fca43823          	sd	a0,-48(s0)
  uint64 sstatus = r_sstatus();
    80003ce4:	00000097          	auipc	ra,0x0
    80003ce8:	b82080e7          	jalr	-1150(ra) # 80003866 <r_sstatus>
    80003cec:	fca43423          	sd	a0,-56(s0)
  uint64 scause = r_scause();
    80003cf0:	00000097          	auipc	ra,0x0
    80003cf4:	c46080e7          	jalr	-954(ra) # 80003936 <r_scause>
    80003cf8:	fca43023          	sd	a0,-64(s0)
  
  if((sstatus & SSTATUS_SPP) == 0)
    80003cfc:	fc843783          	ld	a5,-56(s0)
    80003d00:	1007f793          	andi	a5,a5,256
    80003d04:	eb89                	bnez	a5,80003d16 <kerneltrap+0x4c>
    panic("kerneltrap: not from supervisor mode");
    80003d06:	00007517          	auipc	a0,0x7
    80003d0a:	63250513          	addi	a0,a0,1586 # 8000b338 <etext+0x338>
    80003d0e:	ffffd097          	auipc	ra,0xffffd
    80003d12:	f7c080e7          	jalr	-132(ra) # 80000c8a <panic>
  if(intr_get() != 0)
    80003d16:	00000097          	auipc	ra,0x0
    80003d1a:	ca6080e7          	jalr	-858(ra) # 800039bc <intr_get>
    80003d1e:	87aa                	mv	a5,a0
    80003d20:	cb89                	beqz	a5,80003d32 <kerneltrap+0x68>
    panic("kerneltrap: interrupts enabled");
    80003d22:	00007517          	auipc	a0,0x7
    80003d26:	63e50513          	addi	a0,a0,1598 # 8000b360 <etext+0x360>
    80003d2a:	ffffd097          	auipc	ra,0xffffd
    80003d2e:	f60080e7          	jalr	-160(ra) # 80000c8a <panic>

  if((which_dev = devintr()) == 0){
    80003d32:	00000097          	auipc	ra,0x0
    80003d36:	118080e7          	jalr	280(ra) # 80003e4a <devintr>
    80003d3a:	87aa                	mv	a5,a0
    80003d3c:	fcf42e23          	sw	a5,-36(s0)
    80003d40:	fdc42783          	lw	a5,-36(s0)
    80003d44:	2781                	sext.w	a5,a5
    80003d46:	e7b9                	bnez	a5,80003d94 <kerneltrap+0xca>
    printf("scause %p\n", scause);
    80003d48:	fc043583          	ld	a1,-64(s0)
    80003d4c:	00007517          	auipc	a0,0x7
    80003d50:	63450513          	addi	a0,a0,1588 # 8000b380 <etext+0x380>
    80003d54:	ffffd097          	auipc	ra,0xffffd
    80003d58:	ce0080e7          	jalr	-800(ra) # 80000a34 <printf>
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	b8c080e7          	jalr	-1140(ra) # 800038e8 <r_sepc>
    80003d64:	84aa                	mv	s1,a0
    80003d66:	00000097          	auipc	ra,0x0
    80003d6a:	bea080e7          	jalr	-1046(ra) # 80003950 <r_stval>
    80003d6e:	87aa                	mv	a5,a0
    80003d70:	863e                	mv	a2,a5
    80003d72:	85a6                	mv	a1,s1
    80003d74:	00007517          	auipc	a0,0x7
    80003d78:	61c50513          	addi	a0,a0,1564 # 8000b390 <etext+0x390>
    80003d7c:	ffffd097          	auipc	ra,0xffffd
    80003d80:	cb8080e7          	jalr	-840(ra) # 80000a34 <printf>
    panic("kerneltrap");
    80003d84:	00007517          	auipc	a0,0x7
    80003d88:	62450513          	addi	a0,a0,1572 # 8000b3a8 <etext+0x3a8>
    80003d8c:	ffffd097          	auipc	ra,0xffffd
    80003d90:	efe080e7          	jalr	-258(ra) # 80000c8a <panic>
  }

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003d94:	fdc42783          	lw	a5,-36(s0)
    80003d98:	0007871b          	sext.w	a4,a5
    80003d9c:	4789                	li	a5,2
    80003d9e:	02f71663          	bne	a4,a5,80003dca <kerneltrap+0x100>
    80003da2:	fffff097          	auipc	ra,0xfffff
    80003da6:	aa4080e7          	jalr	-1372(ra) # 80002846 <myproc>
    80003daa:	87aa                	mv	a5,a0
    80003dac:	cf99                	beqz	a5,80003dca <kerneltrap+0x100>
    80003dae:	fffff097          	auipc	ra,0xfffff
    80003db2:	a98080e7          	jalr	-1384(ra) # 80002846 <myproc>
    80003db6:	87aa                	mv	a5,a0
    80003db8:	4f9c                	lw	a5,24(a5)
    80003dba:	873e                	mv	a4,a5
    80003dbc:	4791                	li	a5,4
    80003dbe:	00f71663          	bne	a4,a5,80003dca <kerneltrap+0x100>
    yield();
    80003dc2:	fffff097          	auipc	ra,0xfffff
    80003dc6:	5ac080e7          	jalr	1452(ra) # 8000336e <yield>

  // the yield() may have caused some traps to occur,
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
    80003dca:	fd043503          	ld	a0,-48(s0)
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	b00080e7          	jalr	-1280(ra) # 800038ce <w_sepc>
  w_sstatus(sstatus);
    80003dd6:	fc843503          	ld	a0,-56(s0)
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	aa6080e7          	jalr	-1370(ra) # 80003880 <w_sstatus>
}
    80003de2:	0001                	nop
    80003de4:	70e2                	ld	ra,56(sp)
    80003de6:	7442                	ld	s0,48(sp)
    80003de8:	74a2                	ld	s1,40(sp)
    80003dea:	6121                	addi	sp,sp,64
    80003dec:	8082                	ret

0000000080003dee <clockintr>:

void
clockintr()
{
    80003dee:	1141                	addi	sp,sp,-16
    80003df0:	e406                	sd	ra,8(sp)
    80003df2:	e022                	sd	s0,0(sp)
    80003df4:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    80003df6:	00018517          	auipc	a0,0x18
    80003dfa:	0d250513          	addi	a0,a0,210 # 8001bec8 <tickslock>
    80003dfe:	ffffd097          	auipc	ra,0xffffd
    80003e02:	480080e7          	jalr	1152(ra) # 8000127e <acquire>
  ticks++;
    80003e06:	0000a797          	auipc	a5,0xa
    80003e0a:	02278793          	addi	a5,a5,34 # 8000de28 <ticks>
    80003e0e:	439c                	lw	a5,0(a5)
    80003e10:	2785                	addiw	a5,a5,1
    80003e12:	0007871b          	sext.w	a4,a5
    80003e16:	0000a797          	auipc	a5,0xa
    80003e1a:	01278793          	addi	a5,a5,18 # 8000de28 <ticks>
    80003e1e:	c398                	sw	a4,0(a5)
  wakeup(&ticks);
    80003e20:	0000a517          	auipc	a0,0xa
    80003e24:	00850513          	addi	a0,a0,8 # 8000de28 <ticks>
    80003e28:	fffff097          	auipc	ra,0xfffff
    80003e2c:	65c080e7          	jalr	1628(ra) # 80003484 <wakeup>
  release(&tickslock);
    80003e30:	00018517          	auipc	a0,0x18
    80003e34:	09850513          	addi	a0,a0,152 # 8001bec8 <tickslock>
    80003e38:	ffffd097          	auipc	ra,0xffffd
    80003e3c:	4aa080e7          	jalr	1194(ra) # 800012e2 <release>
}
    80003e40:	0001                	nop
    80003e42:	60a2                	ld	ra,8(sp)
    80003e44:	6402                	ld	s0,0(sp)
    80003e46:	0141                	addi	sp,sp,16
    80003e48:	8082                	ret

0000000080003e4a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80003e4a:	1101                	addi	sp,sp,-32
    80003e4c:	ec06                	sd	ra,24(sp)
    80003e4e:	e822                	sd	s0,16(sp)
    80003e50:	1000                	addi	s0,sp,32
  uint64 scause = r_scause();
    80003e52:	00000097          	auipc	ra,0x0
    80003e56:	ae4080e7          	jalr	-1308(ra) # 80003936 <r_scause>
    80003e5a:	fea43423          	sd	a0,-24(s0)

  if((scause & 0x8000000000000000L) &&
    80003e5e:	fe843783          	ld	a5,-24(s0)
    80003e62:	0807d463          	bgez	a5,80003eea <devintr+0xa0>
     (scause & 0xff) == 9){
    80003e66:	fe843783          	ld	a5,-24(s0)
    80003e6a:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80003e6e:	47a5                	li	a5,9
    80003e70:	06f71d63          	bne	a4,a5,80003eea <devintr+0xa0>
    // this is a supervisor external interrupt, via PLIC.

    // irq indicates which device interrupted.
    int irq = plic_claim();
    80003e74:	00005097          	auipc	ra,0x5
    80003e78:	a3e080e7          	jalr	-1474(ra) # 800088b2 <plic_claim>
    80003e7c:	87aa                	mv	a5,a0
    80003e7e:	fef42223          	sw	a5,-28(s0)

    if(irq == UART0_IRQ){
    80003e82:	fe442783          	lw	a5,-28(s0)
    80003e86:	0007871b          	sext.w	a4,a5
    80003e8a:	47a9                	li	a5,10
    80003e8c:	00f71763          	bne	a4,a5,80003e9a <devintr+0x50>
      uartintr();
    80003e90:	ffffd097          	auipc	ra,0xffffd
    80003e94:	0f6080e7          	jalr	246(ra) # 80000f86 <uartintr>
    80003e98:	a825                	j	80003ed0 <devintr+0x86>
    } else if(irq == VIRTIO0_IRQ){
    80003e9a:	fe442783          	lw	a5,-28(s0)
    80003e9e:	0007871b          	sext.w	a4,a5
    80003ea2:	4785                	li	a5,1
    80003ea4:	00f71763          	bne	a4,a5,80003eb2 <devintr+0x68>
      virtio_disk_intr();
    80003ea8:	00005097          	auipc	ra,0x5
    80003eac:	3cc080e7          	jalr	972(ra) # 80009274 <virtio_disk_intr>
    80003eb0:	a005                	j	80003ed0 <devintr+0x86>
    } else if(irq){
    80003eb2:	fe442783          	lw	a5,-28(s0)
    80003eb6:	2781                	sext.w	a5,a5
    80003eb8:	cf81                	beqz	a5,80003ed0 <devintr+0x86>
      printf("unexpected interrupt irq=%d\n", irq);
    80003eba:	fe442783          	lw	a5,-28(s0)
    80003ebe:	85be                	mv	a1,a5
    80003ec0:	00007517          	auipc	a0,0x7
    80003ec4:	4f850513          	addi	a0,a0,1272 # 8000b3b8 <etext+0x3b8>
    80003ec8:	ffffd097          	auipc	ra,0xffffd
    80003ecc:	b6c080e7          	jalr	-1172(ra) # 80000a34 <printf>
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
    80003ed0:	fe442783          	lw	a5,-28(s0)
    80003ed4:	2781                	sext.w	a5,a5
    80003ed6:	cb81                	beqz	a5,80003ee6 <devintr+0x9c>
      plic_complete(irq);
    80003ed8:	fe442783          	lw	a5,-28(s0)
    80003edc:	853e                	mv	a0,a5
    80003ede:	00005097          	auipc	ra,0x5
    80003ee2:	a12080e7          	jalr	-1518(ra) # 800088f0 <plic_complete>

    return 1;
    80003ee6:	4785                	li	a5,1
    80003ee8:	a081                	j	80003f28 <devintr+0xde>
  } else if(scause == 0x8000000000000001L){
    80003eea:	fe843703          	ld	a4,-24(s0)
    80003eee:	57fd                	li	a5,-1
    80003ef0:	17fe                	slli	a5,a5,0x3f
    80003ef2:	0785                	addi	a5,a5,1
    80003ef4:	02f71963          	bne	a4,a5,80003f26 <devintr+0xdc>
    // software interrupt from a machine-mode timer interrupt,
    // forwarded by timervec in kernelvec.S.

    if(cpuid() == 0){
    80003ef8:	fffff097          	auipc	ra,0xfffff
    80003efc:	8f0080e7          	jalr	-1808(ra) # 800027e8 <cpuid>
    80003f00:	87aa                	mv	a5,a0
    80003f02:	e789                	bnez	a5,80003f0c <devintr+0xc2>
      clockintr();
    80003f04:	00000097          	auipc	ra,0x0
    80003f08:	eea080e7          	jalr	-278(ra) # 80003dee <clockintr>
    }
    
    // acknowledge the software interrupt by clearing
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);
    80003f0c:	00000097          	auipc	ra,0x0
    80003f10:	98e080e7          	jalr	-1650(ra) # 8000389a <r_sip>
    80003f14:	87aa                	mv	a5,a0
    80003f16:	9bf5                	andi	a5,a5,-3
    80003f18:	853e                	mv	a0,a5
    80003f1a:	00000097          	auipc	ra,0x0
    80003f1e:	99a080e7          	jalr	-1638(ra) # 800038b4 <w_sip>

    return 2;
    80003f22:	4789                	li	a5,2
    80003f24:	a011                	j	80003f28 <devintr+0xde>
  } else {
    return 0;
    80003f26:	4781                	li	a5,0
  }
}
    80003f28:	853e                	mv	a0,a5
    80003f2a:	60e2                	ld	ra,24(sp)
    80003f2c:	6442                	ld	s0,16(sp)
    80003f2e:	6105                	addi	sp,sp,32
    80003f30:	8082                	ret

0000000080003f32 <fetchaddr>:
#include "defs.h"

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
    80003f32:	7179                	addi	sp,sp,-48
    80003f34:	f406                	sd	ra,40(sp)
    80003f36:	f022                	sd	s0,32(sp)
    80003f38:	1800                	addi	s0,sp,48
    80003f3a:	fca43c23          	sd	a0,-40(s0)
    80003f3e:	fcb43823          	sd	a1,-48(s0)
  struct proc *p = myproc();
    80003f42:	fffff097          	auipc	ra,0xfffff
    80003f46:	904080e7          	jalr	-1788(ra) # 80002846 <myproc>
    80003f4a:	fea43423          	sd	a0,-24(s0)
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003f4e:	fe843783          	ld	a5,-24(s0)
    80003f52:	67bc                	ld	a5,72(a5)
    80003f54:	fd843703          	ld	a4,-40(s0)
    80003f58:	00f77b63          	bgeu	a4,a5,80003f6e <fetchaddr+0x3c>
    80003f5c:	fd843783          	ld	a5,-40(s0)
    80003f60:	00878713          	addi	a4,a5,8
    80003f64:	fe843783          	ld	a5,-24(s0)
    80003f68:	67bc                	ld	a5,72(a5)
    80003f6a:	00e7f463          	bgeu	a5,a4,80003f72 <fetchaddr+0x40>
    return -1;
    80003f6e:	57fd                	li	a5,-1
    80003f70:	a01d                	j	80003f96 <fetchaddr+0x64>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003f72:	fe843783          	ld	a5,-24(s0)
    80003f76:	6bbc                	ld	a5,80(a5)
    80003f78:	46a1                	li	a3,8
    80003f7a:	fd843603          	ld	a2,-40(s0)
    80003f7e:	fd043583          	ld	a1,-48(s0)
    80003f82:	853e                	mv	a0,a5
    80003f84:	ffffe097          	auipc	ra,0xffffe
    80003f88:	45a080e7          	jalr	1114(ra) # 800023de <copyin>
    80003f8c:	87aa                	mv	a5,a0
    80003f8e:	c399                	beqz	a5,80003f94 <fetchaddr+0x62>
    return -1;
    80003f90:	57fd                	li	a5,-1
    80003f92:	a011                	j	80003f96 <fetchaddr+0x64>
  return 0;
    80003f94:	4781                	li	a5,0
}
    80003f96:	853e                	mv	a0,a5
    80003f98:	70a2                	ld	ra,40(sp)
    80003f9a:	7402                	ld	s0,32(sp)
    80003f9c:	6145                	addi	sp,sp,48
    80003f9e:	8082                	ret

0000000080003fa0 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
    80003fa0:	7139                	addi	sp,sp,-64
    80003fa2:	fc06                	sd	ra,56(sp)
    80003fa4:	f822                	sd	s0,48(sp)
    80003fa6:	0080                	addi	s0,sp,64
    80003fa8:	fca43c23          	sd	a0,-40(s0)
    80003fac:	fcb43823          	sd	a1,-48(s0)
    80003fb0:	87b2                	mv	a5,a2
    80003fb2:	fcf42623          	sw	a5,-52(s0)
  struct proc *p = myproc();
    80003fb6:	fffff097          	auipc	ra,0xfffff
    80003fba:	890080e7          	jalr	-1904(ra) # 80002846 <myproc>
    80003fbe:	fea43423          	sd	a0,-24(s0)
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003fc2:	fe843783          	ld	a5,-24(s0)
    80003fc6:	6bbc                	ld	a5,80(a5)
    80003fc8:	fcc42703          	lw	a4,-52(s0)
    80003fcc:	86ba                	mv	a3,a4
    80003fce:	fd843603          	ld	a2,-40(s0)
    80003fd2:	fd043583          	ld	a1,-48(s0)
    80003fd6:	853e                	mv	a0,a5
    80003fd8:	ffffe097          	auipc	ra,0xffffe
    80003fdc:	4d4080e7          	jalr	1236(ra) # 800024ac <copyinstr>
    80003fe0:	87aa                	mv	a5,a0
    80003fe2:	0007d463          	bgez	a5,80003fea <fetchstr+0x4a>
    return -1;
    80003fe6:	57fd                	li	a5,-1
    80003fe8:	a801                	j	80003ff8 <fetchstr+0x58>
  return strlen(buf);
    80003fea:	fd043503          	ld	a0,-48(s0)
    80003fee:	ffffd097          	auipc	ra,0xffffd
    80003ff2:	7e4080e7          	jalr	2020(ra) # 800017d2 <strlen>
    80003ff6:	87aa                	mv	a5,a0
}
    80003ff8:	853e                	mv	a0,a5
    80003ffa:	70e2                	ld	ra,56(sp)
    80003ffc:	7442                	ld	s0,48(sp)
    80003ffe:	6121                	addi	sp,sp,64
    80004000:	8082                	ret

0000000080004002 <argraw>:

static uint64
argraw(int n)
{
    80004002:	7179                	addi	sp,sp,-48
    80004004:	f406                	sd	ra,40(sp)
    80004006:	f022                	sd	s0,32(sp)
    80004008:	1800                	addi	s0,sp,48
    8000400a:	87aa                	mv	a5,a0
    8000400c:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p = myproc();
    80004010:	fffff097          	auipc	ra,0xfffff
    80004014:	836080e7          	jalr	-1994(ra) # 80002846 <myproc>
    80004018:	fea43423          	sd	a0,-24(s0)
  switch (n) {
    8000401c:	fdc42783          	lw	a5,-36(s0)
    80004020:	0007871b          	sext.w	a4,a5
    80004024:	4795                	li	a5,5
    80004026:	06e7e263          	bltu	a5,a4,8000408a <argraw+0x88>
    8000402a:	fdc46783          	lwu	a5,-36(s0)
    8000402e:	00279713          	slli	a4,a5,0x2
    80004032:	00007797          	auipc	a5,0x7
    80004036:	3ae78793          	addi	a5,a5,942 # 8000b3e0 <etext+0x3e0>
    8000403a:	97ba                	add	a5,a5,a4
    8000403c:	439c                	lw	a5,0(a5)
    8000403e:	0007871b          	sext.w	a4,a5
    80004042:	00007797          	auipc	a5,0x7
    80004046:	39e78793          	addi	a5,a5,926 # 8000b3e0 <etext+0x3e0>
    8000404a:	97ba                	add	a5,a5,a4
    8000404c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000404e:	fe843783          	ld	a5,-24(s0)
    80004052:	6fbc                	ld	a5,88(a5)
    80004054:	7bbc                	ld	a5,112(a5)
    80004056:	a091                	j	8000409a <argraw+0x98>
  case 1:
    return p->trapframe->a1;
    80004058:	fe843783          	ld	a5,-24(s0)
    8000405c:	6fbc                	ld	a5,88(a5)
    8000405e:	7fbc                	ld	a5,120(a5)
    80004060:	a82d                	j	8000409a <argraw+0x98>
  case 2:
    return p->trapframe->a2;
    80004062:	fe843783          	ld	a5,-24(s0)
    80004066:	6fbc                	ld	a5,88(a5)
    80004068:	63dc                	ld	a5,128(a5)
    8000406a:	a805                	j	8000409a <argraw+0x98>
  case 3:
    return p->trapframe->a3;
    8000406c:	fe843783          	ld	a5,-24(s0)
    80004070:	6fbc                	ld	a5,88(a5)
    80004072:	67dc                	ld	a5,136(a5)
    80004074:	a01d                	j	8000409a <argraw+0x98>
  case 4:
    return p->trapframe->a4;
    80004076:	fe843783          	ld	a5,-24(s0)
    8000407a:	6fbc                	ld	a5,88(a5)
    8000407c:	6bdc                	ld	a5,144(a5)
    8000407e:	a831                	j	8000409a <argraw+0x98>
  case 5:
    return p->trapframe->a5;
    80004080:	fe843783          	ld	a5,-24(s0)
    80004084:	6fbc                	ld	a5,88(a5)
    80004086:	6fdc                	ld	a5,152(a5)
    80004088:	a809                	j	8000409a <argraw+0x98>
  }
  panic("argraw");
    8000408a:	00007517          	auipc	a0,0x7
    8000408e:	34e50513          	addi	a0,a0,846 # 8000b3d8 <etext+0x3d8>
    80004092:	ffffd097          	auipc	ra,0xffffd
    80004096:	bf8080e7          	jalr	-1032(ra) # 80000c8a <panic>
  return -1;
}
    8000409a:	853e                	mv	a0,a5
    8000409c:	70a2                	ld	ra,40(sp)
    8000409e:	7402                	ld	s0,32(sp)
    800040a0:	6145                	addi	sp,sp,48
    800040a2:	8082                	ret

00000000800040a4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800040a4:	1101                	addi	sp,sp,-32
    800040a6:	ec06                	sd	ra,24(sp)
    800040a8:	e822                	sd	s0,16(sp)
    800040aa:	1000                	addi	s0,sp,32
    800040ac:	87aa                	mv	a5,a0
    800040ae:	feb43023          	sd	a1,-32(s0)
    800040b2:	fef42623          	sw	a5,-20(s0)
  *ip = argraw(n);
    800040b6:	fec42783          	lw	a5,-20(s0)
    800040ba:	853e                	mv	a0,a5
    800040bc:	00000097          	auipc	ra,0x0
    800040c0:	f46080e7          	jalr	-186(ra) # 80004002 <argraw>
    800040c4:	87aa                	mv	a5,a0
    800040c6:	0007871b          	sext.w	a4,a5
    800040ca:	fe043783          	ld	a5,-32(s0)
    800040ce:	c398                	sw	a4,0(a5)
}
    800040d0:	0001                	nop
    800040d2:	60e2                	ld	ra,24(sp)
    800040d4:	6442                	ld	s0,16(sp)
    800040d6:	6105                	addi	sp,sp,32
    800040d8:	8082                	ret

00000000800040da <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800040da:	1101                	addi	sp,sp,-32
    800040dc:	ec06                	sd	ra,24(sp)
    800040de:	e822                	sd	s0,16(sp)
    800040e0:	1000                	addi	s0,sp,32
    800040e2:	87aa                	mv	a5,a0
    800040e4:	feb43023          	sd	a1,-32(s0)
    800040e8:	fef42623          	sw	a5,-20(s0)
  *ip = argraw(n);
    800040ec:	fec42783          	lw	a5,-20(s0)
    800040f0:	853e                	mv	a0,a5
    800040f2:	00000097          	auipc	ra,0x0
    800040f6:	f10080e7          	jalr	-240(ra) # 80004002 <argraw>
    800040fa:	872a                	mv	a4,a0
    800040fc:	fe043783          	ld	a5,-32(s0)
    80004100:	e398                	sd	a4,0(a5)
}
    80004102:	0001                	nop
    80004104:	60e2                	ld	ra,24(sp)
    80004106:	6442                	ld	s0,16(sp)
    80004108:	6105                	addi	sp,sp,32
    8000410a:	8082                	ret

000000008000410c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000410c:	7179                	addi	sp,sp,-48
    8000410e:	f406                	sd	ra,40(sp)
    80004110:	f022                	sd	s0,32(sp)
    80004112:	1800                	addi	s0,sp,48
    80004114:	87aa                	mv	a5,a0
    80004116:	fcb43823          	sd	a1,-48(s0)
    8000411a:	8732                	mv	a4,a2
    8000411c:	fcf42e23          	sw	a5,-36(s0)
    80004120:	87ba                	mv	a5,a4
    80004122:	fcf42c23          	sw	a5,-40(s0)
  uint64 addr;
  argaddr(n, &addr);
    80004126:	fe840713          	addi	a4,s0,-24
    8000412a:	fdc42783          	lw	a5,-36(s0)
    8000412e:	85ba                	mv	a1,a4
    80004130:	853e                	mv	a0,a5
    80004132:	00000097          	auipc	ra,0x0
    80004136:	fa8080e7          	jalr	-88(ra) # 800040da <argaddr>
  return fetchstr(addr, buf, max);
    8000413a:	fe843783          	ld	a5,-24(s0)
    8000413e:	fd842703          	lw	a4,-40(s0)
    80004142:	863a                	mv	a2,a4
    80004144:	fd043583          	ld	a1,-48(s0)
    80004148:	853e                	mv	a0,a5
    8000414a:	00000097          	auipc	ra,0x0
    8000414e:	e56080e7          	jalr	-426(ra) # 80003fa0 <fetchstr>
    80004152:	87aa                	mv	a5,a0
}
    80004154:	853e                	mv	a0,a5
    80004156:	70a2                	ld	ra,40(sp)
    80004158:	7402                	ld	s0,32(sp)
    8000415a:	6145                	addi	sp,sp,48
    8000415c:	8082                	ret

000000008000415e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000415e:	7179                	addi	sp,sp,-48
    80004160:	f406                	sd	ra,40(sp)
    80004162:	f022                	sd	s0,32(sp)
    80004164:	ec26                	sd	s1,24(sp)
    80004166:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80004168:	ffffe097          	auipc	ra,0xffffe
    8000416c:	6de080e7          	jalr	1758(ra) # 80002846 <myproc>
    80004170:	fca43c23          	sd	a0,-40(s0)

  num = p->trapframe->a7;
    80004174:	fd843783          	ld	a5,-40(s0)
    80004178:	6fbc                	ld	a5,88(a5)
    8000417a:	77dc                	ld	a5,168(a5)
    8000417c:	fcf42a23          	sw	a5,-44(s0)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80004180:	fd442783          	lw	a5,-44(s0)
    80004184:	2781                	sext.w	a5,a5
    80004186:	04f05263          	blez	a5,800041ca <syscall+0x6c>
    8000418a:	fd442783          	lw	a5,-44(s0)
    8000418e:	873e                	mv	a4,a5
    80004190:	47d5                	li	a5,21
    80004192:	02e7ec63          	bltu	a5,a4,800041ca <syscall+0x6c>
    80004196:	0000a717          	auipc	a4,0xa
    8000419a:	b9a70713          	addi	a4,a4,-1126 # 8000dd30 <syscalls>
    8000419e:	fd442783          	lw	a5,-44(s0)
    800041a2:	078e                	slli	a5,a5,0x3
    800041a4:	97ba                	add	a5,a5,a4
    800041a6:	639c                	ld	a5,0(a5)
    800041a8:	c38d                	beqz	a5,800041ca <syscall+0x6c>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800041aa:	0000a717          	auipc	a4,0xa
    800041ae:	b8670713          	addi	a4,a4,-1146 # 8000dd30 <syscalls>
    800041b2:	fd442783          	lw	a5,-44(s0)
    800041b6:	078e                	slli	a5,a5,0x3
    800041b8:	97ba                	add	a5,a5,a4
    800041ba:	639c                	ld	a5,0(a5)
    800041bc:	fd843703          	ld	a4,-40(s0)
    800041c0:	6f24                	ld	s1,88(a4)
    800041c2:	9782                	jalr	a5
    800041c4:	87aa                	mv	a5,a0
    800041c6:	f8bc                	sd	a5,112(s1)
    800041c8:	a815                	j	800041fc <syscall+0x9e>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800041ca:	fd843783          	ld	a5,-40(s0)
    800041ce:	5b98                	lw	a4,48(a5)
            p->pid, p->name, num);
    800041d0:	fd843783          	ld	a5,-40(s0)
    800041d4:	15878793          	addi	a5,a5,344
    printf("%d %s: unknown sys call %d\n",
    800041d8:	fd442683          	lw	a3,-44(s0)
    800041dc:	863e                	mv	a2,a5
    800041de:	85ba                	mv	a1,a4
    800041e0:	00007517          	auipc	a0,0x7
    800041e4:	21850513          	addi	a0,a0,536 # 8000b3f8 <etext+0x3f8>
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	84c080e7          	jalr	-1972(ra) # 80000a34 <printf>
    p->trapframe->a0 = -1;
    800041f0:	fd843783          	ld	a5,-40(s0)
    800041f4:	6fbc                	ld	a5,88(a5)
    800041f6:	577d                	li	a4,-1
    800041f8:	fbb8                	sd	a4,112(a5)
  }
}
    800041fa:	0001                	nop
    800041fc:	0001                	nop
    800041fe:	70a2                	ld	ra,40(sp)
    80004200:	7402                	ld	s0,32(sp)
    80004202:	64e2                	ld	s1,24(sp)
    80004204:	6145                	addi	sp,sp,48
    80004206:	8082                	ret

0000000080004208 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80004208:	1101                	addi	sp,sp,-32
    8000420a:	ec06                	sd	ra,24(sp)
    8000420c:	e822                	sd	s0,16(sp)
    8000420e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80004210:	fec40793          	addi	a5,s0,-20
    80004214:	85be                	mv	a1,a5
    80004216:	4501                	li	a0,0
    80004218:	00000097          	auipc	ra,0x0
    8000421c:	e8c080e7          	jalr	-372(ra) # 800040a4 <argint>
  exit(n);
    80004220:	fec42783          	lw	a5,-20(s0)
    80004224:	853e                	mv	a0,a5
    80004226:	fffff097          	auipc	ra,0xfffff
    8000422a:	d12080e7          	jalr	-750(ra) # 80002f38 <exit>
  return 0;  // not reached
    8000422e:	4781                	li	a5,0
}
    80004230:	853e                	mv	a0,a5
    80004232:	60e2                	ld	ra,24(sp)
    80004234:	6442                	ld	s0,16(sp)
    80004236:	6105                	addi	sp,sp,32
    80004238:	8082                	ret

000000008000423a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000423a:	1141                	addi	sp,sp,-16
    8000423c:	e406                	sd	ra,8(sp)
    8000423e:	e022                	sd	s0,0(sp)
    80004240:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80004242:	ffffe097          	auipc	ra,0xffffe
    80004246:	604080e7          	jalr	1540(ra) # 80002846 <myproc>
    8000424a:	87aa                	mv	a5,a0
    8000424c:	5b9c                	lw	a5,48(a5)
}
    8000424e:	853e                	mv	a0,a5
    80004250:	60a2                	ld	ra,8(sp)
    80004252:	6402                	ld	s0,0(sp)
    80004254:	0141                	addi	sp,sp,16
    80004256:	8082                	ret

0000000080004258 <sys_fork>:

uint64
sys_fork(void)
{
    80004258:	1141                	addi	sp,sp,-16
    8000425a:	e406                	sd	ra,8(sp)
    8000425c:	e022                	sd	s0,0(sp)
    8000425e:	0800                	addi	s0,sp,16
  return fork();
    80004260:	fffff097          	auipc	ra,0xfffff
    80004264:	ab6080e7          	jalr	-1354(ra) # 80002d16 <fork>
    80004268:	87aa                	mv	a5,a0
}
    8000426a:	853e                	mv	a0,a5
    8000426c:	60a2                	ld	ra,8(sp)
    8000426e:	6402                	ld	s0,0(sp)
    80004270:	0141                	addi	sp,sp,16
    80004272:	8082                	ret

0000000080004274 <sys_wait>:

uint64
sys_wait(void)
{
    80004274:	1101                	addi	sp,sp,-32
    80004276:	ec06                	sd	ra,24(sp)
    80004278:	e822                	sd	s0,16(sp)
    8000427a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000427c:	fe840793          	addi	a5,s0,-24
    80004280:	85be                	mv	a1,a5
    80004282:	4501                	li	a0,0
    80004284:	00000097          	auipc	ra,0x0
    80004288:	e56080e7          	jalr	-426(ra) # 800040da <argaddr>
  return wait(p);
    8000428c:	fe843783          	ld	a5,-24(s0)
    80004290:	853e                	mv	a0,a5
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	de2080e7          	jalr	-542(ra) # 80003074 <wait>
    8000429a:	87aa                	mv	a5,a0
}
    8000429c:	853e                	mv	a0,a5
    8000429e:	60e2                	ld	ra,24(sp)
    800042a0:	6442                	ld	s0,16(sp)
    800042a2:	6105                	addi	sp,sp,32
    800042a4:	8082                	ret

00000000800042a6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800042a6:	1101                	addi	sp,sp,-32
    800042a8:	ec06                	sd	ra,24(sp)
    800042aa:	e822                	sd	s0,16(sp)
    800042ac:	1000                	addi	s0,sp,32
  uint64 addr;
  int n;

  argint(0, &n);
    800042ae:	fe440793          	addi	a5,s0,-28
    800042b2:	85be                	mv	a1,a5
    800042b4:	4501                	li	a0,0
    800042b6:	00000097          	auipc	ra,0x0
    800042ba:	dee080e7          	jalr	-530(ra) # 800040a4 <argint>
  addr = myproc()->sz;
    800042be:	ffffe097          	auipc	ra,0xffffe
    800042c2:	588080e7          	jalr	1416(ra) # 80002846 <myproc>
    800042c6:	87aa                	mv	a5,a0
    800042c8:	67bc                	ld	a5,72(a5)
    800042ca:	fef43423          	sd	a5,-24(s0)
  if(growproc(n) < 0)
    800042ce:	fe442783          	lw	a5,-28(s0)
    800042d2:	853e                	mv	a0,a5
    800042d4:	fffff097          	auipc	ra,0xfffff
    800042d8:	9a2080e7          	jalr	-1630(ra) # 80002c76 <growproc>
    800042dc:	87aa                	mv	a5,a0
    800042de:	0007d463          	bgez	a5,800042e6 <sys_sbrk+0x40>
    return -1;
    800042e2:	57fd                	li	a5,-1
    800042e4:	a019                	j	800042ea <sys_sbrk+0x44>
  return addr;
    800042e6:	fe843783          	ld	a5,-24(s0)
}
    800042ea:	853e                	mv	a0,a5
    800042ec:	60e2                	ld	ra,24(sp)
    800042ee:	6442                	ld	s0,16(sp)
    800042f0:	6105                	addi	sp,sp,32
    800042f2:	8082                	ret

00000000800042f4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800042f4:	1101                	addi	sp,sp,-32
    800042f6:	ec06                	sd	ra,24(sp)
    800042f8:	e822                	sd	s0,16(sp)
    800042fa:	1000                	addi	s0,sp,32
  int n;
  uint ticks0;

  argint(0, &n);
    800042fc:	fe840793          	addi	a5,s0,-24
    80004300:	85be                	mv	a1,a5
    80004302:	4501                	li	a0,0
    80004304:	00000097          	auipc	ra,0x0
    80004308:	da0080e7          	jalr	-608(ra) # 800040a4 <argint>
  acquire(&tickslock);
    8000430c:	00018517          	auipc	a0,0x18
    80004310:	bbc50513          	addi	a0,a0,-1092 # 8001bec8 <tickslock>
    80004314:	ffffd097          	auipc	ra,0xffffd
    80004318:	f6a080e7          	jalr	-150(ra) # 8000127e <acquire>
  ticks0 = ticks;
    8000431c:	0000a797          	auipc	a5,0xa
    80004320:	b0c78793          	addi	a5,a5,-1268 # 8000de28 <ticks>
    80004324:	439c                	lw	a5,0(a5)
    80004326:	fef42623          	sw	a5,-20(s0)
  while(ticks - ticks0 < n){
    8000432a:	a099                	j	80004370 <sys_sleep+0x7c>
    if(killed(myproc())){
    8000432c:	ffffe097          	auipc	ra,0xffffe
    80004330:	51a080e7          	jalr	1306(ra) # 80002846 <myproc>
    80004334:	87aa                	mv	a5,a0
    80004336:	853e                	mv	a0,a5
    80004338:	fffff097          	auipc	ra,0xfffff
    8000433c:	2ba080e7          	jalr	698(ra) # 800035f2 <killed>
    80004340:	87aa                	mv	a5,a0
    80004342:	cb99                	beqz	a5,80004358 <sys_sleep+0x64>
      release(&tickslock);
    80004344:	00018517          	auipc	a0,0x18
    80004348:	b8450513          	addi	a0,a0,-1148 # 8001bec8 <tickslock>
    8000434c:	ffffd097          	auipc	ra,0xffffd
    80004350:	f96080e7          	jalr	-106(ra) # 800012e2 <release>
      return -1;
    80004354:	57fd                	li	a5,-1
    80004356:	a0a9                	j	800043a0 <sys_sleep+0xac>
    }
    sleep(&ticks, &tickslock);
    80004358:	00018597          	auipc	a1,0x18
    8000435c:	b7058593          	addi	a1,a1,-1168 # 8001bec8 <tickslock>
    80004360:	0000a517          	auipc	a0,0xa
    80004364:	ac850513          	addi	a0,a0,-1336 # 8000de28 <ticks>
    80004368:	fffff097          	auipc	ra,0xfffff
    8000436c:	0a0080e7          	jalr	160(ra) # 80003408 <sleep>
  while(ticks - ticks0 < n){
    80004370:	0000a797          	auipc	a5,0xa
    80004374:	ab878793          	addi	a5,a5,-1352 # 8000de28 <ticks>
    80004378:	439c                	lw	a5,0(a5)
    8000437a:	fec42703          	lw	a4,-20(s0)
    8000437e:	9f99                	subw	a5,a5,a4
    80004380:	0007871b          	sext.w	a4,a5
    80004384:	fe842783          	lw	a5,-24(s0)
    80004388:	2781                	sext.w	a5,a5
    8000438a:	faf761e3          	bltu	a4,a5,8000432c <sys_sleep+0x38>
  }
  release(&tickslock);
    8000438e:	00018517          	auipc	a0,0x18
    80004392:	b3a50513          	addi	a0,a0,-1222 # 8001bec8 <tickslock>
    80004396:	ffffd097          	auipc	ra,0xffffd
    8000439a:	f4c080e7          	jalr	-180(ra) # 800012e2 <release>
  return 0;
    8000439e:	4781                	li	a5,0
}
    800043a0:	853e                	mv	a0,a5
    800043a2:	60e2                	ld	ra,24(sp)
    800043a4:	6442                	ld	s0,16(sp)
    800043a6:	6105                	addi	sp,sp,32
    800043a8:	8082                	ret

00000000800043aa <sys_kill>:

uint64
sys_kill(void)
{
    800043aa:	1101                	addi	sp,sp,-32
    800043ac:	ec06                	sd	ra,24(sp)
    800043ae:	e822                	sd	s0,16(sp)
    800043b0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800043b2:	fec40793          	addi	a5,s0,-20
    800043b6:	85be                	mv	a1,a5
    800043b8:	4501                	li	a0,0
    800043ba:	00000097          	auipc	ra,0x0
    800043be:	cea080e7          	jalr	-790(ra) # 800040a4 <argint>
  return kill(pid);
    800043c2:	fec42783          	lw	a5,-20(s0)
    800043c6:	853e                	mv	a0,a5
    800043c8:	fffff097          	auipc	ra,0xfffff
    800043cc:	150080e7          	jalr	336(ra) # 80003518 <kill>
    800043d0:	87aa                	mv	a5,a0
}
    800043d2:	853e                	mv	a0,a5
    800043d4:	60e2                	ld	ra,24(sp)
    800043d6:	6442                	ld	s0,16(sp)
    800043d8:	6105                	addi	sp,sp,32
    800043da:	8082                	ret

00000000800043dc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800043dc:	1101                	addi	sp,sp,-32
    800043de:	ec06                	sd	ra,24(sp)
    800043e0:	e822                	sd	s0,16(sp)
    800043e2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800043e4:	00018517          	auipc	a0,0x18
    800043e8:	ae450513          	addi	a0,a0,-1308 # 8001bec8 <tickslock>
    800043ec:	ffffd097          	auipc	ra,0xffffd
    800043f0:	e92080e7          	jalr	-366(ra) # 8000127e <acquire>
  xticks = ticks;
    800043f4:	0000a797          	auipc	a5,0xa
    800043f8:	a3478793          	addi	a5,a5,-1484 # 8000de28 <ticks>
    800043fc:	439c                	lw	a5,0(a5)
    800043fe:	fef42623          	sw	a5,-20(s0)
  release(&tickslock);
    80004402:	00018517          	auipc	a0,0x18
    80004406:	ac650513          	addi	a0,a0,-1338 # 8001bec8 <tickslock>
    8000440a:	ffffd097          	auipc	ra,0xffffd
    8000440e:	ed8080e7          	jalr	-296(ra) # 800012e2 <release>
  return xticks;
    80004412:	fec46783          	lwu	a5,-20(s0)
}
    80004416:	853e                	mv	a0,a5
    80004418:	60e2                	ld	ra,24(sp)
    8000441a:	6442                	ld	s0,16(sp)
    8000441c:	6105                	addi	sp,sp,32
    8000441e:	8082                	ret

0000000080004420 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80004420:	1101                	addi	sp,sp,-32
    80004422:	ec06                	sd	ra,24(sp)
    80004424:	e822                	sd	s0,16(sp)
    80004426:	1000                	addi	s0,sp,32
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80004428:	00007597          	auipc	a1,0x7
    8000442c:	ff058593          	addi	a1,a1,-16 # 8000b418 <etext+0x418>
    80004430:	00018517          	auipc	a0,0x18
    80004434:	ab050513          	addi	a0,a0,-1360 # 8001bee0 <bcache>
    80004438:	ffffd097          	auipc	ra,0xffffd
    8000443c:	e16080e7          	jalr	-490(ra) # 8000124e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80004440:	00018717          	auipc	a4,0x18
    80004444:	aa070713          	addi	a4,a4,-1376 # 8001bee0 <bcache>
    80004448:	67a1                	lui	a5,0x8
    8000444a:	97ba                	add	a5,a5,a4
    8000444c:	00020717          	auipc	a4,0x20
    80004450:	cfc70713          	addi	a4,a4,-772 # 80024148 <bcache+0x8268>
    80004454:	2ae7b823          	sd	a4,688(a5) # 82b0 <_entry-0x7fff7d50>
  bcache.head.next = &bcache.head;
    80004458:	00018717          	auipc	a4,0x18
    8000445c:	a8870713          	addi	a4,a4,-1400 # 8001bee0 <bcache>
    80004460:	67a1                	lui	a5,0x8
    80004462:	97ba                	add	a5,a5,a4
    80004464:	00020717          	auipc	a4,0x20
    80004468:	ce470713          	addi	a4,a4,-796 # 80024148 <bcache+0x8268>
    8000446c:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80004470:	00018797          	auipc	a5,0x18
    80004474:	a8878793          	addi	a5,a5,-1400 # 8001bef8 <bcache+0x18>
    80004478:	fef43423          	sd	a5,-24(s0)
    8000447c:	a895                	j	800044f0 <binit+0xd0>
    b->next = bcache.head.next;
    8000447e:	00018717          	auipc	a4,0x18
    80004482:	a6270713          	addi	a4,a4,-1438 # 8001bee0 <bcache>
    80004486:	67a1                	lui	a5,0x8
    80004488:	97ba                	add	a5,a5,a4
    8000448a:	2b87b703          	ld	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000448e:	fe843783          	ld	a5,-24(s0)
    80004492:	ebb8                	sd	a4,80(a5)
    b->prev = &bcache.head;
    80004494:	fe843783          	ld	a5,-24(s0)
    80004498:	00020717          	auipc	a4,0x20
    8000449c:	cb070713          	addi	a4,a4,-848 # 80024148 <bcache+0x8268>
    800044a0:	e7b8                	sd	a4,72(a5)
    initsleeplock(&b->lock, "buffer");
    800044a2:	fe843783          	ld	a5,-24(s0)
    800044a6:	07c1                	addi	a5,a5,16
    800044a8:	00007597          	auipc	a1,0x7
    800044ac:	f7858593          	addi	a1,a1,-136 # 8000b420 <etext+0x420>
    800044b0:	853e                	mv	a0,a5
    800044b2:	00002097          	auipc	ra,0x2
    800044b6:	01e080e7          	jalr	30(ra) # 800064d0 <initsleeplock>
    bcache.head.next->prev = b;
    800044ba:	00018717          	auipc	a4,0x18
    800044be:	a2670713          	addi	a4,a4,-1498 # 8001bee0 <bcache>
    800044c2:	67a1                	lui	a5,0x8
    800044c4:	97ba                	add	a5,a5,a4
    800044c6:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    800044ca:	fe843703          	ld	a4,-24(s0)
    800044ce:	e7b8                	sd	a4,72(a5)
    bcache.head.next = b;
    800044d0:	00018717          	auipc	a4,0x18
    800044d4:	a1070713          	addi	a4,a4,-1520 # 8001bee0 <bcache>
    800044d8:	67a1                	lui	a5,0x8
    800044da:	97ba                	add	a5,a5,a4
    800044dc:	fe843703          	ld	a4,-24(s0)
    800044e0:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800044e4:	fe843783          	ld	a5,-24(s0)
    800044e8:	45878793          	addi	a5,a5,1112
    800044ec:	fef43423          	sd	a5,-24(s0)
    800044f0:	00020797          	auipc	a5,0x20
    800044f4:	c5878793          	addi	a5,a5,-936 # 80024148 <bcache+0x8268>
    800044f8:	fe843703          	ld	a4,-24(s0)
    800044fc:	f8f761e3          	bltu	a4,a5,8000447e <binit+0x5e>
  }
}
    80004500:	0001                	nop
    80004502:	0001                	nop
    80004504:	60e2                	ld	ra,24(sp)
    80004506:	6442                	ld	s0,16(sp)
    80004508:	6105                	addi	sp,sp,32
    8000450a:	8082                	ret

000000008000450c <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
    8000450c:	7179                	addi	sp,sp,-48
    8000450e:	f406                	sd	ra,40(sp)
    80004510:	f022                	sd	s0,32(sp)
    80004512:	1800                	addi	s0,sp,48
    80004514:	87aa                	mv	a5,a0
    80004516:	872e                	mv	a4,a1
    80004518:	fcf42e23          	sw	a5,-36(s0)
    8000451c:	87ba                	mv	a5,a4
    8000451e:	fcf42c23          	sw	a5,-40(s0)
  struct buf *b;

  acquire(&bcache.lock);
    80004522:	00018517          	auipc	a0,0x18
    80004526:	9be50513          	addi	a0,a0,-1602 # 8001bee0 <bcache>
    8000452a:	ffffd097          	auipc	ra,0xffffd
    8000452e:	d54080e7          	jalr	-684(ra) # 8000127e <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80004532:	00018717          	auipc	a4,0x18
    80004536:	9ae70713          	addi	a4,a4,-1618 # 8001bee0 <bcache>
    8000453a:	67a1                	lui	a5,0x8
    8000453c:	97ba                	add	a5,a5,a4
    8000453e:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    80004542:	fef43423          	sd	a5,-24(s0)
    80004546:	a095                	j	800045aa <bget+0x9e>
    if(b->dev == dev && b->blockno == blockno){
    80004548:	fe843783          	ld	a5,-24(s0)
    8000454c:	4798                	lw	a4,8(a5)
    8000454e:	fdc42783          	lw	a5,-36(s0)
    80004552:	2781                	sext.w	a5,a5
    80004554:	04e79663          	bne	a5,a4,800045a0 <bget+0x94>
    80004558:	fe843783          	ld	a5,-24(s0)
    8000455c:	47d8                	lw	a4,12(a5)
    8000455e:	fd842783          	lw	a5,-40(s0)
    80004562:	2781                	sext.w	a5,a5
    80004564:	02e79e63          	bne	a5,a4,800045a0 <bget+0x94>
      b->refcnt++;
    80004568:	fe843783          	ld	a5,-24(s0)
    8000456c:	43bc                	lw	a5,64(a5)
    8000456e:	2785                	addiw	a5,a5,1
    80004570:	0007871b          	sext.w	a4,a5
    80004574:	fe843783          	ld	a5,-24(s0)
    80004578:	c3b8                	sw	a4,64(a5)
      release(&bcache.lock);
    8000457a:	00018517          	auipc	a0,0x18
    8000457e:	96650513          	addi	a0,a0,-1690 # 8001bee0 <bcache>
    80004582:	ffffd097          	auipc	ra,0xffffd
    80004586:	d60080e7          	jalr	-672(ra) # 800012e2 <release>
      acquiresleep(&b->lock);
    8000458a:	fe843783          	ld	a5,-24(s0)
    8000458e:	07c1                	addi	a5,a5,16
    80004590:	853e                	mv	a0,a5
    80004592:	00002097          	auipc	ra,0x2
    80004596:	f8a080e7          	jalr	-118(ra) # 8000651c <acquiresleep>
      return b;
    8000459a:	fe843783          	ld	a5,-24(s0)
    8000459e:	a07d                	j	8000464c <bget+0x140>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800045a0:	fe843783          	ld	a5,-24(s0)
    800045a4:	6bbc                	ld	a5,80(a5)
    800045a6:	fef43423          	sd	a5,-24(s0)
    800045aa:	fe843703          	ld	a4,-24(s0)
    800045ae:	00020797          	auipc	a5,0x20
    800045b2:	b9a78793          	addi	a5,a5,-1126 # 80024148 <bcache+0x8268>
    800045b6:	f8f719e3          	bne	a4,a5,80004548 <bget+0x3c>
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800045ba:	00018717          	auipc	a4,0x18
    800045be:	92670713          	addi	a4,a4,-1754 # 8001bee0 <bcache>
    800045c2:	67a1                	lui	a5,0x8
    800045c4:	97ba                	add	a5,a5,a4
    800045c6:	2b07b783          	ld	a5,688(a5) # 82b0 <_entry-0x7fff7d50>
    800045ca:	fef43423          	sd	a5,-24(s0)
    800045ce:	a8b9                	j	8000462c <bget+0x120>
    if(b->refcnt == 0) {
    800045d0:	fe843783          	ld	a5,-24(s0)
    800045d4:	43bc                	lw	a5,64(a5)
    800045d6:	e7b1                	bnez	a5,80004622 <bget+0x116>
      b->dev = dev;
    800045d8:	fe843783          	ld	a5,-24(s0)
    800045dc:	fdc42703          	lw	a4,-36(s0)
    800045e0:	c798                	sw	a4,8(a5)
      b->blockno = blockno;
    800045e2:	fe843783          	ld	a5,-24(s0)
    800045e6:	fd842703          	lw	a4,-40(s0)
    800045ea:	c7d8                	sw	a4,12(a5)
      b->valid = 0;
    800045ec:	fe843783          	ld	a5,-24(s0)
    800045f0:	0007a023          	sw	zero,0(a5)
      b->refcnt = 1;
    800045f4:	fe843783          	ld	a5,-24(s0)
    800045f8:	4705                	li	a4,1
    800045fa:	c3b8                	sw	a4,64(a5)
      release(&bcache.lock);
    800045fc:	00018517          	auipc	a0,0x18
    80004600:	8e450513          	addi	a0,a0,-1820 # 8001bee0 <bcache>
    80004604:	ffffd097          	auipc	ra,0xffffd
    80004608:	cde080e7          	jalr	-802(ra) # 800012e2 <release>
      acquiresleep(&b->lock);
    8000460c:	fe843783          	ld	a5,-24(s0)
    80004610:	07c1                	addi	a5,a5,16
    80004612:	853e                	mv	a0,a5
    80004614:	00002097          	auipc	ra,0x2
    80004618:	f08080e7          	jalr	-248(ra) # 8000651c <acquiresleep>
      return b;
    8000461c:	fe843783          	ld	a5,-24(s0)
    80004620:	a035                	j	8000464c <bget+0x140>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004622:	fe843783          	ld	a5,-24(s0)
    80004626:	67bc                	ld	a5,72(a5)
    80004628:	fef43423          	sd	a5,-24(s0)
    8000462c:	fe843703          	ld	a4,-24(s0)
    80004630:	00020797          	auipc	a5,0x20
    80004634:	b1878793          	addi	a5,a5,-1256 # 80024148 <bcache+0x8268>
    80004638:	f8f71ce3          	bne	a4,a5,800045d0 <bget+0xc4>
    }
  }
  panic("bget: no buffers");
    8000463c:	00007517          	auipc	a0,0x7
    80004640:	dec50513          	addi	a0,a0,-532 # 8000b428 <etext+0x428>
    80004644:	ffffc097          	auipc	ra,0xffffc
    80004648:	646080e7          	jalr	1606(ra) # 80000c8a <panic>
}
    8000464c:	853e                	mv	a0,a5
    8000464e:	70a2                	ld	ra,40(sp)
    80004650:	7402                	ld	s0,32(sp)
    80004652:	6145                	addi	sp,sp,48
    80004654:	8082                	ret

0000000080004656 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80004656:	7179                	addi	sp,sp,-48
    80004658:	f406                	sd	ra,40(sp)
    8000465a:	f022                	sd	s0,32(sp)
    8000465c:	1800                	addi	s0,sp,48
    8000465e:	87aa                	mv	a5,a0
    80004660:	872e                	mv	a4,a1
    80004662:	fcf42e23          	sw	a5,-36(s0)
    80004666:	87ba                	mv	a5,a4
    80004668:	fcf42c23          	sw	a5,-40(s0)
  struct buf *b;

  b = bget(dev, blockno);
    8000466c:	fd842703          	lw	a4,-40(s0)
    80004670:	fdc42783          	lw	a5,-36(s0)
    80004674:	85ba                	mv	a1,a4
    80004676:	853e                	mv	a0,a5
    80004678:	00000097          	auipc	ra,0x0
    8000467c:	e94080e7          	jalr	-364(ra) # 8000450c <bget>
    80004680:	fea43423          	sd	a0,-24(s0)
  if(!b->valid) {
    80004684:	fe843783          	ld	a5,-24(s0)
    80004688:	439c                	lw	a5,0(a5)
    8000468a:	ef81                	bnez	a5,800046a2 <bread+0x4c>
    virtio_disk_rw(b, 0);
    8000468c:	4581                	li	a1,0
    8000468e:	fe843503          	ld	a0,-24(s0)
    80004692:	00005097          	auipc	ra,0x5
    80004696:	8a0080e7          	jalr	-1888(ra) # 80008f32 <virtio_disk_rw>
    b->valid = 1;
    8000469a:	fe843783          	ld	a5,-24(s0)
    8000469e:	4705                	li	a4,1
    800046a0:	c398                	sw	a4,0(a5)
  }
  return b;
    800046a2:	fe843783          	ld	a5,-24(s0)
}
    800046a6:	853e                	mv	a0,a5
    800046a8:	70a2                	ld	ra,40(sp)
    800046aa:	7402                	ld	s0,32(sp)
    800046ac:	6145                	addi	sp,sp,48
    800046ae:	8082                	ret

00000000800046b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800046b0:	1101                	addi	sp,sp,-32
    800046b2:	ec06                	sd	ra,24(sp)
    800046b4:	e822                	sd	s0,16(sp)
    800046b6:	1000                	addi	s0,sp,32
    800046b8:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    800046bc:	fe843783          	ld	a5,-24(s0)
    800046c0:	07c1                	addi	a5,a5,16
    800046c2:	853e                	mv	a0,a5
    800046c4:	00002097          	auipc	ra,0x2
    800046c8:	f18080e7          	jalr	-232(ra) # 800065dc <holdingsleep>
    800046cc:	87aa                	mv	a5,a0
    800046ce:	eb89                	bnez	a5,800046e0 <bwrite+0x30>
    panic("bwrite");
    800046d0:	00007517          	auipc	a0,0x7
    800046d4:	d7050513          	addi	a0,a0,-656 # 8000b440 <etext+0x440>
    800046d8:	ffffc097          	auipc	ra,0xffffc
    800046dc:	5b2080e7          	jalr	1458(ra) # 80000c8a <panic>
  virtio_disk_rw(b, 1);
    800046e0:	4585                	li	a1,1
    800046e2:	fe843503          	ld	a0,-24(s0)
    800046e6:	00005097          	auipc	ra,0x5
    800046ea:	84c080e7          	jalr	-1972(ra) # 80008f32 <virtio_disk_rw>
}
    800046ee:	0001                	nop
    800046f0:	60e2                	ld	ra,24(sp)
    800046f2:	6442                	ld	s0,16(sp)
    800046f4:	6105                	addi	sp,sp,32
    800046f6:	8082                	ret

00000000800046f8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800046f8:	1101                	addi	sp,sp,-32
    800046fa:	ec06                	sd	ra,24(sp)
    800046fc:	e822                	sd	s0,16(sp)
    800046fe:	1000                	addi	s0,sp,32
    80004700:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    80004704:	fe843783          	ld	a5,-24(s0)
    80004708:	07c1                	addi	a5,a5,16
    8000470a:	853e                	mv	a0,a5
    8000470c:	00002097          	auipc	ra,0x2
    80004710:	ed0080e7          	jalr	-304(ra) # 800065dc <holdingsleep>
    80004714:	87aa                	mv	a5,a0
    80004716:	eb89                	bnez	a5,80004728 <brelse+0x30>
    panic("brelse");
    80004718:	00007517          	auipc	a0,0x7
    8000471c:	d3050513          	addi	a0,a0,-720 # 8000b448 <etext+0x448>
    80004720:	ffffc097          	auipc	ra,0xffffc
    80004724:	56a080e7          	jalr	1386(ra) # 80000c8a <panic>

  releasesleep(&b->lock);
    80004728:	fe843783          	ld	a5,-24(s0)
    8000472c:	07c1                	addi	a5,a5,16
    8000472e:	853e                	mv	a0,a5
    80004730:	00002097          	auipc	ra,0x2
    80004734:	e5a080e7          	jalr	-422(ra) # 8000658a <releasesleep>

  acquire(&bcache.lock);
    80004738:	00017517          	auipc	a0,0x17
    8000473c:	7a850513          	addi	a0,a0,1960 # 8001bee0 <bcache>
    80004740:	ffffd097          	auipc	ra,0xffffd
    80004744:	b3e080e7          	jalr	-1218(ra) # 8000127e <acquire>
  b->refcnt--;
    80004748:	fe843783          	ld	a5,-24(s0)
    8000474c:	43bc                	lw	a5,64(a5)
    8000474e:	37fd                	addiw	a5,a5,-1
    80004750:	0007871b          	sext.w	a4,a5
    80004754:	fe843783          	ld	a5,-24(s0)
    80004758:	c3b8                	sw	a4,64(a5)
  if (b->refcnt == 0) {
    8000475a:	fe843783          	ld	a5,-24(s0)
    8000475e:	43bc                	lw	a5,64(a5)
    80004760:	e7b5                	bnez	a5,800047cc <brelse+0xd4>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80004762:	fe843783          	ld	a5,-24(s0)
    80004766:	6bbc                	ld	a5,80(a5)
    80004768:	fe843703          	ld	a4,-24(s0)
    8000476c:	6738                	ld	a4,72(a4)
    8000476e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80004770:	fe843783          	ld	a5,-24(s0)
    80004774:	67bc                	ld	a5,72(a5)
    80004776:	fe843703          	ld	a4,-24(s0)
    8000477a:	6b38                	ld	a4,80(a4)
    8000477c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000477e:	00017717          	auipc	a4,0x17
    80004782:	76270713          	addi	a4,a4,1890 # 8001bee0 <bcache>
    80004786:	67a1                	lui	a5,0x8
    80004788:	97ba                	add	a5,a5,a4
    8000478a:	2b87b703          	ld	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000478e:	fe843783          	ld	a5,-24(s0)
    80004792:	ebb8                	sd	a4,80(a5)
    b->prev = &bcache.head;
    80004794:	fe843783          	ld	a5,-24(s0)
    80004798:	00020717          	auipc	a4,0x20
    8000479c:	9b070713          	addi	a4,a4,-1616 # 80024148 <bcache+0x8268>
    800047a0:	e7b8                	sd	a4,72(a5)
    bcache.head.next->prev = b;
    800047a2:	00017717          	auipc	a4,0x17
    800047a6:	73e70713          	addi	a4,a4,1854 # 8001bee0 <bcache>
    800047aa:	67a1                	lui	a5,0x8
    800047ac:	97ba                	add	a5,a5,a4
    800047ae:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    800047b2:	fe843703          	ld	a4,-24(s0)
    800047b6:	e7b8                	sd	a4,72(a5)
    bcache.head.next = b;
    800047b8:	00017717          	auipc	a4,0x17
    800047bc:	72870713          	addi	a4,a4,1832 # 8001bee0 <bcache>
    800047c0:	67a1                	lui	a5,0x8
    800047c2:	97ba                	add	a5,a5,a4
    800047c4:	fe843703          	ld	a4,-24(s0)
    800047c8:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  }
  
  release(&bcache.lock);
    800047cc:	00017517          	auipc	a0,0x17
    800047d0:	71450513          	addi	a0,a0,1812 # 8001bee0 <bcache>
    800047d4:	ffffd097          	auipc	ra,0xffffd
    800047d8:	b0e080e7          	jalr	-1266(ra) # 800012e2 <release>
}
    800047dc:	0001                	nop
    800047de:	60e2                	ld	ra,24(sp)
    800047e0:	6442                	ld	s0,16(sp)
    800047e2:	6105                	addi	sp,sp,32
    800047e4:	8082                	ret

00000000800047e6 <bpin>:

void
bpin(struct buf *b) {
    800047e6:	1101                	addi	sp,sp,-32
    800047e8:	ec06                	sd	ra,24(sp)
    800047ea:	e822                	sd	s0,16(sp)
    800047ec:	1000                	addi	s0,sp,32
    800047ee:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    800047f2:	00017517          	auipc	a0,0x17
    800047f6:	6ee50513          	addi	a0,a0,1774 # 8001bee0 <bcache>
    800047fa:	ffffd097          	auipc	ra,0xffffd
    800047fe:	a84080e7          	jalr	-1404(ra) # 8000127e <acquire>
  b->refcnt++;
    80004802:	fe843783          	ld	a5,-24(s0)
    80004806:	43bc                	lw	a5,64(a5)
    80004808:	2785                	addiw	a5,a5,1
    8000480a:	0007871b          	sext.w	a4,a5
    8000480e:	fe843783          	ld	a5,-24(s0)
    80004812:	c3b8                	sw	a4,64(a5)
  release(&bcache.lock);
    80004814:	00017517          	auipc	a0,0x17
    80004818:	6cc50513          	addi	a0,a0,1740 # 8001bee0 <bcache>
    8000481c:	ffffd097          	auipc	ra,0xffffd
    80004820:	ac6080e7          	jalr	-1338(ra) # 800012e2 <release>
}
    80004824:	0001                	nop
    80004826:	60e2                	ld	ra,24(sp)
    80004828:	6442                	ld	s0,16(sp)
    8000482a:	6105                	addi	sp,sp,32
    8000482c:	8082                	ret

000000008000482e <bunpin>:

void
bunpin(struct buf *b) {
    8000482e:	1101                	addi	sp,sp,-32
    80004830:	ec06                	sd	ra,24(sp)
    80004832:	e822                	sd	s0,16(sp)
    80004834:	1000                	addi	s0,sp,32
    80004836:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    8000483a:	00017517          	auipc	a0,0x17
    8000483e:	6a650513          	addi	a0,a0,1702 # 8001bee0 <bcache>
    80004842:	ffffd097          	auipc	ra,0xffffd
    80004846:	a3c080e7          	jalr	-1476(ra) # 8000127e <acquire>
  b->refcnt--;
    8000484a:	fe843783          	ld	a5,-24(s0)
    8000484e:	43bc                	lw	a5,64(a5)
    80004850:	37fd                	addiw	a5,a5,-1
    80004852:	0007871b          	sext.w	a4,a5
    80004856:	fe843783          	ld	a5,-24(s0)
    8000485a:	c3b8                	sw	a4,64(a5)
  release(&bcache.lock);
    8000485c:	00017517          	auipc	a0,0x17
    80004860:	68450513          	addi	a0,a0,1668 # 8001bee0 <bcache>
    80004864:	ffffd097          	auipc	ra,0xffffd
    80004868:	a7e080e7          	jalr	-1410(ra) # 800012e2 <release>
}
    8000486c:	0001                	nop
    8000486e:	60e2                	ld	ra,24(sp)
    80004870:	6442                	ld	s0,16(sp)
    80004872:	6105                	addi	sp,sp,32
    80004874:	8082                	ret

0000000080004876 <readsb>:
struct superblock sb; 

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
    80004876:	7179                	addi	sp,sp,-48
    80004878:	f406                	sd	ra,40(sp)
    8000487a:	f022                	sd	s0,32(sp)
    8000487c:	1800                	addi	s0,sp,48
    8000487e:	87aa                	mv	a5,a0
    80004880:	fcb43823          	sd	a1,-48(s0)
    80004884:	fcf42e23          	sw	a5,-36(s0)
  struct buf *bp;

  bp = bread(dev, 1);
    80004888:	fdc42783          	lw	a5,-36(s0)
    8000488c:	4585                	li	a1,1
    8000488e:	853e                	mv	a0,a5
    80004890:	00000097          	auipc	ra,0x0
    80004894:	dc6080e7          	jalr	-570(ra) # 80004656 <bread>
    80004898:	fea43423          	sd	a0,-24(s0)
  memmove(sb, bp->data, sizeof(*sb));
    8000489c:	fe843783          	ld	a5,-24(s0)
    800048a0:	05878793          	addi	a5,a5,88
    800048a4:	02000613          	li	a2,32
    800048a8:	85be                	mv	a1,a5
    800048aa:	fd043503          	ld	a0,-48(s0)
    800048ae:	ffffd097          	auipc	ra,0xffffd
    800048b2:	c88080e7          	jalr	-888(ra) # 80001536 <memmove>
  brelse(bp);
    800048b6:	fe843503          	ld	a0,-24(s0)
    800048ba:	00000097          	auipc	ra,0x0
    800048be:	e3e080e7          	jalr	-450(ra) # 800046f8 <brelse>
}
    800048c2:	0001                	nop
    800048c4:	70a2                	ld	ra,40(sp)
    800048c6:	7402                	ld	s0,32(sp)
    800048c8:	6145                	addi	sp,sp,48
    800048ca:	8082                	ret

00000000800048cc <fsinit>:

// Init fs
void
fsinit(int dev) {
    800048cc:	1101                	addi	sp,sp,-32
    800048ce:	ec06                	sd	ra,24(sp)
    800048d0:	e822                	sd	s0,16(sp)
    800048d2:	1000                	addi	s0,sp,32
    800048d4:	87aa                	mv	a5,a0
    800048d6:	fef42623          	sw	a5,-20(s0)
  readsb(dev, &sb);
    800048da:	fec42783          	lw	a5,-20(s0)
    800048de:	00020597          	auipc	a1,0x20
    800048e2:	cc258593          	addi	a1,a1,-830 # 800245a0 <sb>
    800048e6:	853e                	mv	a0,a5
    800048e8:	00000097          	auipc	ra,0x0
    800048ec:	f8e080e7          	jalr	-114(ra) # 80004876 <readsb>
  if(sb.magic != FSMAGIC)
    800048f0:	00020797          	auipc	a5,0x20
    800048f4:	cb078793          	addi	a5,a5,-848 # 800245a0 <sb>
    800048f8:	439c                	lw	a5,0(a5)
    800048fa:	873e                	mv	a4,a5
    800048fc:	102037b7          	lui	a5,0x10203
    80004900:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004904:	00f70a63          	beq	a4,a5,80004918 <fsinit+0x4c>
    panic("invalid file system");
    80004908:	00007517          	auipc	a0,0x7
    8000490c:	b4850513          	addi	a0,a0,-1208 # 8000b450 <etext+0x450>
    80004910:	ffffc097          	auipc	ra,0xffffc
    80004914:	37a080e7          	jalr	890(ra) # 80000c8a <panic>
  initlog(dev, &sb);
    80004918:	fec42783          	lw	a5,-20(s0)
    8000491c:	00020597          	auipc	a1,0x20
    80004920:	c8458593          	addi	a1,a1,-892 # 800245a0 <sb>
    80004924:	853e                	mv	a0,a5
    80004926:	00001097          	auipc	ra,0x1
    8000492a:	48e080e7          	jalr	1166(ra) # 80005db4 <initlog>
}
    8000492e:	0001                	nop
    80004930:	60e2                	ld	ra,24(sp)
    80004932:	6442                	ld	s0,16(sp)
    80004934:	6105                	addi	sp,sp,32
    80004936:	8082                	ret

0000000080004938 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
    80004938:	7179                	addi	sp,sp,-48
    8000493a:	f406                	sd	ra,40(sp)
    8000493c:	f022                	sd	s0,32(sp)
    8000493e:	1800                	addi	s0,sp,48
    80004940:	87aa                	mv	a5,a0
    80004942:	872e                	mv	a4,a1
    80004944:	fcf42e23          	sw	a5,-36(s0)
    80004948:	87ba                	mv	a5,a4
    8000494a:	fcf42c23          	sw	a5,-40(s0)
  struct buf *bp;

  bp = bread(dev, bno);
    8000494e:	fdc42783          	lw	a5,-36(s0)
    80004952:	fd842703          	lw	a4,-40(s0)
    80004956:	85ba                	mv	a1,a4
    80004958:	853e                	mv	a0,a5
    8000495a:	00000097          	auipc	ra,0x0
    8000495e:	cfc080e7          	jalr	-772(ra) # 80004656 <bread>
    80004962:	fea43423          	sd	a0,-24(s0)
  memset(bp->data, 0, BSIZE);
    80004966:	fe843783          	ld	a5,-24(s0)
    8000496a:	05878793          	addi	a5,a5,88
    8000496e:	40000613          	li	a2,1024
    80004972:	4581                	li	a1,0
    80004974:	853e                	mv	a0,a5
    80004976:	ffffd097          	auipc	ra,0xffffd
    8000497a:	adc080e7          	jalr	-1316(ra) # 80001452 <memset>
  log_write(bp);
    8000497e:	fe843503          	ld	a0,-24(s0)
    80004982:	00002097          	auipc	ra,0x2
    80004986:	a1a080e7          	jalr	-1510(ra) # 8000639c <log_write>
  brelse(bp);
    8000498a:	fe843503          	ld	a0,-24(s0)
    8000498e:	00000097          	auipc	ra,0x0
    80004992:	d6a080e7          	jalr	-662(ra) # 800046f8 <brelse>
}
    80004996:	0001                	nop
    80004998:	70a2                	ld	ra,40(sp)
    8000499a:	7402                	ld	s0,32(sp)
    8000499c:	6145                	addi	sp,sp,48
    8000499e:	8082                	ret

00000000800049a0 <balloc>:

// Allocate a zeroed disk block.
// returns 0 if out of disk space.
static uint
balloc(uint dev)
{
    800049a0:	7139                	addi	sp,sp,-64
    800049a2:	fc06                	sd	ra,56(sp)
    800049a4:	f822                	sd	s0,48(sp)
    800049a6:	0080                	addi	s0,sp,64
    800049a8:	87aa                	mv	a5,a0
    800049aa:	fcf42623          	sw	a5,-52(s0)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
    800049ae:	fe043023          	sd	zero,-32(s0)
  for(b = 0; b < sb.size; b += BPB){
    800049b2:	fe042623          	sw	zero,-20(s0)
    800049b6:	a295                	j	80004b1a <balloc+0x17a>
    bp = bread(dev, BBLOCK(b, sb));
    800049b8:	fec42783          	lw	a5,-20(s0)
    800049bc:	41f7d71b          	sraiw	a4,a5,0x1f
    800049c0:	0137571b          	srliw	a4,a4,0x13
    800049c4:	9fb9                	addw	a5,a5,a4
    800049c6:	40d7d79b          	sraiw	a5,a5,0xd
    800049ca:	2781                	sext.w	a5,a5
    800049cc:	0007871b          	sext.w	a4,a5
    800049d0:	00020797          	auipc	a5,0x20
    800049d4:	bd078793          	addi	a5,a5,-1072 # 800245a0 <sb>
    800049d8:	4fdc                	lw	a5,28(a5)
    800049da:	9fb9                	addw	a5,a5,a4
    800049dc:	0007871b          	sext.w	a4,a5
    800049e0:	fcc42783          	lw	a5,-52(s0)
    800049e4:	85ba                	mv	a1,a4
    800049e6:	853e                	mv	a0,a5
    800049e8:	00000097          	auipc	ra,0x0
    800049ec:	c6e080e7          	jalr	-914(ra) # 80004656 <bread>
    800049f0:	fea43023          	sd	a0,-32(s0)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800049f4:	fe042423          	sw	zero,-24(s0)
    800049f8:	a8e9                	j	80004ad2 <balloc+0x132>
      m = 1 << (bi % 8);
    800049fa:	fe842783          	lw	a5,-24(s0)
    800049fe:	8b9d                	andi	a5,a5,7
    80004a00:	2781                	sext.w	a5,a5
    80004a02:	4705                	li	a4,1
    80004a04:	00f717bb          	sllw	a5,a4,a5
    80004a08:	fcf42e23          	sw	a5,-36(s0)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004a0c:	fe842783          	lw	a5,-24(s0)
    80004a10:	41f7d71b          	sraiw	a4,a5,0x1f
    80004a14:	01d7571b          	srliw	a4,a4,0x1d
    80004a18:	9fb9                	addw	a5,a5,a4
    80004a1a:	4037d79b          	sraiw	a5,a5,0x3
    80004a1e:	2781                	sext.w	a5,a5
    80004a20:	fe043703          	ld	a4,-32(s0)
    80004a24:	97ba                	add	a5,a5,a4
    80004a26:	0587c783          	lbu	a5,88(a5)
    80004a2a:	2781                	sext.w	a5,a5
    80004a2c:	fdc42703          	lw	a4,-36(s0)
    80004a30:	8ff9                	and	a5,a5,a4
    80004a32:	2781                	sext.w	a5,a5
    80004a34:	ebd1                	bnez	a5,80004ac8 <balloc+0x128>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004a36:	fe842783          	lw	a5,-24(s0)
    80004a3a:	41f7d71b          	sraiw	a4,a5,0x1f
    80004a3e:	01d7571b          	srliw	a4,a4,0x1d
    80004a42:	9fb9                	addw	a5,a5,a4
    80004a44:	4037d79b          	sraiw	a5,a5,0x3
    80004a48:	2781                	sext.w	a5,a5
    80004a4a:	fe043703          	ld	a4,-32(s0)
    80004a4e:	973e                	add	a4,a4,a5
    80004a50:	05874703          	lbu	a4,88(a4)
    80004a54:	0187169b          	slliw	a3,a4,0x18
    80004a58:	4186d69b          	sraiw	a3,a3,0x18
    80004a5c:	fdc42703          	lw	a4,-36(s0)
    80004a60:	0187171b          	slliw	a4,a4,0x18
    80004a64:	4187571b          	sraiw	a4,a4,0x18
    80004a68:	8f55                	or	a4,a4,a3
    80004a6a:	0187171b          	slliw	a4,a4,0x18
    80004a6e:	4187571b          	sraiw	a4,a4,0x18
    80004a72:	0ff77713          	zext.b	a4,a4
    80004a76:	fe043683          	ld	a3,-32(s0)
    80004a7a:	97b6                	add	a5,a5,a3
    80004a7c:	04e78c23          	sb	a4,88(a5)
        log_write(bp);
    80004a80:	fe043503          	ld	a0,-32(s0)
    80004a84:	00002097          	auipc	ra,0x2
    80004a88:	918080e7          	jalr	-1768(ra) # 8000639c <log_write>
        brelse(bp);
    80004a8c:	fe043503          	ld	a0,-32(s0)
    80004a90:	00000097          	auipc	ra,0x0
    80004a94:	c68080e7          	jalr	-920(ra) # 800046f8 <brelse>
        bzero(dev, b + bi);
    80004a98:	fcc42783          	lw	a5,-52(s0)
    80004a9c:	fec42703          	lw	a4,-20(s0)
    80004aa0:	86ba                	mv	a3,a4
    80004aa2:	fe842703          	lw	a4,-24(s0)
    80004aa6:	9f35                	addw	a4,a4,a3
    80004aa8:	2701                	sext.w	a4,a4
    80004aaa:	85ba                	mv	a1,a4
    80004aac:	853e                	mv	a0,a5
    80004aae:	00000097          	auipc	ra,0x0
    80004ab2:	e8a080e7          	jalr	-374(ra) # 80004938 <bzero>
        return b + bi;
    80004ab6:	fec42783          	lw	a5,-20(s0)
    80004aba:	873e                	mv	a4,a5
    80004abc:	fe842783          	lw	a5,-24(s0)
    80004ac0:	9fb9                	addw	a5,a5,a4
    80004ac2:	2781                	sext.w	a5,a5
    80004ac4:	2781                	sext.w	a5,a5
    80004ac6:	a8a5                	j	80004b3e <balloc+0x19e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004ac8:	fe842783          	lw	a5,-24(s0)
    80004acc:	2785                	addiw	a5,a5,1
    80004ace:	fef42423          	sw	a5,-24(s0)
    80004ad2:	fe842783          	lw	a5,-24(s0)
    80004ad6:	0007871b          	sext.w	a4,a5
    80004ada:	6789                	lui	a5,0x2
    80004adc:	02f75263          	bge	a4,a5,80004b00 <balloc+0x160>
    80004ae0:	fec42783          	lw	a5,-20(s0)
    80004ae4:	873e                	mv	a4,a5
    80004ae6:	fe842783          	lw	a5,-24(s0)
    80004aea:	9fb9                	addw	a5,a5,a4
    80004aec:	2781                	sext.w	a5,a5
    80004aee:	0007871b          	sext.w	a4,a5
    80004af2:	00020797          	auipc	a5,0x20
    80004af6:	aae78793          	addi	a5,a5,-1362 # 800245a0 <sb>
    80004afa:	43dc                	lw	a5,4(a5)
    80004afc:	eef76fe3          	bltu	a4,a5,800049fa <balloc+0x5a>
      }
    }
    brelse(bp);
    80004b00:	fe043503          	ld	a0,-32(s0)
    80004b04:	00000097          	auipc	ra,0x0
    80004b08:	bf4080e7          	jalr	-1036(ra) # 800046f8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004b0c:	fec42783          	lw	a5,-20(s0)
    80004b10:	873e                	mv	a4,a5
    80004b12:	6789                	lui	a5,0x2
    80004b14:	9fb9                	addw	a5,a5,a4
    80004b16:	fef42623          	sw	a5,-20(s0)
    80004b1a:	00020797          	auipc	a5,0x20
    80004b1e:	a8678793          	addi	a5,a5,-1402 # 800245a0 <sb>
    80004b22:	43d8                	lw	a4,4(a5)
    80004b24:	fec42783          	lw	a5,-20(s0)
    80004b28:	e8e7e8e3          	bltu	a5,a4,800049b8 <balloc+0x18>
  }
  printf("balloc: out of blocks\n");
    80004b2c:	00007517          	auipc	a0,0x7
    80004b30:	93c50513          	addi	a0,a0,-1732 # 8000b468 <etext+0x468>
    80004b34:	ffffc097          	auipc	ra,0xffffc
    80004b38:	f00080e7          	jalr	-256(ra) # 80000a34 <printf>
  return 0;
    80004b3c:	4781                	li	a5,0
}
    80004b3e:	853e                	mv	a0,a5
    80004b40:	70e2                	ld	ra,56(sp)
    80004b42:	7442                	ld	s0,48(sp)
    80004b44:	6121                	addi	sp,sp,64
    80004b46:	8082                	ret

0000000080004b48 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80004b48:	7179                	addi	sp,sp,-48
    80004b4a:	f406                	sd	ra,40(sp)
    80004b4c:	f022                	sd	s0,32(sp)
    80004b4e:	1800                	addi	s0,sp,48
    80004b50:	87aa                	mv	a5,a0
    80004b52:	872e                	mv	a4,a1
    80004b54:	fcf42e23          	sw	a5,-36(s0)
    80004b58:	87ba                	mv	a5,a4
    80004b5a:	fcf42c23          	sw	a5,-40(s0)
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80004b5e:	fdc42683          	lw	a3,-36(s0)
    80004b62:	fd842783          	lw	a5,-40(s0)
    80004b66:	00d7d79b          	srliw	a5,a5,0xd
    80004b6a:	0007871b          	sext.w	a4,a5
    80004b6e:	00020797          	auipc	a5,0x20
    80004b72:	a3278793          	addi	a5,a5,-1486 # 800245a0 <sb>
    80004b76:	4fdc                	lw	a5,28(a5)
    80004b78:	9fb9                	addw	a5,a5,a4
    80004b7a:	2781                	sext.w	a5,a5
    80004b7c:	85be                	mv	a1,a5
    80004b7e:	8536                	mv	a0,a3
    80004b80:	00000097          	auipc	ra,0x0
    80004b84:	ad6080e7          	jalr	-1322(ra) # 80004656 <bread>
    80004b88:	fea43423          	sd	a0,-24(s0)
  bi = b % BPB;
    80004b8c:	fd842703          	lw	a4,-40(s0)
    80004b90:	6789                	lui	a5,0x2
    80004b92:	17fd                	addi	a5,a5,-1 # 1fff <_entry-0x7fffe001>
    80004b94:	8ff9                	and	a5,a5,a4
    80004b96:	fef42223          	sw	a5,-28(s0)
  m = 1 << (bi % 8);
    80004b9a:	fe442783          	lw	a5,-28(s0)
    80004b9e:	8b9d                	andi	a5,a5,7
    80004ba0:	2781                	sext.w	a5,a5
    80004ba2:	4705                	li	a4,1
    80004ba4:	00f717bb          	sllw	a5,a4,a5
    80004ba8:	fef42023          	sw	a5,-32(s0)
  if((bp->data[bi/8] & m) == 0)
    80004bac:	fe442783          	lw	a5,-28(s0)
    80004bb0:	41f7d71b          	sraiw	a4,a5,0x1f
    80004bb4:	01d7571b          	srliw	a4,a4,0x1d
    80004bb8:	9fb9                	addw	a5,a5,a4
    80004bba:	4037d79b          	sraiw	a5,a5,0x3
    80004bbe:	2781                	sext.w	a5,a5
    80004bc0:	fe843703          	ld	a4,-24(s0)
    80004bc4:	97ba                	add	a5,a5,a4
    80004bc6:	0587c783          	lbu	a5,88(a5)
    80004bca:	2781                	sext.w	a5,a5
    80004bcc:	fe042703          	lw	a4,-32(s0)
    80004bd0:	8ff9                	and	a5,a5,a4
    80004bd2:	2781                	sext.w	a5,a5
    80004bd4:	eb89                	bnez	a5,80004be6 <bfree+0x9e>
    panic("freeing free block");
    80004bd6:	00007517          	auipc	a0,0x7
    80004bda:	8aa50513          	addi	a0,a0,-1878 # 8000b480 <etext+0x480>
    80004bde:	ffffc097          	auipc	ra,0xffffc
    80004be2:	0ac080e7          	jalr	172(ra) # 80000c8a <panic>
  bp->data[bi/8] &= ~m;
    80004be6:	fe442783          	lw	a5,-28(s0)
    80004bea:	41f7d71b          	sraiw	a4,a5,0x1f
    80004bee:	01d7571b          	srliw	a4,a4,0x1d
    80004bf2:	9fb9                	addw	a5,a5,a4
    80004bf4:	4037d79b          	sraiw	a5,a5,0x3
    80004bf8:	2781                	sext.w	a5,a5
    80004bfa:	fe843703          	ld	a4,-24(s0)
    80004bfe:	973e                	add	a4,a4,a5
    80004c00:	05874703          	lbu	a4,88(a4)
    80004c04:	0187169b          	slliw	a3,a4,0x18
    80004c08:	4186d69b          	sraiw	a3,a3,0x18
    80004c0c:	fe042703          	lw	a4,-32(s0)
    80004c10:	0187171b          	slliw	a4,a4,0x18
    80004c14:	4187571b          	sraiw	a4,a4,0x18
    80004c18:	fff74713          	not	a4,a4
    80004c1c:	0187171b          	slliw	a4,a4,0x18
    80004c20:	4187571b          	sraiw	a4,a4,0x18
    80004c24:	8f75                	and	a4,a4,a3
    80004c26:	0187171b          	slliw	a4,a4,0x18
    80004c2a:	4187571b          	sraiw	a4,a4,0x18
    80004c2e:	0ff77713          	zext.b	a4,a4
    80004c32:	fe843683          	ld	a3,-24(s0)
    80004c36:	97b6                	add	a5,a5,a3
    80004c38:	04e78c23          	sb	a4,88(a5)
  log_write(bp);
    80004c3c:	fe843503          	ld	a0,-24(s0)
    80004c40:	00001097          	auipc	ra,0x1
    80004c44:	75c080e7          	jalr	1884(ra) # 8000639c <log_write>
  brelse(bp);
    80004c48:	fe843503          	ld	a0,-24(s0)
    80004c4c:	00000097          	auipc	ra,0x0
    80004c50:	aac080e7          	jalr	-1364(ra) # 800046f8 <brelse>
}
    80004c54:	0001                	nop
    80004c56:	70a2                	ld	ra,40(sp)
    80004c58:	7402                	ld	s0,32(sp)
    80004c5a:	6145                	addi	sp,sp,48
    80004c5c:	8082                	ret

0000000080004c5e <iinit>:
  struct inode inode[NINODE];
} itable;

void
iinit()
{
    80004c5e:	1101                	addi	sp,sp,-32
    80004c60:	ec06                	sd	ra,24(sp)
    80004c62:	e822                	sd	s0,16(sp)
    80004c64:	1000                	addi	s0,sp,32
  int i = 0;
    80004c66:	fe042623          	sw	zero,-20(s0)
  
  initlock(&itable.lock, "itable");
    80004c6a:	00007597          	auipc	a1,0x7
    80004c6e:	82e58593          	addi	a1,a1,-2002 # 8000b498 <etext+0x498>
    80004c72:	00020517          	auipc	a0,0x20
    80004c76:	94e50513          	addi	a0,a0,-1714 # 800245c0 <itable>
    80004c7a:	ffffc097          	auipc	ra,0xffffc
    80004c7e:	5d4080e7          	jalr	1492(ra) # 8000124e <initlock>
  for(i = 0; i < NINODE; i++) {
    80004c82:	fe042623          	sw	zero,-20(s0)
    80004c86:	a82d                	j	80004cc0 <iinit+0x62>
    initsleeplock(&itable.inode[i].lock, "inode");
    80004c88:	fec42703          	lw	a4,-20(s0)
    80004c8c:	87ba                	mv	a5,a4
    80004c8e:	0792                	slli	a5,a5,0x4
    80004c90:	97ba                	add	a5,a5,a4
    80004c92:	078e                	slli	a5,a5,0x3
    80004c94:	02078713          	addi	a4,a5,32
    80004c98:	00020797          	auipc	a5,0x20
    80004c9c:	92878793          	addi	a5,a5,-1752 # 800245c0 <itable>
    80004ca0:	97ba                	add	a5,a5,a4
    80004ca2:	07a1                	addi	a5,a5,8
    80004ca4:	00006597          	auipc	a1,0x6
    80004ca8:	7fc58593          	addi	a1,a1,2044 # 8000b4a0 <etext+0x4a0>
    80004cac:	853e                	mv	a0,a5
    80004cae:	00002097          	auipc	ra,0x2
    80004cb2:	822080e7          	jalr	-2014(ra) # 800064d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004cb6:	fec42783          	lw	a5,-20(s0)
    80004cba:	2785                	addiw	a5,a5,1
    80004cbc:	fef42623          	sw	a5,-20(s0)
    80004cc0:	fec42783          	lw	a5,-20(s0)
    80004cc4:	0007871b          	sext.w	a4,a5
    80004cc8:	03100793          	li	a5,49
    80004ccc:	fae7dee3          	bge	a5,a4,80004c88 <iinit+0x2a>
  }
}
    80004cd0:	0001                	nop
    80004cd2:	0001                	nop
    80004cd4:	60e2                	ld	ra,24(sp)
    80004cd6:	6442                	ld	s0,16(sp)
    80004cd8:	6105                	addi	sp,sp,32
    80004cda:	8082                	ret

0000000080004cdc <ialloc>:
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode,
// or NULL if there is no free inode.
struct inode*
ialloc(uint dev, short type)
{
    80004cdc:	7139                	addi	sp,sp,-64
    80004cde:	fc06                	sd	ra,56(sp)
    80004ce0:	f822                	sd	s0,48(sp)
    80004ce2:	0080                	addi	s0,sp,64
    80004ce4:	87aa                	mv	a5,a0
    80004ce6:	872e                	mv	a4,a1
    80004ce8:	fcf42623          	sw	a5,-52(s0)
    80004cec:	87ba                	mv	a5,a4
    80004cee:	fcf41523          	sh	a5,-54(s0)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    80004cf2:	4785                	li	a5,1
    80004cf4:	fef42623          	sw	a5,-20(s0)
    80004cf8:	a855                	j	80004dac <ialloc+0xd0>
    bp = bread(dev, IBLOCK(inum, sb));
    80004cfa:	fec42783          	lw	a5,-20(s0)
    80004cfe:	8391                	srli	a5,a5,0x4
    80004d00:	0007871b          	sext.w	a4,a5
    80004d04:	00020797          	auipc	a5,0x20
    80004d08:	89c78793          	addi	a5,a5,-1892 # 800245a0 <sb>
    80004d0c:	4f9c                	lw	a5,24(a5)
    80004d0e:	9fb9                	addw	a5,a5,a4
    80004d10:	0007871b          	sext.w	a4,a5
    80004d14:	fcc42783          	lw	a5,-52(s0)
    80004d18:	85ba                	mv	a1,a4
    80004d1a:	853e                	mv	a0,a5
    80004d1c:	00000097          	auipc	ra,0x0
    80004d20:	93a080e7          	jalr	-1734(ra) # 80004656 <bread>
    80004d24:	fea43023          	sd	a0,-32(s0)
    dip = (struct dinode*)bp->data + inum%IPB;
    80004d28:	fe043783          	ld	a5,-32(s0)
    80004d2c:	05878713          	addi	a4,a5,88
    80004d30:	fec42783          	lw	a5,-20(s0)
    80004d34:	8bbd                	andi	a5,a5,15
    80004d36:	079a                	slli	a5,a5,0x6
    80004d38:	97ba                	add	a5,a5,a4
    80004d3a:	fcf43c23          	sd	a5,-40(s0)
    if(dip->type == 0){  // a free inode
    80004d3e:	fd843783          	ld	a5,-40(s0)
    80004d42:	00079783          	lh	a5,0(a5)
    80004d46:	eba1                	bnez	a5,80004d96 <ialloc+0xba>
      memset(dip, 0, sizeof(*dip));
    80004d48:	04000613          	li	a2,64
    80004d4c:	4581                	li	a1,0
    80004d4e:	fd843503          	ld	a0,-40(s0)
    80004d52:	ffffc097          	auipc	ra,0xffffc
    80004d56:	700080e7          	jalr	1792(ra) # 80001452 <memset>
      dip->type = type;
    80004d5a:	fd843783          	ld	a5,-40(s0)
    80004d5e:	fca45703          	lhu	a4,-54(s0)
    80004d62:	00e79023          	sh	a4,0(a5)
      log_write(bp);   // mark it allocated on the disk
    80004d66:	fe043503          	ld	a0,-32(s0)
    80004d6a:	00001097          	auipc	ra,0x1
    80004d6e:	632080e7          	jalr	1586(ra) # 8000639c <log_write>
      brelse(bp);
    80004d72:	fe043503          	ld	a0,-32(s0)
    80004d76:	00000097          	auipc	ra,0x0
    80004d7a:	982080e7          	jalr	-1662(ra) # 800046f8 <brelse>
      return iget(dev, inum);
    80004d7e:	fec42703          	lw	a4,-20(s0)
    80004d82:	fcc42783          	lw	a5,-52(s0)
    80004d86:	85ba                	mv	a1,a4
    80004d88:	853e                	mv	a0,a5
    80004d8a:	00000097          	auipc	ra,0x0
    80004d8e:	138080e7          	jalr	312(ra) # 80004ec2 <iget>
    80004d92:	87aa                	mv	a5,a0
    80004d94:	a835                	j	80004dd0 <ialloc+0xf4>
    }
    brelse(bp);
    80004d96:	fe043503          	ld	a0,-32(s0)
    80004d9a:	00000097          	auipc	ra,0x0
    80004d9e:	95e080e7          	jalr	-1698(ra) # 800046f8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004da2:	fec42783          	lw	a5,-20(s0)
    80004da6:	2785                	addiw	a5,a5,1
    80004da8:	fef42623          	sw	a5,-20(s0)
    80004dac:	0001f797          	auipc	a5,0x1f
    80004db0:	7f478793          	addi	a5,a5,2036 # 800245a0 <sb>
    80004db4:	47d8                	lw	a4,12(a5)
    80004db6:	fec42783          	lw	a5,-20(s0)
    80004dba:	f4e7e0e3          	bltu	a5,a4,80004cfa <ialloc+0x1e>
  }
  printf("ialloc: no inodes\n");
    80004dbe:	00006517          	auipc	a0,0x6
    80004dc2:	6ea50513          	addi	a0,a0,1770 # 8000b4a8 <etext+0x4a8>
    80004dc6:	ffffc097          	auipc	ra,0xffffc
    80004dca:	c6e080e7          	jalr	-914(ra) # 80000a34 <printf>
  return 0;
    80004dce:	4781                	li	a5,0
}
    80004dd0:	853e                	mv	a0,a5
    80004dd2:	70e2                	ld	ra,56(sp)
    80004dd4:	7442                	ld	s0,48(sp)
    80004dd6:	6121                	addi	sp,sp,64
    80004dd8:	8082                	ret

0000000080004dda <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
    80004dda:	7179                	addi	sp,sp,-48
    80004ddc:	f406                	sd	ra,40(sp)
    80004dde:	f022                	sd	s0,32(sp)
    80004de0:	1800                	addi	s0,sp,48
    80004de2:	fca43c23          	sd	a0,-40(s0)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004de6:	fd843783          	ld	a5,-40(s0)
    80004dea:	4394                	lw	a3,0(a5)
    80004dec:	fd843783          	ld	a5,-40(s0)
    80004df0:	43dc                	lw	a5,4(a5)
    80004df2:	0047d79b          	srliw	a5,a5,0x4
    80004df6:	0007871b          	sext.w	a4,a5
    80004dfa:	0001f797          	auipc	a5,0x1f
    80004dfe:	7a678793          	addi	a5,a5,1958 # 800245a0 <sb>
    80004e02:	4f9c                	lw	a5,24(a5)
    80004e04:	9fb9                	addw	a5,a5,a4
    80004e06:	2781                	sext.w	a5,a5
    80004e08:	85be                	mv	a1,a5
    80004e0a:	8536                	mv	a0,a3
    80004e0c:	00000097          	auipc	ra,0x0
    80004e10:	84a080e7          	jalr	-1974(ra) # 80004656 <bread>
    80004e14:	fea43423          	sd	a0,-24(s0)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004e18:	fe843783          	ld	a5,-24(s0)
    80004e1c:	05878713          	addi	a4,a5,88
    80004e20:	fd843783          	ld	a5,-40(s0)
    80004e24:	43dc                	lw	a5,4(a5)
    80004e26:	1782                	slli	a5,a5,0x20
    80004e28:	9381                	srli	a5,a5,0x20
    80004e2a:	8bbd                	andi	a5,a5,15
    80004e2c:	079a                	slli	a5,a5,0x6
    80004e2e:	97ba                	add	a5,a5,a4
    80004e30:	fef43023          	sd	a5,-32(s0)
  dip->type = ip->type;
    80004e34:	fd843783          	ld	a5,-40(s0)
    80004e38:	04479703          	lh	a4,68(a5)
    80004e3c:	fe043783          	ld	a5,-32(s0)
    80004e40:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004e44:	fd843783          	ld	a5,-40(s0)
    80004e48:	04679703          	lh	a4,70(a5)
    80004e4c:	fe043783          	ld	a5,-32(s0)
    80004e50:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004e54:	fd843783          	ld	a5,-40(s0)
    80004e58:	04879703          	lh	a4,72(a5)
    80004e5c:	fe043783          	ld	a5,-32(s0)
    80004e60:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004e64:	fd843783          	ld	a5,-40(s0)
    80004e68:	04a79703          	lh	a4,74(a5)
    80004e6c:	fe043783          	ld	a5,-32(s0)
    80004e70:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004e74:	fd843783          	ld	a5,-40(s0)
    80004e78:	47f8                	lw	a4,76(a5)
    80004e7a:	fe043783          	ld	a5,-32(s0)
    80004e7e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004e80:	fe043783          	ld	a5,-32(s0)
    80004e84:	00c78713          	addi	a4,a5,12
    80004e88:	fd843783          	ld	a5,-40(s0)
    80004e8c:	05078793          	addi	a5,a5,80
    80004e90:	03400613          	li	a2,52
    80004e94:	85be                	mv	a1,a5
    80004e96:	853a                	mv	a0,a4
    80004e98:	ffffc097          	auipc	ra,0xffffc
    80004e9c:	69e080e7          	jalr	1694(ra) # 80001536 <memmove>
  log_write(bp);
    80004ea0:	fe843503          	ld	a0,-24(s0)
    80004ea4:	00001097          	auipc	ra,0x1
    80004ea8:	4f8080e7          	jalr	1272(ra) # 8000639c <log_write>
  brelse(bp);
    80004eac:	fe843503          	ld	a0,-24(s0)
    80004eb0:	00000097          	auipc	ra,0x0
    80004eb4:	848080e7          	jalr	-1976(ra) # 800046f8 <brelse>
}
    80004eb8:	0001                	nop
    80004eba:	70a2                	ld	ra,40(sp)
    80004ebc:	7402                	ld	s0,32(sp)
    80004ebe:	6145                	addi	sp,sp,48
    80004ec0:	8082                	ret

0000000080004ec2 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
    80004ec2:	7179                	addi	sp,sp,-48
    80004ec4:	f406                	sd	ra,40(sp)
    80004ec6:	f022                	sd	s0,32(sp)
    80004ec8:	1800                	addi	s0,sp,48
    80004eca:	87aa                	mv	a5,a0
    80004ecc:	872e                	mv	a4,a1
    80004ece:	fcf42e23          	sw	a5,-36(s0)
    80004ed2:	87ba                	mv	a5,a4
    80004ed4:	fcf42c23          	sw	a5,-40(s0)
  struct inode *ip, *empty;

  acquire(&itable.lock);
    80004ed8:	0001f517          	auipc	a0,0x1f
    80004edc:	6e850513          	addi	a0,a0,1768 # 800245c0 <itable>
    80004ee0:	ffffc097          	auipc	ra,0xffffc
    80004ee4:	39e080e7          	jalr	926(ra) # 8000127e <acquire>

  // Is the inode already in the table?
  empty = 0;
    80004ee8:	fe043023          	sd	zero,-32(s0)
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004eec:	0001f797          	auipc	a5,0x1f
    80004ef0:	6ec78793          	addi	a5,a5,1772 # 800245d8 <itable+0x18>
    80004ef4:	fef43423          	sd	a5,-24(s0)
    80004ef8:	a89d                	j	80004f6e <iget+0xac>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80004efa:	fe843783          	ld	a5,-24(s0)
    80004efe:	479c                	lw	a5,8(a5)
    80004f00:	04f05663          	blez	a5,80004f4c <iget+0x8a>
    80004f04:	fe843783          	ld	a5,-24(s0)
    80004f08:	4398                	lw	a4,0(a5)
    80004f0a:	fdc42783          	lw	a5,-36(s0)
    80004f0e:	2781                	sext.w	a5,a5
    80004f10:	02e79e63          	bne	a5,a4,80004f4c <iget+0x8a>
    80004f14:	fe843783          	ld	a5,-24(s0)
    80004f18:	43d8                	lw	a4,4(a5)
    80004f1a:	fd842783          	lw	a5,-40(s0)
    80004f1e:	2781                	sext.w	a5,a5
    80004f20:	02e79663          	bne	a5,a4,80004f4c <iget+0x8a>
      ip->ref++;
    80004f24:	fe843783          	ld	a5,-24(s0)
    80004f28:	479c                	lw	a5,8(a5)
    80004f2a:	2785                	addiw	a5,a5,1
    80004f2c:	0007871b          	sext.w	a4,a5
    80004f30:	fe843783          	ld	a5,-24(s0)
    80004f34:	c798                	sw	a4,8(a5)
      release(&itable.lock);
    80004f36:	0001f517          	auipc	a0,0x1f
    80004f3a:	68a50513          	addi	a0,a0,1674 # 800245c0 <itable>
    80004f3e:	ffffc097          	auipc	ra,0xffffc
    80004f42:	3a4080e7          	jalr	932(ra) # 800012e2 <release>
      return ip;
    80004f46:	fe843783          	ld	a5,-24(s0)
    80004f4a:	a069                	j	80004fd4 <iget+0x112>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004f4c:	fe043783          	ld	a5,-32(s0)
    80004f50:	eb89                	bnez	a5,80004f62 <iget+0xa0>
    80004f52:	fe843783          	ld	a5,-24(s0)
    80004f56:	479c                	lw	a5,8(a5)
    80004f58:	e789                	bnez	a5,80004f62 <iget+0xa0>
      empty = ip;
    80004f5a:	fe843783          	ld	a5,-24(s0)
    80004f5e:	fef43023          	sd	a5,-32(s0)
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004f62:	fe843783          	ld	a5,-24(s0)
    80004f66:	08878793          	addi	a5,a5,136
    80004f6a:	fef43423          	sd	a5,-24(s0)
    80004f6e:	fe843703          	ld	a4,-24(s0)
    80004f72:	00021797          	auipc	a5,0x21
    80004f76:	0f678793          	addi	a5,a5,246 # 80026068 <log>
    80004f7a:	f8f760e3          	bltu	a4,a5,80004efa <iget+0x38>
  }

  // Recycle an inode entry.
  if(empty == 0)
    80004f7e:	fe043783          	ld	a5,-32(s0)
    80004f82:	eb89                	bnez	a5,80004f94 <iget+0xd2>
    panic("iget: no inodes");
    80004f84:	00006517          	auipc	a0,0x6
    80004f88:	53c50513          	addi	a0,a0,1340 # 8000b4c0 <etext+0x4c0>
    80004f8c:	ffffc097          	auipc	ra,0xffffc
    80004f90:	cfe080e7          	jalr	-770(ra) # 80000c8a <panic>

  ip = empty;
    80004f94:	fe043783          	ld	a5,-32(s0)
    80004f98:	fef43423          	sd	a5,-24(s0)
  ip->dev = dev;
    80004f9c:	fe843783          	ld	a5,-24(s0)
    80004fa0:	fdc42703          	lw	a4,-36(s0)
    80004fa4:	c398                	sw	a4,0(a5)
  ip->inum = inum;
    80004fa6:	fe843783          	ld	a5,-24(s0)
    80004faa:	fd842703          	lw	a4,-40(s0)
    80004fae:	c3d8                	sw	a4,4(a5)
  ip->ref = 1;
    80004fb0:	fe843783          	ld	a5,-24(s0)
    80004fb4:	4705                	li	a4,1
    80004fb6:	c798                	sw	a4,8(a5)
  ip->valid = 0;
    80004fb8:	fe843783          	ld	a5,-24(s0)
    80004fbc:	0407a023          	sw	zero,64(a5)
  release(&itable.lock);
    80004fc0:	0001f517          	auipc	a0,0x1f
    80004fc4:	60050513          	addi	a0,a0,1536 # 800245c0 <itable>
    80004fc8:	ffffc097          	auipc	ra,0xffffc
    80004fcc:	31a080e7          	jalr	794(ra) # 800012e2 <release>

  return ip;
    80004fd0:	fe843783          	ld	a5,-24(s0)
}
    80004fd4:	853e                	mv	a0,a5
    80004fd6:	70a2                	ld	ra,40(sp)
    80004fd8:	7402                	ld	s0,32(sp)
    80004fda:	6145                	addi	sp,sp,48
    80004fdc:	8082                	ret

0000000080004fde <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
    80004fde:	1101                	addi	sp,sp,-32
    80004fe0:	ec06                	sd	ra,24(sp)
    80004fe2:	e822                	sd	s0,16(sp)
    80004fe4:	1000                	addi	s0,sp,32
    80004fe6:	fea43423          	sd	a0,-24(s0)
  acquire(&itable.lock);
    80004fea:	0001f517          	auipc	a0,0x1f
    80004fee:	5d650513          	addi	a0,a0,1494 # 800245c0 <itable>
    80004ff2:	ffffc097          	auipc	ra,0xffffc
    80004ff6:	28c080e7          	jalr	652(ra) # 8000127e <acquire>
  ip->ref++;
    80004ffa:	fe843783          	ld	a5,-24(s0)
    80004ffe:	479c                	lw	a5,8(a5)
    80005000:	2785                	addiw	a5,a5,1
    80005002:	0007871b          	sext.w	a4,a5
    80005006:	fe843783          	ld	a5,-24(s0)
    8000500a:	c798                	sw	a4,8(a5)
  release(&itable.lock);
    8000500c:	0001f517          	auipc	a0,0x1f
    80005010:	5b450513          	addi	a0,a0,1460 # 800245c0 <itable>
    80005014:	ffffc097          	auipc	ra,0xffffc
    80005018:	2ce080e7          	jalr	718(ra) # 800012e2 <release>
  return ip;
    8000501c:	fe843783          	ld	a5,-24(s0)
}
    80005020:	853e                	mv	a0,a5
    80005022:	60e2                	ld	ra,24(sp)
    80005024:	6442                	ld	s0,16(sp)
    80005026:	6105                	addi	sp,sp,32
    80005028:	8082                	ret

000000008000502a <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
    8000502a:	7179                	addi	sp,sp,-48
    8000502c:	f406                	sd	ra,40(sp)
    8000502e:	f022                	sd	s0,32(sp)
    80005030:	1800                	addi	s0,sp,48
    80005032:	fca43c23          	sd	a0,-40(s0)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    80005036:	fd843783          	ld	a5,-40(s0)
    8000503a:	c791                	beqz	a5,80005046 <ilock+0x1c>
    8000503c:	fd843783          	ld	a5,-40(s0)
    80005040:	479c                	lw	a5,8(a5)
    80005042:	00f04a63          	bgtz	a5,80005056 <ilock+0x2c>
    panic("ilock");
    80005046:	00006517          	auipc	a0,0x6
    8000504a:	48a50513          	addi	a0,a0,1162 # 8000b4d0 <etext+0x4d0>
    8000504e:	ffffc097          	auipc	ra,0xffffc
    80005052:	c3c080e7          	jalr	-964(ra) # 80000c8a <panic>

  acquiresleep(&ip->lock);
    80005056:	fd843783          	ld	a5,-40(s0)
    8000505a:	07c1                	addi	a5,a5,16
    8000505c:	853e                	mv	a0,a5
    8000505e:	00001097          	auipc	ra,0x1
    80005062:	4be080e7          	jalr	1214(ra) # 8000651c <acquiresleep>

  if(ip->valid == 0){
    80005066:	fd843783          	ld	a5,-40(s0)
    8000506a:	43bc                	lw	a5,64(a5)
    8000506c:	e7e5                	bnez	a5,80005154 <ilock+0x12a>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000506e:	fd843783          	ld	a5,-40(s0)
    80005072:	4394                	lw	a3,0(a5)
    80005074:	fd843783          	ld	a5,-40(s0)
    80005078:	43dc                	lw	a5,4(a5)
    8000507a:	0047d79b          	srliw	a5,a5,0x4
    8000507e:	0007871b          	sext.w	a4,a5
    80005082:	0001f797          	auipc	a5,0x1f
    80005086:	51e78793          	addi	a5,a5,1310 # 800245a0 <sb>
    8000508a:	4f9c                	lw	a5,24(a5)
    8000508c:	9fb9                	addw	a5,a5,a4
    8000508e:	2781                	sext.w	a5,a5
    80005090:	85be                	mv	a1,a5
    80005092:	8536                	mv	a0,a3
    80005094:	fffff097          	auipc	ra,0xfffff
    80005098:	5c2080e7          	jalr	1474(ra) # 80004656 <bread>
    8000509c:	fea43423          	sd	a0,-24(s0)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800050a0:	fe843783          	ld	a5,-24(s0)
    800050a4:	05878713          	addi	a4,a5,88
    800050a8:	fd843783          	ld	a5,-40(s0)
    800050ac:	43dc                	lw	a5,4(a5)
    800050ae:	1782                	slli	a5,a5,0x20
    800050b0:	9381                	srli	a5,a5,0x20
    800050b2:	8bbd                	andi	a5,a5,15
    800050b4:	079a                	slli	a5,a5,0x6
    800050b6:	97ba                	add	a5,a5,a4
    800050b8:	fef43023          	sd	a5,-32(s0)
    ip->type = dip->type;
    800050bc:	fe043783          	ld	a5,-32(s0)
    800050c0:	00079703          	lh	a4,0(a5)
    800050c4:	fd843783          	ld	a5,-40(s0)
    800050c8:	04e79223          	sh	a4,68(a5)
    ip->major = dip->major;
    800050cc:	fe043783          	ld	a5,-32(s0)
    800050d0:	00279703          	lh	a4,2(a5)
    800050d4:	fd843783          	ld	a5,-40(s0)
    800050d8:	04e79323          	sh	a4,70(a5)
    ip->minor = dip->minor;
    800050dc:	fe043783          	ld	a5,-32(s0)
    800050e0:	00479703          	lh	a4,4(a5)
    800050e4:	fd843783          	ld	a5,-40(s0)
    800050e8:	04e79423          	sh	a4,72(a5)
    ip->nlink = dip->nlink;
    800050ec:	fe043783          	ld	a5,-32(s0)
    800050f0:	00679703          	lh	a4,6(a5)
    800050f4:	fd843783          	ld	a5,-40(s0)
    800050f8:	04e79523          	sh	a4,74(a5)
    ip->size = dip->size;
    800050fc:	fe043783          	ld	a5,-32(s0)
    80005100:	4798                	lw	a4,8(a5)
    80005102:	fd843783          	ld	a5,-40(s0)
    80005106:	c7f8                	sw	a4,76(a5)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80005108:	fd843783          	ld	a5,-40(s0)
    8000510c:	05078713          	addi	a4,a5,80
    80005110:	fe043783          	ld	a5,-32(s0)
    80005114:	07b1                	addi	a5,a5,12
    80005116:	03400613          	li	a2,52
    8000511a:	85be                	mv	a1,a5
    8000511c:	853a                	mv	a0,a4
    8000511e:	ffffc097          	auipc	ra,0xffffc
    80005122:	418080e7          	jalr	1048(ra) # 80001536 <memmove>
    brelse(bp);
    80005126:	fe843503          	ld	a0,-24(s0)
    8000512a:	fffff097          	auipc	ra,0xfffff
    8000512e:	5ce080e7          	jalr	1486(ra) # 800046f8 <brelse>
    ip->valid = 1;
    80005132:	fd843783          	ld	a5,-40(s0)
    80005136:	4705                	li	a4,1
    80005138:	c3b8                	sw	a4,64(a5)
    if(ip->type == 0)
    8000513a:	fd843783          	ld	a5,-40(s0)
    8000513e:	04479783          	lh	a5,68(a5)
    80005142:	eb89                	bnez	a5,80005154 <ilock+0x12a>
      panic("ilock: no type");
    80005144:	00006517          	auipc	a0,0x6
    80005148:	39450513          	addi	a0,a0,916 # 8000b4d8 <etext+0x4d8>
    8000514c:	ffffc097          	auipc	ra,0xffffc
    80005150:	b3e080e7          	jalr	-1218(ra) # 80000c8a <panic>
  }
}
    80005154:	0001                	nop
    80005156:	70a2                	ld	ra,40(sp)
    80005158:	7402                	ld	s0,32(sp)
    8000515a:	6145                	addi	sp,sp,48
    8000515c:	8082                	ret

000000008000515e <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
    8000515e:	1101                	addi	sp,sp,-32
    80005160:	ec06                	sd	ra,24(sp)
    80005162:	e822                	sd	s0,16(sp)
    80005164:	1000                	addi	s0,sp,32
    80005166:	fea43423          	sd	a0,-24(s0)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000516a:	fe843783          	ld	a5,-24(s0)
    8000516e:	c385                	beqz	a5,8000518e <iunlock+0x30>
    80005170:	fe843783          	ld	a5,-24(s0)
    80005174:	07c1                	addi	a5,a5,16
    80005176:	853e                	mv	a0,a5
    80005178:	00001097          	auipc	ra,0x1
    8000517c:	464080e7          	jalr	1124(ra) # 800065dc <holdingsleep>
    80005180:	87aa                	mv	a5,a0
    80005182:	c791                	beqz	a5,8000518e <iunlock+0x30>
    80005184:	fe843783          	ld	a5,-24(s0)
    80005188:	479c                	lw	a5,8(a5)
    8000518a:	00f04a63          	bgtz	a5,8000519e <iunlock+0x40>
    panic("iunlock");
    8000518e:	00006517          	auipc	a0,0x6
    80005192:	35a50513          	addi	a0,a0,858 # 8000b4e8 <etext+0x4e8>
    80005196:	ffffc097          	auipc	ra,0xffffc
    8000519a:	af4080e7          	jalr	-1292(ra) # 80000c8a <panic>

  releasesleep(&ip->lock);
    8000519e:	fe843783          	ld	a5,-24(s0)
    800051a2:	07c1                	addi	a5,a5,16
    800051a4:	853e                	mv	a0,a5
    800051a6:	00001097          	auipc	ra,0x1
    800051aa:	3e4080e7          	jalr	996(ra) # 8000658a <releasesleep>
}
    800051ae:	0001                	nop
    800051b0:	60e2                	ld	ra,24(sp)
    800051b2:	6442                	ld	s0,16(sp)
    800051b4:	6105                	addi	sp,sp,32
    800051b6:	8082                	ret

00000000800051b8 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
    800051b8:	1101                	addi	sp,sp,-32
    800051ba:	ec06                	sd	ra,24(sp)
    800051bc:	e822                	sd	s0,16(sp)
    800051be:	1000                	addi	s0,sp,32
    800051c0:	fea43423          	sd	a0,-24(s0)
  acquire(&itable.lock);
    800051c4:	0001f517          	auipc	a0,0x1f
    800051c8:	3fc50513          	addi	a0,a0,1020 # 800245c0 <itable>
    800051cc:	ffffc097          	auipc	ra,0xffffc
    800051d0:	0b2080e7          	jalr	178(ra) # 8000127e <acquire>

  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800051d4:	fe843783          	ld	a5,-24(s0)
    800051d8:	479c                	lw	a5,8(a5)
    800051da:	873e                	mv	a4,a5
    800051dc:	4785                	li	a5,1
    800051de:	06f71f63          	bne	a4,a5,8000525c <iput+0xa4>
    800051e2:	fe843783          	ld	a5,-24(s0)
    800051e6:	43bc                	lw	a5,64(a5)
    800051e8:	cbb5                	beqz	a5,8000525c <iput+0xa4>
    800051ea:	fe843783          	ld	a5,-24(s0)
    800051ee:	04a79783          	lh	a5,74(a5)
    800051f2:	e7ad                	bnez	a5,8000525c <iput+0xa4>
    // inode has no links and no other references: truncate and free.

    // ip->ref == 1 means no other process can have ip locked,
    // so this acquiresleep() won't block (or deadlock).
    acquiresleep(&ip->lock);
    800051f4:	fe843783          	ld	a5,-24(s0)
    800051f8:	07c1                	addi	a5,a5,16
    800051fa:	853e                	mv	a0,a5
    800051fc:	00001097          	auipc	ra,0x1
    80005200:	320080e7          	jalr	800(ra) # 8000651c <acquiresleep>

    release(&itable.lock);
    80005204:	0001f517          	auipc	a0,0x1f
    80005208:	3bc50513          	addi	a0,a0,956 # 800245c0 <itable>
    8000520c:	ffffc097          	auipc	ra,0xffffc
    80005210:	0d6080e7          	jalr	214(ra) # 800012e2 <release>

    itrunc(ip);
    80005214:	fe843503          	ld	a0,-24(s0)
    80005218:	00000097          	auipc	ra,0x0
    8000521c:	21a080e7          	jalr	538(ra) # 80005432 <itrunc>
    ip->type = 0;
    80005220:	fe843783          	ld	a5,-24(s0)
    80005224:	04079223          	sh	zero,68(a5)
    iupdate(ip);
    80005228:	fe843503          	ld	a0,-24(s0)
    8000522c:	00000097          	auipc	ra,0x0
    80005230:	bae080e7          	jalr	-1106(ra) # 80004dda <iupdate>
    ip->valid = 0;
    80005234:	fe843783          	ld	a5,-24(s0)
    80005238:	0407a023          	sw	zero,64(a5)

    releasesleep(&ip->lock);
    8000523c:	fe843783          	ld	a5,-24(s0)
    80005240:	07c1                	addi	a5,a5,16
    80005242:	853e                	mv	a0,a5
    80005244:	00001097          	auipc	ra,0x1
    80005248:	346080e7          	jalr	838(ra) # 8000658a <releasesleep>

    acquire(&itable.lock);
    8000524c:	0001f517          	auipc	a0,0x1f
    80005250:	37450513          	addi	a0,a0,884 # 800245c0 <itable>
    80005254:	ffffc097          	auipc	ra,0xffffc
    80005258:	02a080e7          	jalr	42(ra) # 8000127e <acquire>
  }

  ip->ref--;
    8000525c:	fe843783          	ld	a5,-24(s0)
    80005260:	479c                	lw	a5,8(a5)
    80005262:	37fd                	addiw	a5,a5,-1
    80005264:	0007871b          	sext.w	a4,a5
    80005268:	fe843783          	ld	a5,-24(s0)
    8000526c:	c798                	sw	a4,8(a5)
  release(&itable.lock);
    8000526e:	0001f517          	auipc	a0,0x1f
    80005272:	35250513          	addi	a0,a0,850 # 800245c0 <itable>
    80005276:	ffffc097          	auipc	ra,0xffffc
    8000527a:	06c080e7          	jalr	108(ra) # 800012e2 <release>
}
    8000527e:	0001                	nop
    80005280:	60e2                	ld	ra,24(sp)
    80005282:	6442                	ld	s0,16(sp)
    80005284:	6105                	addi	sp,sp,32
    80005286:	8082                	ret

0000000080005288 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
    80005288:	1101                	addi	sp,sp,-32
    8000528a:	ec06                	sd	ra,24(sp)
    8000528c:	e822                	sd	s0,16(sp)
    8000528e:	1000                	addi	s0,sp,32
    80005290:	fea43423          	sd	a0,-24(s0)
  iunlock(ip);
    80005294:	fe843503          	ld	a0,-24(s0)
    80005298:	00000097          	auipc	ra,0x0
    8000529c:	ec6080e7          	jalr	-314(ra) # 8000515e <iunlock>
  iput(ip);
    800052a0:	fe843503          	ld	a0,-24(s0)
    800052a4:	00000097          	auipc	ra,0x0
    800052a8:	f14080e7          	jalr	-236(ra) # 800051b8 <iput>
}
    800052ac:	0001                	nop
    800052ae:	60e2                	ld	ra,24(sp)
    800052b0:	6442                	ld	s0,16(sp)
    800052b2:	6105                	addi	sp,sp,32
    800052b4:	8082                	ret

00000000800052b6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800052b6:	7139                	addi	sp,sp,-64
    800052b8:	fc06                	sd	ra,56(sp)
    800052ba:	f822                	sd	s0,48(sp)
    800052bc:	0080                	addi	s0,sp,64
    800052be:	fca43423          	sd	a0,-56(s0)
    800052c2:	87ae                	mv	a5,a1
    800052c4:	fcf42223          	sw	a5,-60(s0)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800052c8:	fc442783          	lw	a5,-60(s0)
    800052cc:	0007871b          	sext.w	a4,a5
    800052d0:	47ad                	li	a5,11
    800052d2:	04e7ee63          	bltu	a5,a4,8000532e <bmap+0x78>
    if((addr = ip->addrs[bn]) == 0){
    800052d6:	fc843703          	ld	a4,-56(s0)
    800052da:	fc446783          	lwu	a5,-60(s0)
    800052de:	07d1                	addi	a5,a5,20
    800052e0:	078a                	slli	a5,a5,0x2
    800052e2:	97ba                	add	a5,a5,a4
    800052e4:	439c                	lw	a5,0(a5)
    800052e6:	fef42623          	sw	a5,-20(s0)
    800052ea:	fec42783          	lw	a5,-20(s0)
    800052ee:	2781                	sext.w	a5,a5
    800052f0:	ef85                	bnez	a5,80005328 <bmap+0x72>
      addr = balloc(ip->dev);
    800052f2:	fc843783          	ld	a5,-56(s0)
    800052f6:	439c                	lw	a5,0(a5)
    800052f8:	853e                	mv	a0,a5
    800052fa:	fffff097          	auipc	ra,0xfffff
    800052fe:	6a6080e7          	jalr	1702(ra) # 800049a0 <balloc>
    80005302:	87aa                	mv	a5,a0
    80005304:	fef42623          	sw	a5,-20(s0)
      if(addr == 0)
    80005308:	fec42783          	lw	a5,-20(s0)
    8000530c:	2781                	sext.w	a5,a5
    8000530e:	e399                	bnez	a5,80005314 <bmap+0x5e>
        return 0;
    80005310:	4781                	li	a5,0
    80005312:	aa19                	j	80005428 <bmap+0x172>
      ip->addrs[bn] = addr;
    80005314:	fc843703          	ld	a4,-56(s0)
    80005318:	fc446783          	lwu	a5,-60(s0)
    8000531c:	07d1                	addi	a5,a5,20
    8000531e:	078a                	slli	a5,a5,0x2
    80005320:	97ba                	add	a5,a5,a4
    80005322:	fec42703          	lw	a4,-20(s0)
    80005326:	c398                	sw	a4,0(a5)
    }
    return addr;
    80005328:	fec42783          	lw	a5,-20(s0)
    8000532c:	a8f5                	j	80005428 <bmap+0x172>
  }
  bn -= NDIRECT;
    8000532e:	fc442783          	lw	a5,-60(s0)
    80005332:	37d1                	addiw	a5,a5,-12
    80005334:	fcf42223          	sw	a5,-60(s0)

  if(bn < NINDIRECT){
    80005338:	fc442783          	lw	a5,-60(s0)
    8000533c:	0007871b          	sext.w	a4,a5
    80005340:	0ff00793          	li	a5,255
    80005344:	0ce7ea63          	bltu	a5,a4,80005418 <bmap+0x162>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80005348:	fc843783          	ld	a5,-56(s0)
    8000534c:	0807a783          	lw	a5,128(a5)
    80005350:	fef42623          	sw	a5,-20(s0)
    80005354:	fec42783          	lw	a5,-20(s0)
    80005358:	2781                	sext.w	a5,a5
    8000535a:	eb85                	bnez	a5,8000538a <bmap+0xd4>
      addr = balloc(ip->dev);
    8000535c:	fc843783          	ld	a5,-56(s0)
    80005360:	439c                	lw	a5,0(a5)
    80005362:	853e                	mv	a0,a5
    80005364:	fffff097          	auipc	ra,0xfffff
    80005368:	63c080e7          	jalr	1596(ra) # 800049a0 <balloc>
    8000536c:	87aa                	mv	a5,a0
    8000536e:	fef42623          	sw	a5,-20(s0)
      if(addr == 0)
    80005372:	fec42783          	lw	a5,-20(s0)
    80005376:	2781                	sext.w	a5,a5
    80005378:	e399                	bnez	a5,8000537e <bmap+0xc8>
        return 0;
    8000537a:	4781                	li	a5,0
    8000537c:	a075                	j	80005428 <bmap+0x172>
      ip->addrs[NDIRECT] = addr;
    8000537e:	fc843783          	ld	a5,-56(s0)
    80005382:	fec42703          	lw	a4,-20(s0)
    80005386:	08e7a023          	sw	a4,128(a5)
    }
    bp = bread(ip->dev, addr);
    8000538a:	fc843783          	ld	a5,-56(s0)
    8000538e:	439c                	lw	a5,0(a5)
    80005390:	fec42703          	lw	a4,-20(s0)
    80005394:	85ba                	mv	a1,a4
    80005396:	853e                	mv	a0,a5
    80005398:	fffff097          	auipc	ra,0xfffff
    8000539c:	2be080e7          	jalr	702(ra) # 80004656 <bread>
    800053a0:	fea43023          	sd	a0,-32(s0)
    a = (uint*)bp->data;
    800053a4:	fe043783          	ld	a5,-32(s0)
    800053a8:	05878793          	addi	a5,a5,88
    800053ac:	fcf43c23          	sd	a5,-40(s0)
    if((addr = a[bn]) == 0){
    800053b0:	fc446783          	lwu	a5,-60(s0)
    800053b4:	078a                	slli	a5,a5,0x2
    800053b6:	fd843703          	ld	a4,-40(s0)
    800053ba:	97ba                	add	a5,a5,a4
    800053bc:	439c                	lw	a5,0(a5)
    800053be:	fef42623          	sw	a5,-20(s0)
    800053c2:	fec42783          	lw	a5,-20(s0)
    800053c6:	2781                	sext.w	a5,a5
    800053c8:	ef9d                	bnez	a5,80005406 <bmap+0x150>
      addr = balloc(ip->dev);
    800053ca:	fc843783          	ld	a5,-56(s0)
    800053ce:	439c                	lw	a5,0(a5)
    800053d0:	853e                	mv	a0,a5
    800053d2:	fffff097          	auipc	ra,0xfffff
    800053d6:	5ce080e7          	jalr	1486(ra) # 800049a0 <balloc>
    800053da:	87aa                	mv	a5,a0
    800053dc:	fef42623          	sw	a5,-20(s0)
      if(addr){
    800053e0:	fec42783          	lw	a5,-20(s0)
    800053e4:	2781                	sext.w	a5,a5
    800053e6:	c385                	beqz	a5,80005406 <bmap+0x150>
        a[bn] = addr;
    800053e8:	fc446783          	lwu	a5,-60(s0)
    800053ec:	078a                	slli	a5,a5,0x2
    800053ee:	fd843703          	ld	a4,-40(s0)
    800053f2:	97ba                	add	a5,a5,a4
    800053f4:	fec42703          	lw	a4,-20(s0)
    800053f8:	c398                	sw	a4,0(a5)
        log_write(bp);
    800053fa:	fe043503          	ld	a0,-32(s0)
    800053fe:	00001097          	auipc	ra,0x1
    80005402:	f9e080e7          	jalr	-98(ra) # 8000639c <log_write>
      }
    }
    brelse(bp);
    80005406:	fe043503          	ld	a0,-32(s0)
    8000540a:	fffff097          	auipc	ra,0xfffff
    8000540e:	2ee080e7          	jalr	750(ra) # 800046f8 <brelse>
    return addr;
    80005412:	fec42783          	lw	a5,-20(s0)
    80005416:	a809                	j	80005428 <bmap+0x172>
  }

  panic("bmap: out of range");
    80005418:	00006517          	auipc	a0,0x6
    8000541c:	0d850513          	addi	a0,a0,216 # 8000b4f0 <etext+0x4f0>
    80005420:	ffffc097          	auipc	ra,0xffffc
    80005424:	86a080e7          	jalr	-1942(ra) # 80000c8a <panic>
}
    80005428:	853e                	mv	a0,a5
    8000542a:	70e2                	ld	ra,56(sp)
    8000542c:	7442                	ld	s0,48(sp)
    8000542e:	6121                	addi	sp,sp,64
    80005430:	8082                	ret

0000000080005432 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80005432:	7139                	addi	sp,sp,-64
    80005434:	fc06                	sd	ra,56(sp)
    80005436:	f822                	sd	s0,48(sp)
    80005438:	0080                	addi	s0,sp,64
    8000543a:	fca43423          	sd	a0,-56(s0)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000543e:	fe042623          	sw	zero,-20(s0)
    80005442:	a899                	j	80005498 <itrunc+0x66>
    if(ip->addrs[i]){
    80005444:	fc843703          	ld	a4,-56(s0)
    80005448:	fec42783          	lw	a5,-20(s0)
    8000544c:	07d1                	addi	a5,a5,20
    8000544e:	078a                	slli	a5,a5,0x2
    80005450:	97ba                	add	a5,a5,a4
    80005452:	439c                	lw	a5,0(a5)
    80005454:	cf8d                	beqz	a5,8000548e <itrunc+0x5c>
      bfree(ip->dev, ip->addrs[i]);
    80005456:	fc843783          	ld	a5,-56(s0)
    8000545a:	439c                	lw	a5,0(a5)
    8000545c:	0007869b          	sext.w	a3,a5
    80005460:	fc843703          	ld	a4,-56(s0)
    80005464:	fec42783          	lw	a5,-20(s0)
    80005468:	07d1                	addi	a5,a5,20
    8000546a:	078a                	slli	a5,a5,0x2
    8000546c:	97ba                	add	a5,a5,a4
    8000546e:	439c                	lw	a5,0(a5)
    80005470:	85be                	mv	a1,a5
    80005472:	8536                	mv	a0,a3
    80005474:	fffff097          	auipc	ra,0xfffff
    80005478:	6d4080e7          	jalr	1748(ra) # 80004b48 <bfree>
      ip->addrs[i] = 0;
    8000547c:	fc843703          	ld	a4,-56(s0)
    80005480:	fec42783          	lw	a5,-20(s0)
    80005484:	07d1                	addi	a5,a5,20
    80005486:	078a                	slli	a5,a5,0x2
    80005488:	97ba                	add	a5,a5,a4
    8000548a:	0007a023          	sw	zero,0(a5)
  for(i = 0; i < NDIRECT; i++){
    8000548e:	fec42783          	lw	a5,-20(s0)
    80005492:	2785                	addiw	a5,a5,1
    80005494:	fef42623          	sw	a5,-20(s0)
    80005498:	fec42783          	lw	a5,-20(s0)
    8000549c:	0007871b          	sext.w	a4,a5
    800054a0:	47ad                	li	a5,11
    800054a2:	fae7d1e3          	bge	a5,a4,80005444 <itrunc+0x12>
    }
  }

  if(ip->addrs[NDIRECT]){
    800054a6:	fc843783          	ld	a5,-56(s0)
    800054aa:	0807a783          	lw	a5,128(a5)
    800054ae:	cbc5                	beqz	a5,8000555e <itrunc+0x12c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800054b0:	fc843783          	ld	a5,-56(s0)
    800054b4:	4398                	lw	a4,0(a5)
    800054b6:	fc843783          	ld	a5,-56(s0)
    800054ba:	0807a783          	lw	a5,128(a5)
    800054be:	85be                	mv	a1,a5
    800054c0:	853a                	mv	a0,a4
    800054c2:	fffff097          	auipc	ra,0xfffff
    800054c6:	194080e7          	jalr	404(ra) # 80004656 <bread>
    800054ca:	fea43023          	sd	a0,-32(s0)
    a = (uint*)bp->data;
    800054ce:	fe043783          	ld	a5,-32(s0)
    800054d2:	05878793          	addi	a5,a5,88
    800054d6:	fcf43c23          	sd	a5,-40(s0)
    for(j = 0; j < NINDIRECT; j++){
    800054da:	fe042423          	sw	zero,-24(s0)
    800054de:	a081                	j	8000551e <itrunc+0xec>
      if(a[j])
    800054e0:	fe842783          	lw	a5,-24(s0)
    800054e4:	078a                	slli	a5,a5,0x2
    800054e6:	fd843703          	ld	a4,-40(s0)
    800054ea:	97ba                	add	a5,a5,a4
    800054ec:	439c                	lw	a5,0(a5)
    800054ee:	c39d                	beqz	a5,80005514 <itrunc+0xe2>
        bfree(ip->dev, a[j]);
    800054f0:	fc843783          	ld	a5,-56(s0)
    800054f4:	439c                	lw	a5,0(a5)
    800054f6:	0007869b          	sext.w	a3,a5
    800054fa:	fe842783          	lw	a5,-24(s0)
    800054fe:	078a                	slli	a5,a5,0x2
    80005500:	fd843703          	ld	a4,-40(s0)
    80005504:	97ba                	add	a5,a5,a4
    80005506:	439c                	lw	a5,0(a5)
    80005508:	85be                	mv	a1,a5
    8000550a:	8536                	mv	a0,a3
    8000550c:	fffff097          	auipc	ra,0xfffff
    80005510:	63c080e7          	jalr	1596(ra) # 80004b48 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80005514:	fe842783          	lw	a5,-24(s0)
    80005518:	2785                	addiw	a5,a5,1
    8000551a:	fef42423          	sw	a5,-24(s0)
    8000551e:	fe842783          	lw	a5,-24(s0)
    80005522:	873e                	mv	a4,a5
    80005524:	0ff00793          	li	a5,255
    80005528:	fae7fce3          	bgeu	a5,a4,800054e0 <itrunc+0xae>
    }
    brelse(bp);
    8000552c:	fe043503          	ld	a0,-32(s0)
    80005530:	fffff097          	auipc	ra,0xfffff
    80005534:	1c8080e7          	jalr	456(ra) # 800046f8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80005538:	fc843783          	ld	a5,-56(s0)
    8000553c:	439c                	lw	a5,0(a5)
    8000553e:	0007871b          	sext.w	a4,a5
    80005542:	fc843783          	ld	a5,-56(s0)
    80005546:	0807a783          	lw	a5,128(a5)
    8000554a:	85be                	mv	a1,a5
    8000554c:	853a                	mv	a0,a4
    8000554e:	fffff097          	auipc	ra,0xfffff
    80005552:	5fa080e7          	jalr	1530(ra) # 80004b48 <bfree>
    ip->addrs[NDIRECT] = 0;
    80005556:	fc843783          	ld	a5,-56(s0)
    8000555a:	0807a023          	sw	zero,128(a5)
  }

  ip->size = 0;
    8000555e:	fc843783          	ld	a5,-56(s0)
    80005562:	0407a623          	sw	zero,76(a5)
  iupdate(ip);
    80005566:	fc843503          	ld	a0,-56(s0)
    8000556a:	00000097          	auipc	ra,0x0
    8000556e:	870080e7          	jalr	-1936(ra) # 80004dda <iupdate>
}
    80005572:	0001                	nop
    80005574:	70e2                	ld	ra,56(sp)
    80005576:	7442                	ld	s0,48(sp)
    80005578:	6121                	addi	sp,sp,64
    8000557a:	8082                	ret

000000008000557c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000557c:	1101                	addi	sp,sp,-32
    8000557e:	ec22                	sd	s0,24(sp)
    80005580:	1000                	addi	s0,sp,32
    80005582:	fea43423          	sd	a0,-24(s0)
    80005586:	feb43023          	sd	a1,-32(s0)
  st->dev = ip->dev;
    8000558a:	fe843783          	ld	a5,-24(s0)
    8000558e:	439c                	lw	a5,0(a5)
    80005590:	0007871b          	sext.w	a4,a5
    80005594:	fe043783          	ld	a5,-32(s0)
    80005598:	c398                	sw	a4,0(a5)
  st->ino = ip->inum;
    8000559a:	fe843783          	ld	a5,-24(s0)
    8000559e:	43d8                	lw	a4,4(a5)
    800055a0:	fe043783          	ld	a5,-32(s0)
    800055a4:	c3d8                	sw	a4,4(a5)
  st->type = ip->type;
    800055a6:	fe843783          	ld	a5,-24(s0)
    800055aa:	04479703          	lh	a4,68(a5)
    800055ae:	fe043783          	ld	a5,-32(s0)
    800055b2:	00e79423          	sh	a4,8(a5)
  st->nlink = ip->nlink;
    800055b6:	fe843783          	ld	a5,-24(s0)
    800055ba:	04a79703          	lh	a4,74(a5)
    800055be:	fe043783          	ld	a5,-32(s0)
    800055c2:	00e79523          	sh	a4,10(a5)
  st->size = ip->size;
    800055c6:	fe843783          	ld	a5,-24(s0)
    800055ca:	47fc                	lw	a5,76(a5)
    800055cc:	02079713          	slli	a4,a5,0x20
    800055d0:	9301                	srli	a4,a4,0x20
    800055d2:	fe043783          	ld	a5,-32(s0)
    800055d6:	eb98                	sd	a4,16(a5)
}
    800055d8:	0001                	nop
    800055da:	6462                	ld	s0,24(sp)
    800055dc:	6105                	addi	sp,sp,32
    800055de:	8082                	ret

00000000800055e0 <readi>:
// Caller must hold ip->lock.
// If user_dst==1, then dst is a user virtual address;
// otherwise, dst is a kernel address.
int
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    800055e0:	715d                	addi	sp,sp,-80
    800055e2:	e486                	sd	ra,72(sp)
    800055e4:	e0a2                	sd	s0,64(sp)
    800055e6:	0880                	addi	s0,sp,80
    800055e8:	fca43423          	sd	a0,-56(s0)
    800055ec:	87ae                	mv	a5,a1
    800055ee:	fac43c23          	sd	a2,-72(s0)
    800055f2:	fcf42223          	sw	a5,-60(s0)
    800055f6:	87b6                	mv	a5,a3
    800055f8:	fcf42023          	sw	a5,-64(s0)
    800055fc:	87ba                	mv	a5,a4
    800055fe:	faf42a23          	sw	a5,-76(s0)
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80005602:	fc843783          	ld	a5,-56(s0)
    80005606:	47f8                	lw	a4,76(a5)
    80005608:	fc042783          	lw	a5,-64(s0)
    8000560c:	2781                	sext.w	a5,a5
    8000560e:	00f76f63          	bltu	a4,a5,8000562c <readi+0x4c>
    80005612:	fc042783          	lw	a5,-64(s0)
    80005616:	873e                	mv	a4,a5
    80005618:	fb442783          	lw	a5,-76(s0)
    8000561c:	9fb9                	addw	a5,a5,a4
    8000561e:	0007871b          	sext.w	a4,a5
    80005622:	fc042783          	lw	a5,-64(s0)
    80005626:	2781                	sext.w	a5,a5
    80005628:	00f77463          	bgeu	a4,a5,80005630 <readi+0x50>
    return 0;
    8000562c:	4781                	li	a5,0
    8000562e:	a299                	j	80005774 <readi+0x194>
  if(off + n > ip->size)
    80005630:	fc042783          	lw	a5,-64(s0)
    80005634:	873e                	mv	a4,a5
    80005636:	fb442783          	lw	a5,-76(s0)
    8000563a:	9fb9                	addw	a5,a5,a4
    8000563c:	0007871b          	sext.w	a4,a5
    80005640:	fc843783          	ld	a5,-56(s0)
    80005644:	47fc                	lw	a5,76(a5)
    80005646:	00e7fa63          	bgeu	a5,a4,8000565a <readi+0x7a>
    n = ip->size - off;
    8000564a:	fc843783          	ld	a5,-56(s0)
    8000564e:	47fc                	lw	a5,76(a5)
    80005650:	fc042703          	lw	a4,-64(s0)
    80005654:	9f99                	subw	a5,a5,a4
    80005656:	faf42a23          	sw	a5,-76(s0)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000565a:	fe042623          	sw	zero,-20(s0)
    8000565e:	a8f5                	j	8000575a <readi+0x17a>
    uint addr = bmap(ip, off/BSIZE);
    80005660:	fc042783          	lw	a5,-64(s0)
    80005664:	00a7d79b          	srliw	a5,a5,0xa
    80005668:	2781                	sext.w	a5,a5
    8000566a:	85be                	mv	a1,a5
    8000566c:	fc843503          	ld	a0,-56(s0)
    80005670:	00000097          	auipc	ra,0x0
    80005674:	c46080e7          	jalr	-954(ra) # 800052b6 <bmap>
    80005678:	87aa                	mv	a5,a0
    8000567a:	fef42423          	sw	a5,-24(s0)
    if(addr == 0)
    8000567e:	fe842783          	lw	a5,-24(s0)
    80005682:	2781                	sext.w	a5,a5
    80005684:	c7ed                	beqz	a5,8000576e <readi+0x18e>
      break;
    bp = bread(ip->dev, addr);
    80005686:	fc843783          	ld	a5,-56(s0)
    8000568a:	439c                	lw	a5,0(a5)
    8000568c:	fe842703          	lw	a4,-24(s0)
    80005690:	85ba                	mv	a1,a4
    80005692:	853e                	mv	a0,a5
    80005694:	fffff097          	auipc	ra,0xfffff
    80005698:	fc2080e7          	jalr	-62(ra) # 80004656 <bread>
    8000569c:	fea43023          	sd	a0,-32(s0)
    m = min(n - tot, BSIZE - off%BSIZE);
    800056a0:	fc042783          	lw	a5,-64(s0)
    800056a4:	3ff7f793          	andi	a5,a5,1023
    800056a8:	2781                	sext.w	a5,a5
    800056aa:	40000713          	li	a4,1024
    800056ae:	40f707bb          	subw	a5,a4,a5
    800056b2:	2781                	sext.w	a5,a5
    800056b4:	fb442703          	lw	a4,-76(s0)
    800056b8:	86ba                	mv	a3,a4
    800056ba:	fec42703          	lw	a4,-20(s0)
    800056be:	40e6873b          	subw	a4,a3,a4
    800056c2:	2701                	sext.w	a4,a4
    800056c4:	863a                	mv	a2,a4
    800056c6:	0007869b          	sext.w	a3,a5
    800056ca:	0006071b          	sext.w	a4,a2
    800056ce:	00d77363          	bgeu	a4,a3,800056d4 <readi+0xf4>
    800056d2:	87b2                	mv	a5,a2
    800056d4:	fcf42e23          	sw	a5,-36(s0)
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800056d8:	fe043783          	ld	a5,-32(s0)
    800056dc:	05878713          	addi	a4,a5,88
    800056e0:	fc046783          	lwu	a5,-64(s0)
    800056e4:	3ff7f793          	andi	a5,a5,1023
    800056e8:	973e                	add	a4,a4,a5
    800056ea:	fdc46683          	lwu	a3,-36(s0)
    800056ee:	fc442783          	lw	a5,-60(s0)
    800056f2:	863a                	mv	a2,a4
    800056f4:	fb843583          	ld	a1,-72(s0)
    800056f8:	853e                	mv	a0,a5
    800056fa:	ffffe097          	auipc	ra,0xffffe
    800056fe:	f38080e7          	jalr	-200(ra) # 80003632 <either_copyout>
    80005702:	87aa                	mv	a5,a0
    80005704:	873e                	mv	a4,a5
    80005706:	57fd                	li	a5,-1
    80005708:	00f71c63          	bne	a4,a5,80005720 <readi+0x140>
      brelse(bp);
    8000570c:	fe043503          	ld	a0,-32(s0)
    80005710:	fffff097          	auipc	ra,0xfffff
    80005714:	fe8080e7          	jalr	-24(ra) # 800046f8 <brelse>
      tot = -1;
    80005718:	57fd                	li	a5,-1
    8000571a:	fef42623          	sw	a5,-20(s0)
      break;
    8000571e:	a889                	j	80005770 <readi+0x190>
    }
    brelse(bp);
    80005720:	fe043503          	ld	a0,-32(s0)
    80005724:	fffff097          	auipc	ra,0xfffff
    80005728:	fd4080e7          	jalr	-44(ra) # 800046f8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000572c:	fec42783          	lw	a5,-20(s0)
    80005730:	873e                	mv	a4,a5
    80005732:	fdc42783          	lw	a5,-36(s0)
    80005736:	9fb9                	addw	a5,a5,a4
    80005738:	fef42623          	sw	a5,-20(s0)
    8000573c:	fc042783          	lw	a5,-64(s0)
    80005740:	873e                	mv	a4,a5
    80005742:	fdc42783          	lw	a5,-36(s0)
    80005746:	9fb9                	addw	a5,a5,a4
    80005748:	fcf42023          	sw	a5,-64(s0)
    8000574c:	fdc46783          	lwu	a5,-36(s0)
    80005750:	fb843703          	ld	a4,-72(s0)
    80005754:	97ba                	add	a5,a5,a4
    80005756:	faf43c23          	sd	a5,-72(s0)
    8000575a:	fec42783          	lw	a5,-20(s0)
    8000575e:	873e                	mv	a4,a5
    80005760:	fb442783          	lw	a5,-76(s0)
    80005764:	2701                	sext.w	a4,a4
    80005766:	2781                	sext.w	a5,a5
    80005768:	eef76ce3          	bltu	a4,a5,80005660 <readi+0x80>
    8000576c:	a011                	j	80005770 <readi+0x190>
      break;
    8000576e:	0001                	nop
  }
  return tot;
    80005770:	fec42783          	lw	a5,-20(s0)
}
    80005774:	853e                	mv	a0,a5
    80005776:	60a6                	ld	ra,72(sp)
    80005778:	6406                	ld	s0,64(sp)
    8000577a:	6161                	addi	sp,sp,80
    8000577c:	8082                	ret

000000008000577e <writei>:
// Returns the number of bytes successfully written.
// If the return value is less than the requested n,
// there was an error of some kind.
int
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    8000577e:	715d                	addi	sp,sp,-80
    80005780:	e486                	sd	ra,72(sp)
    80005782:	e0a2                	sd	s0,64(sp)
    80005784:	0880                	addi	s0,sp,80
    80005786:	fca43423          	sd	a0,-56(s0)
    8000578a:	87ae                	mv	a5,a1
    8000578c:	fac43c23          	sd	a2,-72(s0)
    80005790:	fcf42223          	sw	a5,-60(s0)
    80005794:	87b6                	mv	a5,a3
    80005796:	fcf42023          	sw	a5,-64(s0)
    8000579a:	87ba                	mv	a5,a4
    8000579c:	faf42a23          	sw	a5,-76(s0)
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800057a0:	fc843783          	ld	a5,-56(s0)
    800057a4:	47f8                	lw	a4,76(a5)
    800057a6:	fc042783          	lw	a5,-64(s0)
    800057aa:	2781                	sext.w	a5,a5
    800057ac:	00f76f63          	bltu	a4,a5,800057ca <writei+0x4c>
    800057b0:	fc042783          	lw	a5,-64(s0)
    800057b4:	873e                	mv	a4,a5
    800057b6:	fb442783          	lw	a5,-76(s0)
    800057ba:	9fb9                	addw	a5,a5,a4
    800057bc:	0007871b          	sext.w	a4,a5
    800057c0:	fc042783          	lw	a5,-64(s0)
    800057c4:	2781                	sext.w	a5,a5
    800057c6:	00f77463          	bgeu	a4,a5,800057ce <writei+0x50>
    return -1;
    800057ca:	57fd                	li	a5,-1
    800057cc:	a295                	j	80005930 <writei+0x1b2>
  if(off + n > MAXFILE*BSIZE)
    800057ce:	fc042783          	lw	a5,-64(s0)
    800057d2:	873e                	mv	a4,a5
    800057d4:	fb442783          	lw	a5,-76(s0)
    800057d8:	9fb9                	addw	a5,a5,a4
    800057da:	2781                	sext.w	a5,a5
    800057dc:	873e                	mv	a4,a5
    800057de:	000437b7          	lui	a5,0x43
    800057e2:	00e7f463          	bgeu	a5,a4,800057ea <writei+0x6c>
    return -1;
    800057e6:	57fd                	li	a5,-1
    800057e8:	a2a1                	j	80005930 <writei+0x1b2>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800057ea:	fe042623          	sw	zero,-20(s0)
    800057ee:	a209                	j	800058f0 <writei+0x172>
    uint addr = bmap(ip, off/BSIZE);
    800057f0:	fc042783          	lw	a5,-64(s0)
    800057f4:	00a7d79b          	srliw	a5,a5,0xa
    800057f8:	2781                	sext.w	a5,a5
    800057fa:	85be                	mv	a1,a5
    800057fc:	fc843503          	ld	a0,-56(s0)
    80005800:	00000097          	auipc	ra,0x0
    80005804:	ab6080e7          	jalr	-1354(ra) # 800052b6 <bmap>
    80005808:	87aa                	mv	a5,a0
    8000580a:	fef42423          	sw	a5,-24(s0)
    if(addr == 0)
    8000580e:	fe842783          	lw	a5,-24(s0)
    80005812:	2781                	sext.w	a5,a5
    80005814:	cbe5                	beqz	a5,80005904 <writei+0x186>
      break;
    bp = bread(ip->dev, addr);
    80005816:	fc843783          	ld	a5,-56(s0)
    8000581a:	439c                	lw	a5,0(a5)
    8000581c:	fe842703          	lw	a4,-24(s0)
    80005820:	85ba                	mv	a1,a4
    80005822:	853e                	mv	a0,a5
    80005824:	fffff097          	auipc	ra,0xfffff
    80005828:	e32080e7          	jalr	-462(ra) # 80004656 <bread>
    8000582c:	fea43023          	sd	a0,-32(s0)
    m = min(n - tot, BSIZE - off%BSIZE);
    80005830:	fc042783          	lw	a5,-64(s0)
    80005834:	3ff7f793          	andi	a5,a5,1023
    80005838:	2781                	sext.w	a5,a5
    8000583a:	40000713          	li	a4,1024
    8000583e:	40f707bb          	subw	a5,a4,a5
    80005842:	2781                	sext.w	a5,a5
    80005844:	fb442703          	lw	a4,-76(s0)
    80005848:	86ba                	mv	a3,a4
    8000584a:	fec42703          	lw	a4,-20(s0)
    8000584e:	40e6873b          	subw	a4,a3,a4
    80005852:	2701                	sext.w	a4,a4
    80005854:	863a                	mv	a2,a4
    80005856:	0007869b          	sext.w	a3,a5
    8000585a:	0006071b          	sext.w	a4,a2
    8000585e:	00d77363          	bgeu	a4,a3,80005864 <writei+0xe6>
    80005862:	87b2                	mv	a5,a2
    80005864:	fcf42e23          	sw	a5,-36(s0)
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80005868:	fe043783          	ld	a5,-32(s0)
    8000586c:	05878713          	addi	a4,a5,88 # 43058 <_entry-0x7ffbcfa8>
    80005870:	fc046783          	lwu	a5,-64(s0)
    80005874:	3ff7f793          	andi	a5,a5,1023
    80005878:	97ba                	add	a5,a5,a4
    8000587a:	fdc46683          	lwu	a3,-36(s0)
    8000587e:	fc442703          	lw	a4,-60(s0)
    80005882:	fb843603          	ld	a2,-72(s0)
    80005886:	85ba                	mv	a1,a4
    80005888:	853e                	mv	a0,a5
    8000588a:	ffffe097          	auipc	ra,0xffffe
    8000588e:	e1c080e7          	jalr	-484(ra) # 800036a6 <either_copyin>
    80005892:	87aa                	mv	a5,a0
    80005894:	873e                	mv	a4,a5
    80005896:	57fd                	li	a5,-1
    80005898:	00f71963          	bne	a4,a5,800058aa <writei+0x12c>
      brelse(bp);
    8000589c:	fe043503          	ld	a0,-32(s0)
    800058a0:	fffff097          	auipc	ra,0xfffff
    800058a4:	e58080e7          	jalr	-424(ra) # 800046f8 <brelse>
      break;
    800058a8:	a8b9                	j	80005906 <writei+0x188>
    }
    log_write(bp);
    800058aa:	fe043503          	ld	a0,-32(s0)
    800058ae:	00001097          	auipc	ra,0x1
    800058b2:	aee080e7          	jalr	-1298(ra) # 8000639c <log_write>
    brelse(bp);
    800058b6:	fe043503          	ld	a0,-32(s0)
    800058ba:	fffff097          	auipc	ra,0xfffff
    800058be:	e3e080e7          	jalr	-450(ra) # 800046f8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800058c2:	fec42783          	lw	a5,-20(s0)
    800058c6:	873e                	mv	a4,a5
    800058c8:	fdc42783          	lw	a5,-36(s0)
    800058cc:	9fb9                	addw	a5,a5,a4
    800058ce:	fef42623          	sw	a5,-20(s0)
    800058d2:	fc042783          	lw	a5,-64(s0)
    800058d6:	873e                	mv	a4,a5
    800058d8:	fdc42783          	lw	a5,-36(s0)
    800058dc:	9fb9                	addw	a5,a5,a4
    800058de:	fcf42023          	sw	a5,-64(s0)
    800058e2:	fdc46783          	lwu	a5,-36(s0)
    800058e6:	fb843703          	ld	a4,-72(s0)
    800058ea:	97ba                	add	a5,a5,a4
    800058ec:	faf43c23          	sd	a5,-72(s0)
    800058f0:	fec42783          	lw	a5,-20(s0)
    800058f4:	873e                	mv	a4,a5
    800058f6:	fb442783          	lw	a5,-76(s0)
    800058fa:	2701                	sext.w	a4,a4
    800058fc:	2781                	sext.w	a5,a5
    800058fe:	eef769e3          	bltu	a4,a5,800057f0 <writei+0x72>
    80005902:	a011                	j	80005906 <writei+0x188>
      break;
    80005904:	0001                	nop
  }

  if(off > ip->size)
    80005906:	fc843783          	ld	a5,-56(s0)
    8000590a:	47f8                	lw	a4,76(a5)
    8000590c:	fc042783          	lw	a5,-64(s0)
    80005910:	2781                	sext.w	a5,a5
    80005912:	00f77763          	bgeu	a4,a5,80005920 <writei+0x1a2>
    ip->size = off;
    80005916:	fc843783          	ld	a5,-56(s0)
    8000591a:	fc042703          	lw	a4,-64(s0)
    8000591e:	c7f8                	sw	a4,76(a5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80005920:	fc843503          	ld	a0,-56(s0)
    80005924:	fffff097          	auipc	ra,0xfffff
    80005928:	4b6080e7          	jalr	1206(ra) # 80004dda <iupdate>

  return tot;
    8000592c:	fec42783          	lw	a5,-20(s0)
}
    80005930:	853e                	mv	a0,a5
    80005932:	60a6                	ld	ra,72(sp)
    80005934:	6406                	ld	s0,64(sp)
    80005936:	6161                	addi	sp,sp,80
    80005938:	8082                	ret

000000008000593a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000593a:	1101                	addi	sp,sp,-32
    8000593c:	ec06                	sd	ra,24(sp)
    8000593e:	e822                	sd	s0,16(sp)
    80005940:	1000                	addi	s0,sp,32
    80005942:	fea43423          	sd	a0,-24(s0)
    80005946:	feb43023          	sd	a1,-32(s0)
  return strncmp(s, t, DIRSIZ);
    8000594a:	4639                	li	a2,14
    8000594c:	fe043583          	ld	a1,-32(s0)
    80005950:	fe843503          	ld	a0,-24(s0)
    80005954:	ffffc097          	auipc	ra,0xffffc
    80005958:	cf6080e7          	jalr	-778(ra) # 8000164a <strncmp>
    8000595c:	87aa                	mv	a5,a0
}
    8000595e:	853e                	mv	a0,a5
    80005960:	60e2                	ld	ra,24(sp)
    80005962:	6442                	ld	s0,16(sp)
    80005964:	6105                	addi	sp,sp,32
    80005966:	8082                	ret

0000000080005968 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80005968:	715d                	addi	sp,sp,-80
    8000596a:	e486                	sd	ra,72(sp)
    8000596c:	e0a2                	sd	s0,64(sp)
    8000596e:	0880                	addi	s0,sp,80
    80005970:	fca43423          	sd	a0,-56(s0)
    80005974:	fcb43023          	sd	a1,-64(s0)
    80005978:	fac43c23          	sd	a2,-72(s0)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000597c:	fc843783          	ld	a5,-56(s0)
    80005980:	04479783          	lh	a5,68(a5)
    80005984:	873e                	mv	a4,a5
    80005986:	4785                	li	a5,1
    80005988:	00f70a63          	beq	a4,a5,8000599c <dirlookup+0x34>
    panic("dirlookup not DIR");
    8000598c:	00006517          	auipc	a0,0x6
    80005990:	b7c50513          	addi	a0,a0,-1156 # 8000b508 <etext+0x508>
    80005994:	ffffb097          	auipc	ra,0xffffb
    80005998:	2f6080e7          	jalr	758(ra) # 80000c8a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000599c:	fe042623          	sw	zero,-20(s0)
    800059a0:	a849                	j	80005a32 <dirlookup+0xca>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800059a2:	fd840793          	addi	a5,s0,-40
    800059a6:	fec42683          	lw	a3,-20(s0)
    800059aa:	4741                	li	a4,16
    800059ac:	863e                	mv	a2,a5
    800059ae:	4581                	li	a1,0
    800059b0:	fc843503          	ld	a0,-56(s0)
    800059b4:	00000097          	auipc	ra,0x0
    800059b8:	c2c080e7          	jalr	-980(ra) # 800055e0 <readi>
    800059bc:	87aa                	mv	a5,a0
    800059be:	873e                	mv	a4,a5
    800059c0:	47c1                	li	a5,16
    800059c2:	00f70a63          	beq	a4,a5,800059d6 <dirlookup+0x6e>
      panic("dirlookup read");
    800059c6:	00006517          	auipc	a0,0x6
    800059ca:	b5a50513          	addi	a0,a0,-1190 # 8000b520 <etext+0x520>
    800059ce:	ffffb097          	auipc	ra,0xffffb
    800059d2:	2bc080e7          	jalr	700(ra) # 80000c8a <panic>
    if(de.inum == 0)
    800059d6:	fd845783          	lhu	a5,-40(s0)
    800059da:	c7b1                	beqz	a5,80005a26 <dirlookup+0xbe>
      continue;
    if(namecmp(name, de.name) == 0){
    800059dc:	fd840793          	addi	a5,s0,-40
    800059e0:	0789                	addi	a5,a5,2
    800059e2:	85be                	mv	a1,a5
    800059e4:	fc043503          	ld	a0,-64(s0)
    800059e8:	00000097          	auipc	ra,0x0
    800059ec:	f52080e7          	jalr	-174(ra) # 8000593a <namecmp>
    800059f0:	87aa                	mv	a5,a0
    800059f2:	eb9d                	bnez	a5,80005a28 <dirlookup+0xc0>
      // entry matches path element
      if(poff)
    800059f4:	fb843783          	ld	a5,-72(s0)
    800059f8:	c791                	beqz	a5,80005a04 <dirlookup+0x9c>
        *poff = off;
    800059fa:	fb843783          	ld	a5,-72(s0)
    800059fe:	fec42703          	lw	a4,-20(s0)
    80005a02:	c398                	sw	a4,0(a5)
      inum = de.inum;
    80005a04:	fd845783          	lhu	a5,-40(s0)
    80005a08:	fef42423          	sw	a5,-24(s0)
      return iget(dp->dev, inum);
    80005a0c:	fc843783          	ld	a5,-56(s0)
    80005a10:	439c                	lw	a5,0(a5)
    80005a12:	fe842703          	lw	a4,-24(s0)
    80005a16:	85ba                	mv	a1,a4
    80005a18:	853e                	mv	a0,a5
    80005a1a:	fffff097          	auipc	ra,0xfffff
    80005a1e:	4a8080e7          	jalr	1192(ra) # 80004ec2 <iget>
    80005a22:	87aa                	mv	a5,a0
    80005a24:	a005                	j	80005a44 <dirlookup+0xdc>
      continue;
    80005a26:	0001                	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005a28:	fec42783          	lw	a5,-20(s0)
    80005a2c:	27c1                	addiw	a5,a5,16
    80005a2e:	fef42623          	sw	a5,-20(s0)
    80005a32:	fc843783          	ld	a5,-56(s0)
    80005a36:	47f8                	lw	a4,76(a5)
    80005a38:	fec42783          	lw	a5,-20(s0)
    80005a3c:	2781                	sext.w	a5,a5
    80005a3e:	f6e7e2e3          	bltu	a5,a4,800059a2 <dirlookup+0x3a>
    }
  }

  return 0;
    80005a42:	4781                	li	a5,0
}
    80005a44:	853e                	mv	a0,a5
    80005a46:	60a6                	ld	ra,72(sp)
    80005a48:	6406                	ld	s0,64(sp)
    80005a4a:	6161                	addi	sp,sp,80
    80005a4c:	8082                	ret

0000000080005a4e <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
// Returns 0 on success, -1 on failure (e.g. out of disk blocks).
int
dirlink(struct inode *dp, char *name, uint inum)
{
    80005a4e:	715d                	addi	sp,sp,-80
    80005a50:	e486                	sd	ra,72(sp)
    80005a52:	e0a2                	sd	s0,64(sp)
    80005a54:	0880                	addi	s0,sp,80
    80005a56:	fca43423          	sd	a0,-56(s0)
    80005a5a:	fcb43023          	sd	a1,-64(s0)
    80005a5e:	87b2                	mv	a5,a2
    80005a60:	faf42e23          	sw	a5,-68(s0)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    80005a64:	4601                	li	a2,0
    80005a66:	fc043583          	ld	a1,-64(s0)
    80005a6a:	fc843503          	ld	a0,-56(s0)
    80005a6e:	00000097          	auipc	ra,0x0
    80005a72:	efa080e7          	jalr	-262(ra) # 80005968 <dirlookup>
    80005a76:	fea43023          	sd	a0,-32(s0)
    80005a7a:	fe043783          	ld	a5,-32(s0)
    80005a7e:	cb89                	beqz	a5,80005a90 <dirlink+0x42>
    iput(ip);
    80005a80:	fe043503          	ld	a0,-32(s0)
    80005a84:	fffff097          	auipc	ra,0xfffff
    80005a88:	734080e7          	jalr	1844(ra) # 800051b8 <iput>
    return -1;
    80005a8c:	57fd                	li	a5,-1
    80005a8e:	a075                	j	80005b3a <dirlink+0xec>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005a90:	fe042623          	sw	zero,-20(s0)
    80005a94:	a0a1                	j	80005adc <dirlink+0x8e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a96:	fd040793          	addi	a5,s0,-48
    80005a9a:	fec42683          	lw	a3,-20(s0)
    80005a9e:	4741                	li	a4,16
    80005aa0:	863e                	mv	a2,a5
    80005aa2:	4581                	li	a1,0
    80005aa4:	fc843503          	ld	a0,-56(s0)
    80005aa8:	00000097          	auipc	ra,0x0
    80005aac:	b38080e7          	jalr	-1224(ra) # 800055e0 <readi>
    80005ab0:	87aa                	mv	a5,a0
    80005ab2:	873e                	mv	a4,a5
    80005ab4:	47c1                	li	a5,16
    80005ab6:	00f70a63          	beq	a4,a5,80005aca <dirlink+0x7c>
      panic("dirlink read");
    80005aba:	00006517          	auipc	a0,0x6
    80005abe:	a7650513          	addi	a0,a0,-1418 # 8000b530 <etext+0x530>
    80005ac2:	ffffb097          	auipc	ra,0xffffb
    80005ac6:	1c8080e7          	jalr	456(ra) # 80000c8a <panic>
    if(de.inum == 0)
    80005aca:	fd045783          	lhu	a5,-48(s0)
    80005ace:	cf99                	beqz	a5,80005aec <dirlink+0x9e>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005ad0:	fec42783          	lw	a5,-20(s0)
    80005ad4:	27c1                	addiw	a5,a5,16
    80005ad6:	2781                	sext.w	a5,a5
    80005ad8:	fef42623          	sw	a5,-20(s0)
    80005adc:	fc843783          	ld	a5,-56(s0)
    80005ae0:	47f8                	lw	a4,76(a5)
    80005ae2:	fec42783          	lw	a5,-20(s0)
    80005ae6:	fae7e8e3          	bltu	a5,a4,80005a96 <dirlink+0x48>
    80005aea:	a011                	j	80005aee <dirlink+0xa0>
      break;
    80005aec:	0001                	nop
  }

  strncpy(de.name, name, DIRSIZ);
    80005aee:	fd040793          	addi	a5,s0,-48
    80005af2:	0789                	addi	a5,a5,2
    80005af4:	4639                	li	a2,14
    80005af6:	fc043583          	ld	a1,-64(s0)
    80005afa:	853e                	mv	a0,a5
    80005afc:	ffffc097          	auipc	ra,0xffffc
    80005b00:	bd8080e7          	jalr	-1064(ra) # 800016d4 <strncpy>
  de.inum = inum;
    80005b04:	fbc42783          	lw	a5,-68(s0)
    80005b08:	17c2                	slli	a5,a5,0x30
    80005b0a:	93c1                	srli	a5,a5,0x30
    80005b0c:	fcf41823          	sh	a5,-48(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b10:	fd040793          	addi	a5,s0,-48
    80005b14:	fec42683          	lw	a3,-20(s0)
    80005b18:	4741                	li	a4,16
    80005b1a:	863e                	mv	a2,a5
    80005b1c:	4581                	li	a1,0
    80005b1e:	fc843503          	ld	a0,-56(s0)
    80005b22:	00000097          	auipc	ra,0x0
    80005b26:	c5c080e7          	jalr	-932(ra) # 8000577e <writei>
    80005b2a:	87aa                	mv	a5,a0
    80005b2c:	873e                	mv	a4,a5
    80005b2e:	47c1                	li	a5,16
    80005b30:	00f70463          	beq	a4,a5,80005b38 <dirlink+0xea>
    return -1;
    80005b34:	57fd                	li	a5,-1
    80005b36:	a011                	j	80005b3a <dirlink+0xec>

  return 0;
    80005b38:	4781                	li	a5,0
}
    80005b3a:	853e                	mv	a0,a5
    80005b3c:	60a6                	ld	ra,72(sp)
    80005b3e:	6406                	ld	s0,64(sp)
    80005b40:	6161                	addi	sp,sp,80
    80005b42:	8082                	ret

0000000080005b44 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
    80005b44:	7179                	addi	sp,sp,-48
    80005b46:	f406                	sd	ra,40(sp)
    80005b48:	f022                	sd	s0,32(sp)
    80005b4a:	1800                	addi	s0,sp,48
    80005b4c:	fca43c23          	sd	a0,-40(s0)
    80005b50:	fcb43823          	sd	a1,-48(s0)
  char *s;
  int len;

  while(*path == '/')
    80005b54:	a031                	j	80005b60 <skipelem+0x1c>
    path++;
    80005b56:	fd843783          	ld	a5,-40(s0)
    80005b5a:	0785                	addi	a5,a5,1
    80005b5c:	fcf43c23          	sd	a5,-40(s0)
  while(*path == '/')
    80005b60:	fd843783          	ld	a5,-40(s0)
    80005b64:	0007c783          	lbu	a5,0(a5)
    80005b68:	873e                	mv	a4,a5
    80005b6a:	02f00793          	li	a5,47
    80005b6e:	fef704e3          	beq	a4,a5,80005b56 <skipelem+0x12>
  if(*path == 0)
    80005b72:	fd843783          	ld	a5,-40(s0)
    80005b76:	0007c783          	lbu	a5,0(a5)
    80005b7a:	e399                	bnez	a5,80005b80 <skipelem+0x3c>
    return 0;
    80005b7c:	4781                	li	a5,0
    80005b7e:	a06d                	j	80005c28 <skipelem+0xe4>
  s = path;
    80005b80:	fd843783          	ld	a5,-40(s0)
    80005b84:	fef43423          	sd	a5,-24(s0)
  while(*path != '/' && *path != 0)
    80005b88:	a031                	j	80005b94 <skipelem+0x50>
    path++;
    80005b8a:	fd843783          	ld	a5,-40(s0)
    80005b8e:	0785                	addi	a5,a5,1
    80005b90:	fcf43c23          	sd	a5,-40(s0)
  while(*path != '/' && *path != 0)
    80005b94:	fd843783          	ld	a5,-40(s0)
    80005b98:	0007c783          	lbu	a5,0(a5)
    80005b9c:	873e                	mv	a4,a5
    80005b9e:	02f00793          	li	a5,47
    80005ba2:	00f70763          	beq	a4,a5,80005bb0 <skipelem+0x6c>
    80005ba6:	fd843783          	ld	a5,-40(s0)
    80005baa:	0007c783          	lbu	a5,0(a5)
    80005bae:	fff1                	bnez	a5,80005b8a <skipelem+0x46>
  len = path - s;
    80005bb0:	fd843703          	ld	a4,-40(s0)
    80005bb4:	fe843783          	ld	a5,-24(s0)
    80005bb8:	40f707b3          	sub	a5,a4,a5
    80005bbc:	fef42223          	sw	a5,-28(s0)
  if(len >= DIRSIZ)
    80005bc0:	fe442783          	lw	a5,-28(s0)
    80005bc4:	0007871b          	sext.w	a4,a5
    80005bc8:	47b5                	li	a5,13
    80005bca:	00e7dc63          	bge	a5,a4,80005be2 <skipelem+0x9e>
    memmove(name, s, DIRSIZ);
    80005bce:	4639                	li	a2,14
    80005bd0:	fe843583          	ld	a1,-24(s0)
    80005bd4:	fd043503          	ld	a0,-48(s0)
    80005bd8:	ffffc097          	auipc	ra,0xffffc
    80005bdc:	95e080e7          	jalr	-1698(ra) # 80001536 <memmove>
    80005be0:	a80d                	j	80005c12 <skipelem+0xce>
  else {
    memmove(name, s, len);
    80005be2:	fe442783          	lw	a5,-28(s0)
    80005be6:	863e                	mv	a2,a5
    80005be8:	fe843583          	ld	a1,-24(s0)
    80005bec:	fd043503          	ld	a0,-48(s0)
    80005bf0:	ffffc097          	auipc	ra,0xffffc
    80005bf4:	946080e7          	jalr	-1722(ra) # 80001536 <memmove>
    name[len] = 0;
    80005bf8:	fe442783          	lw	a5,-28(s0)
    80005bfc:	fd043703          	ld	a4,-48(s0)
    80005c00:	97ba                	add	a5,a5,a4
    80005c02:	00078023          	sb	zero,0(a5)
  }
  while(*path == '/')
    80005c06:	a031                	j	80005c12 <skipelem+0xce>
    path++;
    80005c08:	fd843783          	ld	a5,-40(s0)
    80005c0c:	0785                	addi	a5,a5,1
    80005c0e:	fcf43c23          	sd	a5,-40(s0)
  while(*path == '/')
    80005c12:	fd843783          	ld	a5,-40(s0)
    80005c16:	0007c783          	lbu	a5,0(a5)
    80005c1a:	873e                	mv	a4,a5
    80005c1c:	02f00793          	li	a5,47
    80005c20:	fef704e3          	beq	a4,a5,80005c08 <skipelem+0xc4>
  return path;
    80005c24:	fd843783          	ld	a5,-40(s0)
}
    80005c28:	853e                	mv	a0,a5
    80005c2a:	70a2                	ld	ra,40(sp)
    80005c2c:	7402                	ld	s0,32(sp)
    80005c2e:	6145                	addi	sp,sp,48
    80005c30:	8082                	ret

0000000080005c32 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80005c32:	7139                	addi	sp,sp,-64
    80005c34:	fc06                	sd	ra,56(sp)
    80005c36:	f822                	sd	s0,48(sp)
    80005c38:	0080                	addi	s0,sp,64
    80005c3a:	fca43c23          	sd	a0,-40(s0)
    80005c3e:	87ae                	mv	a5,a1
    80005c40:	fcc43423          	sd	a2,-56(s0)
    80005c44:	fcf42a23          	sw	a5,-44(s0)
  struct inode *ip, *next;

  if(*path == '/')
    80005c48:	fd843783          	ld	a5,-40(s0)
    80005c4c:	0007c783          	lbu	a5,0(a5)
    80005c50:	873e                	mv	a4,a5
    80005c52:	02f00793          	li	a5,47
    80005c56:	00f71b63          	bne	a4,a5,80005c6c <namex+0x3a>
    ip = iget(ROOTDEV, ROOTINO);
    80005c5a:	4585                	li	a1,1
    80005c5c:	4505                	li	a0,1
    80005c5e:	fffff097          	auipc	ra,0xfffff
    80005c62:	264080e7          	jalr	612(ra) # 80004ec2 <iget>
    80005c66:	fea43423          	sd	a0,-24(s0)
    80005c6a:	a845                	j	80005d1a <namex+0xe8>
  else
    ip = idup(myproc()->cwd);
    80005c6c:	ffffd097          	auipc	ra,0xffffd
    80005c70:	bda080e7          	jalr	-1062(ra) # 80002846 <myproc>
    80005c74:	87aa                	mv	a5,a0
    80005c76:	1507b783          	ld	a5,336(a5)
    80005c7a:	853e                	mv	a0,a5
    80005c7c:	fffff097          	auipc	ra,0xfffff
    80005c80:	362080e7          	jalr	866(ra) # 80004fde <idup>
    80005c84:	fea43423          	sd	a0,-24(s0)

  while((path = skipelem(path, name)) != 0){
    80005c88:	a849                	j	80005d1a <namex+0xe8>
    ilock(ip);
    80005c8a:	fe843503          	ld	a0,-24(s0)
    80005c8e:	fffff097          	auipc	ra,0xfffff
    80005c92:	39c080e7          	jalr	924(ra) # 8000502a <ilock>
    if(ip->type != T_DIR){
    80005c96:	fe843783          	ld	a5,-24(s0)
    80005c9a:	04479783          	lh	a5,68(a5)
    80005c9e:	873e                	mv	a4,a5
    80005ca0:	4785                	li	a5,1
    80005ca2:	00f70a63          	beq	a4,a5,80005cb6 <namex+0x84>
      iunlockput(ip);
    80005ca6:	fe843503          	ld	a0,-24(s0)
    80005caa:	fffff097          	auipc	ra,0xfffff
    80005cae:	5de080e7          	jalr	1502(ra) # 80005288 <iunlockput>
      return 0;
    80005cb2:	4781                	li	a5,0
    80005cb4:	a871                	j	80005d50 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
    80005cb6:	fd442783          	lw	a5,-44(s0)
    80005cba:	2781                	sext.w	a5,a5
    80005cbc:	cf99                	beqz	a5,80005cda <namex+0xa8>
    80005cbe:	fd843783          	ld	a5,-40(s0)
    80005cc2:	0007c783          	lbu	a5,0(a5)
    80005cc6:	eb91                	bnez	a5,80005cda <namex+0xa8>
      // Stop one level early.
      iunlock(ip);
    80005cc8:	fe843503          	ld	a0,-24(s0)
    80005ccc:	fffff097          	auipc	ra,0xfffff
    80005cd0:	492080e7          	jalr	1170(ra) # 8000515e <iunlock>
      return ip;
    80005cd4:	fe843783          	ld	a5,-24(s0)
    80005cd8:	a8a5                	j	80005d50 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
    80005cda:	4601                	li	a2,0
    80005cdc:	fc843583          	ld	a1,-56(s0)
    80005ce0:	fe843503          	ld	a0,-24(s0)
    80005ce4:	00000097          	auipc	ra,0x0
    80005ce8:	c84080e7          	jalr	-892(ra) # 80005968 <dirlookup>
    80005cec:	fea43023          	sd	a0,-32(s0)
    80005cf0:	fe043783          	ld	a5,-32(s0)
    80005cf4:	eb89                	bnez	a5,80005d06 <namex+0xd4>
      iunlockput(ip);
    80005cf6:	fe843503          	ld	a0,-24(s0)
    80005cfa:	fffff097          	auipc	ra,0xfffff
    80005cfe:	58e080e7          	jalr	1422(ra) # 80005288 <iunlockput>
      return 0;
    80005d02:	4781                	li	a5,0
    80005d04:	a0b1                	j	80005d50 <namex+0x11e>
    }
    iunlockput(ip);
    80005d06:	fe843503          	ld	a0,-24(s0)
    80005d0a:	fffff097          	auipc	ra,0xfffff
    80005d0e:	57e080e7          	jalr	1406(ra) # 80005288 <iunlockput>
    ip = next;
    80005d12:	fe043783          	ld	a5,-32(s0)
    80005d16:	fef43423          	sd	a5,-24(s0)
  while((path = skipelem(path, name)) != 0){
    80005d1a:	fc843583          	ld	a1,-56(s0)
    80005d1e:	fd843503          	ld	a0,-40(s0)
    80005d22:	00000097          	auipc	ra,0x0
    80005d26:	e22080e7          	jalr	-478(ra) # 80005b44 <skipelem>
    80005d2a:	fca43c23          	sd	a0,-40(s0)
    80005d2e:	fd843783          	ld	a5,-40(s0)
    80005d32:	ffa1                	bnez	a5,80005c8a <namex+0x58>
  }
  if(nameiparent){
    80005d34:	fd442783          	lw	a5,-44(s0)
    80005d38:	2781                	sext.w	a5,a5
    80005d3a:	cb89                	beqz	a5,80005d4c <namex+0x11a>
    iput(ip);
    80005d3c:	fe843503          	ld	a0,-24(s0)
    80005d40:	fffff097          	auipc	ra,0xfffff
    80005d44:	478080e7          	jalr	1144(ra) # 800051b8 <iput>
    return 0;
    80005d48:	4781                	li	a5,0
    80005d4a:	a019                	j	80005d50 <namex+0x11e>
  }
  return ip;
    80005d4c:	fe843783          	ld	a5,-24(s0)
}
    80005d50:	853e                	mv	a0,a5
    80005d52:	70e2                	ld	ra,56(sp)
    80005d54:	7442                	ld	s0,48(sp)
    80005d56:	6121                	addi	sp,sp,64
    80005d58:	8082                	ret

0000000080005d5a <namei>:

struct inode*
namei(char *path)
{
    80005d5a:	7179                	addi	sp,sp,-48
    80005d5c:	f406                	sd	ra,40(sp)
    80005d5e:	f022                	sd	s0,32(sp)
    80005d60:	1800                	addi	s0,sp,48
    80005d62:	fca43c23          	sd	a0,-40(s0)
  char name[DIRSIZ];
  return namex(path, 0, name);
    80005d66:	fe040793          	addi	a5,s0,-32
    80005d6a:	863e                	mv	a2,a5
    80005d6c:	4581                	li	a1,0
    80005d6e:	fd843503          	ld	a0,-40(s0)
    80005d72:	00000097          	auipc	ra,0x0
    80005d76:	ec0080e7          	jalr	-320(ra) # 80005c32 <namex>
    80005d7a:	87aa                	mv	a5,a0
}
    80005d7c:	853e                	mv	a0,a5
    80005d7e:	70a2                	ld	ra,40(sp)
    80005d80:	7402                	ld	s0,32(sp)
    80005d82:	6145                	addi	sp,sp,48
    80005d84:	8082                	ret

0000000080005d86 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80005d86:	1101                	addi	sp,sp,-32
    80005d88:	ec06                	sd	ra,24(sp)
    80005d8a:	e822                	sd	s0,16(sp)
    80005d8c:	1000                	addi	s0,sp,32
    80005d8e:	fea43423          	sd	a0,-24(s0)
    80005d92:	feb43023          	sd	a1,-32(s0)
  return namex(path, 1, name);
    80005d96:	fe043603          	ld	a2,-32(s0)
    80005d9a:	4585                	li	a1,1
    80005d9c:	fe843503          	ld	a0,-24(s0)
    80005da0:	00000097          	auipc	ra,0x0
    80005da4:	e92080e7          	jalr	-366(ra) # 80005c32 <namex>
    80005da8:	87aa                	mv	a5,a0
}
    80005daa:	853e                	mv	a0,a5
    80005dac:	60e2                	ld	ra,24(sp)
    80005dae:	6442                	ld	s0,16(sp)
    80005db0:	6105                	addi	sp,sp,32
    80005db2:	8082                	ret

0000000080005db4 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev, struct superblock *sb)
{
    80005db4:	1101                	addi	sp,sp,-32
    80005db6:	ec06                	sd	ra,24(sp)
    80005db8:	e822                	sd	s0,16(sp)
    80005dba:	1000                	addi	s0,sp,32
    80005dbc:	87aa                	mv	a5,a0
    80005dbe:	feb43023          	sd	a1,-32(s0)
    80005dc2:	fef42623          	sw	a5,-20(s0)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  initlock(&log.lock, "log");
    80005dc6:	00005597          	auipc	a1,0x5
    80005dca:	77a58593          	addi	a1,a1,1914 # 8000b540 <etext+0x540>
    80005dce:	00020517          	auipc	a0,0x20
    80005dd2:	29a50513          	addi	a0,a0,666 # 80026068 <log>
    80005dd6:	ffffb097          	auipc	ra,0xffffb
    80005dda:	478080e7          	jalr	1144(ra) # 8000124e <initlock>
  log.start = sb->logstart;
    80005dde:	fe043783          	ld	a5,-32(s0)
    80005de2:	4bdc                	lw	a5,20(a5)
    80005de4:	0007871b          	sext.w	a4,a5
    80005de8:	00020797          	auipc	a5,0x20
    80005dec:	28078793          	addi	a5,a5,640 # 80026068 <log>
    80005df0:	cf98                	sw	a4,24(a5)
  log.size = sb->nlog;
    80005df2:	fe043783          	ld	a5,-32(s0)
    80005df6:	4b9c                	lw	a5,16(a5)
    80005df8:	0007871b          	sext.w	a4,a5
    80005dfc:	00020797          	auipc	a5,0x20
    80005e00:	26c78793          	addi	a5,a5,620 # 80026068 <log>
    80005e04:	cfd8                	sw	a4,28(a5)
  log.dev = dev;
    80005e06:	00020797          	auipc	a5,0x20
    80005e0a:	26278793          	addi	a5,a5,610 # 80026068 <log>
    80005e0e:	fec42703          	lw	a4,-20(s0)
    80005e12:	d798                	sw	a4,40(a5)
  recover_from_log();
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	272080e7          	jalr	626(ra) # 80006086 <recover_from_log>
}
    80005e1c:	0001                	nop
    80005e1e:	60e2                	ld	ra,24(sp)
    80005e20:	6442                	ld	s0,16(sp)
    80005e22:	6105                	addi	sp,sp,32
    80005e24:	8082                	ret

0000000080005e26 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(int recovering)
{
    80005e26:	7139                	addi	sp,sp,-64
    80005e28:	fc06                	sd	ra,56(sp)
    80005e2a:	f822                	sd	s0,48(sp)
    80005e2c:	0080                	addi	s0,sp,64
    80005e2e:	87aa                	mv	a5,a0
    80005e30:	fcf42623          	sw	a5,-52(s0)
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    80005e34:	fe042623          	sw	zero,-20(s0)
    80005e38:	a0f9                	j	80005f06 <install_trans+0xe0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005e3a:	00020797          	auipc	a5,0x20
    80005e3e:	22e78793          	addi	a5,a5,558 # 80026068 <log>
    80005e42:	579c                	lw	a5,40(a5)
    80005e44:	0007871b          	sext.w	a4,a5
    80005e48:	00020797          	auipc	a5,0x20
    80005e4c:	22078793          	addi	a5,a5,544 # 80026068 <log>
    80005e50:	4f9c                	lw	a5,24(a5)
    80005e52:	fec42683          	lw	a3,-20(s0)
    80005e56:	9fb5                	addw	a5,a5,a3
    80005e58:	2781                	sext.w	a5,a5
    80005e5a:	2785                	addiw	a5,a5,1
    80005e5c:	2781                	sext.w	a5,a5
    80005e5e:	2781                	sext.w	a5,a5
    80005e60:	85be                	mv	a1,a5
    80005e62:	853a                	mv	a0,a4
    80005e64:	ffffe097          	auipc	ra,0xffffe
    80005e68:	7f2080e7          	jalr	2034(ra) # 80004656 <bread>
    80005e6c:	fea43023          	sd	a0,-32(s0)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80005e70:	00020797          	auipc	a5,0x20
    80005e74:	1f878793          	addi	a5,a5,504 # 80026068 <log>
    80005e78:	579c                	lw	a5,40(a5)
    80005e7a:	0007869b          	sext.w	a3,a5
    80005e7e:	00020717          	auipc	a4,0x20
    80005e82:	1ea70713          	addi	a4,a4,490 # 80026068 <log>
    80005e86:	fec42783          	lw	a5,-20(s0)
    80005e8a:	07a1                	addi	a5,a5,8
    80005e8c:	078a                	slli	a5,a5,0x2
    80005e8e:	97ba                	add	a5,a5,a4
    80005e90:	4b9c                	lw	a5,16(a5)
    80005e92:	2781                	sext.w	a5,a5
    80005e94:	85be                	mv	a1,a5
    80005e96:	8536                	mv	a0,a3
    80005e98:	ffffe097          	auipc	ra,0xffffe
    80005e9c:	7be080e7          	jalr	1982(ra) # 80004656 <bread>
    80005ea0:	fca43c23          	sd	a0,-40(s0)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80005ea4:	fd843783          	ld	a5,-40(s0)
    80005ea8:	05878713          	addi	a4,a5,88
    80005eac:	fe043783          	ld	a5,-32(s0)
    80005eb0:	05878793          	addi	a5,a5,88
    80005eb4:	40000613          	li	a2,1024
    80005eb8:	85be                	mv	a1,a5
    80005eba:	853a                	mv	a0,a4
    80005ebc:	ffffb097          	auipc	ra,0xffffb
    80005ec0:	67a080e7          	jalr	1658(ra) # 80001536 <memmove>
    bwrite(dbuf);  // write dst to disk
    80005ec4:	fd843503          	ld	a0,-40(s0)
    80005ec8:	ffffe097          	auipc	ra,0xffffe
    80005ecc:	7e8080e7          	jalr	2024(ra) # 800046b0 <bwrite>
    if(recovering == 0)
    80005ed0:	fcc42783          	lw	a5,-52(s0)
    80005ed4:	2781                	sext.w	a5,a5
    80005ed6:	e799                	bnez	a5,80005ee4 <install_trans+0xbe>
      bunpin(dbuf);
    80005ed8:	fd843503          	ld	a0,-40(s0)
    80005edc:	fffff097          	auipc	ra,0xfffff
    80005ee0:	952080e7          	jalr	-1710(ra) # 8000482e <bunpin>
    brelse(lbuf);
    80005ee4:	fe043503          	ld	a0,-32(s0)
    80005ee8:	fffff097          	auipc	ra,0xfffff
    80005eec:	810080e7          	jalr	-2032(ra) # 800046f8 <brelse>
    brelse(dbuf);
    80005ef0:	fd843503          	ld	a0,-40(s0)
    80005ef4:	fffff097          	auipc	ra,0xfffff
    80005ef8:	804080e7          	jalr	-2044(ra) # 800046f8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005efc:	fec42783          	lw	a5,-20(s0)
    80005f00:	2785                	addiw	a5,a5,1
    80005f02:	fef42623          	sw	a5,-20(s0)
    80005f06:	00020797          	auipc	a5,0x20
    80005f0a:	16278793          	addi	a5,a5,354 # 80026068 <log>
    80005f0e:	57d8                	lw	a4,44(a5)
    80005f10:	fec42783          	lw	a5,-20(s0)
    80005f14:	2781                	sext.w	a5,a5
    80005f16:	f2e7c2e3          	blt	a5,a4,80005e3a <install_trans+0x14>
  }
}
    80005f1a:	0001                	nop
    80005f1c:	0001                	nop
    80005f1e:	70e2                	ld	ra,56(sp)
    80005f20:	7442                	ld	s0,48(sp)
    80005f22:	6121                	addi	sp,sp,64
    80005f24:	8082                	ret

0000000080005f26 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
    80005f26:	7179                	addi	sp,sp,-48
    80005f28:	f406                	sd	ra,40(sp)
    80005f2a:	f022                	sd	s0,32(sp)
    80005f2c:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    80005f2e:	00020797          	auipc	a5,0x20
    80005f32:	13a78793          	addi	a5,a5,314 # 80026068 <log>
    80005f36:	579c                	lw	a5,40(a5)
    80005f38:	0007871b          	sext.w	a4,a5
    80005f3c:	00020797          	auipc	a5,0x20
    80005f40:	12c78793          	addi	a5,a5,300 # 80026068 <log>
    80005f44:	4f9c                	lw	a5,24(a5)
    80005f46:	2781                	sext.w	a5,a5
    80005f48:	85be                	mv	a1,a5
    80005f4a:	853a                	mv	a0,a4
    80005f4c:	ffffe097          	auipc	ra,0xffffe
    80005f50:	70a080e7          	jalr	1802(ra) # 80004656 <bread>
    80005f54:	fea43023          	sd	a0,-32(s0)
  struct logheader *lh = (struct logheader *) (buf->data);
    80005f58:	fe043783          	ld	a5,-32(s0)
    80005f5c:	05878793          	addi	a5,a5,88
    80005f60:	fcf43c23          	sd	a5,-40(s0)
  int i;
  log.lh.n = lh->n;
    80005f64:	fd843783          	ld	a5,-40(s0)
    80005f68:	4398                	lw	a4,0(a5)
    80005f6a:	00020797          	auipc	a5,0x20
    80005f6e:	0fe78793          	addi	a5,a5,254 # 80026068 <log>
    80005f72:	d7d8                	sw	a4,44(a5)
  for (i = 0; i < log.lh.n; i++) {
    80005f74:	fe042623          	sw	zero,-20(s0)
    80005f78:	a03d                	j	80005fa6 <read_head+0x80>
    log.lh.block[i] = lh->block[i];
    80005f7a:	fd843703          	ld	a4,-40(s0)
    80005f7e:	fec42783          	lw	a5,-20(s0)
    80005f82:	078a                	slli	a5,a5,0x2
    80005f84:	97ba                	add	a5,a5,a4
    80005f86:	43d8                	lw	a4,4(a5)
    80005f88:	00020697          	auipc	a3,0x20
    80005f8c:	0e068693          	addi	a3,a3,224 # 80026068 <log>
    80005f90:	fec42783          	lw	a5,-20(s0)
    80005f94:	07a1                	addi	a5,a5,8
    80005f96:	078a                	slli	a5,a5,0x2
    80005f98:	97b6                	add	a5,a5,a3
    80005f9a:	cb98                	sw	a4,16(a5)
  for (i = 0; i < log.lh.n; i++) {
    80005f9c:	fec42783          	lw	a5,-20(s0)
    80005fa0:	2785                	addiw	a5,a5,1
    80005fa2:	fef42623          	sw	a5,-20(s0)
    80005fa6:	00020797          	auipc	a5,0x20
    80005faa:	0c278793          	addi	a5,a5,194 # 80026068 <log>
    80005fae:	57d8                	lw	a4,44(a5)
    80005fb0:	fec42783          	lw	a5,-20(s0)
    80005fb4:	2781                	sext.w	a5,a5
    80005fb6:	fce7c2e3          	blt	a5,a4,80005f7a <read_head+0x54>
  }
  brelse(buf);
    80005fba:	fe043503          	ld	a0,-32(s0)
    80005fbe:	ffffe097          	auipc	ra,0xffffe
    80005fc2:	73a080e7          	jalr	1850(ra) # 800046f8 <brelse>
}
    80005fc6:	0001                	nop
    80005fc8:	70a2                	ld	ra,40(sp)
    80005fca:	7402                	ld	s0,32(sp)
    80005fcc:	6145                	addi	sp,sp,48
    80005fce:	8082                	ret

0000000080005fd0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80005fd0:	7179                	addi	sp,sp,-48
    80005fd2:	f406                	sd	ra,40(sp)
    80005fd4:	f022                	sd	s0,32(sp)
    80005fd6:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    80005fd8:	00020797          	auipc	a5,0x20
    80005fdc:	09078793          	addi	a5,a5,144 # 80026068 <log>
    80005fe0:	579c                	lw	a5,40(a5)
    80005fe2:	0007871b          	sext.w	a4,a5
    80005fe6:	00020797          	auipc	a5,0x20
    80005fea:	08278793          	addi	a5,a5,130 # 80026068 <log>
    80005fee:	4f9c                	lw	a5,24(a5)
    80005ff0:	2781                	sext.w	a5,a5
    80005ff2:	85be                	mv	a1,a5
    80005ff4:	853a                	mv	a0,a4
    80005ff6:	ffffe097          	auipc	ra,0xffffe
    80005ffa:	660080e7          	jalr	1632(ra) # 80004656 <bread>
    80005ffe:	fea43023          	sd	a0,-32(s0)
  struct logheader *hb = (struct logheader *) (buf->data);
    80006002:	fe043783          	ld	a5,-32(s0)
    80006006:	05878793          	addi	a5,a5,88
    8000600a:	fcf43c23          	sd	a5,-40(s0)
  int i;
  hb->n = log.lh.n;
    8000600e:	00020797          	auipc	a5,0x20
    80006012:	05a78793          	addi	a5,a5,90 # 80026068 <log>
    80006016:	57d8                	lw	a4,44(a5)
    80006018:	fd843783          	ld	a5,-40(s0)
    8000601c:	c398                	sw	a4,0(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000601e:	fe042623          	sw	zero,-20(s0)
    80006022:	a03d                	j	80006050 <write_head+0x80>
    hb->block[i] = log.lh.block[i];
    80006024:	00020717          	auipc	a4,0x20
    80006028:	04470713          	addi	a4,a4,68 # 80026068 <log>
    8000602c:	fec42783          	lw	a5,-20(s0)
    80006030:	07a1                	addi	a5,a5,8
    80006032:	078a                	slli	a5,a5,0x2
    80006034:	97ba                	add	a5,a5,a4
    80006036:	4b98                	lw	a4,16(a5)
    80006038:	fd843683          	ld	a3,-40(s0)
    8000603c:	fec42783          	lw	a5,-20(s0)
    80006040:	078a                	slli	a5,a5,0x2
    80006042:	97b6                	add	a5,a5,a3
    80006044:	c3d8                	sw	a4,4(a5)
  for (i = 0; i < log.lh.n; i++) {
    80006046:	fec42783          	lw	a5,-20(s0)
    8000604a:	2785                	addiw	a5,a5,1
    8000604c:	fef42623          	sw	a5,-20(s0)
    80006050:	00020797          	auipc	a5,0x20
    80006054:	01878793          	addi	a5,a5,24 # 80026068 <log>
    80006058:	57d8                	lw	a4,44(a5)
    8000605a:	fec42783          	lw	a5,-20(s0)
    8000605e:	2781                	sext.w	a5,a5
    80006060:	fce7c2e3          	blt	a5,a4,80006024 <write_head+0x54>
  }
  bwrite(buf);
    80006064:	fe043503          	ld	a0,-32(s0)
    80006068:	ffffe097          	auipc	ra,0xffffe
    8000606c:	648080e7          	jalr	1608(ra) # 800046b0 <bwrite>
  brelse(buf);
    80006070:	fe043503          	ld	a0,-32(s0)
    80006074:	ffffe097          	auipc	ra,0xffffe
    80006078:	684080e7          	jalr	1668(ra) # 800046f8 <brelse>
}
    8000607c:	0001                	nop
    8000607e:	70a2                	ld	ra,40(sp)
    80006080:	7402                	ld	s0,32(sp)
    80006082:	6145                	addi	sp,sp,48
    80006084:	8082                	ret

0000000080006086 <recover_from_log>:

static void
recover_from_log(void)
{
    80006086:	1141                	addi	sp,sp,-16
    80006088:	e406                	sd	ra,8(sp)
    8000608a:	e022                	sd	s0,0(sp)
    8000608c:	0800                	addi	s0,sp,16
  read_head();
    8000608e:	00000097          	auipc	ra,0x0
    80006092:	e98080e7          	jalr	-360(ra) # 80005f26 <read_head>
  install_trans(1); // if committed, copy from log to disk
    80006096:	4505                	li	a0,1
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	d8e080e7          	jalr	-626(ra) # 80005e26 <install_trans>
  log.lh.n = 0;
    800060a0:	00020797          	auipc	a5,0x20
    800060a4:	fc878793          	addi	a5,a5,-56 # 80026068 <log>
    800060a8:	0207a623          	sw	zero,44(a5)
  write_head(); // clear the log
    800060ac:	00000097          	auipc	ra,0x0
    800060b0:	f24080e7          	jalr	-220(ra) # 80005fd0 <write_head>
}
    800060b4:	0001                	nop
    800060b6:	60a2                	ld	ra,8(sp)
    800060b8:	6402                	ld	s0,0(sp)
    800060ba:	0141                	addi	sp,sp,16
    800060bc:	8082                	ret

00000000800060be <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
    800060be:	1141                	addi	sp,sp,-16
    800060c0:	e406                	sd	ra,8(sp)
    800060c2:	e022                	sd	s0,0(sp)
    800060c4:	0800                	addi	s0,sp,16
  acquire(&log.lock);
    800060c6:	00020517          	auipc	a0,0x20
    800060ca:	fa250513          	addi	a0,a0,-94 # 80026068 <log>
    800060ce:	ffffb097          	auipc	ra,0xffffb
    800060d2:	1b0080e7          	jalr	432(ra) # 8000127e <acquire>
  while(1){
    if(log.committing){
    800060d6:	00020797          	auipc	a5,0x20
    800060da:	f9278793          	addi	a5,a5,-110 # 80026068 <log>
    800060de:	53dc                	lw	a5,36(a5)
    800060e0:	cf91                	beqz	a5,800060fc <begin_op+0x3e>
      sleep(&log, &log.lock);
    800060e2:	00020597          	auipc	a1,0x20
    800060e6:	f8658593          	addi	a1,a1,-122 # 80026068 <log>
    800060ea:	00020517          	auipc	a0,0x20
    800060ee:	f7e50513          	addi	a0,a0,-130 # 80026068 <log>
    800060f2:	ffffd097          	auipc	ra,0xffffd
    800060f6:	316080e7          	jalr	790(ra) # 80003408 <sleep>
    800060fa:	bff1                	j	800060d6 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800060fc:	00020797          	auipc	a5,0x20
    80006100:	f6c78793          	addi	a5,a5,-148 # 80026068 <log>
    80006104:	57d8                	lw	a4,44(a5)
    80006106:	00020797          	auipc	a5,0x20
    8000610a:	f6278793          	addi	a5,a5,-158 # 80026068 <log>
    8000610e:	539c                	lw	a5,32(a5)
    80006110:	2785                	addiw	a5,a5,1
    80006112:	2781                	sext.w	a5,a5
    80006114:	86be                	mv	a3,a5
    80006116:	87b6                	mv	a5,a3
    80006118:	0027979b          	slliw	a5,a5,0x2
    8000611c:	9fb5                	addw	a5,a5,a3
    8000611e:	0017979b          	slliw	a5,a5,0x1
    80006122:	2781                	sext.w	a5,a5
    80006124:	9fb9                	addw	a5,a5,a4
    80006126:	2781                	sext.w	a5,a5
    80006128:	873e                	mv	a4,a5
    8000612a:	47f9                	li	a5,30
    8000612c:	00e7df63          	bge	a5,a4,8000614a <begin_op+0x8c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80006130:	00020597          	auipc	a1,0x20
    80006134:	f3858593          	addi	a1,a1,-200 # 80026068 <log>
    80006138:	00020517          	auipc	a0,0x20
    8000613c:	f3050513          	addi	a0,a0,-208 # 80026068 <log>
    80006140:	ffffd097          	auipc	ra,0xffffd
    80006144:	2c8080e7          	jalr	712(ra) # 80003408 <sleep>
    80006148:	b779                	j	800060d6 <begin_op+0x18>
    } else {
      log.outstanding += 1;
    8000614a:	00020797          	auipc	a5,0x20
    8000614e:	f1e78793          	addi	a5,a5,-226 # 80026068 <log>
    80006152:	539c                	lw	a5,32(a5)
    80006154:	2785                	addiw	a5,a5,1
    80006156:	0007871b          	sext.w	a4,a5
    8000615a:	00020797          	auipc	a5,0x20
    8000615e:	f0e78793          	addi	a5,a5,-242 # 80026068 <log>
    80006162:	d398                	sw	a4,32(a5)
      release(&log.lock);
    80006164:	00020517          	auipc	a0,0x20
    80006168:	f0450513          	addi	a0,a0,-252 # 80026068 <log>
    8000616c:	ffffb097          	auipc	ra,0xffffb
    80006170:	176080e7          	jalr	374(ra) # 800012e2 <release>
      break;
    80006174:	0001                	nop
    }
  }
}
    80006176:	0001                	nop
    80006178:	60a2                	ld	ra,8(sp)
    8000617a:	6402                	ld	s0,0(sp)
    8000617c:	0141                	addi	sp,sp,16
    8000617e:	8082                	ret

0000000080006180 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80006180:	1101                	addi	sp,sp,-32
    80006182:	ec06                	sd	ra,24(sp)
    80006184:	e822                	sd	s0,16(sp)
    80006186:	1000                	addi	s0,sp,32
  int do_commit = 0;
    80006188:	fe042623          	sw	zero,-20(s0)

  acquire(&log.lock);
    8000618c:	00020517          	auipc	a0,0x20
    80006190:	edc50513          	addi	a0,a0,-292 # 80026068 <log>
    80006194:	ffffb097          	auipc	ra,0xffffb
    80006198:	0ea080e7          	jalr	234(ra) # 8000127e <acquire>
  log.outstanding -= 1;
    8000619c:	00020797          	auipc	a5,0x20
    800061a0:	ecc78793          	addi	a5,a5,-308 # 80026068 <log>
    800061a4:	539c                	lw	a5,32(a5)
    800061a6:	37fd                	addiw	a5,a5,-1
    800061a8:	0007871b          	sext.w	a4,a5
    800061ac:	00020797          	auipc	a5,0x20
    800061b0:	ebc78793          	addi	a5,a5,-324 # 80026068 <log>
    800061b4:	d398                	sw	a4,32(a5)
  if(log.committing)
    800061b6:	00020797          	auipc	a5,0x20
    800061ba:	eb278793          	addi	a5,a5,-334 # 80026068 <log>
    800061be:	53dc                	lw	a5,36(a5)
    800061c0:	cb89                	beqz	a5,800061d2 <end_op+0x52>
    panic("log.committing");
    800061c2:	00005517          	auipc	a0,0x5
    800061c6:	38650513          	addi	a0,a0,902 # 8000b548 <etext+0x548>
    800061ca:	ffffb097          	auipc	ra,0xffffb
    800061ce:	ac0080e7          	jalr	-1344(ra) # 80000c8a <panic>
  if(log.outstanding == 0){
    800061d2:	00020797          	auipc	a5,0x20
    800061d6:	e9678793          	addi	a5,a5,-362 # 80026068 <log>
    800061da:	539c                	lw	a5,32(a5)
    800061dc:	eb99                	bnez	a5,800061f2 <end_op+0x72>
    do_commit = 1;
    800061de:	4785                	li	a5,1
    800061e0:	fef42623          	sw	a5,-20(s0)
    log.committing = 1;
    800061e4:	00020797          	auipc	a5,0x20
    800061e8:	e8478793          	addi	a5,a5,-380 # 80026068 <log>
    800061ec:	4705                	li	a4,1
    800061ee:	d3d8                	sw	a4,36(a5)
    800061f0:	a809                	j	80006202 <end_op+0x82>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
    800061f2:	00020517          	auipc	a0,0x20
    800061f6:	e7650513          	addi	a0,a0,-394 # 80026068 <log>
    800061fa:	ffffd097          	auipc	ra,0xffffd
    800061fe:	28a080e7          	jalr	650(ra) # 80003484 <wakeup>
  }
  release(&log.lock);
    80006202:	00020517          	auipc	a0,0x20
    80006206:	e6650513          	addi	a0,a0,-410 # 80026068 <log>
    8000620a:	ffffb097          	auipc	ra,0xffffb
    8000620e:	0d8080e7          	jalr	216(ra) # 800012e2 <release>

  if(do_commit){
    80006212:	fec42783          	lw	a5,-20(s0)
    80006216:	2781                	sext.w	a5,a5
    80006218:	c3b9                	beqz	a5,8000625e <end_op+0xde>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    8000621a:	00000097          	auipc	ra,0x0
    8000621e:	134080e7          	jalr	308(ra) # 8000634e <commit>
    acquire(&log.lock);
    80006222:	00020517          	auipc	a0,0x20
    80006226:	e4650513          	addi	a0,a0,-442 # 80026068 <log>
    8000622a:	ffffb097          	auipc	ra,0xffffb
    8000622e:	054080e7          	jalr	84(ra) # 8000127e <acquire>
    log.committing = 0;
    80006232:	00020797          	auipc	a5,0x20
    80006236:	e3678793          	addi	a5,a5,-458 # 80026068 <log>
    8000623a:	0207a223          	sw	zero,36(a5)
    wakeup(&log);
    8000623e:	00020517          	auipc	a0,0x20
    80006242:	e2a50513          	addi	a0,a0,-470 # 80026068 <log>
    80006246:	ffffd097          	auipc	ra,0xffffd
    8000624a:	23e080e7          	jalr	574(ra) # 80003484 <wakeup>
    release(&log.lock);
    8000624e:	00020517          	auipc	a0,0x20
    80006252:	e1a50513          	addi	a0,a0,-486 # 80026068 <log>
    80006256:	ffffb097          	auipc	ra,0xffffb
    8000625a:	08c080e7          	jalr	140(ra) # 800012e2 <release>
  }
}
    8000625e:	0001                	nop
    80006260:	60e2                	ld	ra,24(sp)
    80006262:	6442                	ld	s0,16(sp)
    80006264:	6105                	addi	sp,sp,32
    80006266:	8082                	ret

0000000080006268 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
    80006268:	7179                	addi	sp,sp,-48
    8000626a:	f406                	sd	ra,40(sp)
    8000626c:	f022                	sd	s0,32(sp)
    8000626e:	1800                	addi	s0,sp,48
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    80006270:	fe042623          	sw	zero,-20(s0)
    80006274:	a86d                	j	8000632e <write_log+0xc6>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80006276:	00020797          	auipc	a5,0x20
    8000627a:	df278793          	addi	a5,a5,-526 # 80026068 <log>
    8000627e:	579c                	lw	a5,40(a5)
    80006280:	0007871b          	sext.w	a4,a5
    80006284:	00020797          	auipc	a5,0x20
    80006288:	de478793          	addi	a5,a5,-540 # 80026068 <log>
    8000628c:	4f9c                	lw	a5,24(a5)
    8000628e:	fec42683          	lw	a3,-20(s0)
    80006292:	9fb5                	addw	a5,a5,a3
    80006294:	2781                	sext.w	a5,a5
    80006296:	2785                	addiw	a5,a5,1
    80006298:	2781                	sext.w	a5,a5
    8000629a:	2781                	sext.w	a5,a5
    8000629c:	85be                	mv	a1,a5
    8000629e:	853a                	mv	a0,a4
    800062a0:	ffffe097          	auipc	ra,0xffffe
    800062a4:	3b6080e7          	jalr	950(ra) # 80004656 <bread>
    800062a8:	fea43023          	sd	a0,-32(s0)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800062ac:	00020797          	auipc	a5,0x20
    800062b0:	dbc78793          	addi	a5,a5,-580 # 80026068 <log>
    800062b4:	579c                	lw	a5,40(a5)
    800062b6:	0007869b          	sext.w	a3,a5
    800062ba:	00020717          	auipc	a4,0x20
    800062be:	dae70713          	addi	a4,a4,-594 # 80026068 <log>
    800062c2:	fec42783          	lw	a5,-20(s0)
    800062c6:	07a1                	addi	a5,a5,8
    800062c8:	078a                	slli	a5,a5,0x2
    800062ca:	97ba                	add	a5,a5,a4
    800062cc:	4b9c                	lw	a5,16(a5)
    800062ce:	2781                	sext.w	a5,a5
    800062d0:	85be                	mv	a1,a5
    800062d2:	8536                	mv	a0,a3
    800062d4:	ffffe097          	auipc	ra,0xffffe
    800062d8:	382080e7          	jalr	898(ra) # 80004656 <bread>
    800062dc:	fca43c23          	sd	a0,-40(s0)
    memmove(to->data, from->data, BSIZE);
    800062e0:	fe043783          	ld	a5,-32(s0)
    800062e4:	05878713          	addi	a4,a5,88
    800062e8:	fd843783          	ld	a5,-40(s0)
    800062ec:	05878793          	addi	a5,a5,88
    800062f0:	40000613          	li	a2,1024
    800062f4:	85be                	mv	a1,a5
    800062f6:	853a                	mv	a0,a4
    800062f8:	ffffb097          	auipc	ra,0xffffb
    800062fc:	23e080e7          	jalr	574(ra) # 80001536 <memmove>
    bwrite(to);  // write the log
    80006300:	fe043503          	ld	a0,-32(s0)
    80006304:	ffffe097          	auipc	ra,0xffffe
    80006308:	3ac080e7          	jalr	940(ra) # 800046b0 <bwrite>
    brelse(from);
    8000630c:	fd843503          	ld	a0,-40(s0)
    80006310:	ffffe097          	auipc	ra,0xffffe
    80006314:	3e8080e7          	jalr	1000(ra) # 800046f8 <brelse>
    brelse(to);
    80006318:	fe043503          	ld	a0,-32(s0)
    8000631c:	ffffe097          	auipc	ra,0xffffe
    80006320:	3dc080e7          	jalr	988(ra) # 800046f8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80006324:	fec42783          	lw	a5,-20(s0)
    80006328:	2785                	addiw	a5,a5,1
    8000632a:	fef42623          	sw	a5,-20(s0)
    8000632e:	00020797          	auipc	a5,0x20
    80006332:	d3a78793          	addi	a5,a5,-710 # 80026068 <log>
    80006336:	57d8                	lw	a4,44(a5)
    80006338:	fec42783          	lw	a5,-20(s0)
    8000633c:	2781                	sext.w	a5,a5
    8000633e:	f2e7cce3          	blt	a5,a4,80006276 <write_log+0xe>
  }
}
    80006342:	0001                	nop
    80006344:	0001                	nop
    80006346:	70a2                	ld	ra,40(sp)
    80006348:	7402                	ld	s0,32(sp)
    8000634a:	6145                	addi	sp,sp,48
    8000634c:	8082                	ret

000000008000634e <commit>:

static void
commit()
{
    8000634e:	1141                	addi	sp,sp,-16
    80006350:	e406                	sd	ra,8(sp)
    80006352:	e022                	sd	s0,0(sp)
    80006354:	0800                	addi	s0,sp,16
  if (log.lh.n > 0) {
    80006356:	00020797          	auipc	a5,0x20
    8000635a:	d1278793          	addi	a5,a5,-750 # 80026068 <log>
    8000635e:	57dc                	lw	a5,44(a5)
    80006360:	02f05963          	blez	a5,80006392 <commit+0x44>
    write_log();     // Write modified blocks from cache to log
    80006364:	00000097          	auipc	ra,0x0
    80006368:	f04080e7          	jalr	-252(ra) # 80006268 <write_log>
    write_head();    // Write header to disk -- the real commit
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	c64080e7          	jalr	-924(ra) # 80005fd0 <write_head>
    install_trans(0); // Now install writes to home locations
    80006374:	4501                	li	a0,0
    80006376:	00000097          	auipc	ra,0x0
    8000637a:	ab0080e7          	jalr	-1360(ra) # 80005e26 <install_trans>
    log.lh.n = 0;
    8000637e:	00020797          	auipc	a5,0x20
    80006382:	cea78793          	addi	a5,a5,-790 # 80026068 <log>
    80006386:	0207a623          	sw	zero,44(a5)
    write_head();    // Erase the transaction from the log
    8000638a:	00000097          	auipc	ra,0x0
    8000638e:	c46080e7          	jalr	-954(ra) # 80005fd0 <write_head>
  }
}
    80006392:	0001                	nop
    80006394:	60a2                	ld	ra,8(sp)
    80006396:	6402                	ld	s0,0(sp)
    80006398:	0141                	addi	sp,sp,16
    8000639a:	8082                	ret

000000008000639c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000639c:	7179                	addi	sp,sp,-48
    8000639e:	f406                	sd	ra,40(sp)
    800063a0:	f022                	sd	s0,32(sp)
    800063a2:	1800                	addi	s0,sp,48
    800063a4:	fca43c23          	sd	a0,-40(s0)
  int i;

  acquire(&log.lock);
    800063a8:	00020517          	auipc	a0,0x20
    800063ac:	cc050513          	addi	a0,a0,-832 # 80026068 <log>
    800063b0:	ffffb097          	auipc	ra,0xffffb
    800063b4:	ece080e7          	jalr	-306(ra) # 8000127e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800063b8:	00020797          	auipc	a5,0x20
    800063bc:	cb078793          	addi	a5,a5,-848 # 80026068 <log>
    800063c0:	57dc                	lw	a5,44(a5)
    800063c2:	873e                	mv	a4,a5
    800063c4:	47f5                	li	a5,29
    800063c6:	02e7c063          	blt	a5,a4,800063e6 <log_write+0x4a>
    800063ca:	00020797          	auipc	a5,0x20
    800063ce:	c9e78793          	addi	a5,a5,-866 # 80026068 <log>
    800063d2:	57d8                	lw	a4,44(a5)
    800063d4:	00020797          	auipc	a5,0x20
    800063d8:	c9478793          	addi	a5,a5,-876 # 80026068 <log>
    800063dc:	4fdc                	lw	a5,28(a5)
    800063de:	37fd                	addiw	a5,a5,-1
    800063e0:	2781                	sext.w	a5,a5
    800063e2:	00f74a63          	blt	a4,a5,800063f6 <log_write+0x5a>
    panic("too big a transaction");
    800063e6:	00005517          	auipc	a0,0x5
    800063ea:	17250513          	addi	a0,a0,370 # 8000b558 <etext+0x558>
    800063ee:	ffffb097          	auipc	ra,0xffffb
    800063f2:	89c080e7          	jalr	-1892(ra) # 80000c8a <panic>
  if (log.outstanding < 1)
    800063f6:	00020797          	auipc	a5,0x20
    800063fa:	c7278793          	addi	a5,a5,-910 # 80026068 <log>
    800063fe:	539c                	lw	a5,32(a5)
    80006400:	00f04a63          	bgtz	a5,80006414 <log_write+0x78>
    panic("log_write outside of trans");
    80006404:	00005517          	auipc	a0,0x5
    80006408:	16c50513          	addi	a0,a0,364 # 8000b570 <etext+0x570>
    8000640c:	ffffb097          	auipc	ra,0xffffb
    80006410:	87e080e7          	jalr	-1922(ra) # 80000c8a <panic>

  for (i = 0; i < log.lh.n; i++) {
    80006414:	fe042623          	sw	zero,-20(s0)
    80006418:	a03d                	j	80006446 <log_write+0xaa>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000641a:	00020717          	auipc	a4,0x20
    8000641e:	c4e70713          	addi	a4,a4,-946 # 80026068 <log>
    80006422:	fec42783          	lw	a5,-20(s0)
    80006426:	07a1                	addi	a5,a5,8
    80006428:	078a                	slli	a5,a5,0x2
    8000642a:	97ba                	add	a5,a5,a4
    8000642c:	4b9c                	lw	a5,16(a5)
    8000642e:	0007871b          	sext.w	a4,a5
    80006432:	fd843783          	ld	a5,-40(s0)
    80006436:	47dc                	lw	a5,12(a5)
    80006438:	02f70263          	beq	a4,a5,8000645c <log_write+0xc0>
  for (i = 0; i < log.lh.n; i++) {
    8000643c:	fec42783          	lw	a5,-20(s0)
    80006440:	2785                	addiw	a5,a5,1
    80006442:	fef42623          	sw	a5,-20(s0)
    80006446:	00020797          	auipc	a5,0x20
    8000644a:	c2278793          	addi	a5,a5,-990 # 80026068 <log>
    8000644e:	57d8                	lw	a4,44(a5)
    80006450:	fec42783          	lw	a5,-20(s0)
    80006454:	2781                	sext.w	a5,a5
    80006456:	fce7c2e3          	blt	a5,a4,8000641a <log_write+0x7e>
    8000645a:	a011                	j	8000645e <log_write+0xc2>
      break;
    8000645c:	0001                	nop
  }
  log.lh.block[i] = b->blockno;
    8000645e:	fd843783          	ld	a5,-40(s0)
    80006462:	47dc                	lw	a5,12(a5)
    80006464:	0007871b          	sext.w	a4,a5
    80006468:	00020697          	auipc	a3,0x20
    8000646c:	c0068693          	addi	a3,a3,-1024 # 80026068 <log>
    80006470:	fec42783          	lw	a5,-20(s0)
    80006474:	07a1                	addi	a5,a5,8
    80006476:	078a                	slli	a5,a5,0x2
    80006478:	97b6                	add	a5,a5,a3
    8000647a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    8000647c:	00020797          	auipc	a5,0x20
    80006480:	bec78793          	addi	a5,a5,-1044 # 80026068 <log>
    80006484:	57d8                	lw	a4,44(a5)
    80006486:	fec42783          	lw	a5,-20(s0)
    8000648a:	2781                	sext.w	a5,a5
    8000648c:	02e79563          	bne	a5,a4,800064b6 <log_write+0x11a>
    bpin(b);
    80006490:	fd843503          	ld	a0,-40(s0)
    80006494:	ffffe097          	auipc	ra,0xffffe
    80006498:	352080e7          	jalr	850(ra) # 800047e6 <bpin>
    log.lh.n++;
    8000649c:	00020797          	auipc	a5,0x20
    800064a0:	bcc78793          	addi	a5,a5,-1076 # 80026068 <log>
    800064a4:	57dc                	lw	a5,44(a5)
    800064a6:	2785                	addiw	a5,a5,1
    800064a8:	0007871b          	sext.w	a4,a5
    800064ac:	00020797          	auipc	a5,0x20
    800064b0:	bbc78793          	addi	a5,a5,-1092 # 80026068 <log>
    800064b4:	d7d8                	sw	a4,44(a5)
  }
  release(&log.lock);
    800064b6:	00020517          	auipc	a0,0x20
    800064ba:	bb250513          	addi	a0,a0,-1102 # 80026068 <log>
    800064be:	ffffb097          	auipc	ra,0xffffb
    800064c2:	e24080e7          	jalr	-476(ra) # 800012e2 <release>
}
    800064c6:	0001                	nop
    800064c8:	70a2                	ld	ra,40(sp)
    800064ca:	7402                	ld	s0,32(sp)
    800064cc:	6145                	addi	sp,sp,48
    800064ce:	8082                	ret

00000000800064d0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800064d0:	1101                	addi	sp,sp,-32
    800064d2:	ec06                	sd	ra,24(sp)
    800064d4:	e822                	sd	s0,16(sp)
    800064d6:	1000                	addi	s0,sp,32
    800064d8:	fea43423          	sd	a0,-24(s0)
    800064dc:	feb43023          	sd	a1,-32(s0)
  initlock(&lk->lk, "sleep lock");
    800064e0:	fe843783          	ld	a5,-24(s0)
    800064e4:	07a1                	addi	a5,a5,8
    800064e6:	00005597          	auipc	a1,0x5
    800064ea:	0aa58593          	addi	a1,a1,170 # 8000b590 <etext+0x590>
    800064ee:	853e                	mv	a0,a5
    800064f0:	ffffb097          	auipc	ra,0xffffb
    800064f4:	d5e080e7          	jalr	-674(ra) # 8000124e <initlock>
  lk->name = name;
    800064f8:	fe843783          	ld	a5,-24(s0)
    800064fc:	fe043703          	ld	a4,-32(s0)
    80006500:	f398                	sd	a4,32(a5)
  lk->locked = 0;
    80006502:	fe843783          	ld	a5,-24(s0)
    80006506:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    8000650a:	fe843783          	ld	a5,-24(s0)
    8000650e:	0207a423          	sw	zero,40(a5)
}
    80006512:	0001                	nop
    80006514:	60e2                	ld	ra,24(sp)
    80006516:	6442                	ld	s0,16(sp)
    80006518:	6105                	addi	sp,sp,32
    8000651a:	8082                	ret

000000008000651c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000651c:	1101                	addi	sp,sp,-32
    8000651e:	ec06                	sd	ra,24(sp)
    80006520:	e822                	sd	s0,16(sp)
    80006522:	1000                	addi	s0,sp,32
    80006524:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    80006528:	fe843783          	ld	a5,-24(s0)
    8000652c:	07a1                	addi	a5,a5,8
    8000652e:	853e                	mv	a0,a5
    80006530:	ffffb097          	auipc	ra,0xffffb
    80006534:	d4e080e7          	jalr	-690(ra) # 8000127e <acquire>
  while (lk->locked) {
    80006538:	a819                	j	8000654e <acquiresleep+0x32>
    sleep(lk, &lk->lk);
    8000653a:	fe843783          	ld	a5,-24(s0)
    8000653e:	07a1                	addi	a5,a5,8
    80006540:	85be                	mv	a1,a5
    80006542:	fe843503          	ld	a0,-24(s0)
    80006546:	ffffd097          	auipc	ra,0xffffd
    8000654a:	ec2080e7          	jalr	-318(ra) # 80003408 <sleep>
  while (lk->locked) {
    8000654e:	fe843783          	ld	a5,-24(s0)
    80006552:	439c                	lw	a5,0(a5)
    80006554:	f3fd                	bnez	a5,8000653a <acquiresleep+0x1e>
  }
  lk->locked = 1;
    80006556:	fe843783          	ld	a5,-24(s0)
    8000655a:	4705                	li	a4,1
    8000655c:	c398                	sw	a4,0(a5)
  lk->pid = myproc()->pid;
    8000655e:	ffffc097          	auipc	ra,0xffffc
    80006562:	2e8080e7          	jalr	744(ra) # 80002846 <myproc>
    80006566:	87aa                	mv	a5,a0
    80006568:	5b98                	lw	a4,48(a5)
    8000656a:	fe843783          	ld	a5,-24(s0)
    8000656e:	d798                	sw	a4,40(a5)
  release(&lk->lk);
    80006570:	fe843783          	ld	a5,-24(s0)
    80006574:	07a1                	addi	a5,a5,8
    80006576:	853e                	mv	a0,a5
    80006578:	ffffb097          	auipc	ra,0xffffb
    8000657c:	d6a080e7          	jalr	-662(ra) # 800012e2 <release>
}
    80006580:	0001                	nop
    80006582:	60e2                	ld	ra,24(sp)
    80006584:	6442                	ld	s0,16(sp)
    80006586:	6105                	addi	sp,sp,32
    80006588:	8082                	ret

000000008000658a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000658a:	1101                	addi	sp,sp,-32
    8000658c:	ec06                	sd	ra,24(sp)
    8000658e:	e822                	sd	s0,16(sp)
    80006590:	1000                	addi	s0,sp,32
    80006592:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    80006596:	fe843783          	ld	a5,-24(s0)
    8000659a:	07a1                	addi	a5,a5,8
    8000659c:	853e                	mv	a0,a5
    8000659e:	ffffb097          	auipc	ra,0xffffb
    800065a2:	ce0080e7          	jalr	-800(ra) # 8000127e <acquire>
  lk->locked = 0;
    800065a6:	fe843783          	ld	a5,-24(s0)
    800065aa:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    800065ae:	fe843783          	ld	a5,-24(s0)
    800065b2:	0207a423          	sw	zero,40(a5)
  wakeup(lk);
    800065b6:	fe843503          	ld	a0,-24(s0)
    800065ba:	ffffd097          	auipc	ra,0xffffd
    800065be:	eca080e7          	jalr	-310(ra) # 80003484 <wakeup>
  release(&lk->lk);
    800065c2:	fe843783          	ld	a5,-24(s0)
    800065c6:	07a1                	addi	a5,a5,8
    800065c8:	853e                	mv	a0,a5
    800065ca:	ffffb097          	auipc	ra,0xffffb
    800065ce:	d18080e7          	jalr	-744(ra) # 800012e2 <release>
}
    800065d2:	0001                	nop
    800065d4:	60e2                	ld	ra,24(sp)
    800065d6:	6442                	ld	s0,16(sp)
    800065d8:	6105                	addi	sp,sp,32
    800065da:	8082                	ret

00000000800065dc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800065dc:	7139                	addi	sp,sp,-64
    800065de:	fc06                	sd	ra,56(sp)
    800065e0:	f822                	sd	s0,48(sp)
    800065e2:	f426                	sd	s1,40(sp)
    800065e4:	0080                	addi	s0,sp,64
    800065e6:	fca43423          	sd	a0,-56(s0)
  int r;
  
  acquire(&lk->lk);
    800065ea:	fc843783          	ld	a5,-56(s0)
    800065ee:	07a1                	addi	a5,a5,8
    800065f0:	853e                	mv	a0,a5
    800065f2:	ffffb097          	auipc	ra,0xffffb
    800065f6:	c8c080e7          	jalr	-884(ra) # 8000127e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800065fa:	fc843783          	ld	a5,-56(s0)
    800065fe:	439c                	lw	a5,0(a5)
    80006600:	cf99                	beqz	a5,8000661e <holdingsleep+0x42>
    80006602:	fc843783          	ld	a5,-56(s0)
    80006606:	5784                	lw	s1,40(a5)
    80006608:	ffffc097          	auipc	ra,0xffffc
    8000660c:	23e080e7          	jalr	574(ra) # 80002846 <myproc>
    80006610:	87aa                	mv	a5,a0
    80006612:	5b9c                	lw	a5,48(a5)
    80006614:	8726                	mv	a4,s1
    80006616:	00f71463          	bne	a4,a5,8000661e <holdingsleep+0x42>
    8000661a:	4785                	li	a5,1
    8000661c:	a011                	j	80006620 <holdingsleep+0x44>
    8000661e:	4781                	li	a5,0
    80006620:	fcf42e23          	sw	a5,-36(s0)
  release(&lk->lk);
    80006624:	fc843783          	ld	a5,-56(s0)
    80006628:	07a1                	addi	a5,a5,8
    8000662a:	853e                	mv	a0,a5
    8000662c:	ffffb097          	auipc	ra,0xffffb
    80006630:	cb6080e7          	jalr	-842(ra) # 800012e2 <release>
  return r;
    80006634:	fdc42783          	lw	a5,-36(s0)
}
    80006638:	853e                	mv	a0,a5
    8000663a:	70e2                	ld	ra,56(sp)
    8000663c:	7442                	ld	s0,48(sp)
    8000663e:	74a2                	ld	s1,40(sp)
    80006640:	6121                	addi	sp,sp,64
    80006642:	8082                	ret

0000000080006644 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80006644:	1141                	addi	sp,sp,-16
    80006646:	e406                	sd	ra,8(sp)
    80006648:	e022                	sd	s0,0(sp)
    8000664a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000664c:	00005597          	auipc	a1,0x5
    80006650:	f5458593          	addi	a1,a1,-172 # 8000b5a0 <etext+0x5a0>
    80006654:	00020517          	auipc	a0,0x20
    80006658:	b5c50513          	addi	a0,a0,-1188 # 800261b0 <ftable>
    8000665c:	ffffb097          	auipc	ra,0xffffb
    80006660:	bf2080e7          	jalr	-1038(ra) # 8000124e <initlock>
}
    80006664:	0001                	nop
    80006666:	60a2                	ld	ra,8(sp)
    80006668:	6402                	ld	s0,0(sp)
    8000666a:	0141                	addi	sp,sp,16
    8000666c:	8082                	ret

000000008000666e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000666e:	1101                	addi	sp,sp,-32
    80006670:	ec06                	sd	ra,24(sp)
    80006672:	e822                	sd	s0,16(sp)
    80006674:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80006676:	00020517          	auipc	a0,0x20
    8000667a:	b3a50513          	addi	a0,a0,-1222 # 800261b0 <ftable>
    8000667e:	ffffb097          	auipc	ra,0xffffb
    80006682:	c00080e7          	jalr	-1024(ra) # 8000127e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80006686:	00020797          	auipc	a5,0x20
    8000668a:	b4278793          	addi	a5,a5,-1214 # 800261c8 <ftable+0x18>
    8000668e:	fef43423          	sd	a5,-24(s0)
    80006692:	a815                	j	800066c6 <filealloc+0x58>
    if(f->ref == 0){
    80006694:	fe843783          	ld	a5,-24(s0)
    80006698:	43dc                	lw	a5,4(a5)
    8000669a:	e385                	bnez	a5,800066ba <filealloc+0x4c>
      f->ref = 1;
    8000669c:	fe843783          	ld	a5,-24(s0)
    800066a0:	4705                	li	a4,1
    800066a2:	c3d8                	sw	a4,4(a5)
      release(&ftable.lock);
    800066a4:	00020517          	auipc	a0,0x20
    800066a8:	b0c50513          	addi	a0,a0,-1268 # 800261b0 <ftable>
    800066ac:	ffffb097          	auipc	ra,0xffffb
    800066b0:	c36080e7          	jalr	-970(ra) # 800012e2 <release>
      return f;
    800066b4:	fe843783          	ld	a5,-24(s0)
    800066b8:	a805                	j	800066e8 <filealloc+0x7a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800066ba:	fe843783          	ld	a5,-24(s0)
    800066be:	02878793          	addi	a5,a5,40
    800066c2:	fef43423          	sd	a5,-24(s0)
    800066c6:	00021797          	auipc	a5,0x21
    800066ca:	aa278793          	addi	a5,a5,-1374 # 80027168 <disk>
    800066ce:	fe843703          	ld	a4,-24(s0)
    800066d2:	fcf761e3          	bltu	a4,a5,80006694 <filealloc+0x26>
    }
  }
  release(&ftable.lock);
    800066d6:	00020517          	auipc	a0,0x20
    800066da:	ada50513          	addi	a0,a0,-1318 # 800261b0 <ftable>
    800066de:	ffffb097          	auipc	ra,0xffffb
    800066e2:	c04080e7          	jalr	-1020(ra) # 800012e2 <release>
  return 0;
    800066e6:	4781                	li	a5,0
}
    800066e8:	853e                	mv	a0,a5
    800066ea:	60e2                	ld	ra,24(sp)
    800066ec:	6442                	ld	s0,16(sp)
    800066ee:	6105                	addi	sp,sp,32
    800066f0:	8082                	ret

00000000800066f2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800066f2:	1101                	addi	sp,sp,-32
    800066f4:	ec06                	sd	ra,24(sp)
    800066f6:	e822                	sd	s0,16(sp)
    800066f8:	1000                	addi	s0,sp,32
    800066fa:	fea43423          	sd	a0,-24(s0)
  acquire(&ftable.lock);
    800066fe:	00020517          	auipc	a0,0x20
    80006702:	ab250513          	addi	a0,a0,-1358 # 800261b0 <ftable>
    80006706:	ffffb097          	auipc	ra,0xffffb
    8000670a:	b78080e7          	jalr	-1160(ra) # 8000127e <acquire>
  if(f->ref < 1)
    8000670e:	fe843783          	ld	a5,-24(s0)
    80006712:	43dc                	lw	a5,4(a5)
    80006714:	00f04a63          	bgtz	a5,80006728 <filedup+0x36>
    panic("filedup");
    80006718:	00005517          	auipc	a0,0x5
    8000671c:	e9050513          	addi	a0,a0,-368 # 8000b5a8 <etext+0x5a8>
    80006720:	ffffa097          	auipc	ra,0xffffa
    80006724:	56a080e7          	jalr	1386(ra) # 80000c8a <panic>
  f->ref++;
    80006728:	fe843783          	ld	a5,-24(s0)
    8000672c:	43dc                	lw	a5,4(a5)
    8000672e:	2785                	addiw	a5,a5,1
    80006730:	0007871b          	sext.w	a4,a5
    80006734:	fe843783          	ld	a5,-24(s0)
    80006738:	c3d8                	sw	a4,4(a5)
  release(&ftable.lock);
    8000673a:	00020517          	auipc	a0,0x20
    8000673e:	a7650513          	addi	a0,a0,-1418 # 800261b0 <ftable>
    80006742:	ffffb097          	auipc	ra,0xffffb
    80006746:	ba0080e7          	jalr	-1120(ra) # 800012e2 <release>
  return f;
    8000674a:	fe843783          	ld	a5,-24(s0)
}
    8000674e:	853e                	mv	a0,a5
    80006750:	60e2                	ld	ra,24(sp)
    80006752:	6442                	ld	s0,16(sp)
    80006754:	6105                	addi	sp,sp,32
    80006756:	8082                	ret

0000000080006758 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80006758:	715d                	addi	sp,sp,-80
    8000675a:	e486                	sd	ra,72(sp)
    8000675c:	e0a2                	sd	s0,64(sp)
    8000675e:	0880                	addi	s0,sp,80
    80006760:	faa43c23          	sd	a0,-72(s0)
  struct file ff;

  acquire(&ftable.lock);
    80006764:	00020517          	auipc	a0,0x20
    80006768:	a4c50513          	addi	a0,a0,-1460 # 800261b0 <ftable>
    8000676c:	ffffb097          	auipc	ra,0xffffb
    80006770:	b12080e7          	jalr	-1262(ra) # 8000127e <acquire>
  if(f->ref < 1)
    80006774:	fb843783          	ld	a5,-72(s0)
    80006778:	43dc                	lw	a5,4(a5)
    8000677a:	00f04a63          	bgtz	a5,8000678e <fileclose+0x36>
    panic("fileclose");
    8000677e:	00005517          	auipc	a0,0x5
    80006782:	e3250513          	addi	a0,a0,-462 # 8000b5b0 <etext+0x5b0>
    80006786:	ffffa097          	auipc	ra,0xffffa
    8000678a:	504080e7          	jalr	1284(ra) # 80000c8a <panic>
  if(--f->ref > 0){
    8000678e:	fb843783          	ld	a5,-72(s0)
    80006792:	43dc                	lw	a5,4(a5)
    80006794:	37fd                	addiw	a5,a5,-1
    80006796:	0007871b          	sext.w	a4,a5
    8000679a:	fb843783          	ld	a5,-72(s0)
    8000679e:	c3d8                	sw	a4,4(a5)
    800067a0:	fb843783          	ld	a5,-72(s0)
    800067a4:	43dc                	lw	a5,4(a5)
    800067a6:	00f05b63          	blez	a5,800067bc <fileclose+0x64>
    release(&ftable.lock);
    800067aa:	00020517          	auipc	a0,0x20
    800067ae:	a0650513          	addi	a0,a0,-1530 # 800261b0 <ftable>
    800067b2:	ffffb097          	auipc	ra,0xffffb
    800067b6:	b30080e7          	jalr	-1232(ra) # 800012e2 <release>
    800067ba:	a879                	j	80006858 <fileclose+0x100>
    return;
  }
  ff = *f;
    800067bc:	fb843783          	ld	a5,-72(s0)
    800067c0:	638c                	ld	a1,0(a5)
    800067c2:	6790                	ld	a2,8(a5)
    800067c4:	6b94                	ld	a3,16(a5)
    800067c6:	6f98                	ld	a4,24(a5)
    800067c8:	739c                	ld	a5,32(a5)
    800067ca:	fcb43423          	sd	a1,-56(s0)
    800067ce:	fcc43823          	sd	a2,-48(s0)
    800067d2:	fcd43c23          	sd	a3,-40(s0)
    800067d6:	fee43023          	sd	a4,-32(s0)
    800067da:	fef43423          	sd	a5,-24(s0)
  f->ref = 0;
    800067de:	fb843783          	ld	a5,-72(s0)
    800067e2:	0007a223          	sw	zero,4(a5)
  f->type = FD_NONE;
    800067e6:	fb843783          	ld	a5,-72(s0)
    800067ea:	0007a023          	sw	zero,0(a5)
  release(&ftable.lock);
    800067ee:	00020517          	auipc	a0,0x20
    800067f2:	9c250513          	addi	a0,a0,-1598 # 800261b0 <ftable>
    800067f6:	ffffb097          	auipc	ra,0xffffb
    800067fa:	aec080e7          	jalr	-1300(ra) # 800012e2 <release>

  if(ff.type == FD_PIPE){
    800067fe:	fc842783          	lw	a5,-56(s0)
    80006802:	873e                	mv	a4,a5
    80006804:	4785                	li	a5,1
    80006806:	00f71e63          	bne	a4,a5,80006822 <fileclose+0xca>
    pipeclose(ff.pipe, ff.writable);
    8000680a:	fd843783          	ld	a5,-40(s0)
    8000680e:	fd144703          	lbu	a4,-47(s0)
    80006812:	2701                	sext.w	a4,a4
    80006814:	85ba                	mv	a1,a4
    80006816:	853e                	mv	a0,a5
    80006818:	00000097          	auipc	ra,0x0
    8000681c:	5a6080e7          	jalr	1446(ra) # 80006dbe <pipeclose>
    80006820:	a825                	j	80006858 <fileclose+0x100>
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80006822:	fc842783          	lw	a5,-56(s0)
    80006826:	873e                	mv	a4,a5
    80006828:	4789                	li	a5,2
    8000682a:	00f70863          	beq	a4,a5,8000683a <fileclose+0xe2>
    8000682e:	fc842783          	lw	a5,-56(s0)
    80006832:	873e                	mv	a4,a5
    80006834:	478d                	li	a5,3
    80006836:	02f71163          	bne	a4,a5,80006858 <fileclose+0x100>
    begin_op();
    8000683a:	00000097          	auipc	ra,0x0
    8000683e:	884080e7          	jalr	-1916(ra) # 800060be <begin_op>
    iput(ff.ip);
    80006842:	fe043783          	ld	a5,-32(s0)
    80006846:	853e                	mv	a0,a5
    80006848:	fffff097          	auipc	ra,0xfffff
    8000684c:	970080e7          	jalr	-1680(ra) # 800051b8 <iput>
    end_op();
    80006850:	00000097          	auipc	ra,0x0
    80006854:	930080e7          	jalr	-1744(ra) # 80006180 <end_op>
  }
}
    80006858:	60a6                	ld	ra,72(sp)
    8000685a:	6406                	ld	s0,64(sp)
    8000685c:	6161                	addi	sp,sp,80
    8000685e:	8082                	ret

0000000080006860 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80006860:	7139                	addi	sp,sp,-64
    80006862:	fc06                	sd	ra,56(sp)
    80006864:	f822                	sd	s0,48(sp)
    80006866:	0080                	addi	s0,sp,64
    80006868:	fca43423          	sd	a0,-56(s0)
    8000686c:	fcb43023          	sd	a1,-64(s0)
  struct proc *p = myproc();
    80006870:	ffffc097          	auipc	ra,0xffffc
    80006874:	fd6080e7          	jalr	-42(ra) # 80002846 <myproc>
    80006878:	fea43423          	sd	a0,-24(s0)
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000687c:	fc843783          	ld	a5,-56(s0)
    80006880:	439c                	lw	a5,0(a5)
    80006882:	873e                	mv	a4,a5
    80006884:	4789                	li	a5,2
    80006886:	00f70963          	beq	a4,a5,80006898 <filestat+0x38>
    8000688a:	fc843783          	ld	a5,-56(s0)
    8000688e:	439c                	lw	a5,0(a5)
    80006890:	873e                	mv	a4,a5
    80006892:	478d                	li	a5,3
    80006894:	06f71263          	bne	a4,a5,800068f8 <filestat+0x98>
    ilock(f->ip);
    80006898:	fc843783          	ld	a5,-56(s0)
    8000689c:	6f9c                	ld	a5,24(a5)
    8000689e:	853e                	mv	a0,a5
    800068a0:	ffffe097          	auipc	ra,0xffffe
    800068a4:	78a080e7          	jalr	1930(ra) # 8000502a <ilock>
    stati(f->ip, &st);
    800068a8:	fc843783          	ld	a5,-56(s0)
    800068ac:	6f9c                	ld	a5,24(a5)
    800068ae:	fd040713          	addi	a4,s0,-48
    800068b2:	85ba                	mv	a1,a4
    800068b4:	853e                	mv	a0,a5
    800068b6:	fffff097          	auipc	ra,0xfffff
    800068ba:	cc6080e7          	jalr	-826(ra) # 8000557c <stati>
    iunlock(f->ip);
    800068be:	fc843783          	ld	a5,-56(s0)
    800068c2:	6f9c                	ld	a5,24(a5)
    800068c4:	853e                	mv	a0,a5
    800068c6:	fffff097          	auipc	ra,0xfffff
    800068ca:	898080e7          	jalr	-1896(ra) # 8000515e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800068ce:	fe843783          	ld	a5,-24(s0)
    800068d2:	6bbc                	ld	a5,80(a5)
    800068d4:	fd040713          	addi	a4,s0,-48
    800068d8:	46e1                	li	a3,24
    800068da:	863a                	mv	a2,a4
    800068dc:	fc043583          	ld	a1,-64(s0)
    800068e0:	853e                	mv	a0,a5
    800068e2:	ffffc097          	auipc	ra,0xffffc
    800068e6:	a2e080e7          	jalr	-1490(ra) # 80002310 <copyout>
    800068ea:	87aa                	mv	a5,a0
    800068ec:	0007d463          	bgez	a5,800068f4 <filestat+0x94>
      return -1;
    800068f0:	57fd                	li	a5,-1
    800068f2:	a021                	j	800068fa <filestat+0x9a>
    return 0;
    800068f4:	4781                	li	a5,0
    800068f6:	a011                	j	800068fa <filestat+0x9a>
  }
  return -1;
    800068f8:	57fd                	li	a5,-1
}
    800068fa:	853e                	mv	a0,a5
    800068fc:	70e2                	ld	ra,56(sp)
    800068fe:	7442                	ld	s0,48(sp)
    80006900:	6121                	addi	sp,sp,64
    80006902:	8082                	ret

0000000080006904 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80006904:	7139                	addi	sp,sp,-64
    80006906:	fc06                	sd	ra,56(sp)
    80006908:	f822                	sd	s0,48(sp)
    8000690a:	0080                	addi	s0,sp,64
    8000690c:	fca43c23          	sd	a0,-40(s0)
    80006910:	fcb43823          	sd	a1,-48(s0)
    80006914:	87b2                	mv	a5,a2
    80006916:	fcf42623          	sw	a5,-52(s0)
  int r = 0;
    8000691a:	fe042623          	sw	zero,-20(s0)

  if(f->readable == 0)
    8000691e:	fd843783          	ld	a5,-40(s0)
    80006922:	0087c783          	lbu	a5,8(a5)
    80006926:	e399                	bnez	a5,8000692c <fileread+0x28>
    return -1;
    80006928:	57fd                	li	a5,-1
    8000692a:	a23d                	j	80006a58 <fileread+0x154>

  if(f->type == FD_PIPE){
    8000692c:	fd843783          	ld	a5,-40(s0)
    80006930:	439c                	lw	a5,0(a5)
    80006932:	873e                	mv	a4,a5
    80006934:	4785                	li	a5,1
    80006936:	02f71363          	bne	a4,a5,8000695c <fileread+0x58>
    r = piperead(f->pipe, addr, n);
    8000693a:	fd843783          	ld	a5,-40(s0)
    8000693e:	6b9c                	ld	a5,16(a5)
    80006940:	fcc42703          	lw	a4,-52(s0)
    80006944:	863a                	mv	a2,a4
    80006946:	fd043583          	ld	a1,-48(s0)
    8000694a:	853e                	mv	a0,a5
    8000694c:	00000097          	auipc	ra,0x0
    80006950:	66e080e7          	jalr	1646(ra) # 80006fba <piperead>
    80006954:	87aa                	mv	a5,a0
    80006956:	fef42623          	sw	a5,-20(s0)
    8000695a:	a8ed                	j	80006a54 <fileread+0x150>
  } else if(f->type == FD_DEVICE){
    8000695c:	fd843783          	ld	a5,-40(s0)
    80006960:	439c                	lw	a5,0(a5)
    80006962:	873e                	mv	a4,a5
    80006964:	478d                	li	a5,3
    80006966:	06f71463          	bne	a4,a5,800069ce <fileread+0xca>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000696a:	fd843783          	ld	a5,-40(s0)
    8000696e:	02479783          	lh	a5,36(a5)
    80006972:	0207c663          	bltz	a5,8000699e <fileread+0x9a>
    80006976:	fd843783          	ld	a5,-40(s0)
    8000697a:	02479783          	lh	a5,36(a5)
    8000697e:	873e                	mv	a4,a5
    80006980:	47a5                	li	a5,9
    80006982:	00e7ce63          	blt	a5,a4,8000699e <fileread+0x9a>
    80006986:	fd843783          	ld	a5,-40(s0)
    8000698a:	02479783          	lh	a5,36(a5)
    8000698e:	0001f717          	auipc	a4,0x1f
    80006992:	78270713          	addi	a4,a4,1922 # 80026110 <devsw>
    80006996:	0792                	slli	a5,a5,0x4
    80006998:	97ba                	add	a5,a5,a4
    8000699a:	639c                	ld	a5,0(a5)
    8000699c:	e399                	bnez	a5,800069a2 <fileread+0x9e>
      return -1;
    8000699e:	57fd                	li	a5,-1
    800069a0:	a865                	j	80006a58 <fileread+0x154>
    r = devsw[f->major].read(1, addr, n);
    800069a2:	fd843783          	ld	a5,-40(s0)
    800069a6:	02479783          	lh	a5,36(a5)
    800069aa:	0001f717          	auipc	a4,0x1f
    800069ae:	76670713          	addi	a4,a4,1894 # 80026110 <devsw>
    800069b2:	0792                	slli	a5,a5,0x4
    800069b4:	97ba                	add	a5,a5,a4
    800069b6:	639c                	ld	a5,0(a5)
    800069b8:	fcc42703          	lw	a4,-52(s0)
    800069bc:	863a                	mv	a2,a4
    800069be:	fd043583          	ld	a1,-48(s0)
    800069c2:	4505                	li	a0,1
    800069c4:	9782                	jalr	a5
    800069c6:	87aa                	mv	a5,a0
    800069c8:	fef42623          	sw	a5,-20(s0)
    800069cc:	a061                	j	80006a54 <fileread+0x150>
  } else if(f->type == FD_INODE){
    800069ce:	fd843783          	ld	a5,-40(s0)
    800069d2:	439c                	lw	a5,0(a5)
    800069d4:	873e                	mv	a4,a5
    800069d6:	4789                	li	a5,2
    800069d8:	06f71663          	bne	a4,a5,80006a44 <fileread+0x140>
    ilock(f->ip);
    800069dc:	fd843783          	ld	a5,-40(s0)
    800069e0:	6f9c                	ld	a5,24(a5)
    800069e2:	853e                	mv	a0,a5
    800069e4:	ffffe097          	auipc	ra,0xffffe
    800069e8:	646080e7          	jalr	1606(ra) # 8000502a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800069ec:	fd843783          	ld	a5,-40(s0)
    800069f0:	6f88                	ld	a0,24(a5)
    800069f2:	fd843783          	ld	a5,-40(s0)
    800069f6:	539c                	lw	a5,32(a5)
    800069f8:	fcc42703          	lw	a4,-52(s0)
    800069fc:	86be                	mv	a3,a5
    800069fe:	fd043603          	ld	a2,-48(s0)
    80006a02:	4585                	li	a1,1
    80006a04:	fffff097          	auipc	ra,0xfffff
    80006a08:	bdc080e7          	jalr	-1060(ra) # 800055e0 <readi>
    80006a0c:	87aa                	mv	a5,a0
    80006a0e:	fef42623          	sw	a5,-20(s0)
    80006a12:	fec42783          	lw	a5,-20(s0)
    80006a16:	2781                	sext.w	a5,a5
    80006a18:	00f05d63          	blez	a5,80006a32 <fileread+0x12e>
      f->off += r;
    80006a1c:	fd843783          	ld	a5,-40(s0)
    80006a20:	5398                	lw	a4,32(a5)
    80006a22:	fec42783          	lw	a5,-20(s0)
    80006a26:	9fb9                	addw	a5,a5,a4
    80006a28:	0007871b          	sext.w	a4,a5
    80006a2c:	fd843783          	ld	a5,-40(s0)
    80006a30:	d398                	sw	a4,32(a5)
    iunlock(f->ip);
    80006a32:	fd843783          	ld	a5,-40(s0)
    80006a36:	6f9c                	ld	a5,24(a5)
    80006a38:	853e                	mv	a0,a5
    80006a3a:	ffffe097          	auipc	ra,0xffffe
    80006a3e:	724080e7          	jalr	1828(ra) # 8000515e <iunlock>
    80006a42:	a809                	j	80006a54 <fileread+0x150>
  } else {
    panic("fileread");
    80006a44:	00005517          	auipc	a0,0x5
    80006a48:	b7c50513          	addi	a0,a0,-1156 # 8000b5c0 <etext+0x5c0>
    80006a4c:	ffffa097          	auipc	ra,0xffffa
    80006a50:	23e080e7          	jalr	574(ra) # 80000c8a <panic>
  }

  return r;
    80006a54:	fec42783          	lw	a5,-20(s0)
}
    80006a58:	853e                	mv	a0,a5
    80006a5a:	70e2                	ld	ra,56(sp)
    80006a5c:	7442                	ld	s0,48(sp)
    80006a5e:	6121                	addi	sp,sp,64
    80006a60:	8082                	ret

0000000080006a62 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80006a62:	715d                	addi	sp,sp,-80
    80006a64:	e486                	sd	ra,72(sp)
    80006a66:	e0a2                	sd	s0,64(sp)
    80006a68:	0880                	addi	s0,sp,80
    80006a6a:	fca43423          	sd	a0,-56(s0)
    80006a6e:	fcb43023          	sd	a1,-64(s0)
    80006a72:	87b2                	mv	a5,a2
    80006a74:	faf42e23          	sw	a5,-68(s0)
  int r, ret = 0;
    80006a78:	fe042623          	sw	zero,-20(s0)

  if(f->writable == 0)
    80006a7c:	fc843783          	ld	a5,-56(s0)
    80006a80:	0097c783          	lbu	a5,9(a5)
    80006a84:	e399                	bnez	a5,80006a8a <filewrite+0x28>
    return -1;
    80006a86:	57fd                	li	a5,-1
    80006a88:	aae1                	j	80006c60 <filewrite+0x1fe>

  if(f->type == FD_PIPE){
    80006a8a:	fc843783          	ld	a5,-56(s0)
    80006a8e:	439c                	lw	a5,0(a5)
    80006a90:	873e                	mv	a4,a5
    80006a92:	4785                	li	a5,1
    80006a94:	02f71363          	bne	a4,a5,80006aba <filewrite+0x58>
    ret = pipewrite(f->pipe, addr, n);
    80006a98:	fc843783          	ld	a5,-56(s0)
    80006a9c:	6b9c                	ld	a5,16(a5)
    80006a9e:	fbc42703          	lw	a4,-68(s0)
    80006aa2:	863a                	mv	a2,a4
    80006aa4:	fc043583          	ld	a1,-64(s0)
    80006aa8:	853e                	mv	a0,a5
    80006aaa:	00000097          	auipc	ra,0x0
    80006aae:	3bc080e7          	jalr	956(ra) # 80006e66 <pipewrite>
    80006ab2:	87aa                	mv	a5,a0
    80006ab4:	fef42623          	sw	a5,-20(s0)
    80006ab8:	a255                	j	80006c5c <filewrite+0x1fa>
  } else if(f->type == FD_DEVICE){
    80006aba:	fc843783          	ld	a5,-56(s0)
    80006abe:	439c                	lw	a5,0(a5)
    80006ac0:	873e                	mv	a4,a5
    80006ac2:	478d                	li	a5,3
    80006ac4:	06f71463          	bne	a4,a5,80006b2c <filewrite+0xca>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80006ac8:	fc843783          	ld	a5,-56(s0)
    80006acc:	02479783          	lh	a5,36(a5)
    80006ad0:	0207c663          	bltz	a5,80006afc <filewrite+0x9a>
    80006ad4:	fc843783          	ld	a5,-56(s0)
    80006ad8:	02479783          	lh	a5,36(a5)
    80006adc:	873e                	mv	a4,a5
    80006ade:	47a5                	li	a5,9
    80006ae0:	00e7ce63          	blt	a5,a4,80006afc <filewrite+0x9a>
    80006ae4:	fc843783          	ld	a5,-56(s0)
    80006ae8:	02479783          	lh	a5,36(a5)
    80006aec:	0001f717          	auipc	a4,0x1f
    80006af0:	62470713          	addi	a4,a4,1572 # 80026110 <devsw>
    80006af4:	0792                	slli	a5,a5,0x4
    80006af6:	97ba                	add	a5,a5,a4
    80006af8:	679c                	ld	a5,8(a5)
    80006afa:	e399                	bnez	a5,80006b00 <filewrite+0x9e>
      return -1;
    80006afc:	57fd                	li	a5,-1
    80006afe:	a28d                	j	80006c60 <filewrite+0x1fe>
    ret = devsw[f->major].write(1, addr, n);
    80006b00:	fc843783          	ld	a5,-56(s0)
    80006b04:	02479783          	lh	a5,36(a5)
    80006b08:	0001f717          	auipc	a4,0x1f
    80006b0c:	60870713          	addi	a4,a4,1544 # 80026110 <devsw>
    80006b10:	0792                	slli	a5,a5,0x4
    80006b12:	97ba                	add	a5,a5,a4
    80006b14:	679c                	ld	a5,8(a5)
    80006b16:	fbc42703          	lw	a4,-68(s0)
    80006b1a:	863a                	mv	a2,a4
    80006b1c:	fc043583          	ld	a1,-64(s0)
    80006b20:	4505                	li	a0,1
    80006b22:	9782                	jalr	a5
    80006b24:	87aa                	mv	a5,a0
    80006b26:	fef42623          	sw	a5,-20(s0)
    80006b2a:	aa0d                	j	80006c5c <filewrite+0x1fa>
  } else if(f->type == FD_INODE){
    80006b2c:	fc843783          	ld	a5,-56(s0)
    80006b30:	439c                	lw	a5,0(a5)
    80006b32:	873e                	mv	a4,a5
    80006b34:	4789                	li	a5,2
    80006b36:	10f71b63          	bne	a4,a5,80006c4c <filewrite+0x1ea>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    80006b3a:	6785                	lui	a5,0x1
    80006b3c:	c0078793          	addi	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80006b40:	fef42023          	sw	a5,-32(s0)
    int i = 0;
    80006b44:	fe042423          	sw	zero,-24(s0)
    while(i < n){
    80006b48:	a0f9                	j	80006c16 <filewrite+0x1b4>
      int n1 = n - i;
    80006b4a:	fbc42783          	lw	a5,-68(s0)
    80006b4e:	873e                	mv	a4,a5
    80006b50:	fe842783          	lw	a5,-24(s0)
    80006b54:	40f707bb          	subw	a5,a4,a5
    80006b58:	fef42223          	sw	a5,-28(s0)
      if(n1 > max)
    80006b5c:	fe442783          	lw	a5,-28(s0)
    80006b60:	873e                	mv	a4,a5
    80006b62:	fe042783          	lw	a5,-32(s0)
    80006b66:	2701                	sext.w	a4,a4
    80006b68:	2781                	sext.w	a5,a5
    80006b6a:	00e7d663          	bge	a5,a4,80006b76 <filewrite+0x114>
        n1 = max;
    80006b6e:	fe042783          	lw	a5,-32(s0)
    80006b72:	fef42223          	sw	a5,-28(s0)

      begin_op();
    80006b76:	fffff097          	auipc	ra,0xfffff
    80006b7a:	548080e7          	jalr	1352(ra) # 800060be <begin_op>
      ilock(f->ip);
    80006b7e:	fc843783          	ld	a5,-56(s0)
    80006b82:	6f9c                	ld	a5,24(a5)
    80006b84:	853e                	mv	a0,a5
    80006b86:	ffffe097          	auipc	ra,0xffffe
    80006b8a:	4a4080e7          	jalr	1188(ra) # 8000502a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80006b8e:	fc843783          	ld	a5,-56(s0)
    80006b92:	6f88                	ld	a0,24(a5)
    80006b94:	fe842703          	lw	a4,-24(s0)
    80006b98:	fc043783          	ld	a5,-64(s0)
    80006b9c:	00f70633          	add	a2,a4,a5
    80006ba0:	fc843783          	ld	a5,-56(s0)
    80006ba4:	539c                	lw	a5,32(a5)
    80006ba6:	fe442703          	lw	a4,-28(s0)
    80006baa:	86be                	mv	a3,a5
    80006bac:	4585                	li	a1,1
    80006bae:	fffff097          	auipc	ra,0xfffff
    80006bb2:	bd0080e7          	jalr	-1072(ra) # 8000577e <writei>
    80006bb6:	87aa                	mv	a5,a0
    80006bb8:	fcf42e23          	sw	a5,-36(s0)
    80006bbc:	fdc42783          	lw	a5,-36(s0)
    80006bc0:	2781                	sext.w	a5,a5
    80006bc2:	00f05d63          	blez	a5,80006bdc <filewrite+0x17a>
        f->off += r;
    80006bc6:	fc843783          	ld	a5,-56(s0)
    80006bca:	5398                	lw	a4,32(a5)
    80006bcc:	fdc42783          	lw	a5,-36(s0)
    80006bd0:	9fb9                	addw	a5,a5,a4
    80006bd2:	0007871b          	sext.w	a4,a5
    80006bd6:	fc843783          	ld	a5,-56(s0)
    80006bda:	d398                	sw	a4,32(a5)
      iunlock(f->ip);
    80006bdc:	fc843783          	ld	a5,-56(s0)
    80006be0:	6f9c                	ld	a5,24(a5)
    80006be2:	853e                	mv	a0,a5
    80006be4:	ffffe097          	auipc	ra,0xffffe
    80006be8:	57a080e7          	jalr	1402(ra) # 8000515e <iunlock>
      end_op();
    80006bec:	fffff097          	auipc	ra,0xfffff
    80006bf0:	594080e7          	jalr	1428(ra) # 80006180 <end_op>

      if(r != n1){
    80006bf4:	fdc42783          	lw	a5,-36(s0)
    80006bf8:	873e                	mv	a4,a5
    80006bfa:	fe442783          	lw	a5,-28(s0)
    80006bfe:	2701                	sext.w	a4,a4
    80006c00:	2781                	sext.w	a5,a5
    80006c02:	02f71463          	bne	a4,a5,80006c2a <filewrite+0x1c8>
        // error from writei
        break;
      }
      i += r;
    80006c06:	fe842783          	lw	a5,-24(s0)
    80006c0a:	873e                	mv	a4,a5
    80006c0c:	fdc42783          	lw	a5,-36(s0)
    80006c10:	9fb9                	addw	a5,a5,a4
    80006c12:	fef42423          	sw	a5,-24(s0)
    while(i < n){
    80006c16:	fe842783          	lw	a5,-24(s0)
    80006c1a:	873e                	mv	a4,a5
    80006c1c:	fbc42783          	lw	a5,-68(s0)
    80006c20:	2701                	sext.w	a4,a4
    80006c22:	2781                	sext.w	a5,a5
    80006c24:	f2f743e3          	blt	a4,a5,80006b4a <filewrite+0xe8>
    80006c28:	a011                	j	80006c2c <filewrite+0x1ca>
        break;
    80006c2a:	0001                	nop
    }
    ret = (i == n ? n : -1);
    80006c2c:	fe842783          	lw	a5,-24(s0)
    80006c30:	873e                	mv	a4,a5
    80006c32:	fbc42783          	lw	a5,-68(s0)
    80006c36:	2701                	sext.w	a4,a4
    80006c38:	2781                	sext.w	a5,a5
    80006c3a:	00f71563          	bne	a4,a5,80006c44 <filewrite+0x1e2>
    80006c3e:	fbc42783          	lw	a5,-68(s0)
    80006c42:	a011                	j	80006c46 <filewrite+0x1e4>
    80006c44:	57fd                	li	a5,-1
    80006c46:	fef42623          	sw	a5,-20(s0)
    80006c4a:	a809                	j	80006c5c <filewrite+0x1fa>
  } else {
    panic("filewrite");
    80006c4c:	00005517          	auipc	a0,0x5
    80006c50:	98450513          	addi	a0,a0,-1660 # 8000b5d0 <etext+0x5d0>
    80006c54:	ffffa097          	auipc	ra,0xffffa
    80006c58:	036080e7          	jalr	54(ra) # 80000c8a <panic>
  }

  return ret;
    80006c5c:	fec42783          	lw	a5,-20(s0)
}
    80006c60:	853e                	mv	a0,a5
    80006c62:	60a6                	ld	ra,72(sp)
    80006c64:	6406                	ld	s0,64(sp)
    80006c66:	6161                	addi	sp,sp,80
    80006c68:	8082                	ret

0000000080006c6a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80006c6a:	7179                	addi	sp,sp,-48
    80006c6c:	f406                	sd	ra,40(sp)
    80006c6e:	f022                	sd	s0,32(sp)
    80006c70:	1800                	addi	s0,sp,48
    80006c72:	fca43c23          	sd	a0,-40(s0)
    80006c76:	fcb43823          	sd	a1,-48(s0)
  struct pipe *pi;

  pi = 0;
    80006c7a:	fe043423          	sd	zero,-24(s0)
  *f0 = *f1 = 0;
    80006c7e:	fd043783          	ld	a5,-48(s0)
    80006c82:	0007b023          	sd	zero,0(a5)
    80006c86:	fd043783          	ld	a5,-48(s0)
    80006c8a:	6398                	ld	a4,0(a5)
    80006c8c:	fd843783          	ld	a5,-40(s0)
    80006c90:	e398                	sd	a4,0(a5)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80006c92:	00000097          	auipc	ra,0x0
    80006c96:	9dc080e7          	jalr	-1572(ra) # 8000666e <filealloc>
    80006c9a:	872a                	mv	a4,a0
    80006c9c:	fd843783          	ld	a5,-40(s0)
    80006ca0:	e398                	sd	a4,0(a5)
    80006ca2:	fd843783          	ld	a5,-40(s0)
    80006ca6:	639c                	ld	a5,0(a5)
    80006ca8:	c3e9                	beqz	a5,80006d6a <pipealloc+0x100>
    80006caa:	00000097          	auipc	ra,0x0
    80006cae:	9c4080e7          	jalr	-1596(ra) # 8000666e <filealloc>
    80006cb2:	872a                	mv	a4,a0
    80006cb4:	fd043783          	ld	a5,-48(s0)
    80006cb8:	e398                	sd	a4,0(a5)
    80006cba:	fd043783          	ld	a5,-48(s0)
    80006cbe:	639c                	ld	a5,0(a5)
    80006cc0:	c7cd                	beqz	a5,80006d6a <pipealloc+0x100>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80006cc2:	ffffa097          	auipc	ra,0xffffa
    80006cc6:	468080e7          	jalr	1128(ra) # 8000112a <kalloc>
    80006cca:	fea43423          	sd	a0,-24(s0)
    80006cce:	fe843783          	ld	a5,-24(s0)
    80006cd2:	cfd1                	beqz	a5,80006d6e <pipealloc+0x104>
    goto bad;
  pi->readopen = 1;
    80006cd4:	fe843783          	ld	a5,-24(s0)
    80006cd8:	4705                	li	a4,1
    80006cda:	22e7a023          	sw	a4,544(a5)
  pi->writeopen = 1;
    80006cde:	fe843783          	ld	a5,-24(s0)
    80006ce2:	4705                	li	a4,1
    80006ce4:	22e7a223          	sw	a4,548(a5)
  pi->nwrite = 0;
    80006ce8:	fe843783          	ld	a5,-24(s0)
    80006cec:	2007ae23          	sw	zero,540(a5)
  pi->nread = 0;
    80006cf0:	fe843783          	ld	a5,-24(s0)
    80006cf4:	2007ac23          	sw	zero,536(a5)
  initlock(&pi->lock, "pipe");
    80006cf8:	fe843783          	ld	a5,-24(s0)
    80006cfc:	00005597          	auipc	a1,0x5
    80006d00:	8e458593          	addi	a1,a1,-1820 # 8000b5e0 <etext+0x5e0>
    80006d04:	853e                	mv	a0,a5
    80006d06:	ffffa097          	auipc	ra,0xffffa
    80006d0a:	548080e7          	jalr	1352(ra) # 8000124e <initlock>
  (*f0)->type = FD_PIPE;
    80006d0e:	fd843783          	ld	a5,-40(s0)
    80006d12:	639c                	ld	a5,0(a5)
    80006d14:	4705                	li	a4,1
    80006d16:	c398                	sw	a4,0(a5)
  (*f0)->readable = 1;
    80006d18:	fd843783          	ld	a5,-40(s0)
    80006d1c:	639c                	ld	a5,0(a5)
    80006d1e:	4705                	li	a4,1
    80006d20:	00e78423          	sb	a4,8(a5)
  (*f0)->writable = 0;
    80006d24:	fd843783          	ld	a5,-40(s0)
    80006d28:	639c                	ld	a5,0(a5)
    80006d2a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80006d2e:	fd843783          	ld	a5,-40(s0)
    80006d32:	639c                	ld	a5,0(a5)
    80006d34:	fe843703          	ld	a4,-24(s0)
    80006d38:	eb98                	sd	a4,16(a5)
  (*f1)->type = FD_PIPE;
    80006d3a:	fd043783          	ld	a5,-48(s0)
    80006d3e:	639c                	ld	a5,0(a5)
    80006d40:	4705                	li	a4,1
    80006d42:	c398                	sw	a4,0(a5)
  (*f1)->readable = 0;
    80006d44:	fd043783          	ld	a5,-48(s0)
    80006d48:	639c                	ld	a5,0(a5)
    80006d4a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80006d4e:	fd043783          	ld	a5,-48(s0)
    80006d52:	639c                	ld	a5,0(a5)
    80006d54:	4705                	li	a4,1
    80006d56:	00e784a3          	sb	a4,9(a5)
  (*f1)->pipe = pi;
    80006d5a:	fd043783          	ld	a5,-48(s0)
    80006d5e:	639c                	ld	a5,0(a5)
    80006d60:	fe843703          	ld	a4,-24(s0)
    80006d64:	eb98                	sd	a4,16(a5)
  return 0;
    80006d66:	4781                	li	a5,0
    80006d68:	a0b1                	j	80006db4 <pipealloc+0x14a>
    goto bad;
    80006d6a:	0001                	nop
    80006d6c:	a011                	j	80006d70 <pipealloc+0x106>
    goto bad;
    80006d6e:	0001                	nop

 bad:
  if(pi)
    80006d70:	fe843783          	ld	a5,-24(s0)
    80006d74:	c799                	beqz	a5,80006d82 <pipealloc+0x118>
    kfree((char*)pi);
    80006d76:	fe843503          	ld	a0,-24(s0)
    80006d7a:	ffffa097          	auipc	ra,0xffffa
    80006d7e:	30c080e7          	jalr	780(ra) # 80001086 <kfree>
  if(*f0)
    80006d82:	fd843783          	ld	a5,-40(s0)
    80006d86:	639c                	ld	a5,0(a5)
    80006d88:	cb89                	beqz	a5,80006d9a <pipealloc+0x130>
    fileclose(*f0);
    80006d8a:	fd843783          	ld	a5,-40(s0)
    80006d8e:	639c                	ld	a5,0(a5)
    80006d90:	853e                	mv	a0,a5
    80006d92:	00000097          	auipc	ra,0x0
    80006d96:	9c6080e7          	jalr	-1594(ra) # 80006758 <fileclose>
  if(*f1)
    80006d9a:	fd043783          	ld	a5,-48(s0)
    80006d9e:	639c                	ld	a5,0(a5)
    80006da0:	cb89                	beqz	a5,80006db2 <pipealloc+0x148>
    fileclose(*f1);
    80006da2:	fd043783          	ld	a5,-48(s0)
    80006da6:	639c                	ld	a5,0(a5)
    80006da8:	853e                	mv	a0,a5
    80006daa:	00000097          	auipc	ra,0x0
    80006dae:	9ae080e7          	jalr	-1618(ra) # 80006758 <fileclose>
  return -1;
    80006db2:	57fd                	li	a5,-1
}
    80006db4:	853e                	mv	a0,a5
    80006db6:	70a2                	ld	ra,40(sp)
    80006db8:	7402                	ld	s0,32(sp)
    80006dba:	6145                	addi	sp,sp,48
    80006dbc:	8082                	ret

0000000080006dbe <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80006dbe:	1101                	addi	sp,sp,-32
    80006dc0:	ec06                	sd	ra,24(sp)
    80006dc2:	e822                	sd	s0,16(sp)
    80006dc4:	1000                	addi	s0,sp,32
    80006dc6:	fea43423          	sd	a0,-24(s0)
    80006dca:	87ae                	mv	a5,a1
    80006dcc:	fef42223          	sw	a5,-28(s0)
  acquire(&pi->lock);
    80006dd0:	fe843783          	ld	a5,-24(s0)
    80006dd4:	853e                	mv	a0,a5
    80006dd6:	ffffa097          	auipc	ra,0xffffa
    80006dda:	4a8080e7          	jalr	1192(ra) # 8000127e <acquire>
  if(writable){
    80006dde:	fe442783          	lw	a5,-28(s0)
    80006de2:	2781                	sext.w	a5,a5
    80006de4:	cf99                	beqz	a5,80006e02 <pipeclose+0x44>
    pi->writeopen = 0;
    80006de6:	fe843783          	ld	a5,-24(s0)
    80006dea:	2207a223          	sw	zero,548(a5)
    wakeup(&pi->nread);
    80006dee:	fe843783          	ld	a5,-24(s0)
    80006df2:	21878793          	addi	a5,a5,536
    80006df6:	853e                	mv	a0,a5
    80006df8:	ffffc097          	auipc	ra,0xffffc
    80006dfc:	68c080e7          	jalr	1676(ra) # 80003484 <wakeup>
    80006e00:	a831                	j	80006e1c <pipeclose+0x5e>
  } else {
    pi->readopen = 0;
    80006e02:	fe843783          	ld	a5,-24(s0)
    80006e06:	2207a023          	sw	zero,544(a5)
    wakeup(&pi->nwrite);
    80006e0a:	fe843783          	ld	a5,-24(s0)
    80006e0e:	21c78793          	addi	a5,a5,540
    80006e12:	853e                	mv	a0,a5
    80006e14:	ffffc097          	auipc	ra,0xffffc
    80006e18:	670080e7          	jalr	1648(ra) # 80003484 <wakeup>
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80006e1c:	fe843783          	ld	a5,-24(s0)
    80006e20:	2207a783          	lw	a5,544(a5)
    80006e24:	e785                	bnez	a5,80006e4c <pipeclose+0x8e>
    80006e26:	fe843783          	ld	a5,-24(s0)
    80006e2a:	2247a783          	lw	a5,548(a5)
    80006e2e:	ef99                	bnez	a5,80006e4c <pipeclose+0x8e>
    release(&pi->lock);
    80006e30:	fe843783          	ld	a5,-24(s0)
    80006e34:	853e                	mv	a0,a5
    80006e36:	ffffa097          	auipc	ra,0xffffa
    80006e3a:	4ac080e7          	jalr	1196(ra) # 800012e2 <release>
    kfree((char*)pi);
    80006e3e:	fe843503          	ld	a0,-24(s0)
    80006e42:	ffffa097          	auipc	ra,0xffffa
    80006e46:	244080e7          	jalr	580(ra) # 80001086 <kfree>
    80006e4a:	a809                	j	80006e5c <pipeclose+0x9e>
  } else
    release(&pi->lock);
    80006e4c:	fe843783          	ld	a5,-24(s0)
    80006e50:	853e                	mv	a0,a5
    80006e52:	ffffa097          	auipc	ra,0xffffa
    80006e56:	490080e7          	jalr	1168(ra) # 800012e2 <release>
}
    80006e5a:	0001                	nop
    80006e5c:	0001                	nop
    80006e5e:	60e2                	ld	ra,24(sp)
    80006e60:	6442                	ld	s0,16(sp)
    80006e62:	6105                	addi	sp,sp,32
    80006e64:	8082                	ret

0000000080006e66 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80006e66:	715d                	addi	sp,sp,-80
    80006e68:	e486                	sd	ra,72(sp)
    80006e6a:	e0a2                	sd	s0,64(sp)
    80006e6c:	0880                	addi	s0,sp,80
    80006e6e:	fca43423          	sd	a0,-56(s0)
    80006e72:	fcb43023          	sd	a1,-64(s0)
    80006e76:	87b2                	mv	a5,a2
    80006e78:	faf42e23          	sw	a5,-68(s0)
  int i = 0;
    80006e7c:	fe042623          	sw	zero,-20(s0)
  struct proc *pr = myproc();
    80006e80:	ffffc097          	auipc	ra,0xffffc
    80006e84:	9c6080e7          	jalr	-1594(ra) # 80002846 <myproc>
    80006e88:	fea43023          	sd	a0,-32(s0)

  acquire(&pi->lock);
    80006e8c:	fc843783          	ld	a5,-56(s0)
    80006e90:	853e                	mv	a0,a5
    80006e92:	ffffa097          	auipc	ra,0xffffa
    80006e96:	3ec080e7          	jalr	1004(ra) # 8000127e <acquire>
  while(i < n){
    80006e9a:	a8f1                	j	80006f76 <pipewrite+0x110>
    if(pi->readopen == 0 || killed(pr)){
    80006e9c:	fc843783          	ld	a5,-56(s0)
    80006ea0:	2207a783          	lw	a5,544(a5)
    80006ea4:	cb89                	beqz	a5,80006eb6 <pipewrite+0x50>
    80006ea6:	fe043503          	ld	a0,-32(s0)
    80006eaa:	ffffc097          	auipc	ra,0xffffc
    80006eae:	748080e7          	jalr	1864(ra) # 800035f2 <killed>
    80006eb2:	87aa                	mv	a5,a0
    80006eb4:	cb91                	beqz	a5,80006ec8 <pipewrite+0x62>
      release(&pi->lock);
    80006eb6:	fc843783          	ld	a5,-56(s0)
    80006eba:	853e                	mv	a0,a5
    80006ebc:	ffffa097          	auipc	ra,0xffffa
    80006ec0:	426080e7          	jalr	1062(ra) # 800012e2 <release>
      return -1;
    80006ec4:	57fd                	li	a5,-1
    80006ec6:	a0ed                	j	80006fb0 <pipewrite+0x14a>
    }
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80006ec8:	fc843783          	ld	a5,-56(s0)
    80006ecc:	21c7a703          	lw	a4,540(a5)
    80006ed0:	fc843783          	ld	a5,-56(s0)
    80006ed4:	2187a783          	lw	a5,536(a5)
    80006ed8:	2007879b          	addiw	a5,a5,512
    80006edc:	2781                	sext.w	a5,a5
    80006ede:	02f71863          	bne	a4,a5,80006f0e <pipewrite+0xa8>
      wakeup(&pi->nread);
    80006ee2:	fc843783          	ld	a5,-56(s0)
    80006ee6:	21878793          	addi	a5,a5,536
    80006eea:	853e                	mv	a0,a5
    80006eec:	ffffc097          	auipc	ra,0xffffc
    80006ef0:	598080e7          	jalr	1432(ra) # 80003484 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80006ef4:	fc843783          	ld	a5,-56(s0)
    80006ef8:	21c78793          	addi	a5,a5,540
    80006efc:	fc843703          	ld	a4,-56(s0)
    80006f00:	85ba                	mv	a1,a4
    80006f02:	853e                	mv	a0,a5
    80006f04:	ffffc097          	auipc	ra,0xffffc
    80006f08:	504080e7          	jalr	1284(ra) # 80003408 <sleep>
    80006f0c:	a0ad                	j	80006f76 <pipewrite+0x110>
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80006f0e:	fe043783          	ld	a5,-32(s0)
    80006f12:	6ba8                	ld	a0,80(a5)
    80006f14:	fec42703          	lw	a4,-20(s0)
    80006f18:	fc043783          	ld	a5,-64(s0)
    80006f1c:	973e                	add	a4,a4,a5
    80006f1e:	fdf40793          	addi	a5,s0,-33
    80006f22:	4685                	li	a3,1
    80006f24:	863a                	mv	a2,a4
    80006f26:	85be                	mv	a1,a5
    80006f28:	ffffb097          	auipc	ra,0xffffb
    80006f2c:	4b6080e7          	jalr	1206(ra) # 800023de <copyin>
    80006f30:	87aa                	mv	a5,a0
    80006f32:	873e                	mv	a4,a5
    80006f34:	57fd                	li	a5,-1
    80006f36:	04f70a63          	beq	a4,a5,80006f8a <pipewrite+0x124>
        break;
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80006f3a:	fc843783          	ld	a5,-56(s0)
    80006f3e:	21c7a783          	lw	a5,540(a5)
    80006f42:	2781                	sext.w	a5,a5
    80006f44:	0017871b          	addiw	a4,a5,1
    80006f48:	0007069b          	sext.w	a3,a4
    80006f4c:	fc843703          	ld	a4,-56(s0)
    80006f50:	20d72e23          	sw	a3,540(a4)
    80006f54:	1ff7f793          	andi	a5,a5,511
    80006f58:	2781                	sext.w	a5,a5
    80006f5a:	fdf44703          	lbu	a4,-33(s0)
    80006f5e:	fc843683          	ld	a3,-56(s0)
    80006f62:	1782                	slli	a5,a5,0x20
    80006f64:	9381                	srli	a5,a5,0x20
    80006f66:	97b6                	add	a5,a5,a3
    80006f68:	00e78c23          	sb	a4,24(a5)
      i++;
    80006f6c:	fec42783          	lw	a5,-20(s0)
    80006f70:	2785                	addiw	a5,a5,1
    80006f72:	fef42623          	sw	a5,-20(s0)
  while(i < n){
    80006f76:	fec42783          	lw	a5,-20(s0)
    80006f7a:	873e                	mv	a4,a5
    80006f7c:	fbc42783          	lw	a5,-68(s0)
    80006f80:	2701                	sext.w	a4,a4
    80006f82:	2781                	sext.w	a5,a5
    80006f84:	f0f74ce3          	blt	a4,a5,80006e9c <pipewrite+0x36>
    80006f88:	a011                	j	80006f8c <pipewrite+0x126>
        break;
    80006f8a:	0001                	nop
    }
  }
  wakeup(&pi->nread);
    80006f8c:	fc843783          	ld	a5,-56(s0)
    80006f90:	21878793          	addi	a5,a5,536
    80006f94:	853e                	mv	a0,a5
    80006f96:	ffffc097          	auipc	ra,0xffffc
    80006f9a:	4ee080e7          	jalr	1262(ra) # 80003484 <wakeup>
  release(&pi->lock);
    80006f9e:	fc843783          	ld	a5,-56(s0)
    80006fa2:	853e                	mv	a0,a5
    80006fa4:	ffffa097          	auipc	ra,0xffffa
    80006fa8:	33e080e7          	jalr	830(ra) # 800012e2 <release>

  return i;
    80006fac:	fec42783          	lw	a5,-20(s0)
}
    80006fb0:	853e                	mv	a0,a5
    80006fb2:	60a6                	ld	ra,72(sp)
    80006fb4:	6406                	ld	s0,64(sp)
    80006fb6:	6161                	addi	sp,sp,80
    80006fb8:	8082                	ret

0000000080006fba <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80006fba:	715d                	addi	sp,sp,-80
    80006fbc:	e486                	sd	ra,72(sp)
    80006fbe:	e0a2                	sd	s0,64(sp)
    80006fc0:	0880                	addi	s0,sp,80
    80006fc2:	fca43423          	sd	a0,-56(s0)
    80006fc6:	fcb43023          	sd	a1,-64(s0)
    80006fca:	87b2                	mv	a5,a2
    80006fcc:	faf42e23          	sw	a5,-68(s0)
  int i;
  struct proc *pr = myproc();
    80006fd0:	ffffc097          	auipc	ra,0xffffc
    80006fd4:	876080e7          	jalr	-1930(ra) # 80002846 <myproc>
    80006fd8:	fea43023          	sd	a0,-32(s0)
  char ch;

  acquire(&pi->lock);
    80006fdc:	fc843783          	ld	a5,-56(s0)
    80006fe0:	853e                	mv	a0,a5
    80006fe2:	ffffa097          	auipc	ra,0xffffa
    80006fe6:	29c080e7          	jalr	668(ra) # 8000127e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80006fea:	a835                	j	80007026 <piperead+0x6c>
    if(killed(pr)){
    80006fec:	fe043503          	ld	a0,-32(s0)
    80006ff0:	ffffc097          	auipc	ra,0xffffc
    80006ff4:	602080e7          	jalr	1538(ra) # 800035f2 <killed>
    80006ff8:	87aa                	mv	a5,a0
    80006ffa:	cb91                	beqz	a5,8000700e <piperead+0x54>
      release(&pi->lock);
    80006ffc:	fc843783          	ld	a5,-56(s0)
    80007000:	853e                	mv	a0,a5
    80007002:	ffffa097          	auipc	ra,0xffffa
    80007006:	2e0080e7          	jalr	736(ra) # 800012e2 <release>
      return -1;
    8000700a:	57fd                	li	a5,-1
    8000700c:	a8e5                	j	80007104 <piperead+0x14a>
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000700e:	fc843783          	ld	a5,-56(s0)
    80007012:	21878793          	addi	a5,a5,536
    80007016:	fc843703          	ld	a4,-56(s0)
    8000701a:	85ba                	mv	a1,a4
    8000701c:	853e                	mv	a0,a5
    8000701e:	ffffc097          	auipc	ra,0xffffc
    80007022:	3ea080e7          	jalr	1002(ra) # 80003408 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80007026:	fc843783          	ld	a5,-56(s0)
    8000702a:	2187a703          	lw	a4,536(a5)
    8000702e:	fc843783          	ld	a5,-56(s0)
    80007032:	21c7a783          	lw	a5,540(a5)
    80007036:	00f71763          	bne	a4,a5,80007044 <piperead+0x8a>
    8000703a:	fc843783          	ld	a5,-56(s0)
    8000703e:	2247a783          	lw	a5,548(a5)
    80007042:	f7cd                	bnez	a5,80006fec <piperead+0x32>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80007044:	fe042623          	sw	zero,-20(s0)
    80007048:	a8bd                	j	800070c6 <piperead+0x10c>
    if(pi->nread == pi->nwrite)
    8000704a:	fc843783          	ld	a5,-56(s0)
    8000704e:	2187a703          	lw	a4,536(a5)
    80007052:	fc843783          	ld	a5,-56(s0)
    80007056:	21c7a783          	lw	a5,540(a5)
    8000705a:	08f70063          	beq	a4,a5,800070da <piperead+0x120>
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000705e:	fc843783          	ld	a5,-56(s0)
    80007062:	2187a783          	lw	a5,536(a5)
    80007066:	2781                	sext.w	a5,a5
    80007068:	0017871b          	addiw	a4,a5,1
    8000706c:	0007069b          	sext.w	a3,a4
    80007070:	fc843703          	ld	a4,-56(s0)
    80007074:	20d72c23          	sw	a3,536(a4)
    80007078:	1ff7f793          	andi	a5,a5,511
    8000707c:	2781                	sext.w	a5,a5
    8000707e:	fc843703          	ld	a4,-56(s0)
    80007082:	1782                	slli	a5,a5,0x20
    80007084:	9381                	srli	a5,a5,0x20
    80007086:	97ba                	add	a5,a5,a4
    80007088:	0187c783          	lbu	a5,24(a5)
    8000708c:	fcf40fa3          	sb	a5,-33(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80007090:	fe043783          	ld	a5,-32(s0)
    80007094:	6ba8                	ld	a0,80(a5)
    80007096:	fec42703          	lw	a4,-20(s0)
    8000709a:	fc043783          	ld	a5,-64(s0)
    8000709e:	97ba                	add	a5,a5,a4
    800070a0:	fdf40713          	addi	a4,s0,-33
    800070a4:	4685                	li	a3,1
    800070a6:	863a                	mv	a2,a4
    800070a8:	85be                	mv	a1,a5
    800070aa:	ffffb097          	auipc	ra,0xffffb
    800070ae:	266080e7          	jalr	614(ra) # 80002310 <copyout>
    800070b2:	87aa                	mv	a5,a0
    800070b4:	873e                	mv	a4,a5
    800070b6:	57fd                	li	a5,-1
    800070b8:	02f70363          	beq	a4,a5,800070de <piperead+0x124>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800070bc:	fec42783          	lw	a5,-20(s0)
    800070c0:	2785                	addiw	a5,a5,1
    800070c2:	fef42623          	sw	a5,-20(s0)
    800070c6:	fec42783          	lw	a5,-20(s0)
    800070ca:	873e                	mv	a4,a5
    800070cc:	fbc42783          	lw	a5,-68(s0)
    800070d0:	2701                	sext.w	a4,a4
    800070d2:	2781                	sext.w	a5,a5
    800070d4:	f6f74be3          	blt	a4,a5,8000704a <piperead+0x90>
    800070d8:	a021                	j	800070e0 <piperead+0x126>
      break;
    800070da:	0001                	nop
    800070dc:	a011                	j	800070e0 <piperead+0x126>
      break;
    800070de:	0001                	nop
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800070e0:	fc843783          	ld	a5,-56(s0)
    800070e4:	21c78793          	addi	a5,a5,540
    800070e8:	853e                	mv	a0,a5
    800070ea:	ffffc097          	auipc	ra,0xffffc
    800070ee:	39a080e7          	jalr	922(ra) # 80003484 <wakeup>
  release(&pi->lock);
    800070f2:	fc843783          	ld	a5,-56(s0)
    800070f6:	853e                	mv	a0,a5
    800070f8:	ffffa097          	auipc	ra,0xffffa
    800070fc:	1ea080e7          	jalr	490(ra) # 800012e2 <release>
  return i;
    80007100:	fec42783          	lw	a5,-20(s0)
}
    80007104:	853e                	mv	a0,a5
    80007106:	60a6                	ld	ra,72(sp)
    80007108:	6406                	ld	s0,64(sp)
    8000710a:	6161                	addi	sp,sp,80
    8000710c:	8082                	ret

000000008000710e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000710e:	7179                	addi	sp,sp,-48
    80007110:	f422                	sd	s0,40(sp)
    80007112:	1800                	addi	s0,sp,48
    80007114:	87aa                	mv	a5,a0
    80007116:	fcf42e23          	sw	a5,-36(s0)
    int perm = 0;
    8000711a:	fe042623          	sw	zero,-20(s0)
    if(flags & 0x1)
    8000711e:	fdc42783          	lw	a5,-36(s0)
    80007122:	8b85                	andi	a5,a5,1
    80007124:	2781                	sext.w	a5,a5
    80007126:	c781                	beqz	a5,8000712e <flags2perm+0x20>
      perm = PTE_X;
    80007128:	47a1                	li	a5,8
    8000712a:	fef42623          	sw	a5,-20(s0)
    if(flags & 0x2)
    8000712e:	fdc42783          	lw	a5,-36(s0)
    80007132:	8b89                	andi	a5,a5,2
    80007134:	2781                	sext.w	a5,a5
    80007136:	c799                	beqz	a5,80007144 <flags2perm+0x36>
      perm |= PTE_W;
    80007138:	fec42783          	lw	a5,-20(s0)
    8000713c:	0047e793          	ori	a5,a5,4
    80007140:	fef42623          	sw	a5,-20(s0)
    return perm;
    80007144:	fec42783          	lw	a5,-20(s0)
}
    80007148:	853e                	mv	a0,a5
    8000714a:	7422                	ld	s0,40(sp)
    8000714c:	6145                	addi	sp,sp,48
    8000714e:	8082                	ret

0000000080007150 <exec>:

int
exec(char *path, char **argv)
{
    80007150:	de010113          	addi	sp,sp,-544
    80007154:	20113c23          	sd	ra,536(sp)
    80007158:	20813823          	sd	s0,528(sp)
    8000715c:	20913423          	sd	s1,520(sp)
    80007160:	1400                	addi	s0,sp,544
    80007162:	dea43423          	sd	a0,-536(s0)
    80007166:	deb43023          	sd	a1,-544(s0)
  char *s, *last;
  int i, off;
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000716a:	fa043c23          	sd	zero,-72(s0)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
    8000716e:	fa043023          	sd	zero,-96(s0)
  struct proc *p = myproc();
    80007172:	ffffb097          	auipc	ra,0xffffb
    80007176:	6d4080e7          	jalr	1748(ra) # 80002846 <myproc>
    8000717a:	f8a43c23          	sd	a0,-104(s0)

  begin_op();
    8000717e:	fffff097          	auipc	ra,0xfffff
    80007182:	f40080e7          	jalr	-192(ra) # 800060be <begin_op>

  if((ip = namei(path)) == 0){
    80007186:	de843503          	ld	a0,-536(s0)
    8000718a:	fffff097          	auipc	ra,0xfffff
    8000718e:	bd0080e7          	jalr	-1072(ra) # 80005d5a <namei>
    80007192:	faa43423          	sd	a0,-88(s0)
    80007196:	fa843783          	ld	a5,-88(s0)
    8000719a:	e799                	bnez	a5,800071a8 <exec+0x58>
    end_op();
    8000719c:	fffff097          	auipc	ra,0xfffff
    800071a0:	fe4080e7          	jalr	-28(ra) # 80006180 <end_op>
    return -1;
    800071a4:	57fd                	li	a5,-1
    800071a6:	a199                	j	800075ec <exec+0x49c>
  }
  ilock(ip);
    800071a8:	fa843503          	ld	a0,-88(s0)
    800071ac:	ffffe097          	auipc	ra,0xffffe
    800071b0:	e7e080e7          	jalr	-386(ra) # 8000502a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800071b4:	e3040793          	addi	a5,s0,-464
    800071b8:	04000713          	li	a4,64
    800071bc:	4681                	li	a3,0
    800071be:	863e                	mv	a2,a5
    800071c0:	4581                	li	a1,0
    800071c2:	fa843503          	ld	a0,-88(s0)
    800071c6:	ffffe097          	auipc	ra,0xffffe
    800071ca:	41a080e7          	jalr	1050(ra) # 800055e0 <readi>
    800071ce:	87aa                	mv	a5,a0
    800071d0:	873e                	mv	a4,a5
    800071d2:	04000793          	li	a5,64
    800071d6:	3af71563          	bne	a4,a5,80007580 <exec+0x430>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800071da:	e3042783          	lw	a5,-464(s0)
    800071de:	873e                	mv	a4,a5
    800071e0:	464c47b7          	lui	a5,0x464c4
    800071e4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800071e8:	38f71e63          	bne	a4,a5,80007584 <exec+0x434>
    goto bad;

  if((pagetable = proc_pagetable(p)) == 0)
    800071ec:	f9843503          	ld	a0,-104(s0)
    800071f0:	ffffc097          	auipc	ra,0xffffc
    800071f4:	8b8080e7          	jalr	-1864(ra) # 80002aa8 <proc_pagetable>
    800071f8:	faa43023          	sd	a0,-96(s0)
    800071fc:	fa043783          	ld	a5,-96(s0)
    80007200:	38078463          	beqz	a5,80007588 <exec+0x438>
    goto bad;

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80007204:	fc042623          	sw	zero,-52(s0)
    80007208:	e5043783          	ld	a5,-432(s0)
    8000720c:	fcf42423          	sw	a5,-56(s0)
    80007210:	a0fd                	j	800072fe <exec+0x1ae>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80007212:	df840793          	addi	a5,s0,-520
    80007216:	fc842683          	lw	a3,-56(s0)
    8000721a:	03800713          	li	a4,56
    8000721e:	863e                	mv	a2,a5
    80007220:	4581                	li	a1,0
    80007222:	fa843503          	ld	a0,-88(s0)
    80007226:	ffffe097          	auipc	ra,0xffffe
    8000722a:	3ba080e7          	jalr	954(ra) # 800055e0 <readi>
    8000722e:	87aa                	mv	a5,a0
    80007230:	873e                	mv	a4,a5
    80007232:	03800793          	li	a5,56
    80007236:	34f71b63          	bne	a4,a5,8000758c <exec+0x43c>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
    8000723a:	df842783          	lw	a5,-520(s0)
    8000723e:	873e                	mv	a4,a5
    80007240:	4785                	li	a5,1
    80007242:	0af71163          	bne	a4,a5,800072e4 <exec+0x194>
      continue;
    if(ph.memsz < ph.filesz)
    80007246:	e2043703          	ld	a4,-480(s0)
    8000724a:	e1843783          	ld	a5,-488(s0)
    8000724e:	34f76163          	bltu	a4,a5,80007590 <exec+0x440>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80007252:	e0843703          	ld	a4,-504(s0)
    80007256:	e2043783          	ld	a5,-480(s0)
    8000725a:	973e                	add	a4,a4,a5
    8000725c:	e0843783          	ld	a5,-504(s0)
    80007260:	32f76a63          	bltu	a4,a5,80007594 <exec+0x444>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
    80007264:	e0843703          	ld	a4,-504(s0)
    80007268:	6785                	lui	a5,0x1
    8000726a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000726c:	8ff9                	and	a5,a5,a4
    8000726e:	32079563          	bnez	a5,80007598 <exec+0x448>
      goto bad;
    uint64 sz1;
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80007272:	e0843703          	ld	a4,-504(s0)
    80007276:	e2043783          	ld	a5,-480(s0)
    8000727a:	00f704b3          	add	s1,a4,a5
    8000727e:	dfc42783          	lw	a5,-516(s0)
    80007282:	2781                	sext.w	a5,a5
    80007284:	853e                	mv	a0,a5
    80007286:	00000097          	auipc	ra,0x0
    8000728a:	e88080e7          	jalr	-376(ra) # 8000710e <flags2perm>
    8000728e:	87aa                	mv	a5,a0
    80007290:	86be                	mv	a3,a5
    80007292:	8626                	mv	a2,s1
    80007294:	fb843583          	ld	a1,-72(s0)
    80007298:	fa043503          	ld	a0,-96(s0)
    8000729c:	ffffb097          	auipc	ra,0xffffb
    800072a0:	c88080e7          	jalr	-888(ra) # 80001f24 <uvmalloc>
    800072a4:	f6a43823          	sd	a0,-144(s0)
    800072a8:	f7043783          	ld	a5,-144(s0)
    800072ac:	2e078863          	beqz	a5,8000759c <exec+0x44c>
      goto bad;
    sz = sz1;
    800072b0:	f7043783          	ld	a5,-144(s0)
    800072b4:	faf43c23          	sd	a5,-72(s0)
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800072b8:	e0843783          	ld	a5,-504(s0)
    800072bc:	e0043703          	ld	a4,-512(s0)
    800072c0:	0007069b          	sext.w	a3,a4
    800072c4:	e1843703          	ld	a4,-488(s0)
    800072c8:	2701                	sext.w	a4,a4
    800072ca:	fa843603          	ld	a2,-88(s0)
    800072ce:	85be                	mv	a1,a5
    800072d0:	fa043503          	ld	a0,-96(s0)
    800072d4:	00000097          	auipc	ra,0x0
    800072d8:	32c080e7          	jalr	812(ra) # 80007600 <loadseg>
    800072dc:	87aa                	mv	a5,a0
    800072de:	2c07c163          	bltz	a5,800075a0 <exec+0x450>
    800072e2:	a011                	j	800072e6 <exec+0x196>
      continue;
    800072e4:	0001                	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800072e6:	fcc42783          	lw	a5,-52(s0)
    800072ea:	2785                	addiw	a5,a5,1
    800072ec:	fcf42623          	sw	a5,-52(s0)
    800072f0:	fc842783          	lw	a5,-56(s0)
    800072f4:	0387879b          	addiw	a5,a5,56
    800072f8:	2781                	sext.w	a5,a5
    800072fa:	fcf42423          	sw	a5,-56(s0)
    800072fe:	e6845783          	lhu	a5,-408(s0)
    80007302:	0007871b          	sext.w	a4,a5
    80007306:	fcc42783          	lw	a5,-52(s0)
    8000730a:	2781                	sext.w	a5,a5
    8000730c:	f0e7c3e3          	blt	a5,a4,80007212 <exec+0xc2>
      goto bad;
  }
  iunlockput(ip);
    80007310:	fa843503          	ld	a0,-88(s0)
    80007314:	ffffe097          	auipc	ra,0xffffe
    80007318:	f74080e7          	jalr	-140(ra) # 80005288 <iunlockput>
  end_op();
    8000731c:	fffff097          	auipc	ra,0xfffff
    80007320:	e64080e7          	jalr	-412(ra) # 80006180 <end_op>
  ip = 0;
    80007324:	fa043423          	sd	zero,-88(s0)

  p = myproc();
    80007328:	ffffb097          	auipc	ra,0xffffb
    8000732c:	51e080e7          	jalr	1310(ra) # 80002846 <myproc>
    80007330:	f8a43c23          	sd	a0,-104(s0)
  uint64 oldsz = p->sz;
    80007334:	f9843783          	ld	a5,-104(s0)
    80007338:	67bc                	ld	a5,72(a5)
    8000733a:	f8f43823          	sd	a5,-112(s0)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible as a stack guard.
  // Use the second as the user stack.
  sz = PGROUNDUP(sz);
    8000733e:	fb843703          	ld	a4,-72(s0)
    80007342:	6785                	lui	a5,0x1
    80007344:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80007346:	973e                	add	a4,a4,a5
    80007348:	77fd                	lui	a5,0xfffff
    8000734a:	8ff9                	and	a5,a5,a4
    8000734c:	faf43c23          	sd	a5,-72(s0)
  uint64 sz1;
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80007350:	fb843703          	ld	a4,-72(s0)
    80007354:	6789                	lui	a5,0x2
    80007356:	97ba                	add	a5,a5,a4
    80007358:	4691                	li	a3,4
    8000735a:	863e                	mv	a2,a5
    8000735c:	fb843583          	ld	a1,-72(s0)
    80007360:	fa043503          	ld	a0,-96(s0)
    80007364:	ffffb097          	auipc	ra,0xffffb
    80007368:	bc0080e7          	jalr	-1088(ra) # 80001f24 <uvmalloc>
    8000736c:	f8a43423          	sd	a0,-120(s0)
    80007370:	f8843783          	ld	a5,-120(s0)
    80007374:	22078863          	beqz	a5,800075a4 <exec+0x454>
    goto bad;
  sz = sz1;
    80007378:	f8843783          	ld	a5,-120(s0)
    8000737c:	faf43c23          	sd	a5,-72(s0)
  uvmclear(pagetable, sz-2*PGSIZE);
    80007380:	fb843703          	ld	a4,-72(s0)
    80007384:	77f9                	lui	a5,0xffffe
    80007386:	97ba                	add	a5,a5,a4
    80007388:	85be                	mv	a1,a5
    8000738a:	fa043503          	ld	a0,-96(s0)
    8000738e:	ffffb097          	auipc	ra,0xffffb
    80007392:	f2c080e7          	jalr	-212(ra) # 800022ba <uvmclear>
  sp = sz;
    80007396:	fb843783          	ld	a5,-72(s0)
    8000739a:	faf43823          	sd	a5,-80(s0)
  stackbase = sp - PGSIZE;
    8000739e:	fb043703          	ld	a4,-80(s0)
    800073a2:	77fd                	lui	a5,0xfffff
    800073a4:	97ba                	add	a5,a5,a4
    800073a6:	f8f43023          	sd	a5,-128(s0)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    800073aa:	fc043023          	sd	zero,-64(s0)
    800073ae:	a07d                	j	8000745c <exec+0x30c>
    if(argc >= MAXARG)
    800073b0:	fc043703          	ld	a4,-64(s0)
    800073b4:	47fd                	li	a5,31
    800073b6:	1ee7e963          	bltu	a5,a4,800075a8 <exec+0x458>
      goto bad;
    sp -= strlen(argv[argc]) + 1;
    800073ba:	fc043783          	ld	a5,-64(s0)
    800073be:	078e                	slli	a5,a5,0x3
    800073c0:	de043703          	ld	a4,-544(s0)
    800073c4:	97ba                	add	a5,a5,a4
    800073c6:	639c                	ld	a5,0(a5)
    800073c8:	853e                	mv	a0,a5
    800073ca:	ffffa097          	auipc	ra,0xffffa
    800073ce:	408080e7          	jalr	1032(ra) # 800017d2 <strlen>
    800073d2:	87aa                	mv	a5,a0
    800073d4:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffd7d59>
    800073d6:	2781                	sext.w	a5,a5
    800073d8:	873e                	mv	a4,a5
    800073da:	fb043783          	ld	a5,-80(s0)
    800073de:	8f99                	sub	a5,a5,a4
    800073e0:	faf43823          	sd	a5,-80(s0)
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800073e4:	fb043783          	ld	a5,-80(s0)
    800073e8:	9bc1                	andi	a5,a5,-16
    800073ea:	faf43823          	sd	a5,-80(s0)
    if(sp < stackbase)
    800073ee:	fb043703          	ld	a4,-80(s0)
    800073f2:	f8043783          	ld	a5,-128(s0)
    800073f6:	1af76b63          	bltu	a4,a5,800075ac <exec+0x45c>
      goto bad;
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800073fa:	fc043783          	ld	a5,-64(s0)
    800073fe:	078e                	slli	a5,a5,0x3
    80007400:	de043703          	ld	a4,-544(s0)
    80007404:	97ba                	add	a5,a5,a4
    80007406:	6384                	ld	s1,0(a5)
    80007408:	fc043783          	ld	a5,-64(s0)
    8000740c:	078e                	slli	a5,a5,0x3
    8000740e:	de043703          	ld	a4,-544(s0)
    80007412:	97ba                	add	a5,a5,a4
    80007414:	639c                	ld	a5,0(a5)
    80007416:	853e                	mv	a0,a5
    80007418:	ffffa097          	auipc	ra,0xffffa
    8000741c:	3ba080e7          	jalr	954(ra) # 800017d2 <strlen>
    80007420:	87aa                	mv	a5,a0
    80007422:	2785                	addiw	a5,a5,1
    80007424:	2781                	sext.w	a5,a5
    80007426:	86be                	mv	a3,a5
    80007428:	8626                	mv	a2,s1
    8000742a:	fb043583          	ld	a1,-80(s0)
    8000742e:	fa043503          	ld	a0,-96(s0)
    80007432:	ffffb097          	auipc	ra,0xffffb
    80007436:	ede080e7          	jalr	-290(ra) # 80002310 <copyout>
    8000743a:	87aa                	mv	a5,a0
    8000743c:	1607ca63          	bltz	a5,800075b0 <exec+0x460>
      goto bad;
    ustack[argc] = sp;
    80007440:	fc043783          	ld	a5,-64(s0)
    80007444:	078e                	slli	a5,a5,0x3
    80007446:	1781                	addi	a5,a5,-32
    80007448:	97a2                	add	a5,a5,s0
    8000744a:	fb043703          	ld	a4,-80(s0)
    8000744e:	e8e7b823          	sd	a4,-368(a5)
  for(argc = 0; argv[argc]; argc++) {
    80007452:	fc043783          	ld	a5,-64(s0)
    80007456:	0785                	addi	a5,a5,1
    80007458:	fcf43023          	sd	a5,-64(s0)
    8000745c:	fc043783          	ld	a5,-64(s0)
    80007460:	078e                	slli	a5,a5,0x3
    80007462:	de043703          	ld	a4,-544(s0)
    80007466:	97ba                	add	a5,a5,a4
    80007468:	639c                	ld	a5,0(a5)
    8000746a:	f3b9                	bnez	a5,800073b0 <exec+0x260>
  }
  ustack[argc] = 0;
    8000746c:	fc043783          	ld	a5,-64(s0)
    80007470:	078e                	slli	a5,a5,0x3
    80007472:	1781                	addi	a5,a5,-32
    80007474:	97a2                	add	a5,a5,s0
    80007476:	e807b823          	sd	zero,-368(a5)

  // push the array of argv[] pointers.
  sp -= (argc+1) * sizeof(uint64);
    8000747a:	fc043783          	ld	a5,-64(s0)
    8000747e:	0785                	addi	a5,a5,1
    80007480:	078e                	slli	a5,a5,0x3
    80007482:	fb043703          	ld	a4,-80(s0)
    80007486:	40f707b3          	sub	a5,a4,a5
    8000748a:	faf43823          	sd	a5,-80(s0)
  sp -= sp % 16;
    8000748e:	fb043783          	ld	a5,-80(s0)
    80007492:	9bc1                	andi	a5,a5,-16
    80007494:	faf43823          	sd	a5,-80(s0)
  if(sp < stackbase)
    80007498:	fb043703          	ld	a4,-80(s0)
    8000749c:	f8043783          	ld	a5,-128(s0)
    800074a0:	10f76a63          	bltu	a4,a5,800075b4 <exec+0x464>
    goto bad;
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800074a4:	fc043783          	ld	a5,-64(s0)
    800074a8:	0785                	addi	a5,a5,1
    800074aa:	00379713          	slli	a4,a5,0x3
    800074ae:	e7040793          	addi	a5,s0,-400
    800074b2:	86ba                	mv	a3,a4
    800074b4:	863e                	mv	a2,a5
    800074b6:	fb043583          	ld	a1,-80(s0)
    800074ba:	fa043503          	ld	a0,-96(s0)
    800074be:	ffffb097          	auipc	ra,0xffffb
    800074c2:	e52080e7          	jalr	-430(ra) # 80002310 <copyout>
    800074c6:	87aa                	mv	a5,a0
    800074c8:	0e07c863          	bltz	a5,800075b8 <exec+0x468>
    goto bad;

  // arguments to user main(argc, argv)
  // argc is returned via the system call return
  // value, which goes in a0.
  p->trapframe->a1 = sp;
    800074cc:	f9843783          	ld	a5,-104(s0)
    800074d0:	6fbc                	ld	a5,88(a5)
    800074d2:	fb043703          	ld	a4,-80(s0)
    800074d6:	ffb8                	sd	a4,120(a5)

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    800074d8:	de843783          	ld	a5,-536(s0)
    800074dc:	fcf43c23          	sd	a5,-40(s0)
    800074e0:	fd843783          	ld	a5,-40(s0)
    800074e4:	fcf43823          	sd	a5,-48(s0)
    800074e8:	a025                	j	80007510 <exec+0x3c0>
    if(*s == '/')
    800074ea:	fd843783          	ld	a5,-40(s0)
    800074ee:	0007c783          	lbu	a5,0(a5)
    800074f2:	873e                	mv	a4,a5
    800074f4:	02f00793          	li	a5,47
    800074f8:	00f71763          	bne	a4,a5,80007506 <exec+0x3b6>
      last = s+1;
    800074fc:	fd843783          	ld	a5,-40(s0)
    80007500:	0785                	addi	a5,a5,1
    80007502:	fcf43823          	sd	a5,-48(s0)
  for(last=s=path; *s; s++)
    80007506:	fd843783          	ld	a5,-40(s0)
    8000750a:	0785                	addi	a5,a5,1
    8000750c:	fcf43c23          	sd	a5,-40(s0)
    80007510:	fd843783          	ld	a5,-40(s0)
    80007514:	0007c783          	lbu	a5,0(a5)
    80007518:	fbe9                	bnez	a5,800074ea <exec+0x39a>
  safestrcpy(p->name, last, sizeof(p->name));
    8000751a:	f9843783          	ld	a5,-104(s0)
    8000751e:	15878793          	addi	a5,a5,344
    80007522:	4641                	li	a2,16
    80007524:	fd043583          	ld	a1,-48(s0)
    80007528:	853e                	mv	a0,a5
    8000752a:	ffffa097          	auipc	ra,0xffffa
    8000752e:	22c080e7          	jalr	556(ra) # 80001756 <safestrcpy>
    
  // Commit to the user image.
  oldpagetable = p->pagetable;
    80007532:	f9843783          	ld	a5,-104(s0)
    80007536:	6bbc                	ld	a5,80(a5)
    80007538:	f6f43c23          	sd	a5,-136(s0)
  p->pagetable = pagetable;
    8000753c:	f9843783          	ld	a5,-104(s0)
    80007540:	fa043703          	ld	a4,-96(s0)
    80007544:	ebb8                	sd	a4,80(a5)
  p->sz = sz;
    80007546:	f9843783          	ld	a5,-104(s0)
    8000754a:	fb843703          	ld	a4,-72(s0)
    8000754e:	e7b8                	sd	a4,72(a5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80007550:	f9843783          	ld	a5,-104(s0)
    80007554:	6fbc                	ld	a5,88(a5)
    80007556:	e4843703          	ld	a4,-440(s0)
    8000755a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000755c:	f9843783          	ld	a5,-104(s0)
    80007560:	6fbc                	ld	a5,88(a5)
    80007562:	fb043703          	ld	a4,-80(s0)
    80007566:	fb98                	sd	a4,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80007568:	f9043583          	ld	a1,-112(s0)
    8000756c:	f7843503          	ld	a0,-136(s0)
    80007570:	ffffb097          	auipc	ra,0xffffb
    80007574:	5f8080e7          	jalr	1528(ra) # 80002b68 <proc_freepagetable>

  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80007578:	fc043783          	ld	a5,-64(s0)
    8000757c:	2781                	sext.w	a5,a5
    8000757e:	a0bd                	j	800075ec <exec+0x49c>
    goto bad;
    80007580:	0001                	nop
    80007582:	a825                	j	800075ba <exec+0x46a>
    goto bad;
    80007584:	0001                	nop
    80007586:	a815                	j	800075ba <exec+0x46a>
    goto bad;
    80007588:	0001                	nop
    8000758a:	a805                	j	800075ba <exec+0x46a>
      goto bad;
    8000758c:	0001                	nop
    8000758e:	a035                	j	800075ba <exec+0x46a>
      goto bad;
    80007590:	0001                	nop
    80007592:	a025                	j	800075ba <exec+0x46a>
      goto bad;
    80007594:	0001                	nop
    80007596:	a015                	j	800075ba <exec+0x46a>
      goto bad;
    80007598:	0001                	nop
    8000759a:	a005                	j	800075ba <exec+0x46a>
      goto bad;
    8000759c:	0001                	nop
    8000759e:	a831                	j	800075ba <exec+0x46a>
      goto bad;
    800075a0:	0001                	nop
    800075a2:	a821                	j	800075ba <exec+0x46a>
    goto bad;
    800075a4:	0001                	nop
    800075a6:	a811                	j	800075ba <exec+0x46a>
      goto bad;
    800075a8:	0001                	nop
    800075aa:	a801                	j	800075ba <exec+0x46a>
      goto bad;
    800075ac:	0001                	nop
    800075ae:	a031                	j	800075ba <exec+0x46a>
      goto bad;
    800075b0:	0001                	nop
    800075b2:	a021                	j	800075ba <exec+0x46a>
    goto bad;
    800075b4:	0001                	nop
    800075b6:	a011                	j	800075ba <exec+0x46a>
    goto bad;
    800075b8:	0001                	nop

 bad:
  if(pagetable)
    800075ba:	fa043783          	ld	a5,-96(s0)
    800075be:	cb89                	beqz	a5,800075d0 <exec+0x480>
    proc_freepagetable(pagetable, sz);
    800075c0:	fb843583          	ld	a1,-72(s0)
    800075c4:	fa043503          	ld	a0,-96(s0)
    800075c8:	ffffb097          	auipc	ra,0xffffb
    800075cc:	5a0080e7          	jalr	1440(ra) # 80002b68 <proc_freepagetable>
  if(ip){
    800075d0:	fa843783          	ld	a5,-88(s0)
    800075d4:	cb99                	beqz	a5,800075ea <exec+0x49a>
    iunlockput(ip);
    800075d6:	fa843503          	ld	a0,-88(s0)
    800075da:	ffffe097          	auipc	ra,0xffffe
    800075de:	cae080e7          	jalr	-850(ra) # 80005288 <iunlockput>
    end_op();
    800075e2:	fffff097          	auipc	ra,0xfffff
    800075e6:	b9e080e7          	jalr	-1122(ra) # 80006180 <end_op>
  }
  return -1;
    800075ea:	57fd                	li	a5,-1
}
    800075ec:	853e                	mv	a0,a5
    800075ee:	21813083          	ld	ra,536(sp)
    800075f2:	21013403          	ld	s0,528(sp)
    800075f6:	20813483          	ld	s1,520(sp)
    800075fa:	22010113          	addi	sp,sp,544
    800075fe:	8082                	ret

0000000080007600 <loadseg>:
// va must be page-aligned
// and the pages from va to va+sz must already be mapped.
// Returns 0 on success, -1 on failure.
static int
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
    80007600:	7139                	addi	sp,sp,-64
    80007602:	fc06                	sd	ra,56(sp)
    80007604:	f822                	sd	s0,48(sp)
    80007606:	0080                	addi	s0,sp,64
    80007608:	fca43c23          	sd	a0,-40(s0)
    8000760c:	fcb43823          	sd	a1,-48(s0)
    80007610:	fcc43423          	sd	a2,-56(s0)
    80007614:	87b6                	mv	a5,a3
    80007616:	fcf42223          	sw	a5,-60(s0)
    8000761a:	87ba                	mv	a5,a4
    8000761c:	fcf42023          	sw	a5,-64(s0)
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80007620:	fe042623          	sw	zero,-20(s0)
    80007624:	a07d                	j	800076d2 <loadseg+0xd2>
    pa = walkaddr(pagetable, va + i);
    80007626:	fec46703          	lwu	a4,-20(s0)
    8000762a:	fd043783          	ld	a5,-48(s0)
    8000762e:	97ba                	add	a5,a5,a4
    80007630:	85be                	mv	a1,a5
    80007632:	fd843503          	ld	a0,-40(s0)
    80007636:	ffffa097          	auipc	ra,0xffffa
    8000763a:	57a080e7          	jalr	1402(ra) # 80001bb0 <walkaddr>
    8000763e:	fea43023          	sd	a0,-32(s0)
    if(pa == 0)
    80007642:	fe043783          	ld	a5,-32(s0)
    80007646:	eb89                	bnez	a5,80007658 <loadseg+0x58>
      panic("loadseg: address should exist");
    80007648:	00004517          	auipc	a0,0x4
    8000764c:	fa050513          	addi	a0,a0,-96 # 8000b5e8 <etext+0x5e8>
    80007650:	ffff9097          	auipc	ra,0xffff9
    80007654:	63a080e7          	jalr	1594(ra) # 80000c8a <panic>
    if(sz - i < PGSIZE)
    80007658:	fc042783          	lw	a5,-64(s0)
    8000765c:	873e                	mv	a4,a5
    8000765e:	fec42783          	lw	a5,-20(s0)
    80007662:	40f707bb          	subw	a5,a4,a5
    80007666:	2781                	sext.w	a5,a5
    80007668:	873e                	mv	a4,a5
    8000766a:	6785                	lui	a5,0x1
    8000766c:	00f77c63          	bgeu	a4,a5,80007684 <loadseg+0x84>
      n = sz - i;
    80007670:	fc042783          	lw	a5,-64(s0)
    80007674:	873e                	mv	a4,a5
    80007676:	fec42783          	lw	a5,-20(s0)
    8000767a:	40f707bb          	subw	a5,a4,a5
    8000767e:	fef42423          	sw	a5,-24(s0)
    80007682:	a021                	j	8000768a <loadseg+0x8a>
    else
      n = PGSIZE;
    80007684:	6785                	lui	a5,0x1
    80007686:	fef42423          	sw	a5,-24(s0)
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000768a:	fc442783          	lw	a5,-60(s0)
    8000768e:	873e                	mv	a4,a5
    80007690:	fec42783          	lw	a5,-20(s0)
    80007694:	9fb9                	addw	a5,a5,a4
    80007696:	2781                	sext.w	a5,a5
    80007698:	fe842703          	lw	a4,-24(s0)
    8000769c:	86be                	mv	a3,a5
    8000769e:	fe043603          	ld	a2,-32(s0)
    800076a2:	4581                	li	a1,0
    800076a4:	fc843503          	ld	a0,-56(s0)
    800076a8:	ffffe097          	auipc	ra,0xffffe
    800076ac:	f38080e7          	jalr	-200(ra) # 800055e0 <readi>
    800076b0:	87aa                	mv	a5,a0
    800076b2:	0007871b          	sext.w	a4,a5
    800076b6:	fe842783          	lw	a5,-24(s0)
    800076ba:	2781                	sext.w	a5,a5
    800076bc:	00e78463          	beq	a5,a4,800076c4 <loadseg+0xc4>
      return -1;
    800076c0:	57fd                	li	a5,-1
    800076c2:	a015                	j	800076e6 <loadseg+0xe6>
  for(i = 0; i < sz; i += PGSIZE){
    800076c4:	fec42783          	lw	a5,-20(s0)
    800076c8:	873e                	mv	a4,a5
    800076ca:	6785                	lui	a5,0x1
    800076cc:	9fb9                	addw	a5,a5,a4
    800076ce:	fef42623          	sw	a5,-20(s0)
    800076d2:	fec42783          	lw	a5,-20(s0)
    800076d6:	873e                	mv	a4,a5
    800076d8:	fc042783          	lw	a5,-64(s0)
    800076dc:	2701                	sext.w	a4,a4
    800076de:	2781                	sext.w	a5,a5
    800076e0:	f4f763e3          	bltu	a4,a5,80007626 <loadseg+0x26>
  }
  
  return 0;
    800076e4:	4781                	li	a5,0
}
    800076e6:	853e                	mv	a0,a5
    800076e8:	70e2                	ld	ra,56(sp)
    800076ea:	7442                	ld	s0,48(sp)
    800076ec:	6121                	addi	sp,sp,64
    800076ee:	8082                	ret

00000000800076f0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800076f0:	7139                	addi	sp,sp,-64
    800076f2:	fc06                	sd	ra,56(sp)
    800076f4:	f822                	sd	s0,48(sp)
    800076f6:	0080                	addi	s0,sp,64
    800076f8:	87aa                	mv	a5,a0
    800076fa:	fcb43823          	sd	a1,-48(s0)
    800076fe:	fcc43423          	sd	a2,-56(s0)
    80007702:	fcf42e23          	sw	a5,-36(s0)
  int fd;
  struct file *f;

  argint(n, &fd);
    80007706:	fe440713          	addi	a4,s0,-28
    8000770a:	fdc42783          	lw	a5,-36(s0)
    8000770e:	85ba                	mv	a1,a4
    80007710:	853e                	mv	a0,a5
    80007712:	ffffd097          	auipc	ra,0xffffd
    80007716:	992080e7          	jalr	-1646(ra) # 800040a4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000771a:	fe442783          	lw	a5,-28(s0)
    8000771e:	0207c863          	bltz	a5,8000774e <argfd+0x5e>
    80007722:	fe442783          	lw	a5,-28(s0)
    80007726:	873e                	mv	a4,a5
    80007728:	47bd                	li	a5,15
    8000772a:	02e7c263          	blt	a5,a4,8000774e <argfd+0x5e>
    8000772e:	ffffb097          	auipc	ra,0xffffb
    80007732:	118080e7          	jalr	280(ra) # 80002846 <myproc>
    80007736:	872a                	mv	a4,a0
    80007738:	fe442783          	lw	a5,-28(s0)
    8000773c:	07e9                	addi	a5,a5,26 # 101a <_entry-0x7fffefe6>
    8000773e:	078e                	slli	a5,a5,0x3
    80007740:	97ba                	add	a5,a5,a4
    80007742:	639c                	ld	a5,0(a5)
    80007744:	fef43423          	sd	a5,-24(s0)
    80007748:	fe843783          	ld	a5,-24(s0)
    8000774c:	e399                	bnez	a5,80007752 <argfd+0x62>
    return -1;
    8000774e:	57fd                	li	a5,-1
    80007750:	a015                	j	80007774 <argfd+0x84>
  if(pfd)
    80007752:	fd043783          	ld	a5,-48(s0)
    80007756:	c791                	beqz	a5,80007762 <argfd+0x72>
    *pfd = fd;
    80007758:	fe442703          	lw	a4,-28(s0)
    8000775c:	fd043783          	ld	a5,-48(s0)
    80007760:	c398                	sw	a4,0(a5)
  if(pf)
    80007762:	fc843783          	ld	a5,-56(s0)
    80007766:	c791                	beqz	a5,80007772 <argfd+0x82>
    *pf = f;
    80007768:	fc843783          	ld	a5,-56(s0)
    8000776c:	fe843703          	ld	a4,-24(s0)
    80007770:	e398                	sd	a4,0(a5)
  return 0;
    80007772:	4781                	li	a5,0
}
    80007774:	853e                	mv	a0,a5
    80007776:	70e2                	ld	ra,56(sp)
    80007778:	7442                	ld	s0,48(sp)
    8000777a:	6121                	addi	sp,sp,64
    8000777c:	8082                	ret

000000008000777e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000777e:	7179                	addi	sp,sp,-48
    80007780:	f406                	sd	ra,40(sp)
    80007782:	f022                	sd	s0,32(sp)
    80007784:	1800                	addi	s0,sp,48
    80007786:	fca43c23          	sd	a0,-40(s0)
  int fd;
  struct proc *p = myproc();
    8000778a:	ffffb097          	auipc	ra,0xffffb
    8000778e:	0bc080e7          	jalr	188(ra) # 80002846 <myproc>
    80007792:	fea43023          	sd	a0,-32(s0)

  for(fd = 0; fd < NOFILE; fd++){
    80007796:	fe042623          	sw	zero,-20(s0)
    8000779a:	a825                	j	800077d2 <fdalloc+0x54>
    if(p->ofile[fd] == 0){
    8000779c:	fe043703          	ld	a4,-32(s0)
    800077a0:	fec42783          	lw	a5,-20(s0)
    800077a4:	07e9                	addi	a5,a5,26
    800077a6:	078e                	slli	a5,a5,0x3
    800077a8:	97ba                	add	a5,a5,a4
    800077aa:	639c                	ld	a5,0(a5)
    800077ac:	ef91                	bnez	a5,800077c8 <fdalloc+0x4a>
      p->ofile[fd] = f;
    800077ae:	fe043703          	ld	a4,-32(s0)
    800077b2:	fec42783          	lw	a5,-20(s0)
    800077b6:	07e9                	addi	a5,a5,26
    800077b8:	078e                	slli	a5,a5,0x3
    800077ba:	97ba                	add	a5,a5,a4
    800077bc:	fd843703          	ld	a4,-40(s0)
    800077c0:	e398                	sd	a4,0(a5)
      return fd;
    800077c2:	fec42783          	lw	a5,-20(s0)
    800077c6:	a831                	j	800077e2 <fdalloc+0x64>
  for(fd = 0; fd < NOFILE; fd++){
    800077c8:	fec42783          	lw	a5,-20(s0)
    800077cc:	2785                	addiw	a5,a5,1
    800077ce:	fef42623          	sw	a5,-20(s0)
    800077d2:	fec42783          	lw	a5,-20(s0)
    800077d6:	0007871b          	sext.w	a4,a5
    800077da:	47bd                	li	a5,15
    800077dc:	fce7d0e3          	bge	a5,a4,8000779c <fdalloc+0x1e>
    }
  }
  return -1;
    800077e0:	57fd                	li	a5,-1
}
    800077e2:	853e                	mv	a0,a5
    800077e4:	70a2                	ld	ra,40(sp)
    800077e6:	7402                	ld	s0,32(sp)
    800077e8:	6145                	addi	sp,sp,48
    800077ea:	8082                	ret

00000000800077ec <sys_dup>:

uint64
sys_dup(void)
{
    800077ec:	1101                	addi	sp,sp,-32
    800077ee:	ec06                	sd	ra,24(sp)
    800077f0:	e822                	sd	s0,16(sp)
    800077f2:	1000                	addi	s0,sp,32
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    800077f4:	fe040793          	addi	a5,s0,-32
    800077f8:	863e                	mv	a2,a5
    800077fa:	4581                	li	a1,0
    800077fc:	4501                	li	a0,0
    800077fe:	00000097          	auipc	ra,0x0
    80007802:	ef2080e7          	jalr	-270(ra) # 800076f0 <argfd>
    80007806:	87aa                	mv	a5,a0
    80007808:	0007d463          	bgez	a5,80007810 <sys_dup+0x24>
    return -1;
    8000780c:	57fd                	li	a5,-1
    8000780e:	a81d                	j	80007844 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
    80007810:	fe043783          	ld	a5,-32(s0)
    80007814:	853e                	mv	a0,a5
    80007816:	00000097          	auipc	ra,0x0
    8000781a:	f68080e7          	jalr	-152(ra) # 8000777e <fdalloc>
    8000781e:	87aa                	mv	a5,a0
    80007820:	fef42623          	sw	a5,-20(s0)
    80007824:	fec42783          	lw	a5,-20(s0)
    80007828:	2781                	sext.w	a5,a5
    8000782a:	0007d463          	bgez	a5,80007832 <sys_dup+0x46>
    return -1;
    8000782e:	57fd                	li	a5,-1
    80007830:	a811                	j	80007844 <sys_dup+0x58>
  filedup(f);
    80007832:	fe043783          	ld	a5,-32(s0)
    80007836:	853e                	mv	a0,a5
    80007838:	fffff097          	auipc	ra,0xfffff
    8000783c:	eba080e7          	jalr	-326(ra) # 800066f2 <filedup>
  return fd;
    80007840:	fec42783          	lw	a5,-20(s0)
}
    80007844:	853e                	mv	a0,a5
    80007846:	60e2                	ld	ra,24(sp)
    80007848:	6442                	ld	s0,16(sp)
    8000784a:	6105                	addi	sp,sp,32
    8000784c:	8082                	ret

000000008000784e <sys_read>:

uint64
sys_read(void)
{
    8000784e:	7179                	addi	sp,sp,-48
    80007850:	f406                	sd	ra,40(sp)
    80007852:	f022                	sd	s0,32(sp)
    80007854:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
    80007856:	fd840793          	addi	a5,s0,-40
    8000785a:	85be                	mv	a1,a5
    8000785c:	4505                	li	a0,1
    8000785e:	ffffd097          	auipc	ra,0xffffd
    80007862:	87c080e7          	jalr	-1924(ra) # 800040da <argaddr>
  argint(2, &n);
    80007866:	fe440793          	addi	a5,s0,-28
    8000786a:	85be                	mv	a1,a5
    8000786c:	4509                	li	a0,2
    8000786e:	ffffd097          	auipc	ra,0xffffd
    80007872:	836080e7          	jalr	-1994(ra) # 800040a4 <argint>
  if(argfd(0, 0, &f) < 0)
    80007876:	fe840793          	addi	a5,s0,-24
    8000787a:	863e                	mv	a2,a5
    8000787c:	4581                	li	a1,0
    8000787e:	4501                	li	a0,0
    80007880:	00000097          	auipc	ra,0x0
    80007884:	e70080e7          	jalr	-400(ra) # 800076f0 <argfd>
    80007888:	87aa                	mv	a5,a0
    8000788a:	0007d463          	bgez	a5,80007892 <sys_read+0x44>
    return -1;
    8000788e:	57fd                	li	a5,-1
    80007890:	a839                	j	800078ae <sys_read+0x60>
  return fileread(f, p, n);
    80007892:	fe843783          	ld	a5,-24(s0)
    80007896:	fd843703          	ld	a4,-40(s0)
    8000789a:	fe442683          	lw	a3,-28(s0)
    8000789e:	8636                	mv	a2,a3
    800078a0:	85ba                	mv	a1,a4
    800078a2:	853e                	mv	a0,a5
    800078a4:	fffff097          	auipc	ra,0xfffff
    800078a8:	060080e7          	jalr	96(ra) # 80006904 <fileread>
    800078ac:	87aa                	mv	a5,a0
}
    800078ae:	853e                	mv	a0,a5
    800078b0:	70a2                	ld	ra,40(sp)
    800078b2:	7402                	ld	s0,32(sp)
    800078b4:	6145                	addi	sp,sp,48
    800078b6:	8082                	ret

00000000800078b8 <sys_write>:

uint64
sys_write(void)
{
    800078b8:	7179                	addi	sp,sp,-48
    800078ba:	f406                	sd	ra,40(sp)
    800078bc:	f022                	sd	s0,32(sp)
    800078be:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
    800078c0:	fd840793          	addi	a5,s0,-40
    800078c4:	85be                	mv	a1,a5
    800078c6:	4505                	li	a0,1
    800078c8:	ffffd097          	auipc	ra,0xffffd
    800078cc:	812080e7          	jalr	-2030(ra) # 800040da <argaddr>
  argint(2, &n);
    800078d0:	fe440793          	addi	a5,s0,-28
    800078d4:	85be                	mv	a1,a5
    800078d6:	4509                	li	a0,2
    800078d8:	ffffc097          	auipc	ra,0xffffc
    800078dc:	7cc080e7          	jalr	1996(ra) # 800040a4 <argint>
  if(argfd(0, 0, &f) < 0)
    800078e0:	fe840793          	addi	a5,s0,-24
    800078e4:	863e                	mv	a2,a5
    800078e6:	4581                	li	a1,0
    800078e8:	4501                	li	a0,0
    800078ea:	00000097          	auipc	ra,0x0
    800078ee:	e06080e7          	jalr	-506(ra) # 800076f0 <argfd>
    800078f2:	87aa                	mv	a5,a0
    800078f4:	0007d463          	bgez	a5,800078fc <sys_write+0x44>
    return -1;
    800078f8:	57fd                	li	a5,-1
    800078fa:	a839                	j	80007918 <sys_write+0x60>

  return filewrite(f, p, n);
    800078fc:	fe843783          	ld	a5,-24(s0)
    80007900:	fd843703          	ld	a4,-40(s0)
    80007904:	fe442683          	lw	a3,-28(s0)
    80007908:	8636                	mv	a2,a3
    8000790a:	85ba                	mv	a1,a4
    8000790c:	853e                	mv	a0,a5
    8000790e:	fffff097          	auipc	ra,0xfffff
    80007912:	154080e7          	jalr	340(ra) # 80006a62 <filewrite>
    80007916:	87aa                	mv	a5,a0
}
    80007918:	853e                	mv	a0,a5
    8000791a:	70a2                	ld	ra,40(sp)
    8000791c:	7402                	ld	s0,32(sp)
    8000791e:	6145                	addi	sp,sp,48
    80007920:	8082                	ret

0000000080007922 <sys_close>:

uint64
sys_close(void)
{
    80007922:	1101                	addi	sp,sp,-32
    80007924:	ec06                	sd	ra,24(sp)
    80007926:	e822                	sd	s0,16(sp)
    80007928:	1000                	addi	s0,sp,32
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    8000792a:	fe040713          	addi	a4,s0,-32
    8000792e:	fec40793          	addi	a5,s0,-20
    80007932:	863a                	mv	a2,a4
    80007934:	85be                	mv	a1,a5
    80007936:	4501                	li	a0,0
    80007938:	00000097          	auipc	ra,0x0
    8000793c:	db8080e7          	jalr	-584(ra) # 800076f0 <argfd>
    80007940:	87aa                	mv	a5,a0
    80007942:	0007d463          	bgez	a5,8000794a <sys_close+0x28>
    return -1;
    80007946:	57fd                	li	a5,-1
    80007948:	a02d                	j	80007972 <sys_close+0x50>
  myproc()->ofile[fd] = 0;
    8000794a:	ffffb097          	auipc	ra,0xffffb
    8000794e:	efc080e7          	jalr	-260(ra) # 80002846 <myproc>
    80007952:	872a                	mv	a4,a0
    80007954:	fec42783          	lw	a5,-20(s0)
    80007958:	07e9                	addi	a5,a5,26
    8000795a:	078e                	slli	a5,a5,0x3
    8000795c:	97ba                	add	a5,a5,a4
    8000795e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80007962:	fe043783          	ld	a5,-32(s0)
    80007966:	853e                	mv	a0,a5
    80007968:	fffff097          	auipc	ra,0xfffff
    8000796c:	df0080e7          	jalr	-528(ra) # 80006758 <fileclose>
  return 0;
    80007970:	4781                	li	a5,0
}
    80007972:	853e                	mv	a0,a5
    80007974:	60e2                	ld	ra,24(sp)
    80007976:	6442                	ld	s0,16(sp)
    80007978:	6105                	addi	sp,sp,32
    8000797a:	8082                	ret

000000008000797c <sys_fstat>:

uint64
sys_fstat(void)
{
    8000797c:	1101                	addi	sp,sp,-32
    8000797e:	ec06                	sd	ra,24(sp)
    80007980:	e822                	sd	s0,16(sp)
    80007982:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
    80007984:	fe040793          	addi	a5,s0,-32
    80007988:	85be                	mv	a1,a5
    8000798a:	4505                	li	a0,1
    8000798c:	ffffc097          	auipc	ra,0xffffc
    80007990:	74e080e7          	jalr	1870(ra) # 800040da <argaddr>
  if(argfd(0, 0, &f) < 0)
    80007994:	fe840793          	addi	a5,s0,-24
    80007998:	863e                	mv	a2,a5
    8000799a:	4581                	li	a1,0
    8000799c:	4501                	li	a0,0
    8000799e:	00000097          	auipc	ra,0x0
    800079a2:	d52080e7          	jalr	-686(ra) # 800076f0 <argfd>
    800079a6:	87aa                	mv	a5,a0
    800079a8:	0007d463          	bgez	a5,800079b0 <sys_fstat+0x34>
    return -1;
    800079ac:	57fd                	li	a5,-1
    800079ae:	a821                	j	800079c6 <sys_fstat+0x4a>
  return filestat(f, st);
    800079b0:	fe843783          	ld	a5,-24(s0)
    800079b4:	fe043703          	ld	a4,-32(s0)
    800079b8:	85ba                	mv	a1,a4
    800079ba:	853e                	mv	a0,a5
    800079bc:	fffff097          	auipc	ra,0xfffff
    800079c0:	ea4080e7          	jalr	-348(ra) # 80006860 <filestat>
    800079c4:	87aa                	mv	a5,a0
}
    800079c6:	853e                	mv	a0,a5
    800079c8:	60e2                	ld	ra,24(sp)
    800079ca:	6442                	ld	s0,16(sp)
    800079cc:	6105                	addi	sp,sp,32
    800079ce:	8082                	ret

00000000800079d0 <sys_link>:

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
    800079d0:	7169                	addi	sp,sp,-304
    800079d2:	f606                	sd	ra,296(sp)
    800079d4:	f222                	sd	s0,288(sp)
    800079d6:	1a00                	addi	s0,sp,304
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800079d8:	ed040793          	addi	a5,s0,-304
    800079dc:	08000613          	li	a2,128
    800079e0:	85be                	mv	a1,a5
    800079e2:	4501                	li	a0,0
    800079e4:	ffffc097          	auipc	ra,0xffffc
    800079e8:	728080e7          	jalr	1832(ra) # 8000410c <argstr>
    800079ec:	87aa                	mv	a5,a0
    800079ee:	0007cf63          	bltz	a5,80007a0c <sys_link+0x3c>
    800079f2:	f5040793          	addi	a5,s0,-176
    800079f6:	08000613          	li	a2,128
    800079fa:	85be                	mv	a1,a5
    800079fc:	4505                	li	a0,1
    800079fe:	ffffc097          	auipc	ra,0xffffc
    80007a02:	70e080e7          	jalr	1806(ra) # 8000410c <argstr>
    80007a06:	87aa                	mv	a5,a0
    80007a08:	0007d463          	bgez	a5,80007a10 <sys_link+0x40>
    return -1;
    80007a0c:	57fd                	li	a5,-1
    80007a0e:	aaad                	j	80007b88 <sys_link+0x1b8>

  begin_op();
    80007a10:	ffffe097          	auipc	ra,0xffffe
    80007a14:	6ae080e7          	jalr	1710(ra) # 800060be <begin_op>
  if((ip = namei(old)) == 0){
    80007a18:	ed040793          	addi	a5,s0,-304
    80007a1c:	853e                	mv	a0,a5
    80007a1e:	ffffe097          	auipc	ra,0xffffe
    80007a22:	33c080e7          	jalr	828(ra) # 80005d5a <namei>
    80007a26:	fea43423          	sd	a0,-24(s0)
    80007a2a:	fe843783          	ld	a5,-24(s0)
    80007a2e:	e799                	bnez	a5,80007a3c <sys_link+0x6c>
    end_op();
    80007a30:	ffffe097          	auipc	ra,0xffffe
    80007a34:	750080e7          	jalr	1872(ra) # 80006180 <end_op>
    return -1;
    80007a38:	57fd                	li	a5,-1
    80007a3a:	a2b9                	j	80007b88 <sys_link+0x1b8>
  }

  ilock(ip);
    80007a3c:	fe843503          	ld	a0,-24(s0)
    80007a40:	ffffd097          	auipc	ra,0xffffd
    80007a44:	5ea080e7          	jalr	1514(ra) # 8000502a <ilock>
  if(ip->type == T_DIR){
    80007a48:	fe843783          	ld	a5,-24(s0)
    80007a4c:	04479783          	lh	a5,68(a5)
    80007a50:	873e                	mv	a4,a5
    80007a52:	4785                	li	a5,1
    80007a54:	00f71e63          	bne	a4,a5,80007a70 <sys_link+0xa0>
    iunlockput(ip);
    80007a58:	fe843503          	ld	a0,-24(s0)
    80007a5c:	ffffe097          	auipc	ra,0xffffe
    80007a60:	82c080e7          	jalr	-2004(ra) # 80005288 <iunlockput>
    end_op();
    80007a64:	ffffe097          	auipc	ra,0xffffe
    80007a68:	71c080e7          	jalr	1820(ra) # 80006180 <end_op>
    return -1;
    80007a6c:	57fd                	li	a5,-1
    80007a6e:	aa29                	j	80007b88 <sys_link+0x1b8>
  }

  ip->nlink++;
    80007a70:	fe843783          	ld	a5,-24(s0)
    80007a74:	04a79783          	lh	a5,74(a5)
    80007a78:	17c2                	slli	a5,a5,0x30
    80007a7a:	93c1                	srli	a5,a5,0x30
    80007a7c:	2785                	addiw	a5,a5,1
    80007a7e:	17c2                	slli	a5,a5,0x30
    80007a80:	93c1                	srli	a5,a5,0x30
    80007a82:	0107971b          	slliw	a4,a5,0x10
    80007a86:	4107571b          	sraiw	a4,a4,0x10
    80007a8a:	fe843783          	ld	a5,-24(s0)
    80007a8e:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007a92:	fe843503          	ld	a0,-24(s0)
    80007a96:	ffffd097          	auipc	ra,0xffffd
    80007a9a:	344080e7          	jalr	836(ra) # 80004dda <iupdate>
  iunlock(ip);
    80007a9e:	fe843503          	ld	a0,-24(s0)
    80007aa2:	ffffd097          	auipc	ra,0xffffd
    80007aa6:	6bc080e7          	jalr	1724(ra) # 8000515e <iunlock>

  if((dp = nameiparent(new, name)) == 0)
    80007aaa:	fd040713          	addi	a4,s0,-48
    80007aae:	f5040793          	addi	a5,s0,-176
    80007ab2:	85ba                	mv	a1,a4
    80007ab4:	853e                	mv	a0,a5
    80007ab6:	ffffe097          	auipc	ra,0xffffe
    80007aba:	2d0080e7          	jalr	720(ra) # 80005d86 <nameiparent>
    80007abe:	fea43023          	sd	a0,-32(s0)
    80007ac2:	fe043783          	ld	a5,-32(s0)
    80007ac6:	cba5                	beqz	a5,80007b36 <sys_link+0x166>
    goto bad;
  ilock(dp);
    80007ac8:	fe043503          	ld	a0,-32(s0)
    80007acc:	ffffd097          	auipc	ra,0xffffd
    80007ad0:	55e080e7          	jalr	1374(ra) # 8000502a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80007ad4:	fe043783          	ld	a5,-32(s0)
    80007ad8:	4398                	lw	a4,0(a5)
    80007ada:	fe843783          	ld	a5,-24(s0)
    80007ade:	439c                	lw	a5,0(a5)
    80007ae0:	02f71263          	bne	a4,a5,80007b04 <sys_link+0x134>
    80007ae4:	fe843783          	ld	a5,-24(s0)
    80007ae8:	43d8                	lw	a4,4(a5)
    80007aea:	fd040793          	addi	a5,s0,-48
    80007aee:	863a                	mv	a2,a4
    80007af0:	85be                	mv	a1,a5
    80007af2:	fe043503          	ld	a0,-32(s0)
    80007af6:	ffffe097          	auipc	ra,0xffffe
    80007afa:	f58080e7          	jalr	-168(ra) # 80005a4e <dirlink>
    80007afe:	87aa                	mv	a5,a0
    80007b00:	0007d963          	bgez	a5,80007b12 <sys_link+0x142>
    iunlockput(dp);
    80007b04:	fe043503          	ld	a0,-32(s0)
    80007b08:	ffffd097          	auipc	ra,0xffffd
    80007b0c:	780080e7          	jalr	1920(ra) # 80005288 <iunlockput>
    goto bad;
    80007b10:	a025                	j	80007b38 <sys_link+0x168>
  }
  iunlockput(dp);
    80007b12:	fe043503          	ld	a0,-32(s0)
    80007b16:	ffffd097          	auipc	ra,0xffffd
    80007b1a:	772080e7          	jalr	1906(ra) # 80005288 <iunlockput>
  iput(ip);
    80007b1e:	fe843503          	ld	a0,-24(s0)
    80007b22:	ffffd097          	auipc	ra,0xffffd
    80007b26:	696080e7          	jalr	1686(ra) # 800051b8 <iput>

  end_op();
    80007b2a:	ffffe097          	auipc	ra,0xffffe
    80007b2e:	656080e7          	jalr	1622(ra) # 80006180 <end_op>

  return 0;
    80007b32:	4781                	li	a5,0
    80007b34:	a891                	j	80007b88 <sys_link+0x1b8>
    goto bad;
    80007b36:	0001                	nop

bad:
  ilock(ip);
    80007b38:	fe843503          	ld	a0,-24(s0)
    80007b3c:	ffffd097          	auipc	ra,0xffffd
    80007b40:	4ee080e7          	jalr	1262(ra) # 8000502a <ilock>
  ip->nlink--;
    80007b44:	fe843783          	ld	a5,-24(s0)
    80007b48:	04a79783          	lh	a5,74(a5)
    80007b4c:	17c2                	slli	a5,a5,0x30
    80007b4e:	93c1                	srli	a5,a5,0x30
    80007b50:	37fd                	addiw	a5,a5,-1
    80007b52:	17c2                	slli	a5,a5,0x30
    80007b54:	93c1                	srli	a5,a5,0x30
    80007b56:	0107971b          	slliw	a4,a5,0x10
    80007b5a:	4107571b          	sraiw	a4,a4,0x10
    80007b5e:	fe843783          	ld	a5,-24(s0)
    80007b62:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007b66:	fe843503          	ld	a0,-24(s0)
    80007b6a:	ffffd097          	auipc	ra,0xffffd
    80007b6e:	270080e7          	jalr	624(ra) # 80004dda <iupdate>
  iunlockput(ip);
    80007b72:	fe843503          	ld	a0,-24(s0)
    80007b76:	ffffd097          	auipc	ra,0xffffd
    80007b7a:	712080e7          	jalr	1810(ra) # 80005288 <iunlockput>
  end_op();
    80007b7e:	ffffe097          	auipc	ra,0xffffe
    80007b82:	602080e7          	jalr	1538(ra) # 80006180 <end_op>
  return -1;
    80007b86:	57fd                	li	a5,-1
}
    80007b88:	853e                	mv	a0,a5
    80007b8a:	70b2                	ld	ra,296(sp)
    80007b8c:	7412                	ld	s0,288(sp)
    80007b8e:	6155                	addi	sp,sp,304
    80007b90:	8082                	ret

0000000080007b92 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
    80007b92:	7139                	addi	sp,sp,-64
    80007b94:	fc06                	sd	ra,56(sp)
    80007b96:	f822                	sd	s0,48(sp)
    80007b98:	0080                	addi	s0,sp,64
    80007b9a:	fca43423          	sd	a0,-56(s0)
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007b9e:	02000793          	li	a5,32
    80007ba2:	fef42623          	sw	a5,-20(s0)
    80007ba6:	a0b1                	j	80007bf2 <isdirempty+0x60>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007ba8:	fd840793          	addi	a5,s0,-40
    80007bac:	fec42683          	lw	a3,-20(s0)
    80007bb0:	4741                	li	a4,16
    80007bb2:	863e                	mv	a2,a5
    80007bb4:	4581                	li	a1,0
    80007bb6:	fc843503          	ld	a0,-56(s0)
    80007bba:	ffffe097          	auipc	ra,0xffffe
    80007bbe:	a26080e7          	jalr	-1498(ra) # 800055e0 <readi>
    80007bc2:	87aa                	mv	a5,a0
    80007bc4:	873e                	mv	a4,a5
    80007bc6:	47c1                	li	a5,16
    80007bc8:	00f70a63          	beq	a4,a5,80007bdc <isdirempty+0x4a>
      panic("isdirempty: readi");
    80007bcc:	00004517          	auipc	a0,0x4
    80007bd0:	a3c50513          	addi	a0,a0,-1476 # 8000b608 <etext+0x608>
    80007bd4:	ffff9097          	auipc	ra,0xffff9
    80007bd8:	0b6080e7          	jalr	182(ra) # 80000c8a <panic>
    if(de.inum != 0)
    80007bdc:	fd845783          	lhu	a5,-40(s0)
    80007be0:	c399                	beqz	a5,80007be6 <isdirempty+0x54>
      return 0;
    80007be2:	4781                	li	a5,0
    80007be4:	a839                	j	80007c02 <isdirempty+0x70>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007be6:	fec42783          	lw	a5,-20(s0)
    80007bea:	27c1                	addiw	a5,a5,16
    80007bec:	2781                	sext.w	a5,a5
    80007bee:	fef42623          	sw	a5,-20(s0)
    80007bf2:	fc843783          	ld	a5,-56(s0)
    80007bf6:	47f8                	lw	a4,76(a5)
    80007bf8:	fec42783          	lw	a5,-20(s0)
    80007bfc:	fae7e6e3          	bltu	a5,a4,80007ba8 <isdirempty+0x16>
  }
  return 1;
    80007c00:	4785                	li	a5,1
}
    80007c02:	853e                	mv	a0,a5
    80007c04:	70e2                	ld	ra,56(sp)
    80007c06:	7442                	ld	s0,48(sp)
    80007c08:	6121                	addi	sp,sp,64
    80007c0a:	8082                	ret

0000000080007c0c <sys_unlink>:

uint64
sys_unlink(void)
{
    80007c0c:	7155                	addi	sp,sp,-208
    80007c0e:	e586                	sd	ra,200(sp)
    80007c10:	e1a2                	sd	s0,192(sp)
    80007c12:	0980                	addi	s0,sp,208
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    80007c14:	f4040793          	addi	a5,s0,-192
    80007c18:	08000613          	li	a2,128
    80007c1c:	85be                	mv	a1,a5
    80007c1e:	4501                	li	a0,0
    80007c20:	ffffc097          	auipc	ra,0xffffc
    80007c24:	4ec080e7          	jalr	1260(ra) # 8000410c <argstr>
    80007c28:	87aa                	mv	a5,a0
    80007c2a:	0007d463          	bgez	a5,80007c32 <sys_unlink+0x26>
    return -1;
    80007c2e:	57fd                	li	a5,-1
    80007c30:	a2d5                	j	80007e14 <sys_unlink+0x208>

  begin_op();
    80007c32:	ffffe097          	auipc	ra,0xffffe
    80007c36:	48c080e7          	jalr	1164(ra) # 800060be <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80007c3a:	fc040713          	addi	a4,s0,-64
    80007c3e:	f4040793          	addi	a5,s0,-192
    80007c42:	85ba                	mv	a1,a4
    80007c44:	853e                	mv	a0,a5
    80007c46:	ffffe097          	auipc	ra,0xffffe
    80007c4a:	140080e7          	jalr	320(ra) # 80005d86 <nameiparent>
    80007c4e:	fea43423          	sd	a0,-24(s0)
    80007c52:	fe843783          	ld	a5,-24(s0)
    80007c56:	e799                	bnez	a5,80007c64 <sys_unlink+0x58>
    end_op();
    80007c58:	ffffe097          	auipc	ra,0xffffe
    80007c5c:	528080e7          	jalr	1320(ra) # 80006180 <end_op>
    return -1;
    80007c60:	57fd                	li	a5,-1
    80007c62:	aa4d                	j	80007e14 <sys_unlink+0x208>
  }

  ilock(dp);
    80007c64:	fe843503          	ld	a0,-24(s0)
    80007c68:	ffffd097          	auipc	ra,0xffffd
    80007c6c:	3c2080e7          	jalr	962(ra) # 8000502a <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80007c70:	fc040793          	addi	a5,s0,-64
    80007c74:	00004597          	auipc	a1,0x4
    80007c78:	9ac58593          	addi	a1,a1,-1620 # 8000b620 <etext+0x620>
    80007c7c:	853e                	mv	a0,a5
    80007c7e:	ffffe097          	auipc	ra,0xffffe
    80007c82:	cbc080e7          	jalr	-836(ra) # 8000593a <namecmp>
    80007c86:	87aa                	mv	a5,a0
    80007c88:	16078863          	beqz	a5,80007df8 <sys_unlink+0x1ec>
    80007c8c:	fc040793          	addi	a5,s0,-64
    80007c90:	00004597          	auipc	a1,0x4
    80007c94:	99858593          	addi	a1,a1,-1640 # 8000b628 <etext+0x628>
    80007c98:	853e                	mv	a0,a5
    80007c9a:	ffffe097          	auipc	ra,0xffffe
    80007c9e:	ca0080e7          	jalr	-864(ra) # 8000593a <namecmp>
    80007ca2:	87aa                	mv	a5,a0
    80007ca4:	14078a63          	beqz	a5,80007df8 <sys_unlink+0x1ec>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    80007ca8:	f3c40713          	addi	a4,s0,-196
    80007cac:	fc040793          	addi	a5,s0,-64
    80007cb0:	863a                	mv	a2,a4
    80007cb2:	85be                	mv	a1,a5
    80007cb4:	fe843503          	ld	a0,-24(s0)
    80007cb8:	ffffe097          	auipc	ra,0xffffe
    80007cbc:	cb0080e7          	jalr	-848(ra) # 80005968 <dirlookup>
    80007cc0:	fea43023          	sd	a0,-32(s0)
    80007cc4:	fe043783          	ld	a5,-32(s0)
    80007cc8:	12078a63          	beqz	a5,80007dfc <sys_unlink+0x1f0>
    goto bad;
  ilock(ip);
    80007ccc:	fe043503          	ld	a0,-32(s0)
    80007cd0:	ffffd097          	auipc	ra,0xffffd
    80007cd4:	35a080e7          	jalr	858(ra) # 8000502a <ilock>

  if(ip->nlink < 1)
    80007cd8:	fe043783          	ld	a5,-32(s0)
    80007cdc:	04a79783          	lh	a5,74(a5)
    80007ce0:	00f04a63          	bgtz	a5,80007cf4 <sys_unlink+0xe8>
    panic("unlink: nlink < 1");
    80007ce4:	00004517          	auipc	a0,0x4
    80007ce8:	94c50513          	addi	a0,a0,-1716 # 8000b630 <etext+0x630>
    80007cec:	ffff9097          	auipc	ra,0xffff9
    80007cf0:	f9e080e7          	jalr	-98(ra) # 80000c8a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80007cf4:	fe043783          	ld	a5,-32(s0)
    80007cf8:	04479783          	lh	a5,68(a5)
    80007cfc:	873e                	mv	a4,a5
    80007cfe:	4785                	li	a5,1
    80007d00:	02f71163          	bne	a4,a5,80007d22 <sys_unlink+0x116>
    80007d04:	fe043503          	ld	a0,-32(s0)
    80007d08:	00000097          	auipc	ra,0x0
    80007d0c:	e8a080e7          	jalr	-374(ra) # 80007b92 <isdirempty>
    80007d10:	87aa                	mv	a5,a0
    80007d12:	eb81                	bnez	a5,80007d22 <sys_unlink+0x116>
    iunlockput(ip);
    80007d14:	fe043503          	ld	a0,-32(s0)
    80007d18:	ffffd097          	auipc	ra,0xffffd
    80007d1c:	570080e7          	jalr	1392(ra) # 80005288 <iunlockput>
    goto bad;
    80007d20:	a8f9                	j	80007dfe <sys_unlink+0x1f2>
  }

  memset(&de, 0, sizeof(de));
    80007d22:	fd040793          	addi	a5,s0,-48
    80007d26:	4641                	li	a2,16
    80007d28:	4581                	li	a1,0
    80007d2a:	853e                	mv	a0,a5
    80007d2c:	ffff9097          	auipc	ra,0xffff9
    80007d30:	726080e7          	jalr	1830(ra) # 80001452 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007d34:	fd040793          	addi	a5,s0,-48
    80007d38:	f3c42683          	lw	a3,-196(s0)
    80007d3c:	4741                	li	a4,16
    80007d3e:	863e                	mv	a2,a5
    80007d40:	4581                	li	a1,0
    80007d42:	fe843503          	ld	a0,-24(s0)
    80007d46:	ffffe097          	auipc	ra,0xffffe
    80007d4a:	a38080e7          	jalr	-1480(ra) # 8000577e <writei>
    80007d4e:	87aa                	mv	a5,a0
    80007d50:	873e                	mv	a4,a5
    80007d52:	47c1                	li	a5,16
    80007d54:	00f70a63          	beq	a4,a5,80007d68 <sys_unlink+0x15c>
    panic("unlink: writei");
    80007d58:	00004517          	auipc	a0,0x4
    80007d5c:	8f050513          	addi	a0,a0,-1808 # 8000b648 <etext+0x648>
    80007d60:	ffff9097          	auipc	ra,0xffff9
    80007d64:	f2a080e7          	jalr	-214(ra) # 80000c8a <panic>
  if(ip->type == T_DIR){
    80007d68:	fe043783          	ld	a5,-32(s0)
    80007d6c:	04479783          	lh	a5,68(a5)
    80007d70:	873e                	mv	a4,a5
    80007d72:	4785                	li	a5,1
    80007d74:	02f71963          	bne	a4,a5,80007da6 <sys_unlink+0x19a>
    dp->nlink--;
    80007d78:	fe843783          	ld	a5,-24(s0)
    80007d7c:	04a79783          	lh	a5,74(a5)
    80007d80:	17c2                	slli	a5,a5,0x30
    80007d82:	93c1                	srli	a5,a5,0x30
    80007d84:	37fd                	addiw	a5,a5,-1
    80007d86:	17c2                	slli	a5,a5,0x30
    80007d88:	93c1                	srli	a5,a5,0x30
    80007d8a:	0107971b          	slliw	a4,a5,0x10
    80007d8e:	4107571b          	sraiw	a4,a4,0x10
    80007d92:	fe843783          	ld	a5,-24(s0)
    80007d96:	04e79523          	sh	a4,74(a5)
    iupdate(dp);
    80007d9a:	fe843503          	ld	a0,-24(s0)
    80007d9e:	ffffd097          	auipc	ra,0xffffd
    80007da2:	03c080e7          	jalr	60(ra) # 80004dda <iupdate>
  }
  iunlockput(dp);
    80007da6:	fe843503          	ld	a0,-24(s0)
    80007daa:	ffffd097          	auipc	ra,0xffffd
    80007dae:	4de080e7          	jalr	1246(ra) # 80005288 <iunlockput>

  ip->nlink--;
    80007db2:	fe043783          	ld	a5,-32(s0)
    80007db6:	04a79783          	lh	a5,74(a5)
    80007dba:	17c2                	slli	a5,a5,0x30
    80007dbc:	93c1                	srli	a5,a5,0x30
    80007dbe:	37fd                	addiw	a5,a5,-1
    80007dc0:	17c2                	slli	a5,a5,0x30
    80007dc2:	93c1                	srli	a5,a5,0x30
    80007dc4:	0107971b          	slliw	a4,a5,0x10
    80007dc8:	4107571b          	sraiw	a4,a4,0x10
    80007dcc:	fe043783          	ld	a5,-32(s0)
    80007dd0:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007dd4:	fe043503          	ld	a0,-32(s0)
    80007dd8:	ffffd097          	auipc	ra,0xffffd
    80007ddc:	002080e7          	jalr	2(ra) # 80004dda <iupdate>
  iunlockput(ip);
    80007de0:	fe043503          	ld	a0,-32(s0)
    80007de4:	ffffd097          	auipc	ra,0xffffd
    80007de8:	4a4080e7          	jalr	1188(ra) # 80005288 <iunlockput>

  end_op();
    80007dec:	ffffe097          	auipc	ra,0xffffe
    80007df0:	394080e7          	jalr	916(ra) # 80006180 <end_op>

  return 0;
    80007df4:	4781                	li	a5,0
    80007df6:	a839                	j	80007e14 <sys_unlink+0x208>
    goto bad;
    80007df8:	0001                	nop
    80007dfa:	a011                	j	80007dfe <sys_unlink+0x1f2>
    goto bad;
    80007dfc:	0001                	nop

bad:
  iunlockput(dp);
    80007dfe:	fe843503          	ld	a0,-24(s0)
    80007e02:	ffffd097          	auipc	ra,0xffffd
    80007e06:	486080e7          	jalr	1158(ra) # 80005288 <iunlockput>
  end_op();
    80007e0a:	ffffe097          	auipc	ra,0xffffe
    80007e0e:	376080e7          	jalr	886(ra) # 80006180 <end_op>
  return -1;
    80007e12:	57fd                	li	a5,-1
}
    80007e14:	853e                	mv	a0,a5
    80007e16:	60ae                	ld	ra,200(sp)
    80007e18:	640e                	ld	s0,192(sp)
    80007e1a:	6169                	addi	sp,sp,208
    80007e1c:	8082                	ret

0000000080007e1e <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
    80007e1e:	7139                	addi	sp,sp,-64
    80007e20:	fc06                	sd	ra,56(sp)
    80007e22:	f822                	sd	s0,48(sp)
    80007e24:	0080                	addi	s0,sp,64
    80007e26:	fca43423          	sd	a0,-56(s0)
    80007e2a:	87ae                	mv	a5,a1
    80007e2c:	8736                	mv	a4,a3
    80007e2e:	fcf41323          	sh	a5,-58(s0)
    80007e32:	87b2                	mv	a5,a2
    80007e34:	fcf41223          	sh	a5,-60(s0)
    80007e38:	87ba                	mv	a5,a4
    80007e3a:	fcf41123          	sh	a5,-62(s0)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80007e3e:	fd040793          	addi	a5,s0,-48
    80007e42:	85be                	mv	a1,a5
    80007e44:	fc843503          	ld	a0,-56(s0)
    80007e48:	ffffe097          	auipc	ra,0xffffe
    80007e4c:	f3e080e7          	jalr	-194(ra) # 80005d86 <nameiparent>
    80007e50:	fea43423          	sd	a0,-24(s0)
    80007e54:	fe843783          	ld	a5,-24(s0)
    80007e58:	e399                	bnez	a5,80007e5e <create+0x40>
    return 0;
    80007e5a:	4781                	li	a5,0
    80007e5c:	a2dd                	j	80008042 <create+0x224>

  ilock(dp);
    80007e5e:	fe843503          	ld	a0,-24(s0)
    80007e62:	ffffd097          	auipc	ra,0xffffd
    80007e66:	1c8080e7          	jalr	456(ra) # 8000502a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80007e6a:	fd040793          	addi	a5,s0,-48
    80007e6e:	4601                	li	a2,0
    80007e70:	85be                	mv	a1,a5
    80007e72:	fe843503          	ld	a0,-24(s0)
    80007e76:	ffffe097          	auipc	ra,0xffffe
    80007e7a:	af2080e7          	jalr	-1294(ra) # 80005968 <dirlookup>
    80007e7e:	fea43023          	sd	a0,-32(s0)
    80007e82:	fe043783          	ld	a5,-32(s0)
    80007e86:	cfb9                	beqz	a5,80007ee4 <create+0xc6>
    iunlockput(dp);
    80007e88:	fe843503          	ld	a0,-24(s0)
    80007e8c:	ffffd097          	auipc	ra,0xffffd
    80007e90:	3fc080e7          	jalr	1020(ra) # 80005288 <iunlockput>
    ilock(ip);
    80007e94:	fe043503          	ld	a0,-32(s0)
    80007e98:	ffffd097          	auipc	ra,0xffffd
    80007e9c:	192080e7          	jalr	402(ra) # 8000502a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80007ea0:	fc641783          	lh	a5,-58(s0)
    80007ea4:	0007871b          	sext.w	a4,a5
    80007ea8:	4789                	li	a5,2
    80007eaa:	02f71563          	bne	a4,a5,80007ed4 <create+0xb6>
    80007eae:	fe043783          	ld	a5,-32(s0)
    80007eb2:	04479783          	lh	a5,68(a5)
    80007eb6:	873e                	mv	a4,a5
    80007eb8:	4789                	li	a5,2
    80007eba:	00f70a63          	beq	a4,a5,80007ece <create+0xb0>
    80007ebe:	fe043783          	ld	a5,-32(s0)
    80007ec2:	04479783          	lh	a5,68(a5)
    80007ec6:	873e                	mv	a4,a5
    80007ec8:	478d                	li	a5,3
    80007eca:	00f71563          	bne	a4,a5,80007ed4 <create+0xb6>
      return ip;
    80007ece:	fe043783          	ld	a5,-32(s0)
    80007ed2:	aa85                	j	80008042 <create+0x224>
    iunlockput(ip);
    80007ed4:	fe043503          	ld	a0,-32(s0)
    80007ed8:	ffffd097          	auipc	ra,0xffffd
    80007edc:	3b0080e7          	jalr	944(ra) # 80005288 <iunlockput>
    return 0;
    80007ee0:	4781                	li	a5,0
    80007ee2:	a285                	j	80008042 <create+0x224>
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    80007ee4:	fe843783          	ld	a5,-24(s0)
    80007ee8:	439c                	lw	a5,0(a5)
    80007eea:	fc641703          	lh	a4,-58(s0)
    80007eee:	85ba                	mv	a1,a4
    80007ef0:	853e                	mv	a0,a5
    80007ef2:	ffffd097          	auipc	ra,0xffffd
    80007ef6:	dea080e7          	jalr	-534(ra) # 80004cdc <ialloc>
    80007efa:	fea43023          	sd	a0,-32(s0)
    80007efe:	fe043783          	ld	a5,-32(s0)
    80007f02:	eb89                	bnez	a5,80007f14 <create+0xf6>
    iunlockput(dp);
    80007f04:	fe843503          	ld	a0,-24(s0)
    80007f08:	ffffd097          	auipc	ra,0xffffd
    80007f0c:	380080e7          	jalr	896(ra) # 80005288 <iunlockput>
    return 0;
    80007f10:	4781                	li	a5,0
    80007f12:	aa05                	j	80008042 <create+0x224>
  }

  ilock(ip);
    80007f14:	fe043503          	ld	a0,-32(s0)
    80007f18:	ffffd097          	auipc	ra,0xffffd
    80007f1c:	112080e7          	jalr	274(ra) # 8000502a <ilock>
  ip->major = major;
    80007f20:	fe043783          	ld	a5,-32(s0)
    80007f24:	fc445703          	lhu	a4,-60(s0)
    80007f28:	04e79323          	sh	a4,70(a5)
  ip->minor = minor;
    80007f2c:	fe043783          	ld	a5,-32(s0)
    80007f30:	fc245703          	lhu	a4,-62(s0)
    80007f34:	04e79423          	sh	a4,72(a5)
  ip->nlink = 1;
    80007f38:	fe043783          	ld	a5,-32(s0)
    80007f3c:	4705                	li	a4,1
    80007f3e:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007f42:	fe043503          	ld	a0,-32(s0)
    80007f46:	ffffd097          	auipc	ra,0xffffd
    80007f4a:	e94080e7          	jalr	-364(ra) # 80004dda <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
    80007f4e:	fc641783          	lh	a5,-58(s0)
    80007f52:	0007871b          	sext.w	a4,a5
    80007f56:	4785                	li	a5,1
    80007f58:	04f71463          	bne	a4,a5,80007fa0 <create+0x182>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80007f5c:	fe043783          	ld	a5,-32(s0)
    80007f60:	43dc                	lw	a5,4(a5)
    80007f62:	863e                	mv	a2,a5
    80007f64:	00003597          	auipc	a1,0x3
    80007f68:	6bc58593          	addi	a1,a1,1724 # 8000b620 <etext+0x620>
    80007f6c:	fe043503          	ld	a0,-32(s0)
    80007f70:	ffffe097          	auipc	ra,0xffffe
    80007f74:	ade080e7          	jalr	-1314(ra) # 80005a4e <dirlink>
    80007f78:	87aa                	mv	a5,a0
    80007f7a:	0807ca63          	bltz	a5,8000800e <create+0x1f0>
    80007f7e:	fe843783          	ld	a5,-24(s0)
    80007f82:	43dc                	lw	a5,4(a5)
    80007f84:	863e                	mv	a2,a5
    80007f86:	00003597          	auipc	a1,0x3
    80007f8a:	6a258593          	addi	a1,a1,1698 # 8000b628 <etext+0x628>
    80007f8e:	fe043503          	ld	a0,-32(s0)
    80007f92:	ffffe097          	auipc	ra,0xffffe
    80007f96:	abc080e7          	jalr	-1348(ra) # 80005a4e <dirlink>
    80007f9a:	87aa                	mv	a5,a0
    80007f9c:	0607c963          	bltz	a5,8000800e <create+0x1f0>
      goto fail;
  }

  if(dirlink(dp, name, ip->inum) < 0)
    80007fa0:	fe043783          	ld	a5,-32(s0)
    80007fa4:	43d8                	lw	a4,4(a5)
    80007fa6:	fd040793          	addi	a5,s0,-48
    80007faa:	863a                	mv	a2,a4
    80007fac:	85be                	mv	a1,a5
    80007fae:	fe843503          	ld	a0,-24(s0)
    80007fb2:	ffffe097          	auipc	ra,0xffffe
    80007fb6:	a9c080e7          	jalr	-1380(ra) # 80005a4e <dirlink>
    80007fba:	87aa                	mv	a5,a0
    80007fbc:	0407cb63          	bltz	a5,80008012 <create+0x1f4>
    goto fail;

  if(type == T_DIR){
    80007fc0:	fc641783          	lh	a5,-58(s0)
    80007fc4:	0007871b          	sext.w	a4,a5
    80007fc8:	4785                	li	a5,1
    80007fca:	02f71963          	bne	a4,a5,80007ffc <create+0x1de>
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    80007fce:	fe843783          	ld	a5,-24(s0)
    80007fd2:	04a79783          	lh	a5,74(a5)
    80007fd6:	17c2                	slli	a5,a5,0x30
    80007fd8:	93c1                	srli	a5,a5,0x30
    80007fda:	2785                	addiw	a5,a5,1
    80007fdc:	17c2                	slli	a5,a5,0x30
    80007fde:	93c1                	srli	a5,a5,0x30
    80007fe0:	0107971b          	slliw	a4,a5,0x10
    80007fe4:	4107571b          	sraiw	a4,a4,0x10
    80007fe8:	fe843783          	ld	a5,-24(s0)
    80007fec:	04e79523          	sh	a4,74(a5)
    iupdate(dp);
    80007ff0:	fe843503          	ld	a0,-24(s0)
    80007ff4:	ffffd097          	auipc	ra,0xffffd
    80007ff8:	de6080e7          	jalr	-538(ra) # 80004dda <iupdate>
  }

  iunlockput(dp);
    80007ffc:	fe843503          	ld	a0,-24(s0)
    80008000:	ffffd097          	auipc	ra,0xffffd
    80008004:	288080e7          	jalr	648(ra) # 80005288 <iunlockput>

  return ip;
    80008008:	fe043783          	ld	a5,-32(s0)
    8000800c:	a81d                	j	80008042 <create+0x224>
      goto fail;
    8000800e:	0001                	nop
    80008010:	a011                	j	80008014 <create+0x1f6>
    goto fail;
    80008012:	0001                	nop

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
    80008014:	fe043783          	ld	a5,-32(s0)
    80008018:	04079523          	sh	zero,74(a5)
  iupdate(ip);
    8000801c:	fe043503          	ld	a0,-32(s0)
    80008020:	ffffd097          	auipc	ra,0xffffd
    80008024:	dba080e7          	jalr	-582(ra) # 80004dda <iupdate>
  iunlockput(ip);
    80008028:	fe043503          	ld	a0,-32(s0)
    8000802c:	ffffd097          	auipc	ra,0xffffd
    80008030:	25c080e7          	jalr	604(ra) # 80005288 <iunlockput>
  iunlockput(dp);
    80008034:	fe843503          	ld	a0,-24(s0)
    80008038:	ffffd097          	auipc	ra,0xffffd
    8000803c:	250080e7          	jalr	592(ra) # 80005288 <iunlockput>
  return 0;
    80008040:	4781                	li	a5,0
}
    80008042:	853e                	mv	a0,a5
    80008044:	70e2                	ld	ra,56(sp)
    80008046:	7442                	ld	s0,48(sp)
    80008048:	6121                	addi	sp,sp,64
    8000804a:	8082                	ret

000000008000804c <sys_open>:

uint64
sys_open(void)
{
    8000804c:	7131                	addi	sp,sp,-192
    8000804e:	fd06                	sd	ra,184(sp)
    80008050:	f922                	sd	s0,176(sp)
    80008052:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80008054:	f4c40793          	addi	a5,s0,-180
    80008058:	85be                	mv	a1,a5
    8000805a:	4505                	li	a0,1
    8000805c:	ffffc097          	auipc	ra,0xffffc
    80008060:	048080e7          	jalr	72(ra) # 800040a4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80008064:	f5040793          	addi	a5,s0,-176
    80008068:	08000613          	li	a2,128
    8000806c:	85be                	mv	a1,a5
    8000806e:	4501                	li	a0,0
    80008070:	ffffc097          	auipc	ra,0xffffc
    80008074:	09c080e7          	jalr	156(ra) # 8000410c <argstr>
    80008078:	87aa                	mv	a5,a0
    8000807a:	fef42223          	sw	a5,-28(s0)
    8000807e:	fe442783          	lw	a5,-28(s0)
    80008082:	2781                	sext.w	a5,a5
    80008084:	0007d463          	bgez	a5,8000808c <sys_open+0x40>
    return -1;
    80008088:	57fd                	li	a5,-1
    8000808a:	aafd                	j	80008288 <sys_open+0x23c>

  begin_op();
    8000808c:	ffffe097          	auipc	ra,0xffffe
    80008090:	032080e7          	jalr	50(ra) # 800060be <begin_op>

  if(omode & O_CREATE){
    80008094:	f4c42783          	lw	a5,-180(s0)
    80008098:	2007f793          	andi	a5,a5,512
    8000809c:	2781                	sext.w	a5,a5
    8000809e:	c795                	beqz	a5,800080ca <sys_open+0x7e>
    ip = create(path, T_FILE, 0, 0);
    800080a0:	f5040793          	addi	a5,s0,-176
    800080a4:	4681                	li	a3,0
    800080a6:	4601                	li	a2,0
    800080a8:	4589                	li	a1,2
    800080aa:	853e                	mv	a0,a5
    800080ac:	00000097          	auipc	ra,0x0
    800080b0:	d72080e7          	jalr	-654(ra) # 80007e1e <create>
    800080b4:	fea43423          	sd	a0,-24(s0)
    if(ip == 0){
    800080b8:	fe843783          	ld	a5,-24(s0)
    800080bc:	e7b5                	bnez	a5,80008128 <sys_open+0xdc>
      end_op();
    800080be:	ffffe097          	auipc	ra,0xffffe
    800080c2:	0c2080e7          	jalr	194(ra) # 80006180 <end_op>
      return -1;
    800080c6:	57fd                	li	a5,-1
    800080c8:	a2c1                	j	80008288 <sys_open+0x23c>
    }
  } else {
    if((ip = namei(path)) == 0){
    800080ca:	f5040793          	addi	a5,s0,-176
    800080ce:	853e                	mv	a0,a5
    800080d0:	ffffe097          	auipc	ra,0xffffe
    800080d4:	c8a080e7          	jalr	-886(ra) # 80005d5a <namei>
    800080d8:	fea43423          	sd	a0,-24(s0)
    800080dc:	fe843783          	ld	a5,-24(s0)
    800080e0:	e799                	bnez	a5,800080ee <sys_open+0xa2>
      end_op();
    800080e2:	ffffe097          	auipc	ra,0xffffe
    800080e6:	09e080e7          	jalr	158(ra) # 80006180 <end_op>
      return -1;
    800080ea:	57fd                	li	a5,-1
    800080ec:	aa71                	j	80008288 <sys_open+0x23c>
    }
    ilock(ip);
    800080ee:	fe843503          	ld	a0,-24(s0)
    800080f2:	ffffd097          	auipc	ra,0xffffd
    800080f6:	f38080e7          	jalr	-200(ra) # 8000502a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800080fa:	fe843783          	ld	a5,-24(s0)
    800080fe:	04479783          	lh	a5,68(a5)
    80008102:	873e                	mv	a4,a5
    80008104:	4785                	li	a5,1
    80008106:	02f71163          	bne	a4,a5,80008128 <sys_open+0xdc>
    8000810a:	f4c42783          	lw	a5,-180(s0)
    8000810e:	cf89                	beqz	a5,80008128 <sys_open+0xdc>
      iunlockput(ip);
    80008110:	fe843503          	ld	a0,-24(s0)
    80008114:	ffffd097          	auipc	ra,0xffffd
    80008118:	174080e7          	jalr	372(ra) # 80005288 <iunlockput>
      end_op();
    8000811c:	ffffe097          	auipc	ra,0xffffe
    80008120:	064080e7          	jalr	100(ra) # 80006180 <end_op>
      return -1;
    80008124:	57fd                	li	a5,-1
    80008126:	a28d                	j	80008288 <sys_open+0x23c>
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80008128:	fe843783          	ld	a5,-24(s0)
    8000812c:	04479783          	lh	a5,68(a5)
    80008130:	873e                	mv	a4,a5
    80008132:	478d                	li	a5,3
    80008134:	02f71c63          	bne	a4,a5,8000816c <sys_open+0x120>
    80008138:	fe843783          	ld	a5,-24(s0)
    8000813c:	04679783          	lh	a5,70(a5)
    80008140:	0007ca63          	bltz	a5,80008154 <sys_open+0x108>
    80008144:	fe843783          	ld	a5,-24(s0)
    80008148:	04679783          	lh	a5,70(a5)
    8000814c:	873e                	mv	a4,a5
    8000814e:	47a5                	li	a5,9
    80008150:	00e7de63          	bge	a5,a4,8000816c <sys_open+0x120>
    iunlockput(ip);
    80008154:	fe843503          	ld	a0,-24(s0)
    80008158:	ffffd097          	auipc	ra,0xffffd
    8000815c:	130080e7          	jalr	304(ra) # 80005288 <iunlockput>
    end_op();
    80008160:	ffffe097          	auipc	ra,0xffffe
    80008164:	020080e7          	jalr	32(ra) # 80006180 <end_op>
    return -1;
    80008168:	57fd                	li	a5,-1
    8000816a:	aa39                	j	80008288 <sys_open+0x23c>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000816c:	ffffe097          	auipc	ra,0xffffe
    80008170:	502080e7          	jalr	1282(ra) # 8000666e <filealloc>
    80008174:	fca43c23          	sd	a0,-40(s0)
    80008178:	fd843783          	ld	a5,-40(s0)
    8000817c:	cf99                	beqz	a5,8000819a <sys_open+0x14e>
    8000817e:	fd843503          	ld	a0,-40(s0)
    80008182:	fffff097          	auipc	ra,0xfffff
    80008186:	5fc080e7          	jalr	1532(ra) # 8000777e <fdalloc>
    8000818a:	87aa                	mv	a5,a0
    8000818c:	fcf42a23          	sw	a5,-44(s0)
    80008190:	fd442783          	lw	a5,-44(s0)
    80008194:	2781                	sext.w	a5,a5
    80008196:	0207d763          	bgez	a5,800081c4 <sys_open+0x178>
    if(f)
    8000819a:	fd843783          	ld	a5,-40(s0)
    8000819e:	c799                	beqz	a5,800081ac <sys_open+0x160>
      fileclose(f);
    800081a0:	fd843503          	ld	a0,-40(s0)
    800081a4:	ffffe097          	auipc	ra,0xffffe
    800081a8:	5b4080e7          	jalr	1460(ra) # 80006758 <fileclose>
    iunlockput(ip);
    800081ac:	fe843503          	ld	a0,-24(s0)
    800081b0:	ffffd097          	auipc	ra,0xffffd
    800081b4:	0d8080e7          	jalr	216(ra) # 80005288 <iunlockput>
    end_op();
    800081b8:	ffffe097          	auipc	ra,0xffffe
    800081bc:	fc8080e7          	jalr	-56(ra) # 80006180 <end_op>
    return -1;
    800081c0:	57fd                	li	a5,-1
    800081c2:	a0d9                	j	80008288 <sys_open+0x23c>
  }

  if(ip->type == T_DEVICE){
    800081c4:	fe843783          	ld	a5,-24(s0)
    800081c8:	04479783          	lh	a5,68(a5)
    800081cc:	873e                	mv	a4,a5
    800081ce:	478d                	li	a5,3
    800081d0:	00f71f63          	bne	a4,a5,800081ee <sys_open+0x1a2>
    f->type = FD_DEVICE;
    800081d4:	fd843783          	ld	a5,-40(s0)
    800081d8:	470d                	li	a4,3
    800081da:	c398                	sw	a4,0(a5)
    f->major = ip->major;
    800081dc:	fe843783          	ld	a5,-24(s0)
    800081e0:	04679703          	lh	a4,70(a5)
    800081e4:	fd843783          	ld	a5,-40(s0)
    800081e8:	02e79223          	sh	a4,36(a5)
    800081ec:	a809                	j	800081fe <sys_open+0x1b2>
  } else {
    f->type = FD_INODE;
    800081ee:	fd843783          	ld	a5,-40(s0)
    800081f2:	4709                	li	a4,2
    800081f4:	c398                	sw	a4,0(a5)
    f->off = 0;
    800081f6:	fd843783          	ld	a5,-40(s0)
    800081fa:	0207a023          	sw	zero,32(a5)
  }
  f->ip = ip;
    800081fe:	fd843783          	ld	a5,-40(s0)
    80008202:	fe843703          	ld	a4,-24(s0)
    80008206:	ef98                	sd	a4,24(a5)
  f->readable = !(omode & O_WRONLY);
    80008208:	f4c42783          	lw	a5,-180(s0)
    8000820c:	8b85                	andi	a5,a5,1
    8000820e:	2781                	sext.w	a5,a5
    80008210:	0017b793          	seqz	a5,a5
    80008214:	0ff7f793          	zext.b	a5,a5
    80008218:	873e                	mv	a4,a5
    8000821a:	fd843783          	ld	a5,-40(s0)
    8000821e:	00e78423          	sb	a4,8(a5)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80008222:	f4c42783          	lw	a5,-180(s0)
    80008226:	8b85                	andi	a5,a5,1
    80008228:	2781                	sext.w	a5,a5
    8000822a:	e791                	bnez	a5,80008236 <sys_open+0x1ea>
    8000822c:	f4c42783          	lw	a5,-180(s0)
    80008230:	8b89                	andi	a5,a5,2
    80008232:	2781                	sext.w	a5,a5
    80008234:	c399                	beqz	a5,8000823a <sys_open+0x1ee>
    80008236:	4785                	li	a5,1
    80008238:	a011                	j	8000823c <sys_open+0x1f0>
    8000823a:	4781                	li	a5,0
    8000823c:	0ff7f713          	zext.b	a4,a5
    80008240:	fd843783          	ld	a5,-40(s0)
    80008244:	00e784a3          	sb	a4,9(a5)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80008248:	f4c42783          	lw	a5,-180(s0)
    8000824c:	4007f793          	andi	a5,a5,1024
    80008250:	2781                	sext.w	a5,a5
    80008252:	cf99                	beqz	a5,80008270 <sys_open+0x224>
    80008254:	fe843783          	ld	a5,-24(s0)
    80008258:	04479783          	lh	a5,68(a5)
    8000825c:	873e                	mv	a4,a5
    8000825e:	4789                	li	a5,2
    80008260:	00f71863          	bne	a4,a5,80008270 <sys_open+0x224>
    itrunc(ip);
    80008264:	fe843503          	ld	a0,-24(s0)
    80008268:	ffffd097          	auipc	ra,0xffffd
    8000826c:	1ca080e7          	jalr	458(ra) # 80005432 <itrunc>
  }

  iunlock(ip);
    80008270:	fe843503          	ld	a0,-24(s0)
    80008274:	ffffd097          	auipc	ra,0xffffd
    80008278:	eea080e7          	jalr	-278(ra) # 8000515e <iunlock>
  end_op();
    8000827c:	ffffe097          	auipc	ra,0xffffe
    80008280:	f04080e7          	jalr	-252(ra) # 80006180 <end_op>

  return fd;
    80008284:	fd442783          	lw	a5,-44(s0)
}
    80008288:	853e                	mv	a0,a5
    8000828a:	70ea                	ld	ra,184(sp)
    8000828c:	744a                	ld	s0,176(sp)
    8000828e:	6129                	addi	sp,sp,192
    80008290:	8082                	ret

0000000080008292 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80008292:	7135                	addi	sp,sp,-160
    80008294:	ed06                	sd	ra,152(sp)
    80008296:	e922                	sd	s0,144(sp)
    80008298:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000829a:	ffffe097          	auipc	ra,0xffffe
    8000829e:	e24080e7          	jalr	-476(ra) # 800060be <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800082a2:	f6840793          	addi	a5,s0,-152
    800082a6:	08000613          	li	a2,128
    800082aa:	85be                	mv	a1,a5
    800082ac:	4501                	li	a0,0
    800082ae:	ffffc097          	auipc	ra,0xffffc
    800082b2:	e5e080e7          	jalr	-418(ra) # 8000410c <argstr>
    800082b6:	87aa                	mv	a5,a0
    800082b8:	0207c163          	bltz	a5,800082da <sys_mkdir+0x48>
    800082bc:	f6840793          	addi	a5,s0,-152
    800082c0:	4681                	li	a3,0
    800082c2:	4601                	li	a2,0
    800082c4:	4585                	li	a1,1
    800082c6:	853e                	mv	a0,a5
    800082c8:	00000097          	auipc	ra,0x0
    800082cc:	b56080e7          	jalr	-1194(ra) # 80007e1e <create>
    800082d0:	fea43423          	sd	a0,-24(s0)
    800082d4:	fe843783          	ld	a5,-24(s0)
    800082d8:	e799                	bnez	a5,800082e6 <sys_mkdir+0x54>
    end_op();
    800082da:	ffffe097          	auipc	ra,0xffffe
    800082de:	ea6080e7          	jalr	-346(ra) # 80006180 <end_op>
    return -1;
    800082e2:	57fd                	li	a5,-1
    800082e4:	a821                	j	800082fc <sys_mkdir+0x6a>
  }
  iunlockput(ip);
    800082e6:	fe843503          	ld	a0,-24(s0)
    800082ea:	ffffd097          	auipc	ra,0xffffd
    800082ee:	f9e080e7          	jalr	-98(ra) # 80005288 <iunlockput>
  end_op();
    800082f2:	ffffe097          	auipc	ra,0xffffe
    800082f6:	e8e080e7          	jalr	-370(ra) # 80006180 <end_op>
  return 0;
    800082fa:	4781                	li	a5,0
}
    800082fc:	853e                	mv	a0,a5
    800082fe:	60ea                	ld	ra,152(sp)
    80008300:	644a                	ld	s0,144(sp)
    80008302:	610d                	addi	sp,sp,160
    80008304:	8082                	ret

0000000080008306 <sys_mknod>:

uint64
sys_mknod(void)
{
    80008306:	7135                	addi	sp,sp,-160
    80008308:	ed06                	sd	ra,152(sp)
    8000830a:	e922                	sd	s0,144(sp)
    8000830c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000830e:	ffffe097          	auipc	ra,0xffffe
    80008312:	db0080e7          	jalr	-592(ra) # 800060be <begin_op>
  argint(1, &major);
    80008316:	f6440793          	addi	a5,s0,-156
    8000831a:	85be                	mv	a1,a5
    8000831c:	4505                	li	a0,1
    8000831e:	ffffc097          	auipc	ra,0xffffc
    80008322:	d86080e7          	jalr	-634(ra) # 800040a4 <argint>
  argint(2, &minor);
    80008326:	f6040793          	addi	a5,s0,-160
    8000832a:	85be                	mv	a1,a5
    8000832c:	4509                	li	a0,2
    8000832e:	ffffc097          	auipc	ra,0xffffc
    80008332:	d76080e7          	jalr	-650(ra) # 800040a4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80008336:	f6840793          	addi	a5,s0,-152
    8000833a:	08000613          	li	a2,128
    8000833e:	85be                	mv	a1,a5
    80008340:	4501                	li	a0,0
    80008342:	ffffc097          	auipc	ra,0xffffc
    80008346:	dca080e7          	jalr	-566(ra) # 8000410c <argstr>
    8000834a:	87aa                	mv	a5,a0
    8000834c:	0207cc63          	bltz	a5,80008384 <sys_mknod+0x7e>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80008350:	f6442783          	lw	a5,-156(s0)
    80008354:	0107971b          	slliw	a4,a5,0x10
    80008358:	4107571b          	sraiw	a4,a4,0x10
    8000835c:	f6042783          	lw	a5,-160(s0)
    80008360:	0107969b          	slliw	a3,a5,0x10
    80008364:	4106d69b          	sraiw	a3,a3,0x10
    80008368:	f6840793          	addi	a5,s0,-152
    8000836c:	863a                	mv	a2,a4
    8000836e:	458d                	li	a1,3
    80008370:	853e                	mv	a0,a5
    80008372:	00000097          	auipc	ra,0x0
    80008376:	aac080e7          	jalr	-1364(ra) # 80007e1e <create>
    8000837a:	fea43423          	sd	a0,-24(s0)
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000837e:	fe843783          	ld	a5,-24(s0)
    80008382:	e799                	bnez	a5,80008390 <sys_mknod+0x8a>
    end_op();
    80008384:	ffffe097          	auipc	ra,0xffffe
    80008388:	dfc080e7          	jalr	-516(ra) # 80006180 <end_op>
    return -1;
    8000838c:	57fd                	li	a5,-1
    8000838e:	a821                	j	800083a6 <sys_mknod+0xa0>
  }
  iunlockput(ip);
    80008390:	fe843503          	ld	a0,-24(s0)
    80008394:	ffffd097          	auipc	ra,0xffffd
    80008398:	ef4080e7          	jalr	-268(ra) # 80005288 <iunlockput>
  end_op();
    8000839c:	ffffe097          	auipc	ra,0xffffe
    800083a0:	de4080e7          	jalr	-540(ra) # 80006180 <end_op>
  return 0;
    800083a4:	4781                	li	a5,0
}
    800083a6:	853e                	mv	a0,a5
    800083a8:	60ea                	ld	ra,152(sp)
    800083aa:	644a                	ld	s0,144(sp)
    800083ac:	610d                	addi	sp,sp,160
    800083ae:	8082                	ret

00000000800083b0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800083b0:	7135                	addi	sp,sp,-160
    800083b2:	ed06                	sd	ra,152(sp)
    800083b4:	e922                	sd	s0,144(sp)
    800083b6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800083b8:	ffffa097          	auipc	ra,0xffffa
    800083bc:	48e080e7          	jalr	1166(ra) # 80002846 <myproc>
    800083c0:	fea43423          	sd	a0,-24(s0)
  
  begin_op();
    800083c4:	ffffe097          	auipc	ra,0xffffe
    800083c8:	cfa080e7          	jalr	-774(ra) # 800060be <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800083cc:	f6040793          	addi	a5,s0,-160
    800083d0:	08000613          	li	a2,128
    800083d4:	85be                	mv	a1,a5
    800083d6:	4501                	li	a0,0
    800083d8:	ffffc097          	auipc	ra,0xffffc
    800083dc:	d34080e7          	jalr	-716(ra) # 8000410c <argstr>
    800083e0:	87aa                	mv	a5,a0
    800083e2:	0007ce63          	bltz	a5,800083fe <sys_chdir+0x4e>
    800083e6:	f6040793          	addi	a5,s0,-160
    800083ea:	853e                	mv	a0,a5
    800083ec:	ffffe097          	auipc	ra,0xffffe
    800083f0:	96e080e7          	jalr	-1682(ra) # 80005d5a <namei>
    800083f4:	fea43023          	sd	a0,-32(s0)
    800083f8:	fe043783          	ld	a5,-32(s0)
    800083fc:	e799                	bnez	a5,8000840a <sys_chdir+0x5a>
    end_op();
    800083fe:	ffffe097          	auipc	ra,0xffffe
    80008402:	d82080e7          	jalr	-638(ra) # 80006180 <end_op>
    return -1;
    80008406:	57fd                	li	a5,-1
    80008408:	a0ad                	j	80008472 <sys_chdir+0xc2>
  }
  ilock(ip);
    8000840a:	fe043503          	ld	a0,-32(s0)
    8000840e:	ffffd097          	auipc	ra,0xffffd
    80008412:	c1c080e7          	jalr	-996(ra) # 8000502a <ilock>
  if(ip->type != T_DIR){
    80008416:	fe043783          	ld	a5,-32(s0)
    8000841a:	04479783          	lh	a5,68(a5)
    8000841e:	873e                	mv	a4,a5
    80008420:	4785                	li	a5,1
    80008422:	00f70e63          	beq	a4,a5,8000843e <sys_chdir+0x8e>
    iunlockput(ip);
    80008426:	fe043503          	ld	a0,-32(s0)
    8000842a:	ffffd097          	auipc	ra,0xffffd
    8000842e:	e5e080e7          	jalr	-418(ra) # 80005288 <iunlockput>
    end_op();
    80008432:	ffffe097          	auipc	ra,0xffffe
    80008436:	d4e080e7          	jalr	-690(ra) # 80006180 <end_op>
    return -1;
    8000843a:	57fd                	li	a5,-1
    8000843c:	a81d                	j	80008472 <sys_chdir+0xc2>
  }
  iunlock(ip);
    8000843e:	fe043503          	ld	a0,-32(s0)
    80008442:	ffffd097          	auipc	ra,0xffffd
    80008446:	d1c080e7          	jalr	-740(ra) # 8000515e <iunlock>
  iput(p->cwd);
    8000844a:	fe843783          	ld	a5,-24(s0)
    8000844e:	1507b783          	ld	a5,336(a5)
    80008452:	853e                	mv	a0,a5
    80008454:	ffffd097          	auipc	ra,0xffffd
    80008458:	d64080e7          	jalr	-668(ra) # 800051b8 <iput>
  end_op();
    8000845c:	ffffe097          	auipc	ra,0xffffe
    80008460:	d24080e7          	jalr	-732(ra) # 80006180 <end_op>
  p->cwd = ip;
    80008464:	fe843783          	ld	a5,-24(s0)
    80008468:	fe043703          	ld	a4,-32(s0)
    8000846c:	14e7b823          	sd	a4,336(a5)
  return 0;
    80008470:	4781                	li	a5,0
}
    80008472:	853e                	mv	a0,a5
    80008474:	60ea                	ld	ra,152(sp)
    80008476:	644a                	ld	s0,144(sp)
    80008478:	610d                	addi	sp,sp,160
    8000847a:	8082                	ret

000000008000847c <sys_exec>:

uint64
sys_exec(void)
{
    8000847c:	7161                	addi	sp,sp,-432
    8000847e:	f706                	sd	ra,424(sp)
    80008480:	f322                	sd	s0,416(sp)
    80008482:	1b00                	addi	s0,sp,432
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80008484:	e6040793          	addi	a5,s0,-416
    80008488:	85be                	mv	a1,a5
    8000848a:	4505                	li	a0,1
    8000848c:	ffffc097          	auipc	ra,0xffffc
    80008490:	c4e080e7          	jalr	-946(ra) # 800040da <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80008494:	f6840793          	addi	a5,s0,-152
    80008498:	08000613          	li	a2,128
    8000849c:	85be                	mv	a1,a5
    8000849e:	4501                	li	a0,0
    800084a0:	ffffc097          	auipc	ra,0xffffc
    800084a4:	c6c080e7          	jalr	-916(ra) # 8000410c <argstr>
    800084a8:	87aa                	mv	a5,a0
    800084aa:	0007d463          	bgez	a5,800084b2 <sys_exec+0x36>
    return -1;
    800084ae:	57fd                	li	a5,-1
    800084b0:	aa8d                	j	80008622 <sys_exec+0x1a6>
  }
  memset(argv, 0, sizeof(argv));
    800084b2:	e6840793          	addi	a5,s0,-408
    800084b6:	10000613          	li	a2,256
    800084ba:	4581                	li	a1,0
    800084bc:	853e                	mv	a0,a5
    800084be:	ffff9097          	auipc	ra,0xffff9
    800084c2:	f94080e7          	jalr	-108(ra) # 80001452 <memset>
  for(i=0;; i++){
    800084c6:	fe042623          	sw	zero,-20(s0)
    if(i >= NELEM(argv)){
    800084ca:	fec42783          	lw	a5,-20(s0)
    800084ce:	873e                	mv	a4,a5
    800084d0:	47fd                	li	a5,31
    800084d2:	0ee7ee63          	bltu	a5,a4,800085ce <sys_exec+0x152>
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800084d6:	fec42783          	lw	a5,-20(s0)
    800084da:	00379713          	slli	a4,a5,0x3
    800084de:	e6043783          	ld	a5,-416(s0)
    800084e2:	97ba                	add	a5,a5,a4
    800084e4:	e5840713          	addi	a4,s0,-424
    800084e8:	85ba                	mv	a1,a4
    800084ea:	853e                	mv	a0,a5
    800084ec:	ffffc097          	auipc	ra,0xffffc
    800084f0:	a46080e7          	jalr	-1466(ra) # 80003f32 <fetchaddr>
    800084f4:	87aa                	mv	a5,a0
    800084f6:	0c07ce63          	bltz	a5,800085d2 <sys_exec+0x156>
      goto bad;
    }
    if(uarg == 0){
    800084fa:	e5843783          	ld	a5,-424(s0)
    800084fe:	eb8d                	bnez	a5,80008530 <sys_exec+0xb4>
      argv[i] = 0;
    80008500:	fec42783          	lw	a5,-20(s0)
    80008504:	078e                	slli	a5,a5,0x3
    80008506:	17c1                	addi	a5,a5,-16
    80008508:	97a2                	add	a5,a5,s0
    8000850a:	e607bc23          	sd	zero,-392(a5)
      break;
    8000850e:	0001                	nop
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
      goto bad;
  }

  int ret = exec(path, argv);
    80008510:	e6840713          	addi	a4,s0,-408
    80008514:	f6840793          	addi	a5,s0,-152
    80008518:	85ba                	mv	a1,a4
    8000851a:	853e                	mv	a0,a5
    8000851c:	fffff097          	auipc	ra,0xfffff
    80008520:	c34080e7          	jalr	-972(ra) # 80007150 <exec>
    80008524:	87aa                	mv	a5,a0
    80008526:	fef42423          	sw	a5,-24(s0)

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000852a:	fe042623          	sw	zero,-20(s0)
    8000852e:	a8bd                	j	800085ac <sys_exec+0x130>
    argv[i] = kalloc();
    80008530:	ffff9097          	auipc	ra,0xffff9
    80008534:	bfa080e7          	jalr	-1030(ra) # 8000112a <kalloc>
    80008538:	872a                	mv	a4,a0
    8000853a:	fec42783          	lw	a5,-20(s0)
    8000853e:	078e                	slli	a5,a5,0x3
    80008540:	17c1                	addi	a5,a5,-16
    80008542:	97a2                	add	a5,a5,s0
    80008544:	e6e7bc23          	sd	a4,-392(a5)
    if(argv[i] == 0)
    80008548:	fec42783          	lw	a5,-20(s0)
    8000854c:	078e                	slli	a5,a5,0x3
    8000854e:	17c1                	addi	a5,a5,-16
    80008550:	97a2                	add	a5,a5,s0
    80008552:	e787b783          	ld	a5,-392(a5)
    80008556:	c3c1                	beqz	a5,800085d6 <sys_exec+0x15a>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80008558:	e5843703          	ld	a4,-424(s0)
    8000855c:	fec42783          	lw	a5,-20(s0)
    80008560:	078e                	slli	a5,a5,0x3
    80008562:	17c1                	addi	a5,a5,-16
    80008564:	97a2                	add	a5,a5,s0
    80008566:	e787b783          	ld	a5,-392(a5)
    8000856a:	6605                	lui	a2,0x1
    8000856c:	85be                	mv	a1,a5
    8000856e:	853a                	mv	a0,a4
    80008570:	ffffc097          	auipc	ra,0xffffc
    80008574:	a30080e7          	jalr	-1488(ra) # 80003fa0 <fetchstr>
    80008578:	87aa                	mv	a5,a0
    8000857a:	0607c063          	bltz	a5,800085da <sys_exec+0x15e>
  for(i=0;; i++){
    8000857e:	fec42783          	lw	a5,-20(s0)
    80008582:	2785                	addiw	a5,a5,1
    80008584:	fef42623          	sw	a5,-20(s0)
    if(i >= NELEM(argv)){
    80008588:	b789                	j	800084ca <sys_exec+0x4e>
    kfree(argv[i]);
    8000858a:	fec42783          	lw	a5,-20(s0)
    8000858e:	078e                	slli	a5,a5,0x3
    80008590:	17c1                	addi	a5,a5,-16
    80008592:	97a2                	add	a5,a5,s0
    80008594:	e787b783          	ld	a5,-392(a5)
    80008598:	853e                	mv	a0,a5
    8000859a:	ffff9097          	auipc	ra,0xffff9
    8000859e:	aec080e7          	jalr	-1300(ra) # 80001086 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800085a2:	fec42783          	lw	a5,-20(s0)
    800085a6:	2785                	addiw	a5,a5,1
    800085a8:	fef42623          	sw	a5,-20(s0)
    800085ac:	fec42783          	lw	a5,-20(s0)
    800085b0:	873e                	mv	a4,a5
    800085b2:	47fd                	li	a5,31
    800085b4:	00e7ea63          	bltu	a5,a4,800085c8 <sys_exec+0x14c>
    800085b8:	fec42783          	lw	a5,-20(s0)
    800085bc:	078e                	slli	a5,a5,0x3
    800085be:	17c1                	addi	a5,a5,-16
    800085c0:	97a2                	add	a5,a5,s0
    800085c2:	e787b783          	ld	a5,-392(a5)
    800085c6:	f3f1                	bnez	a5,8000858a <sys_exec+0x10e>

  return ret;
    800085c8:	fe842783          	lw	a5,-24(s0)
    800085cc:	a899                	j	80008622 <sys_exec+0x1a6>
      goto bad;
    800085ce:	0001                	nop
    800085d0:	a031                	j	800085dc <sys_exec+0x160>
      goto bad;
    800085d2:	0001                	nop
    800085d4:	a021                	j	800085dc <sys_exec+0x160>
      goto bad;
    800085d6:	0001                	nop
    800085d8:	a011                	j	800085dc <sys_exec+0x160>
      goto bad;
    800085da:	0001                	nop

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800085dc:	fe042623          	sw	zero,-20(s0)
    800085e0:	a015                	j	80008604 <sys_exec+0x188>
    kfree(argv[i]);
    800085e2:	fec42783          	lw	a5,-20(s0)
    800085e6:	078e                	slli	a5,a5,0x3
    800085e8:	17c1                	addi	a5,a5,-16
    800085ea:	97a2                	add	a5,a5,s0
    800085ec:	e787b783          	ld	a5,-392(a5)
    800085f0:	853e                	mv	a0,a5
    800085f2:	ffff9097          	auipc	ra,0xffff9
    800085f6:	a94080e7          	jalr	-1388(ra) # 80001086 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800085fa:	fec42783          	lw	a5,-20(s0)
    800085fe:	2785                	addiw	a5,a5,1
    80008600:	fef42623          	sw	a5,-20(s0)
    80008604:	fec42783          	lw	a5,-20(s0)
    80008608:	873e                	mv	a4,a5
    8000860a:	47fd                	li	a5,31
    8000860c:	00e7ea63          	bltu	a5,a4,80008620 <sys_exec+0x1a4>
    80008610:	fec42783          	lw	a5,-20(s0)
    80008614:	078e                	slli	a5,a5,0x3
    80008616:	17c1                	addi	a5,a5,-16
    80008618:	97a2                	add	a5,a5,s0
    8000861a:	e787b783          	ld	a5,-392(a5)
    8000861e:	f3f1                	bnez	a5,800085e2 <sys_exec+0x166>
  return -1;
    80008620:	57fd                	li	a5,-1
}
    80008622:	853e                	mv	a0,a5
    80008624:	70ba                	ld	ra,424(sp)
    80008626:	741a                	ld	s0,416(sp)
    80008628:	615d                	addi	sp,sp,432
    8000862a:	8082                	ret

000000008000862c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000862c:	7139                	addi	sp,sp,-64
    8000862e:	fc06                	sd	ra,56(sp)
    80008630:	f822                	sd	s0,48(sp)
    80008632:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80008634:	ffffa097          	auipc	ra,0xffffa
    80008638:	212080e7          	jalr	530(ra) # 80002846 <myproc>
    8000863c:	fea43423          	sd	a0,-24(s0)

  argaddr(0, &fdarray);
    80008640:	fe040793          	addi	a5,s0,-32
    80008644:	85be                	mv	a1,a5
    80008646:	4501                	li	a0,0
    80008648:	ffffc097          	auipc	ra,0xffffc
    8000864c:	a92080e7          	jalr	-1390(ra) # 800040da <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80008650:	fd040713          	addi	a4,s0,-48
    80008654:	fd840793          	addi	a5,s0,-40
    80008658:	85ba                	mv	a1,a4
    8000865a:	853e                	mv	a0,a5
    8000865c:	ffffe097          	auipc	ra,0xffffe
    80008660:	60e080e7          	jalr	1550(ra) # 80006c6a <pipealloc>
    80008664:	87aa                	mv	a5,a0
    80008666:	0007d463          	bgez	a5,8000866e <sys_pipe+0x42>
    return -1;
    8000866a:	57fd                	li	a5,-1
    8000866c:	a219                	j	80008772 <sys_pipe+0x146>
  fd0 = -1;
    8000866e:	57fd                	li	a5,-1
    80008670:	fcf42623          	sw	a5,-52(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80008674:	fd843783          	ld	a5,-40(s0)
    80008678:	853e                	mv	a0,a5
    8000867a:	fffff097          	auipc	ra,0xfffff
    8000867e:	104080e7          	jalr	260(ra) # 8000777e <fdalloc>
    80008682:	87aa                	mv	a5,a0
    80008684:	fcf42623          	sw	a5,-52(s0)
    80008688:	fcc42783          	lw	a5,-52(s0)
    8000868c:	0207c063          	bltz	a5,800086ac <sys_pipe+0x80>
    80008690:	fd043783          	ld	a5,-48(s0)
    80008694:	853e                	mv	a0,a5
    80008696:	fffff097          	auipc	ra,0xfffff
    8000869a:	0e8080e7          	jalr	232(ra) # 8000777e <fdalloc>
    8000869e:	87aa                	mv	a5,a0
    800086a0:	fcf42423          	sw	a5,-56(s0)
    800086a4:	fc842783          	lw	a5,-56(s0)
    800086a8:	0207df63          	bgez	a5,800086e6 <sys_pipe+0xba>
    if(fd0 >= 0)
    800086ac:	fcc42783          	lw	a5,-52(s0)
    800086b0:	0007cb63          	bltz	a5,800086c6 <sys_pipe+0x9a>
      p->ofile[fd0] = 0;
    800086b4:	fcc42783          	lw	a5,-52(s0)
    800086b8:	fe843703          	ld	a4,-24(s0)
    800086bc:	07e9                	addi	a5,a5,26
    800086be:	078e                	slli	a5,a5,0x3
    800086c0:	97ba                	add	a5,a5,a4
    800086c2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800086c6:	fd843783          	ld	a5,-40(s0)
    800086ca:	853e                	mv	a0,a5
    800086cc:	ffffe097          	auipc	ra,0xffffe
    800086d0:	08c080e7          	jalr	140(ra) # 80006758 <fileclose>
    fileclose(wf);
    800086d4:	fd043783          	ld	a5,-48(s0)
    800086d8:	853e                	mv	a0,a5
    800086da:	ffffe097          	auipc	ra,0xffffe
    800086de:	07e080e7          	jalr	126(ra) # 80006758 <fileclose>
    return -1;
    800086e2:	57fd                	li	a5,-1
    800086e4:	a079                	j	80008772 <sys_pipe+0x146>
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800086e6:	fe843783          	ld	a5,-24(s0)
    800086ea:	6bbc                	ld	a5,80(a5)
    800086ec:	fe043703          	ld	a4,-32(s0)
    800086f0:	fcc40613          	addi	a2,s0,-52
    800086f4:	4691                	li	a3,4
    800086f6:	85ba                	mv	a1,a4
    800086f8:	853e                	mv	a0,a5
    800086fa:	ffffa097          	auipc	ra,0xffffa
    800086fe:	c16080e7          	jalr	-1002(ra) # 80002310 <copyout>
    80008702:	87aa                	mv	a5,a0
    80008704:	0207c463          	bltz	a5,8000872c <sys_pipe+0x100>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80008708:	fe843783          	ld	a5,-24(s0)
    8000870c:	6bb8                	ld	a4,80(a5)
    8000870e:	fe043783          	ld	a5,-32(s0)
    80008712:	0791                	addi	a5,a5,4
    80008714:	fc840613          	addi	a2,s0,-56
    80008718:	4691                	li	a3,4
    8000871a:	85be                	mv	a1,a5
    8000871c:	853a                	mv	a0,a4
    8000871e:	ffffa097          	auipc	ra,0xffffa
    80008722:	bf2080e7          	jalr	-1038(ra) # 80002310 <copyout>
    80008726:	87aa                	mv	a5,a0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80008728:	0407d463          	bgez	a5,80008770 <sys_pipe+0x144>
    p->ofile[fd0] = 0;
    8000872c:	fcc42783          	lw	a5,-52(s0)
    80008730:	fe843703          	ld	a4,-24(s0)
    80008734:	07e9                	addi	a5,a5,26
    80008736:	078e                	slli	a5,a5,0x3
    80008738:	97ba                	add	a5,a5,a4
    8000873a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000873e:	fc842783          	lw	a5,-56(s0)
    80008742:	fe843703          	ld	a4,-24(s0)
    80008746:	07e9                	addi	a5,a5,26
    80008748:	078e                	slli	a5,a5,0x3
    8000874a:	97ba                	add	a5,a5,a4
    8000874c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80008750:	fd843783          	ld	a5,-40(s0)
    80008754:	853e                	mv	a0,a5
    80008756:	ffffe097          	auipc	ra,0xffffe
    8000875a:	002080e7          	jalr	2(ra) # 80006758 <fileclose>
    fileclose(wf);
    8000875e:	fd043783          	ld	a5,-48(s0)
    80008762:	853e                	mv	a0,a5
    80008764:	ffffe097          	auipc	ra,0xffffe
    80008768:	ff4080e7          	jalr	-12(ra) # 80006758 <fileclose>
    return -1;
    8000876c:	57fd                	li	a5,-1
    8000876e:	a011                	j	80008772 <sys_pipe+0x146>
  }
  return 0;
    80008770:	4781                	li	a5,0
}
    80008772:	853e                	mv	a0,a5
    80008774:	70e2                	ld	ra,56(sp)
    80008776:	7442                	ld	s0,48(sp)
    80008778:	6121                	addi	sp,sp,64
    8000877a:	8082                	ret
    8000877c:	0000                	unimp
	...

0000000080008780 <kernelvec>:
    80008780:	7111                	addi	sp,sp,-256
    80008782:	e006                	sd	ra,0(sp)
    80008784:	e40a                	sd	sp,8(sp)
    80008786:	e80e                	sd	gp,16(sp)
    80008788:	ec12                	sd	tp,24(sp)
    8000878a:	f016                	sd	t0,32(sp)
    8000878c:	f41a                	sd	t1,40(sp)
    8000878e:	f81e                	sd	t2,48(sp)
    80008790:	fc22                	sd	s0,56(sp)
    80008792:	e0a6                	sd	s1,64(sp)
    80008794:	e4aa                	sd	a0,72(sp)
    80008796:	e8ae                	sd	a1,80(sp)
    80008798:	ecb2                	sd	a2,88(sp)
    8000879a:	f0b6                	sd	a3,96(sp)
    8000879c:	f4ba                	sd	a4,104(sp)
    8000879e:	f8be                	sd	a5,112(sp)
    800087a0:	fcc2                	sd	a6,120(sp)
    800087a2:	e146                	sd	a7,128(sp)
    800087a4:	e54a                	sd	s2,136(sp)
    800087a6:	e94e                	sd	s3,144(sp)
    800087a8:	ed52                	sd	s4,152(sp)
    800087aa:	f156                	sd	s5,160(sp)
    800087ac:	f55a                	sd	s6,168(sp)
    800087ae:	f95e                	sd	s7,176(sp)
    800087b0:	fd62                	sd	s8,184(sp)
    800087b2:	e1e6                	sd	s9,192(sp)
    800087b4:	e5ea                	sd	s10,200(sp)
    800087b6:	e9ee                	sd	s11,208(sp)
    800087b8:	edf2                	sd	t3,216(sp)
    800087ba:	f1f6                	sd	t4,224(sp)
    800087bc:	f5fa                	sd	t5,232(sp)
    800087be:	f9fe                	sd	t6,240(sp)
    800087c0:	d0afb0ef          	jal	80003cca <kerneltrap>
    800087c4:	6082                	ld	ra,0(sp)
    800087c6:	6122                	ld	sp,8(sp)
    800087c8:	61c2                	ld	gp,16(sp)
    800087ca:	7282                	ld	t0,32(sp)
    800087cc:	7322                	ld	t1,40(sp)
    800087ce:	73c2                	ld	t2,48(sp)
    800087d0:	7462                	ld	s0,56(sp)
    800087d2:	6486                	ld	s1,64(sp)
    800087d4:	6526                	ld	a0,72(sp)
    800087d6:	65c6                	ld	a1,80(sp)
    800087d8:	6666                	ld	a2,88(sp)
    800087da:	7686                	ld	a3,96(sp)
    800087dc:	7726                	ld	a4,104(sp)
    800087de:	77c6                	ld	a5,112(sp)
    800087e0:	7866                	ld	a6,120(sp)
    800087e2:	688a                	ld	a7,128(sp)
    800087e4:	692a                	ld	s2,136(sp)
    800087e6:	69ca                	ld	s3,144(sp)
    800087e8:	6a6a                	ld	s4,152(sp)
    800087ea:	7a8a                	ld	s5,160(sp)
    800087ec:	7b2a                	ld	s6,168(sp)
    800087ee:	7bca                	ld	s7,176(sp)
    800087f0:	7c6a                	ld	s8,184(sp)
    800087f2:	6c8e                	ld	s9,192(sp)
    800087f4:	6d2e                	ld	s10,200(sp)
    800087f6:	6dce                	ld	s11,208(sp)
    800087f8:	6e6e                	ld	t3,216(sp)
    800087fa:	7e8e                	ld	t4,224(sp)
    800087fc:	7f2e                	ld	t5,232(sp)
    800087fe:	7fce                	ld	t6,240(sp)
    80008800:	6111                	addi	sp,sp,256
    80008802:	10200073          	sret
    80008806:	00000013          	nop
    8000880a:	00000013          	nop
    8000880e:	0001                	nop

0000000080008810 <timervec>:
    80008810:	34051573          	csrrw	a0,mscratch,a0
    80008814:	e10c                	sd	a1,0(a0)
    80008816:	e510                	sd	a2,8(a0)
    80008818:	e914                	sd	a3,16(a0)
    8000881a:	6d0c                	ld	a1,24(a0)
    8000881c:	7110                	ld	a2,32(a0)
    8000881e:	6194                	ld	a3,0(a1)
    80008820:	96b2                	add	a3,a3,a2
    80008822:	e194                	sd	a3,0(a1)
    80008824:	4589                	li	a1,2
    80008826:	14459073          	csrw	sip,a1
    8000882a:	6914                	ld	a3,16(a0)
    8000882c:	6510                	ld	a2,8(a0)
    8000882e:	610c                	ld	a1,0(a0)
    80008830:	34051573          	csrrw	a0,mscratch,a0
    80008834:	30200073          	mret
	...

000000008000883a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000883a:	1141                	addi	sp,sp,-16
    8000883c:	e422                	sd	s0,8(sp)
    8000883e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80008840:	0c0007b7          	lui	a5,0xc000
    80008844:	02878793          	addi	a5,a5,40 # c000028 <_entry-0x73ffffd8>
    80008848:	4705                	li	a4,1
    8000884a:	c398                	sw	a4,0(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000884c:	0c0007b7          	lui	a5,0xc000
    80008850:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
    80008852:	4705                	li	a4,1
    80008854:	c398                	sw	a4,0(a5)
}
    80008856:	0001                	nop
    80008858:	6422                	ld	s0,8(sp)
    8000885a:	0141                	addi	sp,sp,16
    8000885c:	8082                	ret

000000008000885e <plicinithart>:

void
plicinithart(void)
{
    8000885e:	1101                	addi	sp,sp,-32
    80008860:	ec06                	sd	ra,24(sp)
    80008862:	e822                	sd	s0,16(sp)
    80008864:	1000                	addi	s0,sp,32
  int hart = cpuid();
    80008866:	ffffa097          	auipc	ra,0xffffa
    8000886a:	f82080e7          	jalr	-126(ra) # 800027e8 <cpuid>
    8000886e:	87aa                	mv	a5,a0
    80008870:	fef42623          	sw	a5,-20(s0)
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80008874:	fec42783          	lw	a5,-20(s0)
    80008878:	0087979b          	slliw	a5,a5,0x8
    8000887c:	2781                	sext.w	a5,a5
    8000887e:	873e                	mv	a4,a5
    80008880:	0c0027b7          	lui	a5,0xc002
    80008884:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x73ffdf80>
    80008888:	97ba                	add	a5,a5,a4
    8000888a:	873e                	mv	a4,a5
    8000888c:	40200793          	li	a5,1026
    80008890:	c31c                	sw	a5,0(a4)

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80008892:	fec42783          	lw	a5,-20(s0)
    80008896:	00d7979b          	slliw	a5,a5,0xd
    8000889a:	2781                	sext.w	a5,a5
    8000889c:	873e                	mv	a4,a5
    8000889e:	0c2017b7          	lui	a5,0xc201
    800088a2:	97ba                	add	a5,a5,a4
    800088a4:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800088a8:	0001                	nop
    800088aa:	60e2                	ld	ra,24(sp)
    800088ac:	6442                	ld	s0,16(sp)
    800088ae:	6105                	addi	sp,sp,32
    800088b0:	8082                	ret

00000000800088b2 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800088b2:	1101                	addi	sp,sp,-32
    800088b4:	ec06                	sd	ra,24(sp)
    800088b6:	e822                	sd	s0,16(sp)
    800088b8:	1000                	addi	s0,sp,32
  int hart = cpuid();
    800088ba:	ffffa097          	auipc	ra,0xffffa
    800088be:	f2e080e7          	jalr	-210(ra) # 800027e8 <cpuid>
    800088c2:	87aa                	mv	a5,a0
    800088c4:	fef42623          	sw	a5,-20(s0)
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800088c8:	fec42783          	lw	a5,-20(s0)
    800088cc:	00d7979b          	slliw	a5,a5,0xd
    800088d0:	2781                	sext.w	a5,a5
    800088d2:	873e                	mv	a4,a5
    800088d4:	0c2017b7          	lui	a5,0xc201
    800088d8:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    800088da:	97ba                	add	a5,a5,a4
    800088dc:	439c                	lw	a5,0(a5)
    800088de:	fef42423          	sw	a5,-24(s0)
  return irq;
    800088e2:	fe842783          	lw	a5,-24(s0)
}
    800088e6:	853e                	mv	a0,a5
    800088e8:	60e2                	ld	ra,24(sp)
    800088ea:	6442                	ld	s0,16(sp)
    800088ec:	6105                	addi	sp,sp,32
    800088ee:	8082                	ret

00000000800088f0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800088f0:	7179                	addi	sp,sp,-48
    800088f2:	f406                	sd	ra,40(sp)
    800088f4:	f022                	sd	s0,32(sp)
    800088f6:	1800                	addi	s0,sp,48
    800088f8:	87aa                	mv	a5,a0
    800088fa:	fcf42e23          	sw	a5,-36(s0)
  int hart = cpuid();
    800088fe:	ffffa097          	auipc	ra,0xffffa
    80008902:	eea080e7          	jalr	-278(ra) # 800027e8 <cpuid>
    80008906:	87aa                	mv	a5,a0
    80008908:	fef42623          	sw	a5,-20(s0)
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000890c:	fec42783          	lw	a5,-20(s0)
    80008910:	00d7979b          	slliw	a5,a5,0xd
    80008914:	2781                	sext.w	a5,a5
    80008916:	873e                	mv	a4,a5
    80008918:	0c2017b7          	lui	a5,0xc201
    8000891c:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    8000891e:	97ba                	add	a5,a5,a4
    80008920:	873e                	mv	a4,a5
    80008922:	fdc42783          	lw	a5,-36(s0)
    80008926:	c31c                	sw	a5,0(a4)
}
    80008928:	0001                	nop
    8000892a:	70a2                	ld	ra,40(sp)
    8000892c:	7402                	ld	s0,32(sp)
    8000892e:	6145                	addi	sp,sp,48
    80008930:	8082                	ret

0000000080008932 <virtio_disk_init>:
  
} disk;

void
virtio_disk_init(void)
{
    80008932:	7179                	addi	sp,sp,-48
    80008934:	f406                	sd	ra,40(sp)
    80008936:	f022                	sd	s0,32(sp)
    80008938:	1800                	addi	s0,sp,48
  uint32 status = 0;
    8000893a:	fe042423          	sw	zero,-24(s0)

  initlock(&disk.vdisk_lock, "virtio_disk");
    8000893e:	00003597          	auipc	a1,0x3
    80008942:	d1a58593          	addi	a1,a1,-742 # 8000b658 <etext+0x658>
    80008946:	0001f517          	auipc	a0,0x1f
    8000894a:	94a50513          	addi	a0,a0,-1718 # 80027290 <disk+0x128>
    8000894e:	ffff9097          	auipc	ra,0xffff9
    80008952:	900080e7          	jalr	-1792(ra) # 8000124e <initlock>

  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80008956:	100017b7          	lui	a5,0x10001
    8000895a:	439c                	lw	a5,0(a5)
    8000895c:	2781                	sext.w	a5,a5
    8000895e:	873e                	mv	a4,a5
    80008960:	747277b7          	lui	a5,0x74727
    80008964:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80008968:	04f71063          	bne	a4,a5,800089a8 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000896c:	100017b7          	lui	a5,0x10001
    80008970:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80008972:	439c                	lw	a5,0(a5)
    80008974:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80008976:	873e                	mv	a4,a5
    80008978:	4789                	li	a5,2
    8000897a:	02f71763          	bne	a4,a5,800089a8 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000897e:	100017b7          	lui	a5,0x10001
    80008982:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80008984:	439c                	lw	a5,0(a5)
    80008986:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80008988:	873e                	mv	a4,a5
    8000898a:	4789                	li	a5,2
    8000898c:	00f71e63          	bne	a4,a5,800089a8 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80008990:	100017b7          	lui	a5,0x10001
    80008994:	07b1                	addi	a5,a5,12 # 1000100c <_entry-0x6fffeff4>
    80008996:	439c                	lw	a5,0(a5)
    80008998:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000899a:	873e                	mv	a4,a5
    8000899c:	554d47b7          	lui	a5,0x554d4
    800089a0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800089a4:	00f70a63          	beq	a4,a5,800089b8 <virtio_disk_init+0x86>
    panic("could not find virtio disk");
    800089a8:	00003517          	auipc	a0,0x3
    800089ac:	cc050513          	addi	a0,a0,-832 # 8000b668 <etext+0x668>
    800089b0:	ffff8097          	auipc	ra,0xffff8
    800089b4:	2da080e7          	jalr	730(ra) # 80000c8a <panic>
  }
  
  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    800089b8:	100017b7          	lui	a5,0x10001
    800089bc:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    800089c0:	fe842703          	lw	a4,-24(s0)
    800089c4:	c398                	sw	a4,0(a5)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
    800089c6:	fe842783          	lw	a5,-24(s0)
    800089ca:	0017e793          	ori	a5,a5,1
    800089ce:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    800089d2:	100017b7          	lui	a5,0x10001
    800089d6:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    800089da:	fe842703          	lw	a4,-24(s0)
    800089de:	c398                	sw	a4,0(a5)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
    800089e0:	fe842783          	lw	a5,-24(s0)
    800089e4:	0027e793          	ori	a5,a5,2
    800089e8:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    800089ec:	100017b7          	lui	a5,0x10001
    800089f0:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    800089f4:	fe842703          	lw	a4,-24(s0)
    800089f8:	c398                	sw	a4,0(a5)

  // negotiate features
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800089fa:	100017b7          	lui	a5,0x10001
    800089fe:	07c1                	addi	a5,a5,16 # 10001010 <_entry-0x6fffeff0>
    80008a00:	439c                	lw	a5,0(a5)
    80008a02:	2781                	sext.w	a5,a5
    80008a04:	1782                	slli	a5,a5,0x20
    80008a06:	9381                	srli	a5,a5,0x20
    80008a08:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_RO);
    80008a0c:	fe043783          	ld	a5,-32(s0)
    80008a10:	fdf7f793          	andi	a5,a5,-33
    80008a14:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_SCSI);
    80008a18:	fe043783          	ld	a5,-32(s0)
    80008a1c:	f7f7f793          	andi	a5,a5,-129
    80008a20:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_CONFIG_WCE);
    80008a24:	fe043703          	ld	a4,-32(s0)
    80008a28:	77fd                	lui	a5,0xfffff
    80008a2a:	7ff78793          	addi	a5,a5,2047 # fffffffffffff7ff <end+0xffffffff7ffd8557>
    80008a2e:	8ff9                	and	a5,a5,a4
    80008a30:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_MQ);
    80008a34:	fe043703          	ld	a4,-32(s0)
    80008a38:	77fd                	lui	a5,0xfffff
    80008a3a:	17fd                	addi	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffd7d57>
    80008a3c:	8ff9                	and	a5,a5,a4
    80008a3e:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_F_ANY_LAYOUT);
    80008a42:	fe043703          	ld	a4,-32(s0)
    80008a46:	f80007b7          	lui	a5,0xf8000
    80008a4a:	17fd                	addi	a5,a5,-1 # fffffffff7ffffff <end+0xffffffff77fd8d57>
    80008a4c:	8ff9                	and	a5,a5,a4
    80008a4e:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_EVENT_IDX);
    80008a52:	fe043703          	ld	a4,-32(s0)
    80008a56:	e00007b7          	lui	a5,0xe0000
    80008a5a:	17fd                	addi	a5,a5,-1 # ffffffffdfffffff <end+0xffffffff5ffd8d57>
    80008a5c:	8ff9                	and	a5,a5,a4
    80008a5e:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80008a62:	fe043703          	ld	a4,-32(s0)
    80008a66:	f00007b7          	lui	a5,0xf0000
    80008a6a:	17fd                	addi	a5,a5,-1 # ffffffffefffffff <end+0xffffffff6ffd8d57>
    80008a6c:	8ff9                	and	a5,a5,a4
    80008a6e:	fef43023          	sd	a5,-32(s0)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80008a72:	100017b7          	lui	a5,0x10001
    80008a76:	02078793          	addi	a5,a5,32 # 10001020 <_entry-0x6fffefe0>
    80008a7a:	fe043703          	ld	a4,-32(s0)
    80008a7e:	2701                	sext.w	a4,a4
    80008a80:	c398                	sw	a4,0(a5)

  // tell device that feature negotiation is complete.
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
    80008a82:	fe842783          	lw	a5,-24(s0)
    80008a86:	0087e793          	ori	a5,a5,8
    80008a8a:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008a8e:	100017b7          	lui	a5,0x10001
    80008a92:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008a96:	fe842703          	lw	a4,-24(s0)
    80008a9a:	c398                	sw	a4,0(a5)

  // re-read status to ensure FEATURES_OK is set.
  status = *R(VIRTIO_MMIO_STATUS);
    80008a9c:	100017b7          	lui	a5,0x10001
    80008aa0:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008aa4:	439c                	lw	a5,0(a5)
    80008aa6:	fef42423          	sw	a5,-24(s0)
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80008aaa:	fe842783          	lw	a5,-24(s0)
    80008aae:	8ba1                	andi	a5,a5,8
    80008ab0:	2781                	sext.w	a5,a5
    80008ab2:	eb89                	bnez	a5,80008ac4 <virtio_disk_init+0x192>
    panic("virtio disk FEATURES_OK unset");
    80008ab4:	00003517          	auipc	a0,0x3
    80008ab8:	bd450513          	addi	a0,a0,-1068 # 8000b688 <etext+0x688>
    80008abc:	ffff8097          	auipc	ra,0xffff8
    80008ac0:	1ce080e7          	jalr	462(ra) # 80000c8a <panic>

  // initialize queue 0.
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80008ac4:	100017b7          	lui	a5,0x10001
    80008ac8:	03078793          	addi	a5,a5,48 # 10001030 <_entry-0x6fffefd0>
    80008acc:	0007a023          	sw	zero,0(a5)

  // ensure queue 0 is not in use.
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80008ad0:	100017b7          	lui	a5,0x10001
    80008ad4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80008ad8:	439c                	lw	a5,0(a5)
    80008ada:	2781                	sext.w	a5,a5
    80008adc:	cb89                	beqz	a5,80008aee <virtio_disk_init+0x1bc>
    panic("virtio disk should not be ready");
    80008ade:	00003517          	auipc	a0,0x3
    80008ae2:	bca50513          	addi	a0,a0,-1078 # 8000b6a8 <etext+0x6a8>
    80008ae6:	ffff8097          	auipc	ra,0xffff8
    80008aea:	1a4080e7          	jalr	420(ra) # 80000c8a <panic>

  // check maximum queue size.
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80008aee:	100017b7          	lui	a5,0x10001
    80008af2:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80008af6:	439c                	lw	a5,0(a5)
    80008af8:	fcf42e23          	sw	a5,-36(s0)
  if(max == 0)
    80008afc:	fdc42783          	lw	a5,-36(s0)
    80008b00:	2781                	sext.w	a5,a5
    80008b02:	eb89                	bnez	a5,80008b14 <virtio_disk_init+0x1e2>
    panic("virtio disk has no queue 0");
    80008b04:	00003517          	auipc	a0,0x3
    80008b08:	bc450513          	addi	a0,a0,-1084 # 8000b6c8 <etext+0x6c8>
    80008b0c:	ffff8097          	auipc	ra,0xffff8
    80008b10:	17e080e7          	jalr	382(ra) # 80000c8a <panic>
  if(max < NUM)
    80008b14:	fdc42783          	lw	a5,-36(s0)
    80008b18:	0007871b          	sext.w	a4,a5
    80008b1c:	479d                	li	a5,7
    80008b1e:	00e7ea63          	bltu	a5,a4,80008b32 <virtio_disk_init+0x200>
    panic("virtio disk max queue too short");
    80008b22:	00003517          	auipc	a0,0x3
    80008b26:	bc650513          	addi	a0,a0,-1082 # 8000b6e8 <etext+0x6e8>
    80008b2a:	ffff8097          	auipc	ra,0xffff8
    80008b2e:	160080e7          	jalr	352(ra) # 80000c8a <panic>

  // allocate and zero queue memory.
  disk.desc = kalloc();
    80008b32:	ffff8097          	auipc	ra,0xffff8
    80008b36:	5f8080e7          	jalr	1528(ra) # 8000112a <kalloc>
    80008b3a:	872a                	mv	a4,a0
    80008b3c:	0001e797          	auipc	a5,0x1e
    80008b40:	62c78793          	addi	a5,a5,1580 # 80027168 <disk>
    80008b44:	e398                	sd	a4,0(a5)
  disk.avail = kalloc();
    80008b46:	ffff8097          	auipc	ra,0xffff8
    80008b4a:	5e4080e7          	jalr	1508(ra) # 8000112a <kalloc>
    80008b4e:	872a                	mv	a4,a0
    80008b50:	0001e797          	auipc	a5,0x1e
    80008b54:	61878793          	addi	a5,a5,1560 # 80027168 <disk>
    80008b58:	e798                	sd	a4,8(a5)
  disk.used = kalloc();
    80008b5a:	ffff8097          	auipc	ra,0xffff8
    80008b5e:	5d0080e7          	jalr	1488(ra) # 8000112a <kalloc>
    80008b62:	872a                	mv	a4,a0
    80008b64:	0001e797          	auipc	a5,0x1e
    80008b68:	60478793          	addi	a5,a5,1540 # 80027168 <disk>
    80008b6c:	eb98                	sd	a4,16(a5)
  if(!disk.desc || !disk.avail || !disk.used)
    80008b6e:	0001e797          	auipc	a5,0x1e
    80008b72:	5fa78793          	addi	a5,a5,1530 # 80027168 <disk>
    80008b76:	639c                	ld	a5,0(a5)
    80008b78:	cf89                	beqz	a5,80008b92 <virtio_disk_init+0x260>
    80008b7a:	0001e797          	auipc	a5,0x1e
    80008b7e:	5ee78793          	addi	a5,a5,1518 # 80027168 <disk>
    80008b82:	679c                	ld	a5,8(a5)
    80008b84:	c799                	beqz	a5,80008b92 <virtio_disk_init+0x260>
    80008b86:	0001e797          	auipc	a5,0x1e
    80008b8a:	5e278793          	addi	a5,a5,1506 # 80027168 <disk>
    80008b8e:	6b9c                	ld	a5,16(a5)
    80008b90:	eb89                	bnez	a5,80008ba2 <virtio_disk_init+0x270>
    panic("virtio disk kalloc");
    80008b92:	00003517          	auipc	a0,0x3
    80008b96:	b7650513          	addi	a0,a0,-1162 # 8000b708 <etext+0x708>
    80008b9a:	ffff8097          	auipc	ra,0xffff8
    80008b9e:	0f0080e7          	jalr	240(ra) # 80000c8a <panic>
  memset(disk.desc, 0, PGSIZE);
    80008ba2:	0001e797          	auipc	a5,0x1e
    80008ba6:	5c678793          	addi	a5,a5,1478 # 80027168 <disk>
    80008baa:	639c                	ld	a5,0(a5)
    80008bac:	6605                	lui	a2,0x1
    80008bae:	4581                	li	a1,0
    80008bb0:	853e                	mv	a0,a5
    80008bb2:	ffff9097          	auipc	ra,0xffff9
    80008bb6:	8a0080e7          	jalr	-1888(ra) # 80001452 <memset>
  memset(disk.avail, 0, PGSIZE);
    80008bba:	0001e797          	auipc	a5,0x1e
    80008bbe:	5ae78793          	addi	a5,a5,1454 # 80027168 <disk>
    80008bc2:	679c                	ld	a5,8(a5)
    80008bc4:	6605                	lui	a2,0x1
    80008bc6:	4581                	li	a1,0
    80008bc8:	853e                	mv	a0,a5
    80008bca:	ffff9097          	auipc	ra,0xffff9
    80008bce:	888080e7          	jalr	-1912(ra) # 80001452 <memset>
  memset(disk.used, 0, PGSIZE);
    80008bd2:	0001e797          	auipc	a5,0x1e
    80008bd6:	59678793          	addi	a5,a5,1430 # 80027168 <disk>
    80008bda:	6b9c                	ld	a5,16(a5)
    80008bdc:	6605                	lui	a2,0x1
    80008bde:	4581                	li	a1,0
    80008be0:	853e                	mv	a0,a5
    80008be2:	ffff9097          	auipc	ra,0xffff9
    80008be6:	870080e7          	jalr	-1936(ra) # 80001452 <memset>

  // set queue size.
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80008bea:	100017b7          	lui	a5,0x10001
    80008bee:	03878793          	addi	a5,a5,56 # 10001038 <_entry-0x6fffefc8>
    80008bf2:	4721                	li	a4,8
    80008bf4:	c398                	sw	a4,0(a5)

  // write physical addresses.
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80008bf6:	0001e797          	auipc	a5,0x1e
    80008bfa:	57278793          	addi	a5,a5,1394 # 80027168 <disk>
    80008bfe:	639c                	ld	a5,0(a5)
    80008c00:	873e                	mv	a4,a5
    80008c02:	100017b7          	lui	a5,0x10001
    80008c06:	08078793          	addi	a5,a5,128 # 10001080 <_entry-0x6fffef80>
    80008c0a:	2701                	sext.w	a4,a4
    80008c0c:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80008c0e:	0001e797          	auipc	a5,0x1e
    80008c12:	55a78793          	addi	a5,a5,1370 # 80027168 <disk>
    80008c16:	639c                	ld	a5,0(a5)
    80008c18:	0207d713          	srli	a4,a5,0x20
    80008c1c:	100017b7          	lui	a5,0x10001
    80008c20:	08478793          	addi	a5,a5,132 # 10001084 <_entry-0x6fffef7c>
    80008c24:	2701                	sext.w	a4,a4
    80008c26:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80008c28:	0001e797          	auipc	a5,0x1e
    80008c2c:	54078793          	addi	a5,a5,1344 # 80027168 <disk>
    80008c30:	679c                	ld	a5,8(a5)
    80008c32:	873e                	mv	a4,a5
    80008c34:	100017b7          	lui	a5,0x10001
    80008c38:	09078793          	addi	a5,a5,144 # 10001090 <_entry-0x6fffef70>
    80008c3c:	2701                	sext.w	a4,a4
    80008c3e:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80008c40:	0001e797          	auipc	a5,0x1e
    80008c44:	52878793          	addi	a5,a5,1320 # 80027168 <disk>
    80008c48:	679c                	ld	a5,8(a5)
    80008c4a:	0207d713          	srli	a4,a5,0x20
    80008c4e:	100017b7          	lui	a5,0x10001
    80008c52:	09478793          	addi	a5,a5,148 # 10001094 <_entry-0x6fffef6c>
    80008c56:	2701                	sext.w	a4,a4
    80008c58:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80008c5a:	0001e797          	auipc	a5,0x1e
    80008c5e:	50e78793          	addi	a5,a5,1294 # 80027168 <disk>
    80008c62:	6b9c                	ld	a5,16(a5)
    80008c64:	873e                	mv	a4,a5
    80008c66:	100017b7          	lui	a5,0x10001
    80008c6a:	0a078793          	addi	a5,a5,160 # 100010a0 <_entry-0x6fffef60>
    80008c6e:	2701                	sext.w	a4,a4
    80008c70:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80008c72:	0001e797          	auipc	a5,0x1e
    80008c76:	4f678793          	addi	a5,a5,1270 # 80027168 <disk>
    80008c7a:	6b9c                	ld	a5,16(a5)
    80008c7c:	0207d713          	srli	a4,a5,0x20
    80008c80:	100017b7          	lui	a5,0x10001
    80008c84:	0a478793          	addi	a5,a5,164 # 100010a4 <_entry-0x6fffef5c>
    80008c88:	2701                	sext.w	a4,a4
    80008c8a:	c398                	sw	a4,0(a5)

  // queue is ready.
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80008c8c:	100017b7          	lui	a5,0x10001
    80008c90:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80008c94:	4705                	li	a4,1
    80008c96:	c398                	sw	a4,0(a5)

  // all NUM descriptors start out unused.
  for(int i = 0; i < NUM; i++)
    80008c98:	fe042623          	sw	zero,-20(s0)
    80008c9c:	a005                	j	80008cbc <virtio_disk_init+0x38a>
    disk.free[i] = 1;
    80008c9e:	0001e717          	auipc	a4,0x1e
    80008ca2:	4ca70713          	addi	a4,a4,1226 # 80027168 <disk>
    80008ca6:	fec42783          	lw	a5,-20(s0)
    80008caa:	97ba                	add	a5,a5,a4
    80008cac:	4705                	li	a4,1
    80008cae:	00e78c23          	sb	a4,24(a5)
  for(int i = 0; i < NUM; i++)
    80008cb2:	fec42783          	lw	a5,-20(s0)
    80008cb6:	2785                	addiw	a5,a5,1
    80008cb8:	fef42623          	sw	a5,-20(s0)
    80008cbc:	fec42783          	lw	a5,-20(s0)
    80008cc0:	0007871b          	sext.w	a4,a5
    80008cc4:	479d                	li	a5,7
    80008cc6:	fce7dce3          	bge	a5,a4,80008c9e <virtio_disk_init+0x36c>

  // tell device we're completely ready.
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80008cca:	fe842783          	lw	a5,-24(s0)
    80008cce:	0047e793          	ori	a5,a5,4
    80008cd2:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008cd6:	100017b7          	lui	a5,0x10001
    80008cda:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008cde:	fe842703          	lw	a4,-24(s0)
    80008ce2:	c398                	sw	a4,0(a5)

  // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}
    80008ce4:	0001                	nop
    80008ce6:	70a2                	ld	ra,40(sp)
    80008ce8:	7402                	ld	s0,32(sp)
    80008cea:	6145                	addi	sp,sp,48
    80008cec:	8082                	ret

0000000080008cee <alloc_desc>:

// find a free descriptor, mark it non-free, return its index.
static int
alloc_desc()
{
    80008cee:	1101                	addi	sp,sp,-32
    80008cf0:	ec22                	sd	s0,24(sp)
    80008cf2:	1000                	addi	s0,sp,32
  for(int i = 0; i < NUM; i++){
    80008cf4:	fe042623          	sw	zero,-20(s0)
    80008cf8:	a825                	j	80008d30 <alloc_desc+0x42>
    if(disk.free[i]){
    80008cfa:	0001e717          	auipc	a4,0x1e
    80008cfe:	46e70713          	addi	a4,a4,1134 # 80027168 <disk>
    80008d02:	fec42783          	lw	a5,-20(s0)
    80008d06:	97ba                	add	a5,a5,a4
    80008d08:	0187c783          	lbu	a5,24(a5)
    80008d0c:	cf89                	beqz	a5,80008d26 <alloc_desc+0x38>
      disk.free[i] = 0;
    80008d0e:	0001e717          	auipc	a4,0x1e
    80008d12:	45a70713          	addi	a4,a4,1114 # 80027168 <disk>
    80008d16:	fec42783          	lw	a5,-20(s0)
    80008d1a:	97ba                	add	a5,a5,a4
    80008d1c:	00078c23          	sb	zero,24(a5)
      return i;
    80008d20:	fec42783          	lw	a5,-20(s0)
    80008d24:	a831                	j	80008d40 <alloc_desc+0x52>
  for(int i = 0; i < NUM; i++){
    80008d26:	fec42783          	lw	a5,-20(s0)
    80008d2a:	2785                	addiw	a5,a5,1
    80008d2c:	fef42623          	sw	a5,-20(s0)
    80008d30:	fec42783          	lw	a5,-20(s0)
    80008d34:	0007871b          	sext.w	a4,a5
    80008d38:	479d                	li	a5,7
    80008d3a:	fce7d0e3          	bge	a5,a4,80008cfa <alloc_desc+0xc>
    }
  }
  return -1;
    80008d3e:	57fd                	li	a5,-1
}
    80008d40:	853e                	mv	a0,a5
    80008d42:	6462                	ld	s0,24(sp)
    80008d44:	6105                	addi	sp,sp,32
    80008d46:	8082                	ret

0000000080008d48 <free_desc>:

// mark a descriptor as free.
static void
free_desc(int i)
{
    80008d48:	1101                	addi	sp,sp,-32
    80008d4a:	ec06                	sd	ra,24(sp)
    80008d4c:	e822                	sd	s0,16(sp)
    80008d4e:	1000                	addi	s0,sp,32
    80008d50:	87aa                	mv	a5,a0
    80008d52:	fef42623          	sw	a5,-20(s0)
  if(i >= NUM)
    80008d56:	fec42783          	lw	a5,-20(s0)
    80008d5a:	0007871b          	sext.w	a4,a5
    80008d5e:	479d                	li	a5,7
    80008d60:	00e7da63          	bge	a5,a4,80008d74 <free_desc+0x2c>
    panic("free_desc 1");
    80008d64:	00003517          	auipc	a0,0x3
    80008d68:	9bc50513          	addi	a0,a0,-1604 # 8000b720 <etext+0x720>
    80008d6c:	ffff8097          	auipc	ra,0xffff8
    80008d70:	f1e080e7          	jalr	-226(ra) # 80000c8a <panic>
  if(disk.free[i])
    80008d74:	0001e717          	auipc	a4,0x1e
    80008d78:	3f470713          	addi	a4,a4,1012 # 80027168 <disk>
    80008d7c:	fec42783          	lw	a5,-20(s0)
    80008d80:	97ba                	add	a5,a5,a4
    80008d82:	0187c783          	lbu	a5,24(a5)
    80008d86:	cb89                	beqz	a5,80008d98 <free_desc+0x50>
    panic("free_desc 2");
    80008d88:	00003517          	auipc	a0,0x3
    80008d8c:	9a850513          	addi	a0,a0,-1624 # 8000b730 <etext+0x730>
    80008d90:	ffff8097          	auipc	ra,0xffff8
    80008d94:	efa080e7          	jalr	-262(ra) # 80000c8a <panic>
  disk.desc[i].addr = 0;
    80008d98:	0001e797          	auipc	a5,0x1e
    80008d9c:	3d078793          	addi	a5,a5,976 # 80027168 <disk>
    80008da0:	6398                	ld	a4,0(a5)
    80008da2:	fec42783          	lw	a5,-20(s0)
    80008da6:	0792                	slli	a5,a5,0x4
    80008da8:	97ba                	add	a5,a5,a4
    80008daa:	0007b023          	sd	zero,0(a5)
  disk.desc[i].len = 0;
    80008dae:	0001e797          	auipc	a5,0x1e
    80008db2:	3ba78793          	addi	a5,a5,954 # 80027168 <disk>
    80008db6:	6398                	ld	a4,0(a5)
    80008db8:	fec42783          	lw	a5,-20(s0)
    80008dbc:	0792                	slli	a5,a5,0x4
    80008dbe:	97ba                	add	a5,a5,a4
    80008dc0:	0007a423          	sw	zero,8(a5)
  disk.desc[i].flags = 0;
    80008dc4:	0001e797          	auipc	a5,0x1e
    80008dc8:	3a478793          	addi	a5,a5,932 # 80027168 <disk>
    80008dcc:	6398                	ld	a4,0(a5)
    80008dce:	fec42783          	lw	a5,-20(s0)
    80008dd2:	0792                	slli	a5,a5,0x4
    80008dd4:	97ba                	add	a5,a5,a4
    80008dd6:	00079623          	sh	zero,12(a5)
  disk.desc[i].next = 0;
    80008dda:	0001e797          	auipc	a5,0x1e
    80008dde:	38e78793          	addi	a5,a5,910 # 80027168 <disk>
    80008de2:	6398                	ld	a4,0(a5)
    80008de4:	fec42783          	lw	a5,-20(s0)
    80008de8:	0792                	slli	a5,a5,0x4
    80008dea:	97ba                	add	a5,a5,a4
    80008dec:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80008df0:	0001e717          	auipc	a4,0x1e
    80008df4:	37870713          	addi	a4,a4,888 # 80027168 <disk>
    80008df8:	fec42783          	lw	a5,-20(s0)
    80008dfc:	97ba                	add	a5,a5,a4
    80008dfe:	4705                	li	a4,1
    80008e00:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80008e04:	0001e517          	auipc	a0,0x1e
    80008e08:	37c50513          	addi	a0,a0,892 # 80027180 <disk+0x18>
    80008e0c:	ffffa097          	auipc	ra,0xffffa
    80008e10:	678080e7          	jalr	1656(ra) # 80003484 <wakeup>
}
    80008e14:	0001                	nop
    80008e16:	60e2                	ld	ra,24(sp)
    80008e18:	6442                	ld	s0,16(sp)
    80008e1a:	6105                	addi	sp,sp,32
    80008e1c:	8082                	ret

0000000080008e1e <free_chain>:

// free a chain of descriptors.
static void
free_chain(int i)
{
    80008e1e:	7179                	addi	sp,sp,-48
    80008e20:	f406                	sd	ra,40(sp)
    80008e22:	f022                	sd	s0,32(sp)
    80008e24:	1800                	addi	s0,sp,48
    80008e26:	87aa                	mv	a5,a0
    80008e28:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    int flag = disk.desc[i].flags;
    80008e2c:	0001e797          	auipc	a5,0x1e
    80008e30:	33c78793          	addi	a5,a5,828 # 80027168 <disk>
    80008e34:	6398                	ld	a4,0(a5)
    80008e36:	fdc42783          	lw	a5,-36(s0)
    80008e3a:	0792                	slli	a5,a5,0x4
    80008e3c:	97ba                	add	a5,a5,a4
    80008e3e:	00c7d783          	lhu	a5,12(a5)
    80008e42:	fef42623          	sw	a5,-20(s0)
    int nxt = disk.desc[i].next;
    80008e46:	0001e797          	auipc	a5,0x1e
    80008e4a:	32278793          	addi	a5,a5,802 # 80027168 <disk>
    80008e4e:	6398                	ld	a4,0(a5)
    80008e50:	fdc42783          	lw	a5,-36(s0)
    80008e54:	0792                	slli	a5,a5,0x4
    80008e56:	97ba                	add	a5,a5,a4
    80008e58:	00e7d783          	lhu	a5,14(a5)
    80008e5c:	fef42423          	sw	a5,-24(s0)
    free_desc(i);
    80008e60:	fdc42783          	lw	a5,-36(s0)
    80008e64:	853e                	mv	a0,a5
    80008e66:	00000097          	auipc	ra,0x0
    80008e6a:	ee2080e7          	jalr	-286(ra) # 80008d48 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80008e6e:	fec42783          	lw	a5,-20(s0)
    80008e72:	8b85                	andi	a5,a5,1
    80008e74:	2781                	sext.w	a5,a5
    80008e76:	c791                	beqz	a5,80008e82 <free_chain+0x64>
      i = nxt;
    80008e78:	fe842783          	lw	a5,-24(s0)
    80008e7c:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    80008e80:	b775                	j	80008e2c <free_chain+0xe>
    else
      break;
    80008e82:	0001                	nop
  }
}
    80008e84:	0001                	nop
    80008e86:	70a2                	ld	ra,40(sp)
    80008e88:	7402                	ld	s0,32(sp)
    80008e8a:	6145                	addi	sp,sp,48
    80008e8c:	8082                	ret

0000000080008e8e <alloc3_desc>:

// allocate three descriptors (they need not be contiguous).
// disk transfers always use three descriptors.
static int
alloc3_desc(int *idx)
{
    80008e8e:	7139                	addi	sp,sp,-64
    80008e90:	fc06                	sd	ra,56(sp)
    80008e92:	f822                	sd	s0,48(sp)
    80008e94:	f426                	sd	s1,40(sp)
    80008e96:	0080                	addi	s0,sp,64
    80008e98:	fca43423          	sd	a0,-56(s0)
  for(int i = 0; i < 3; i++){
    80008e9c:	fc042e23          	sw	zero,-36(s0)
    80008ea0:	a89d                	j	80008f16 <alloc3_desc+0x88>
    idx[i] = alloc_desc();
    80008ea2:	fdc42783          	lw	a5,-36(s0)
    80008ea6:	078a                	slli	a5,a5,0x2
    80008ea8:	fc843703          	ld	a4,-56(s0)
    80008eac:	00f704b3          	add	s1,a4,a5
    80008eb0:	00000097          	auipc	ra,0x0
    80008eb4:	e3e080e7          	jalr	-450(ra) # 80008cee <alloc_desc>
    80008eb8:	87aa                	mv	a5,a0
    80008eba:	c09c                	sw	a5,0(s1)
    if(idx[i] < 0){
    80008ebc:	fdc42783          	lw	a5,-36(s0)
    80008ec0:	078a                	slli	a5,a5,0x2
    80008ec2:	fc843703          	ld	a4,-56(s0)
    80008ec6:	97ba                	add	a5,a5,a4
    80008ec8:	439c                	lw	a5,0(a5)
    80008eca:	0407d163          	bgez	a5,80008f0c <alloc3_desc+0x7e>
      for(int j = 0; j < i; j++)
    80008ece:	fc042c23          	sw	zero,-40(s0)
    80008ed2:	a015                	j	80008ef6 <alloc3_desc+0x68>
        free_desc(idx[j]);
    80008ed4:	fd842783          	lw	a5,-40(s0)
    80008ed8:	078a                	slli	a5,a5,0x2
    80008eda:	fc843703          	ld	a4,-56(s0)
    80008ede:	97ba                	add	a5,a5,a4
    80008ee0:	439c                	lw	a5,0(a5)
    80008ee2:	853e                	mv	a0,a5
    80008ee4:	00000097          	auipc	ra,0x0
    80008ee8:	e64080e7          	jalr	-412(ra) # 80008d48 <free_desc>
      for(int j = 0; j < i; j++)
    80008eec:	fd842783          	lw	a5,-40(s0)
    80008ef0:	2785                	addiw	a5,a5,1
    80008ef2:	fcf42c23          	sw	a5,-40(s0)
    80008ef6:	fd842783          	lw	a5,-40(s0)
    80008efa:	873e                	mv	a4,a5
    80008efc:	fdc42783          	lw	a5,-36(s0)
    80008f00:	2701                	sext.w	a4,a4
    80008f02:	2781                	sext.w	a5,a5
    80008f04:	fcf748e3          	blt	a4,a5,80008ed4 <alloc3_desc+0x46>
      return -1;
    80008f08:	57fd                	li	a5,-1
    80008f0a:	a831                	j	80008f26 <alloc3_desc+0x98>
  for(int i = 0; i < 3; i++){
    80008f0c:	fdc42783          	lw	a5,-36(s0)
    80008f10:	2785                	addiw	a5,a5,1
    80008f12:	fcf42e23          	sw	a5,-36(s0)
    80008f16:	fdc42783          	lw	a5,-36(s0)
    80008f1a:	0007871b          	sext.w	a4,a5
    80008f1e:	4789                	li	a5,2
    80008f20:	f8e7d1e3          	bge	a5,a4,80008ea2 <alloc3_desc+0x14>
    }
  }
  return 0;
    80008f24:	4781                	li	a5,0
}
    80008f26:	853e                	mv	a0,a5
    80008f28:	70e2                	ld	ra,56(sp)
    80008f2a:	7442                	ld	s0,48(sp)
    80008f2c:	74a2                	ld	s1,40(sp)
    80008f2e:	6121                	addi	sp,sp,64
    80008f30:	8082                	ret

0000000080008f32 <virtio_disk_rw>:

void
virtio_disk_rw(struct buf *b, int write)
{
    80008f32:	7139                	addi	sp,sp,-64
    80008f34:	fc06                	sd	ra,56(sp)
    80008f36:	f822                	sd	s0,48(sp)
    80008f38:	0080                	addi	s0,sp,64
    80008f3a:	fca43423          	sd	a0,-56(s0)
    80008f3e:	87ae                	mv	a5,a1
    80008f40:	fcf42223          	sw	a5,-60(s0)
  uint64 sector = b->blockno * (BSIZE / 512);
    80008f44:	fc843783          	ld	a5,-56(s0)
    80008f48:	47dc                	lw	a5,12(a5)
    80008f4a:	0017979b          	slliw	a5,a5,0x1
    80008f4e:	2781                	sext.w	a5,a5
    80008f50:	1782                	slli	a5,a5,0x20
    80008f52:	9381                	srli	a5,a5,0x20
    80008f54:	fef43423          	sd	a5,-24(s0)

  acquire(&disk.vdisk_lock);
    80008f58:	0001e517          	auipc	a0,0x1e
    80008f5c:	33850513          	addi	a0,a0,824 # 80027290 <disk+0x128>
    80008f60:	ffff8097          	auipc	ra,0xffff8
    80008f64:	31e080e7          	jalr	798(ra) # 8000127e <acquire>
  // data, one for a 1-byte status result.

  // allocate the three descriptors.
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
    80008f68:	fd040793          	addi	a5,s0,-48
    80008f6c:	853e                	mv	a0,a5
    80008f6e:	00000097          	auipc	ra,0x0
    80008f72:	f20080e7          	jalr	-224(ra) # 80008e8e <alloc3_desc>
    80008f76:	87aa                	mv	a5,a0
    80008f78:	cf91                	beqz	a5,80008f94 <virtio_disk_rw+0x62>
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80008f7a:	0001e597          	auipc	a1,0x1e
    80008f7e:	31658593          	addi	a1,a1,790 # 80027290 <disk+0x128>
    80008f82:	0001e517          	auipc	a0,0x1e
    80008f86:	1fe50513          	addi	a0,a0,510 # 80027180 <disk+0x18>
    80008f8a:	ffffa097          	auipc	ra,0xffffa
    80008f8e:	47e080e7          	jalr	1150(ra) # 80003408 <sleep>
    if(alloc3_desc(idx) == 0) {
    80008f92:	bfd9                	j	80008f68 <virtio_disk_rw+0x36>
      break;
    80008f94:	0001                	nop
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80008f96:	fd042783          	lw	a5,-48(s0)
    80008f9a:	07a9                	addi	a5,a5,10
    80008f9c:	00479713          	slli	a4,a5,0x4
    80008fa0:	0001e797          	auipc	a5,0x1e
    80008fa4:	1c878793          	addi	a5,a5,456 # 80027168 <disk>
    80008fa8:	97ba                	add	a5,a5,a4
    80008faa:	07a1                	addi	a5,a5,8
    80008fac:	fef43023          	sd	a5,-32(s0)

  if(write)
    80008fb0:	fc442783          	lw	a5,-60(s0)
    80008fb4:	2781                	sext.w	a5,a5
    80008fb6:	c791                	beqz	a5,80008fc2 <virtio_disk_rw+0x90>
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80008fb8:	fe043783          	ld	a5,-32(s0)
    80008fbc:	4705                	li	a4,1
    80008fbe:	c398                	sw	a4,0(a5)
    80008fc0:	a029                	j	80008fca <virtio_disk_rw+0x98>
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80008fc2:	fe043783          	ld	a5,-32(s0)
    80008fc6:	0007a023          	sw	zero,0(a5)
  buf0->reserved = 0;
    80008fca:	fe043783          	ld	a5,-32(s0)
    80008fce:	0007a223          	sw	zero,4(a5)
  buf0->sector = sector;
    80008fd2:	fe043783          	ld	a5,-32(s0)
    80008fd6:	fe843703          	ld	a4,-24(s0)
    80008fda:	e798                	sd	a4,8(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80008fdc:	0001e797          	auipc	a5,0x1e
    80008fe0:	18c78793          	addi	a5,a5,396 # 80027168 <disk>
    80008fe4:	6398                	ld	a4,0(a5)
    80008fe6:	fd042783          	lw	a5,-48(s0)
    80008fea:	0792                	slli	a5,a5,0x4
    80008fec:	97ba                	add	a5,a5,a4
    80008fee:	fe043703          	ld	a4,-32(s0)
    80008ff2:	e398                	sd	a4,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80008ff4:	0001e797          	auipc	a5,0x1e
    80008ff8:	17478793          	addi	a5,a5,372 # 80027168 <disk>
    80008ffc:	6398                	ld	a4,0(a5)
    80008ffe:	fd042783          	lw	a5,-48(s0)
    80009002:	0792                	slli	a5,a5,0x4
    80009004:	97ba                	add	a5,a5,a4
    80009006:	4741                	li	a4,16
    80009008:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000900a:	0001e797          	auipc	a5,0x1e
    8000900e:	15e78793          	addi	a5,a5,350 # 80027168 <disk>
    80009012:	6398                	ld	a4,0(a5)
    80009014:	fd042783          	lw	a5,-48(s0)
    80009018:	0792                	slli	a5,a5,0x4
    8000901a:	97ba                	add	a5,a5,a4
    8000901c:	4705                	li	a4,1
    8000901e:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80009022:	fd442683          	lw	a3,-44(s0)
    80009026:	0001e797          	auipc	a5,0x1e
    8000902a:	14278793          	addi	a5,a5,322 # 80027168 <disk>
    8000902e:	6398                	ld	a4,0(a5)
    80009030:	fd042783          	lw	a5,-48(s0)
    80009034:	0792                	slli	a5,a5,0x4
    80009036:	97ba                	add	a5,a5,a4
    80009038:	03069713          	slli	a4,a3,0x30
    8000903c:	9341                	srli	a4,a4,0x30
    8000903e:	00e79723          	sh	a4,14(a5)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80009042:	fc843783          	ld	a5,-56(s0)
    80009046:	05878693          	addi	a3,a5,88
    8000904a:	0001e797          	auipc	a5,0x1e
    8000904e:	11e78793          	addi	a5,a5,286 # 80027168 <disk>
    80009052:	6398                	ld	a4,0(a5)
    80009054:	fd442783          	lw	a5,-44(s0)
    80009058:	0792                	slli	a5,a5,0x4
    8000905a:	97ba                	add	a5,a5,a4
    8000905c:	8736                	mv	a4,a3
    8000905e:	e398                	sd	a4,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    80009060:	0001e797          	auipc	a5,0x1e
    80009064:	10878793          	addi	a5,a5,264 # 80027168 <disk>
    80009068:	6398                	ld	a4,0(a5)
    8000906a:	fd442783          	lw	a5,-44(s0)
    8000906e:	0792                	slli	a5,a5,0x4
    80009070:	97ba                	add	a5,a5,a4
    80009072:	40000713          	li	a4,1024
    80009076:	c798                	sw	a4,8(a5)
  if(write)
    80009078:	fc442783          	lw	a5,-60(s0)
    8000907c:	2781                	sext.w	a5,a5
    8000907e:	cf89                	beqz	a5,80009098 <virtio_disk_rw+0x166>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80009080:	0001e797          	auipc	a5,0x1e
    80009084:	0e878793          	addi	a5,a5,232 # 80027168 <disk>
    80009088:	6398                	ld	a4,0(a5)
    8000908a:	fd442783          	lw	a5,-44(s0)
    8000908e:	0792                	slli	a5,a5,0x4
    80009090:	97ba                	add	a5,a5,a4
    80009092:	00079623          	sh	zero,12(a5)
    80009096:	a829                	j	800090b0 <virtio_disk_rw+0x17e>
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80009098:	0001e797          	auipc	a5,0x1e
    8000909c:	0d078793          	addi	a5,a5,208 # 80027168 <disk>
    800090a0:	6398                	ld	a4,0(a5)
    800090a2:	fd442783          	lw	a5,-44(s0)
    800090a6:	0792                	slli	a5,a5,0x4
    800090a8:	97ba                	add	a5,a5,a4
    800090aa:	4709                	li	a4,2
    800090ac:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800090b0:	0001e797          	auipc	a5,0x1e
    800090b4:	0b878793          	addi	a5,a5,184 # 80027168 <disk>
    800090b8:	6398                	ld	a4,0(a5)
    800090ba:	fd442783          	lw	a5,-44(s0)
    800090be:	0792                	slli	a5,a5,0x4
    800090c0:	97ba                	add	a5,a5,a4
    800090c2:	00c7d703          	lhu	a4,12(a5)
    800090c6:	0001e797          	auipc	a5,0x1e
    800090ca:	0a278793          	addi	a5,a5,162 # 80027168 <disk>
    800090ce:	6394                	ld	a3,0(a5)
    800090d0:	fd442783          	lw	a5,-44(s0)
    800090d4:	0792                	slli	a5,a5,0x4
    800090d6:	97b6                	add	a5,a5,a3
    800090d8:	00176713          	ori	a4,a4,1
    800090dc:	1742                	slli	a4,a4,0x30
    800090de:	9341                	srli	a4,a4,0x30
    800090e0:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800090e4:	fd842683          	lw	a3,-40(s0)
    800090e8:	0001e797          	auipc	a5,0x1e
    800090ec:	08078793          	addi	a5,a5,128 # 80027168 <disk>
    800090f0:	6398                	ld	a4,0(a5)
    800090f2:	fd442783          	lw	a5,-44(s0)
    800090f6:	0792                	slli	a5,a5,0x4
    800090f8:	97ba                	add	a5,a5,a4
    800090fa:	03069713          	slli	a4,a3,0x30
    800090fe:	9341                	srli	a4,a4,0x30
    80009100:	00e79723          	sh	a4,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80009104:	fd042783          	lw	a5,-48(s0)
    80009108:	0001e717          	auipc	a4,0x1e
    8000910c:	06070713          	addi	a4,a4,96 # 80027168 <disk>
    80009110:	0789                	addi	a5,a5,2
    80009112:	0792                	slli	a5,a5,0x4
    80009114:	97ba                	add	a5,a5,a4
    80009116:	577d                	li	a4,-1
    80009118:	00e78823          	sb	a4,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000911c:	fd042783          	lw	a5,-48(s0)
    80009120:	0789                	addi	a5,a5,2
    80009122:	00479713          	slli	a4,a5,0x4
    80009126:	0001e797          	auipc	a5,0x1e
    8000912a:	04278793          	addi	a5,a5,66 # 80027168 <disk>
    8000912e:	97ba                	add	a5,a5,a4
    80009130:	01078693          	addi	a3,a5,16
    80009134:	0001e797          	auipc	a5,0x1e
    80009138:	03478793          	addi	a5,a5,52 # 80027168 <disk>
    8000913c:	6398                	ld	a4,0(a5)
    8000913e:	fd842783          	lw	a5,-40(s0)
    80009142:	0792                	slli	a5,a5,0x4
    80009144:	97ba                	add	a5,a5,a4
    80009146:	8736                	mv	a4,a3
    80009148:	e398                	sd	a4,0(a5)
  disk.desc[idx[2]].len = 1;
    8000914a:	0001e797          	auipc	a5,0x1e
    8000914e:	01e78793          	addi	a5,a5,30 # 80027168 <disk>
    80009152:	6398                	ld	a4,0(a5)
    80009154:	fd842783          	lw	a5,-40(s0)
    80009158:	0792                	slli	a5,a5,0x4
    8000915a:	97ba                	add	a5,a5,a4
    8000915c:	4705                	li	a4,1
    8000915e:	c798                	sw	a4,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80009160:	0001e797          	auipc	a5,0x1e
    80009164:	00878793          	addi	a5,a5,8 # 80027168 <disk>
    80009168:	6398                	ld	a4,0(a5)
    8000916a:	fd842783          	lw	a5,-40(s0)
    8000916e:	0792                	slli	a5,a5,0x4
    80009170:	97ba                	add	a5,a5,a4
    80009172:	4709                	li	a4,2
    80009174:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[2]].next = 0;
    80009178:	0001e797          	auipc	a5,0x1e
    8000917c:	ff078793          	addi	a5,a5,-16 # 80027168 <disk>
    80009180:	6398                	ld	a4,0(a5)
    80009182:	fd842783          	lw	a5,-40(s0)
    80009186:	0792                	slli	a5,a5,0x4
    80009188:	97ba                	add	a5,a5,a4
    8000918a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000918e:	fc843783          	ld	a5,-56(s0)
    80009192:	4705                	li	a4,1
    80009194:	c3d8                	sw	a4,4(a5)
  disk.info[idx[0]].b = b;
    80009196:	fd042783          	lw	a5,-48(s0)
    8000919a:	0001e717          	auipc	a4,0x1e
    8000919e:	fce70713          	addi	a4,a4,-50 # 80027168 <disk>
    800091a2:	0789                	addi	a5,a5,2
    800091a4:	0792                	slli	a5,a5,0x4
    800091a6:	97ba                	add	a5,a5,a4
    800091a8:	fc843703          	ld	a4,-56(s0)
    800091ac:	e798                	sd	a4,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800091ae:	fd042703          	lw	a4,-48(s0)
    800091b2:	0001e797          	auipc	a5,0x1e
    800091b6:	fb678793          	addi	a5,a5,-74 # 80027168 <disk>
    800091ba:	6794                	ld	a3,8(a5)
    800091bc:	0001e797          	auipc	a5,0x1e
    800091c0:	fac78793          	addi	a5,a5,-84 # 80027168 <disk>
    800091c4:	679c                	ld	a5,8(a5)
    800091c6:	0027d783          	lhu	a5,2(a5)
    800091ca:	2781                	sext.w	a5,a5
    800091cc:	8b9d                	andi	a5,a5,7
    800091ce:	2781                	sext.w	a5,a5
    800091d0:	1742                	slli	a4,a4,0x30
    800091d2:	9341                	srli	a4,a4,0x30
    800091d4:	0786                	slli	a5,a5,0x1
    800091d6:	97b6                	add	a5,a5,a3
    800091d8:	00e79223          	sh	a4,4(a5)

  __sync_synchronize();
    800091dc:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800091e0:	0001e797          	auipc	a5,0x1e
    800091e4:	f8878793          	addi	a5,a5,-120 # 80027168 <disk>
    800091e8:	679c                	ld	a5,8(a5)
    800091ea:	0027d703          	lhu	a4,2(a5)
    800091ee:	0001e797          	auipc	a5,0x1e
    800091f2:	f7a78793          	addi	a5,a5,-134 # 80027168 <disk>
    800091f6:	679c                	ld	a5,8(a5)
    800091f8:	2705                	addiw	a4,a4,1
    800091fa:	1742                	slli	a4,a4,0x30
    800091fc:	9341                	srli	a4,a4,0x30
    800091fe:	00e79123          	sh	a4,2(a5)

  __sync_synchronize();
    80009202:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80009206:	100017b7          	lui	a5,0x10001
    8000920a:	05078793          	addi	a5,a5,80 # 10001050 <_entry-0x6fffefb0>
    8000920e:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80009212:	a819                	j	80009228 <virtio_disk_rw+0x2f6>
    sleep(b, &disk.vdisk_lock);
    80009214:	0001e597          	auipc	a1,0x1e
    80009218:	07c58593          	addi	a1,a1,124 # 80027290 <disk+0x128>
    8000921c:	fc843503          	ld	a0,-56(s0)
    80009220:	ffffa097          	auipc	ra,0xffffa
    80009224:	1e8080e7          	jalr	488(ra) # 80003408 <sleep>
  while(b->disk == 1) {
    80009228:	fc843783          	ld	a5,-56(s0)
    8000922c:	43dc                	lw	a5,4(a5)
    8000922e:	873e                	mv	a4,a5
    80009230:	4785                	li	a5,1
    80009232:	fef701e3          	beq	a4,a5,80009214 <virtio_disk_rw+0x2e2>
  }

  disk.info[idx[0]].b = 0;
    80009236:	fd042783          	lw	a5,-48(s0)
    8000923a:	0001e717          	auipc	a4,0x1e
    8000923e:	f2e70713          	addi	a4,a4,-210 # 80027168 <disk>
    80009242:	0789                	addi	a5,a5,2
    80009244:	0792                	slli	a5,a5,0x4
    80009246:	97ba                	add	a5,a5,a4
    80009248:	0007b423          	sd	zero,8(a5)
  free_chain(idx[0]);
    8000924c:	fd042783          	lw	a5,-48(s0)
    80009250:	853e                	mv	a0,a5
    80009252:	00000097          	auipc	ra,0x0
    80009256:	bcc080e7          	jalr	-1076(ra) # 80008e1e <free_chain>

  release(&disk.vdisk_lock);
    8000925a:	0001e517          	auipc	a0,0x1e
    8000925e:	03650513          	addi	a0,a0,54 # 80027290 <disk+0x128>
    80009262:	ffff8097          	auipc	ra,0xffff8
    80009266:	080080e7          	jalr	128(ra) # 800012e2 <release>
}
    8000926a:	0001                	nop
    8000926c:	70e2                	ld	ra,56(sp)
    8000926e:	7442                	ld	s0,48(sp)
    80009270:	6121                	addi	sp,sp,64
    80009272:	8082                	ret

0000000080009274 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80009274:	1101                	addi	sp,sp,-32
    80009276:	ec06                	sd	ra,24(sp)
    80009278:	e822                	sd	s0,16(sp)
    8000927a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000927c:	0001e517          	auipc	a0,0x1e
    80009280:	01450513          	addi	a0,a0,20 # 80027290 <disk+0x128>
    80009284:	ffff8097          	auipc	ra,0xffff8
    80009288:	ffa080e7          	jalr	-6(ra) # 8000127e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000928c:	100017b7          	lui	a5,0x10001
    80009290:	06078793          	addi	a5,a5,96 # 10001060 <_entry-0x6fffefa0>
    80009294:	439c                	lw	a5,0(a5)
    80009296:	0007871b          	sext.w	a4,a5
    8000929a:	100017b7          	lui	a5,0x10001
    8000929e:	06478793          	addi	a5,a5,100 # 10001064 <_entry-0x6fffef9c>
    800092a2:	8b0d                	andi	a4,a4,3
    800092a4:	2701                	sext.w	a4,a4
    800092a6:	c398                	sw	a4,0(a5)

  __sync_synchronize();
    800092a8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800092ac:	a045                	j	8000934c <virtio_disk_intr+0xd8>
    __sync_synchronize();
    800092ae:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800092b2:	0001e797          	auipc	a5,0x1e
    800092b6:	eb678793          	addi	a5,a5,-330 # 80027168 <disk>
    800092ba:	6b98                	ld	a4,16(a5)
    800092bc:	0001e797          	auipc	a5,0x1e
    800092c0:	eac78793          	addi	a5,a5,-340 # 80027168 <disk>
    800092c4:	0207d783          	lhu	a5,32(a5)
    800092c8:	2781                	sext.w	a5,a5
    800092ca:	8b9d                	andi	a5,a5,7
    800092cc:	2781                	sext.w	a5,a5
    800092ce:	078e                	slli	a5,a5,0x3
    800092d0:	97ba                	add	a5,a5,a4
    800092d2:	43dc                	lw	a5,4(a5)
    800092d4:	fef42623          	sw	a5,-20(s0)

    if(disk.info[id].status != 0)
    800092d8:	0001e717          	auipc	a4,0x1e
    800092dc:	e9070713          	addi	a4,a4,-368 # 80027168 <disk>
    800092e0:	fec42783          	lw	a5,-20(s0)
    800092e4:	0789                	addi	a5,a5,2
    800092e6:	0792                	slli	a5,a5,0x4
    800092e8:	97ba                	add	a5,a5,a4
    800092ea:	0107c783          	lbu	a5,16(a5)
    800092ee:	cb89                	beqz	a5,80009300 <virtio_disk_intr+0x8c>
      panic("virtio_disk_intr status");
    800092f0:	00002517          	auipc	a0,0x2
    800092f4:	45050513          	addi	a0,a0,1104 # 8000b740 <etext+0x740>
    800092f8:	ffff8097          	auipc	ra,0xffff8
    800092fc:	992080e7          	jalr	-1646(ra) # 80000c8a <panic>

    struct buf *b = disk.info[id].b;
    80009300:	0001e717          	auipc	a4,0x1e
    80009304:	e6870713          	addi	a4,a4,-408 # 80027168 <disk>
    80009308:	fec42783          	lw	a5,-20(s0)
    8000930c:	0789                	addi	a5,a5,2
    8000930e:	0792                	slli	a5,a5,0x4
    80009310:	97ba                	add	a5,a5,a4
    80009312:	679c                	ld	a5,8(a5)
    80009314:	fef43023          	sd	a5,-32(s0)
    b->disk = 0;   // disk is done with buf
    80009318:	fe043783          	ld	a5,-32(s0)
    8000931c:	0007a223          	sw	zero,4(a5)
    wakeup(b);
    80009320:	fe043503          	ld	a0,-32(s0)
    80009324:	ffffa097          	auipc	ra,0xffffa
    80009328:	160080e7          	jalr	352(ra) # 80003484 <wakeup>

    disk.used_idx += 1;
    8000932c:	0001e797          	auipc	a5,0x1e
    80009330:	e3c78793          	addi	a5,a5,-452 # 80027168 <disk>
    80009334:	0207d783          	lhu	a5,32(a5)
    80009338:	2785                	addiw	a5,a5,1
    8000933a:	03079713          	slli	a4,a5,0x30
    8000933e:	9341                	srli	a4,a4,0x30
    80009340:	0001e797          	auipc	a5,0x1e
    80009344:	e2878793          	addi	a5,a5,-472 # 80027168 <disk>
    80009348:	02e79023          	sh	a4,32(a5)
  while(disk.used_idx != disk.used->idx){
    8000934c:	0001e797          	auipc	a5,0x1e
    80009350:	e1c78793          	addi	a5,a5,-484 # 80027168 <disk>
    80009354:	0207d703          	lhu	a4,32(a5)
    80009358:	0001e797          	auipc	a5,0x1e
    8000935c:	e1078793          	addi	a5,a5,-496 # 80027168 <disk>
    80009360:	6b9c                	ld	a5,16(a5)
    80009362:	0027d783          	lhu	a5,2(a5)
    80009366:	2701                	sext.w	a4,a4
    80009368:	2781                	sext.w	a5,a5
    8000936a:	f4f712e3          	bne	a4,a5,800092ae <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    8000936e:	0001e517          	auipc	a0,0x1e
    80009372:	f2250513          	addi	a0,a0,-222 # 80027290 <disk+0x128>
    80009376:	ffff8097          	auipc	ra,0xffff8
    8000937a:	f6c080e7          	jalr	-148(ra) # 800012e2 <release>
}
    8000937e:	0001                	nop
    80009380:	60e2                	ld	ra,24(sp)
    80009382:	6442                	ld	s0,16(sp)
    80009384:	6105                	addi	sp,sp,32
    80009386:	8082                	ret
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
