
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <r_sp>:
  return (x & SSTATUS_SIE) != 0;
}

static inline uint64
r_sp()
{
       0:	1101                	addi	sp,sp,-32
       2:	ec22                	sd	s0,24(sp)
       4:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
       6:	878a                	mv	a5,sp
       8:	fef43423          	sd	a5,-24(s0)
  return x;
       c:	fe843783          	ld	a5,-24(s0)
}
      10:	853e                	mv	a0,a5
      12:	6462                	ld	s0,24(sp)
      14:	6105                	addi	sp,sp,32
      16:	8082                	ret

0000000000000018 <copyin>:

// what if you pass ridiculous pointers to system calls
// that read user memory with copyin?
void
copyin(char *s)
{
      18:	715d                	addi	sp,sp,-80
      1a:	e486                	sd	ra,72(sp)
      1c:	e0a2                	sd	s0,64(sp)
      1e:	0880                	addi	s0,sp,80
      20:	faa43c23          	sd	a0,-72(s0)
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
      24:	4785                	li	a5,1
      26:	07fe                	slli	a5,a5,0x1f
      28:	fcf43423          	sd	a5,-56(s0)
      2c:	57fd                	li	a5,-1
      2e:	fcf43823          	sd	a5,-48(s0)

  for(int ai = 0; ai < 2; ai++){
      32:	fe042623          	sw	zero,-20(s0)
      36:	aa79                	j	1d4 <copyin+0x1bc>
    uint64 addr = addrs[ai];
      38:	fec42783          	lw	a5,-20(s0)
      3c:	078e                	slli	a5,a5,0x3
      3e:	17c1                	addi	a5,a5,-16
      40:	97a2                	add	a5,a5,s0
      42:	fd87b783          	ld	a5,-40(a5)
      46:	fef43023          	sd	a5,-32(s0)
    
    int fd = open("copyin1", O_CREATE|O_WRONLY);
      4a:	20100593          	li	a1,513
      4e:	00008517          	auipc	a0,0x8
      52:	0c250513          	addi	a0,a0,194 # 8110 <malloc+0x146>
      56:	00008097          	auipc	ra,0x8
      5a:	89a080e7          	jalr	-1894(ra) # 78f0 <open>
      5e:	87aa                	mv	a5,a0
      60:	fcf42e23          	sw	a5,-36(s0)
    if(fd < 0){
      64:	fdc42783          	lw	a5,-36(s0)
      68:	2781                	sext.w	a5,a5
      6a:	0007df63          	bgez	a5,88 <copyin+0x70>
      printf("open(copyin1) failed\n");
      6e:	00008517          	auipc	a0,0x8
      72:	0aa50513          	addi	a0,a0,170 # 8118 <malloc+0x14e>
      76:	00008097          	auipc	ra,0x8
      7a:	d62080e7          	jalr	-670(ra) # 7dd8 <printf>
      exit(1);
      7e:	4505                	li	a0,1
      80:	00008097          	auipc	ra,0x8
      84:	830080e7          	jalr	-2000(ra) # 78b0 <exit>
    }
    int n = write(fd, (void*)addr, 8192);
      88:	fe043703          	ld	a4,-32(s0)
      8c:	fdc42783          	lw	a5,-36(s0)
      90:	6609                	lui	a2,0x2
      92:	85ba                	mv	a1,a4
      94:	853e                	mv	a0,a5
      96:	00008097          	auipc	ra,0x8
      9a:	83a080e7          	jalr	-1990(ra) # 78d0 <write>
      9e:	87aa                	mv	a5,a0
      a0:	fcf42c23          	sw	a5,-40(s0)
    if(n >= 0){
      a4:	fd842783          	lw	a5,-40(s0)
      a8:	2781                	sext.w	a5,a5
      aa:	0207c463          	bltz	a5,d2 <copyin+0xba>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
      ae:	fd842783          	lw	a5,-40(s0)
      b2:	863e                	mv	a2,a5
      b4:	fe043583          	ld	a1,-32(s0)
      b8:	00008517          	auipc	a0,0x8
      bc:	07850513          	addi	a0,a0,120 # 8130 <malloc+0x166>
      c0:	00008097          	auipc	ra,0x8
      c4:	d18080e7          	jalr	-744(ra) # 7dd8 <printf>
      exit(1);
      c8:	4505                	li	a0,1
      ca:	00007097          	auipc	ra,0x7
      ce:	7e6080e7          	jalr	2022(ra) # 78b0 <exit>
    }
    close(fd);
      d2:	fdc42783          	lw	a5,-36(s0)
      d6:	853e                	mv	a0,a5
      d8:	00008097          	auipc	ra,0x8
      dc:	800080e7          	jalr	-2048(ra) # 78d8 <close>
    unlink("copyin1");
      e0:	00008517          	auipc	a0,0x8
      e4:	03050513          	addi	a0,a0,48 # 8110 <malloc+0x146>
      e8:	00008097          	auipc	ra,0x8
      ec:	818080e7          	jalr	-2024(ra) # 7900 <unlink>
    
    n = write(1, (char*)addr, 8192);
      f0:	fe043783          	ld	a5,-32(s0)
      f4:	6609                	lui	a2,0x2
      f6:	85be                	mv	a1,a5
      f8:	4505                	li	a0,1
      fa:	00007097          	auipc	ra,0x7
      fe:	7d6080e7          	jalr	2006(ra) # 78d0 <write>
     102:	87aa                	mv	a5,a0
     104:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     108:	fd842783          	lw	a5,-40(s0)
     10c:	2781                	sext.w	a5,a5
     10e:	02f05463          	blez	a5,136 <copyin+0x11e>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     112:	fd842783          	lw	a5,-40(s0)
     116:	863e                	mv	a2,a5
     118:	fe043583          	ld	a1,-32(s0)
     11c:	00008517          	auipc	a0,0x8
     120:	04450513          	addi	a0,a0,68 # 8160 <malloc+0x196>
     124:	00008097          	auipc	ra,0x8
     128:	cb4080e7          	jalr	-844(ra) # 7dd8 <printf>
      exit(1);
     12c:	4505                	li	a0,1
     12e:	00007097          	auipc	ra,0x7
     132:	782080e7          	jalr	1922(ra) # 78b0 <exit>
    }
    
    int fds[2];
    if(pipe(fds) < 0){
     136:	fc040793          	addi	a5,s0,-64
     13a:	853e                	mv	a0,a5
     13c:	00007097          	auipc	ra,0x7
     140:	784080e7          	jalr	1924(ra) # 78c0 <pipe>
     144:	87aa                	mv	a5,a0
     146:	0007df63          	bgez	a5,164 <copyin+0x14c>
      printf("pipe() failed\n");
     14a:	00008517          	auipc	a0,0x8
     14e:	04650513          	addi	a0,a0,70 # 8190 <malloc+0x1c6>
     152:	00008097          	auipc	ra,0x8
     156:	c86080e7          	jalr	-890(ra) # 7dd8 <printf>
      exit(1);
     15a:	4505                	li	a0,1
     15c:	00007097          	auipc	ra,0x7
     160:	754080e7          	jalr	1876(ra) # 78b0 <exit>
    }
    n = write(fds[1], (char*)addr, 8192);
     164:	fc442783          	lw	a5,-60(s0)
     168:	fe043703          	ld	a4,-32(s0)
     16c:	6609                	lui	a2,0x2
     16e:	85ba                	mv	a1,a4
     170:	853e                	mv	a0,a5
     172:	00007097          	auipc	ra,0x7
     176:	75e080e7          	jalr	1886(ra) # 78d0 <write>
     17a:	87aa                	mv	a5,a0
     17c:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     180:	fd842783          	lw	a5,-40(s0)
     184:	2781                	sext.w	a5,a5
     186:	02f05463          	blez	a5,1ae <copyin+0x196>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     18a:	fd842783          	lw	a5,-40(s0)
     18e:	863e                	mv	a2,a5
     190:	fe043583          	ld	a1,-32(s0)
     194:	00008517          	auipc	a0,0x8
     198:	00c50513          	addi	a0,a0,12 # 81a0 <malloc+0x1d6>
     19c:	00008097          	auipc	ra,0x8
     1a0:	c3c080e7          	jalr	-964(ra) # 7dd8 <printf>
      exit(1);
     1a4:	4505                	li	a0,1
     1a6:	00007097          	auipc	ra,0x7
     1aa:	70a080e7          	jalr	1802(ra) # 78b0 <exit>
    }
    close(fds[0]);
     1ae:	fc042783          	lw	a5,-64(s0)
     1b2:	853e                	mv	a0,a5
     1b4:	00007097          	auipc	ra,0x7
     1b8:	724080e7          	jalr	1828(ra) # 78d8 <close>
    close(fds[1]);
     1bc:	fc442783          	lw	a5,-60(s0)
     1c0:	853e                	mv	a0,a5
     1c2:	00007097          	auipc	ra,0x7
     1c6:	716080e7          	jalr	1814(ra) # 78d8 <close>
  for(int ai = 0; ai < 2; ai++){
     1ca:	fec42783          	lw	a5,-20(s0)
     1ce:	2785                	addiw	a5,a5,1
     1d0:	fef42623          	sw	a5,-20(s0)
     1d4:	fec42783          	lw	a5,-20(s0)
     1d8:	0007871b          	sext.w	a4,a5
     1dc:	4785                	li	a5,1
     1de:	e4e7dde3          	bge	a5,a4,38 <copyin+0x20>
  }
}
     1e2:	0001                	nop
     1e4:	0001                	nop
     1e6:	60a6                	ld	ra,72(sp)
     1e8:	6406                	ld	s0,64(sp)
     1ea:	6161                	addi	sp,sp,80
     1ec:	8082                	ret

00000000000001ee <copyout>:

// what if you pass ridiculous pointers to system calls
// that write user memory with copyout?
void
copyout(char *s)
{
     1ee:	715d                	addi	sp,sp,-80
     1f0:	e486                	sd	ra,72(sp)
     1f2:	e0a2                	sd	s0,64(sp)
     1f4:	0880                	addi	s0,sp,80
     1f6:	faa43c23          	sd	a0,-72(s0)
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     1fa:	4785                	li	a5,1
     1fc:	07fe                	slli	a5,a5,0x1f
     1fe:	fcf43423          	sd	a5,-56(s0)
     202:	57fd                	li	a5,-1
     204:	fcf43823          	sd	a5,-48(s0)

  for(int ai = 0; ai < 2; ai++){
     208:	fe042623          	sw	zero,-20(s0)
     20c:	a271                	j	398 <copyout+0x1aa>
    uint64 addr = addrs[ai];
     20e:	fec42783          	lw	a5,-20(s0)
     212:	078e                	slli	a5,a5,0x3
     214:	17c1                	addi	a5,a5,-16
     216:	97a2                	add	a5,a5,s0
     218:	fd87b783          	ld	a5,-40(a5)
     21c:	fef43023          	sd	a5,-32(s0)

    int fd = open("README", 0);
     220:	4581                	li	a1,0
     222:	00008517          	auipc	a0,0x8
     226:	fae50513          	addi	a0,a0,-82 # 81d0 <malloc+0x206>
     22a:	00007097          	auipc	ra,0x7
     22e:	6c6080e7          	jalr	1734(ra) # 78f0 <open>
     232:	87aa                	mv	a5,a0
     234:	fcf42e23          	sw	a5,-36(s0)
    if(fd < 0){
     238:	fdc42783          	lw	a5,-36(s0)
     23c:	2781                	sext.w	a5,a5
     23e:	0007df63          	bgez	a5,25c <copyout+0x6e>
      printf("open(README) failed\n");
     242:	00008517          	auipc	a0,0x8
     246:	f9650513          	addi	a0,a0,-106 # 81d8 <malloc+0x20e>
     24a:	00008097          	auipc	ra,0x8
     24e:	b8e080e7          	jalr	-1138(ra) # 7dd8 <printf>
      exit(1);
     252:	4505                	li	a0,1
     254:	00007097          	auipc	ra,0x7
     258:	65c080e7          	jalr	1628(ra) # 78b0 <exit>
    }
    int n = read(fd, (void*)addr, 8192);
     25c:	fe043703          	ld	a4,-32(s0)
     260:	fdc42783          	lw	a5,-36(s0)
     264:	6609                	lui	a2,0x2
     266:	85ba                	mv	a1,a4
     268:	853e                	mv	a0,a5
     26a:	00007097          	auipc	ra,0x7
     26e:	65e080e7          	jalr	1630(ra) # 78c8 <read>
     272:	87aa                	mv	a5,a0
     274:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     278:	fd842783          	lw	a5,-40(s0)
     27c:	2781                	sext.w	a5,a5
     27e:	02f05463          	blez	a5,2a6 <copyout+0xb8>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     282:	fd842783          	lw	a5,-40(s0)
     286:	863e                	mv	a2,a5
     288:	fe043583          	ld	a1,-32(s0)
     28c:	00008517          	auipc	a0,0x8
     290:	f6450513          	addi	a0,a0,-156 # 81f0 <malloc+0x226>
     294:	00008097          	auipc	ra,0x8
     298:	b44080e7          	jalr	-1212(ra) # 7dd8 <printf>
      exit(1);
     29c:	4505                	li	a0,1
     29e:	00007097          	auipc	ra,0x7
     2a2:	612080e7          	jalr	1554(ra) # 78b0 <exit>
    }
    close(fd);
     2a6:	fdc42783          	lw	a5,-36(s0)
     2aa:	853e                	mv	a0,a5
     2ac:	00007097          	auipc	ra,0x7
     2b0:	62c080e7          	jalr	1580(ra) # 78d8 <close>

    int fds[2];
    if(pipe(fds) < 0){
     2b4:	fc040793          	addi	a5,s0,-64
     2b8:	853e                	mv	a0,a5
     2ba:	00007097          	auipc	ra,0x7
     2be:	606080e7          	jalr	1542(ra) # 78c0 <pipe>
     2c2:	87aa                	mv	a5,a0
     2c4:	0007df63          	bgez	a5,2e2 <copyout+0xf4>
      printf("pipe() failed\n");
     2c8:	00008517          	auipc	a0,0x8
     2cc:	ec850513          	addi	a0,a0,-312 # 8190 <malloc+0x1c6>
     2d0:	00008097          	auipc	ra,0x8
     2d4:	b08080e7          	jalr	-1272(ra) # 7dd8 <printf>
      exit(1);
     2d8:	4505                	li	a0,1
     2da:	00007097          	auipc	ra,0x7
     2de:	5d6080e7          	jalr	1494(ra) # 78b0 <exit>
    }
    n = write(fds[1], "x", 1);
     2e2:	fc442783          	lw	a5,-60(s0)
     2e6:	4605                	li	a2,1
     2e8:	00008597          	auipc	a1,0x8
     2ec:	f3858593          	addi	a1,a1,-200 # 8220 <malloc+0x256>
     2f0:	853e                	mv	a0,a5
     2f2:	00007097          	auipc	ra,0x7
     2f6:	5de080e7          	jalr	1502(ra) # 78d0 <write>
     2fa:	87aa                	mv	a5,a0
     2fc:	fcf42c23          	sw	a5,-40(s0)
    if(n != 1){
     300:	fd842783          	lw	a5,-40(s0)
     304:	0007871b          	sext.w	a4,a5
     308:	4785                	li	a5,1
     30a:	00f70f63          	beq	a4,a5,328 <copyout+0x13a>
      printf("pipe write failed\n");
     30e:	00008517          	auipc	a0,0x8
     312:	f1a50513          	addi	a0,a0,-230 # 8228 <malloc+0x25e>
     316:	00008097          	auipc	ra,0x8
     31a:	ac2080e7          	jalr	-1342(ra) # 7dd8 <printf>
      exit(1);
     31e:	4505                	li	a0,1
     320:	00007097          	auipc	ra,0x7
     324:	590080e7          	jalr	1424(ra) # 78b0 <exit>
    }
    n = read(fds[0], (void*)addr, 8192);
     328:	fc042783          	lw	a5,-64(s0)
     32c:	fe043703          	ld	a4,-32(s0)
     330:	6609                	lui	a2,0x2
     332:	85ba                	mv	a1,a4
     334:	853e                	mv	a0,a5
     336:	00007097          	auipc	ra,0x7
     33a:	592080e7          	jalr	1426(ra) # 78c8 <read>
     33e:	87aa                	mv	a5,a0
     340:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     344:	fd842783          	lw	a5,-40(s0)
     348:	2781                	sext.w	a5,a5
     34a:	02f05463          	blez	a5,372 <copyout+0x184>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     34e:	fd842783          	lw	a5,-40(s0)
     352:	863e                	mv	a2,a5
     354:	fe043583          	ld	a1,-32(s0)
     358:	00008517          	auipc	a0,0x8
     35c:	ee850513          	addi	a0,a0,-280 # 8240 <malloc+0x276>
     360:	00008097          	auipc	ra,0x8
     364:	a78080e7          	jalr	-1416(ra) # 7dd8 <printf>
      exit(1);
     368:	4505                	li	a0,1
     36a:	00007097          	auipc	ra,0x7
     36e:	546080e7          	jalr	1350(ra) # 78b0 <exit>
    }
    close(fds[0]);
     372:	fc042783          	lw	a5,-64(s0)
     376:	853e                	mv	a0,a5
     378:	00007097          	auipc	ra,0x7
     37c:	560080e7          	jalr	1376(ra) # 78d8 <close>
    close(fds[1]);
     380:	fc442783          	lw	a5,-60(s0)
     384:	853e                	mv	a0,a5
     386:	00007097          	auipc	ra,0x7
     38a:	552080e7          	jalr	1362(ra) # 78d8 <close>
  for(int ai = 0; ai < 2; ai++){
     38e:	fec42783          	lw	a5,-20(s0)
     392:	2785                	addiw	a5,a5,1
     394:	fef42623          	sw	a5,-20(s0)
     398:	fec42783          	lw	a5,-20(s0)
     39c:	0007871b          	sext.w	a4,a5
     3a0:	4785                	li	a5,1
     3a2:	e6e7d6e3          	bge	a5,a4,20e <copyout+0x20>
  }
}
     3a6:	0001                	nop
     3a8:	0001                	nop
     3aa:	60a6                	ld	ra,72(sp)
     3ac:	6406                	ld	s0,64(sp)
     3ae:	6161                	addi	sp,sp,80
     3b0:	8082                	ret

00000000000003b2 <copyinstr1>:

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
     3b2:	715d                	addi	sp,sp,-80
     3b4:	e486                	sd	ra,72(sp)
     3b6:	e0a2                	sd	s0,64(sp)
     3b8:	0880                	addi	s0,sp,80
     3ba:	faa43c23          	sd	a0,-72(s0)
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     3be:	4785                	li	a5,1
     3c0:	07fe                	slli	a5,a5,0x1f
     3c2:	fcf43423          	sd	a5,-56(s0)
     3c6:	57fd                	li	a5,-1
     3c8:	fcf43823          	sd	a5,-48(s0)

  for(int ai = 0; ai < 2; ai++){
     3cc:	fe042623          	sw	zero,-20(s0)
     3d0:	a095                	j	434 <copyinstr1+0x82>
    uint64 addr = addrs[ai];
     3d2:	fec42783          	lw	a5,-20(s0)
     3d6:	078e                	slli	a5,a5,0x3
     3d8:	17c1                	addi	a5,a5,-16
     3da:	97a2                	add	a5,a5,s0
     3dc:	fd87b783          	ld	a5,-40(a5)
     3e0:	fef43023          	sd	a5,-32(s0)

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
     3e4:	fe043783          	ld	a5,-32(s0)
     3e8:	20100593          	li	a1,513
     3ec:	853e                	mv	a0,a5
     3ee:	00007097          	auipc	ra,0x7
     3f2:	502080e7          	jalr	1282(ra) # 78f0 <open>
     3f6:	87aa                	mv	a5,a0
     3f8:	fcf42e23          	sw	a5,-36(s0)
    if(fd >= 0){
     3fc:	fdc42783          	lw	a5,-36(s0)
     400:	2781                	sext.w	a5,a5
     402:	0207c463          	bltz	a5,42a <copyinstr1+0x78>
      printf("open(%p) returned %d, not -1\n", addr, fd);
     406:	fdc42783          	lw	a5,-36(s0)
     40a:	863e                	mv	a2,a5
     40c:	fe043583          	ld	a1,-32(s0)
     410:	00008517          	auipc	a0,0x8
     414:	e6050513          	addi	a0,a0,-416 # 8270 <malloc+0x2a6>
     418:	00008097          	auipc	ra,0x8
     41c:	9c0080e7          	jalr	-1600(ra) # 7dd8 <printf>
      exit(1);
     420:	4505                	li	a0,1
     422:	00007097          	auipc	ra,0x7
     426:	48e080e7          	jalr	1166(ra) # 78b0 <exit>
  for(int ai = 0; ai < 2; ai++){
     42a:	fec42783          	lw	a5,-20(s0)
     42e:	2785                	addiw	a5,a5,1
     430:	fef42623          	sw	a5,-20(s0)
     434:	fec42783          	lw	a5,-20(s0)
     438:	0007871b          	sext.w	a4,a5
     43c:	4785                	li	a5,1
     43e:	f8e7dae3          	bge	a5,a4,3d2 <copyinstr1+0x20>
    }
  }
}
     442:	0001                	nop
     444:	0001                	nop
     446:	60a6                	ld	ra,72(sp)
     448:	6406                	ld	s0,64(sp)
     44a:	6161                	addi	sp,sp,80
     44c:	8082                	ret

000000000000044e <copyinstr2>:
// what if a string system call argument is exactly the size
// of the kernel buffer it is copied into, so that the null
// would fall just beyond the end of the kernel buffer?
void
copyinstr2(char *s)
{
     44e:	7151                	addi	sp,sp,-240
     450:	f586                	sd	ra,232(sp)
     452:	f1a2                	sd	s0,224(sp)
     454:	1980                	addi	s0,sp,240
     456:	f0a43c23          	sd	a0,-232(s0)
  char b[MAXPATH+1];

  for(int i = 0; i < MAXPATH; i++)
     45a:	fe042623          	sw	zero,-20(s0)
     45e:	a831                	j	47a <copyinstr2+0x2c>
    b[i] = 'x';
     460:	fec42783          	lw	a5,-20(s0)
     464:	17c1                	addi	a5,a5,-16
     466:	97a2                	add	a5,a5,s0
     468:	07800713          	li	a4,120
     46c:	f6e78423          	sb	a4,-152(a5)
  for(int i = 0; i < MAXPATH; i++)
     470:	fec42783          	lw	a5,-20(s0)
     474:	2785                	addiw	a5,a5,1
     476:	fef42623          	sw	a5,-20(s0)
     47a:	fec42783          	lw	a5,-20(s0)
     47e:	0007871b          	sext.w	a4,a5
     482:	07f00793          	li	a5,127
     486:	fce7dde3          	bge	a5,a4,460 <copyinstr2+0x12>
  b[MAXPATH] = '\0';
     48a:	fc040c23          	sb	zero,-40(s0)
  
  int ret = unlink(b);
     48e:	f5840793          	addi	a5,s0,-168
     492:	853e                	mv	a0,a5
     494:	00007097          	auipc	ra,0x7
     498:	46c080e7          	jalr	1132(ra) # 7900 <unlink>
     49c:	87aa                	mv	a5,a0
     49e:	fef42223          	sw	a5,-28(s0)
  if(ret != -1){
     4a2:	fe442783          	lw	a5,-28(s0)
     4a6:	0007871b          	sext.w	a4,a5
     4aa:	57fd                	li	a5,-1
     4ac:	02f70563          	beq	a4,a5,4d6 <copyinstr2+0x88>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
     4b0:	fe442703          	lw	a4,-28(s0)
     4b4:	f5840793          	addi	a5,s0,-168
     4b8:	863a                	mv	a2,a4
     4ba:	85be                	mv	a1,a5
     4bc:	00008517          	auipc	a0,0x8
     4c0:	dd450513          	addi	a0,a0,-556 # 8290 <malloc+0x2c6>
     4c4:	00008097          	auipc	ra,0x8
     4c8:	914080e7          	jalr	-1772(ra) # 7dd8 <printf>
    exit(1);
     4cc:	4505                	li	a0,1
     4ce:	00007097          	auipc	ra,0x7
     4d2:	3e2080e7          	jalr	994(ra) # 78b0 <exit>
  }

  int fd = open(b, O_CREATE | O_WRONLY);
     4d6:	f5840793          	addi	a5,s0,-168
     4da:	20100593          	li	a1,513
     4de:	853e                	mv	a0,a5
     4e0:	00007097          	auipc	ra,0x7
     4e4:	410080e7          	jalr	1040(ra) # 78f0 <open>
     4e8:	87aa                	mv	a5,a0
     4ea:	fef42023          	sw	a5,-32(s0)
  if(fd != -1){
     4ee:	fe042783          	lw	a5,-32(s0)
     4f2:	0007871b          	sext.w	a4,a5
     4f6:	57fd                	li	a5,-1
     4f8:	02f70563          	beq	a4,a5,522 <copyinstr2+0xd4>
    printf("open(%s) returned %d, not -1\n", b, fd);
     4fc:	fe042703          	lw	a4,-32(s0)
     500:	f5840793          	addi	a5,s0,-168
     504:	863a                	mv	a2,a4
     506:	85be                	mv	a1,a5
     508:	00008517          	auipc	a0,0x8
     50c:	da850513          	addi	a0,a0,-600 # 82b0 <malloc+0x2e6>
     510:	00008097          	auipc	ra,0x8
     514:	8c8080e7          	jalr	-1848(ra) # 7dd8 <printf>
    exit(1);
     518:	4505                	li	a0,1
     51a:	00007097          	auipc	ra,0x7
     51e:	396080e7          	jalr	918(ra) # 78b0 <exit>
  }

  ret = link(b, b);
     522:	f5840713          	addi	a4,s0,-168
     526:	f5840793          	addi	a5,s0,-168
     52a:	85ba                	mv	a1,a4
     52c:	853e                	mv	a0,a5
     52e:	00007097          	auipc	ra,0x7
     532:	3e2080e7          	jalr	994(ra) # 7910 <link>
     536:	87aa                	mv	a5,a0
     538:	fef42223          	sw	a5,-28(s0)
  if(ret != -1){
     53c:	fe442783          	lw	a5,-28(s0)
     540:	0007871b          	sext.w	a4,a5
     544:	57fd                	li	a5,-1
     546:	02f70763          	beq	a4,a5,574 <copyinstr2+0x126>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
     54a:	fe442683          	lw	a3,-28(s0)
     54e:	f5840713          	addi	a4,s0,-168
     552:	f5840793          	addi	a5,s0,-168
     556:	863a                	mv	a2,a4
     558:	85be                	mv	a1,a5
     55a:	00008517          	auipc	a0,0x8
     55e:	d7650513          	addi	a0,a0,-650 # 82d0 <malloc+0x306>
     562:	00008097          	auipc	ra,0x8
     566:	876080e7          	jalr	-1930(ra) # 7dd8 <printf>
    exit(1);
     56a:	4505                	li	a0,1
     56c:	00007097          	auipc	ra,0x7
     570:	344080e7          	jalr	836(ra) # 78b0 <exit>
  }

  char *args[] = { "xx", 0 };
     574:	00008797          	auipc	a5,0x8
     578:	d8478793          	addi	a5,a5,-636 # 82f8 <malloc+0x32e>
     57c:	f4f43423          	sd	a5,-184(s0)
     580:	f4043823          	sd	zero,-176(s0)
  ret = exec(b, args);
     584:	f4840713          	addi	a4,s0,-184
     588:	f5840793          	addi	a5,s0,-168
     58c:	85ba                	mv	a1,a4
     58e:	853e                	mv	a0,a5
     590:	00007097          	auipc	ra,0x7
     594:	358080e7          	jalr	856(ra) # 78e8 <exec>
     598:	87aa                	mv	a5,a0
     59a:	fef42223          	sw	a5,-28(s0)
  if(ret != -1){
     59e:	fe442783          	lw	a5,-28(s0)
     5a2:	0007871b          	sext.w	a4,a5
     5a6:	57fd                	li	a5,-1
     5a8:	02f70563          	beq	a4,a5,5d2 <copyinstr2+0x184>
    printf("exec(%s) returned %d, not -1\n", b, fd);
     5ac:	fe042703          	lw	a4,-32(s0)
     5b0:	f5840793          	addi	a5,s0,-168
     5b4:	863a                	mv	a2,a4
     5b6:	85be                	mv	a1,a5
     5b8:	00008517          	auipc	a0,0x8
     5bc:	d4850513          	addi	a0,a0,-696 # 8300 <malloc+0x336>
     5c0:	00008097          	auipc	ra,0x8
     5c4:	818080e7          	jalr	-2024(ra) # 7dd8 <printf>
    exit(1);
     5c8:	4505                	li	a0,1
     5ca:	00007097          	auipc	ra,0x7
     5ce:	2e6080e7          	jalr	742(ra) # 78b0 <exit>
  }

  int pid = fork();
     5d2:	00007097          	auipc	ra,0x7
     5d6:	2d6080e7          	jalr	726(ra) # 78a8 <fork>
     5da:	87aa                	mv	a5,a0
     5dc:	fcf42e23          	sw	a5,-36(s0)
  if(pid < 0){
     5e0:	fdc42783          	lw	a5,-36(s0)
     5e4:	2781                	sext.w	a5,a5
     5e6:	0007df63          	bgez	a5,604 <copyinstr2+0x1b6>
    printf("fork failed\n");
     5ea:	00008517          	auipc	a0,0x8
     5ee:	d3650513          	addi	a0,a0,-714 # 8320 <malloc+0x356>
     5f2:	00007097          	auipc	ra,0x7
     5f6:	7e6080e7          	jalr	2022(ra) # 7dd8 <printf>
    exit(1);
     5fa:	4505                	li	a0,1
     5fc:	00007097          	auipc	ra,0x7
     600:	2b4080e7          	jalr	692(ra) # 78b0 <exit>
  }
  if(pid == 0){
     604:	fdc42783          	lw	a5,-36(s0)
     608:	2781                	sext.w	a5,a5
     60a:	efd5                	bnez	a5,6c6 <copyinstr2+0x278>
    static char big[PGSIZE+1];
    for(int i = 0; i < PGSIZE; i++)
     60c:	fe042423          	sw	zero,-24(s0)
     610:	a00d                	j	632 <copyinstr2+0x1e4>
      big[i] = 'x';
     612:	00011717          	auipc	a4,0x11
     616:	3fe70713          	addi	a4,a4,1022 # 11a10 <big.0>
     61a:	fe842783          	lw	a5,-24(s0)
     61e:	97ba                	add	a5,a5,a4
     620:	07800713          	li	a4,120
     624:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
     628:	fe842783          	lw	a5,-24(s0)
     62c:	2785                	addiw	a5,a5,1
     62e:	fef42423          	sw	a5,-24(s0)
     632:	fe842783          	lw	a5,-24(s0)
     636:	0007871b          	sext.w	a4,a5
     63a:	6785                	lui	a5,0x1
     63c:	fcf74be3          	blt	a4,a5,612 <copyinstr2+0x1c4>
    big[PGSIZE] = '\0';
     640:	00011717          	auipc	a4,0x11
     644:	3d070713          	addi	a4,a4,976 # 11a10 <big.0>
     648:	6785                	lui	a5,0x1
     64a:	97ba                	add	a5,a5,a4
     64c:	00078023          	sb	zero,0(a5) # 1000 <truncate3+0x1b2>
    char *args2[] = { big, big, big, 0 };
     650:	00008797          	auipc	a5,0x8
     654:	d4078793          	addi	a5,a5,-704 # 8390 <malloc+0x3c6>
     658:	6390                	ld	a2,0(a5)
     65a:	6794                	ld	a3,8(a5)
     65c:	6b98                	ld	a4,16(a5)
     65e:	6f9c                	ld	a5,24(a5)
     660:	f2c43023          	sd	a2,-224(s0)
     664:	f2d43423          	sd	a3,-216(s0)
     668:	f2e43823          	sd	a4,-208(s0)
     66c:	f2f43c23          	sd	a5,-200(s0)
    ret = exec("echo", args2);
     670:	f2040793          	addi	a5,s0,-224
     674:	85be                	mv	a1,a5
     676:	00008517          	auipc	a0,0x8
     67a:	cba50513          	addi	a0,a0,-838 # 8330 <malloc+0x366>
     67e:	00007097          	auipc	ra,0x7
     682:	26a080e7          	jalr	618(ra) # 78e8 <exec>
     686:	87aa                	mv	a5,a0
     688:	fef42223          	sw	a5,-28(s0)
    if(ret != -1){
     68c:	fe442783          	lw	a5,-28(s0)
     690:	0007871b          	sext.w	a4,a5
     694:	57fd                	li	a5,-1
     696:	02f70263          	beq	a4,a5,6ba <copyinstr2+0x26c>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
     69a:	fe042783          	lw	a5,-32(s0)
     69e:	85be                	mv	a1,a5
     6a0:	00008517          	auipc	a0,0x8
     6a4:	c9850513          	addi	a0,a0,-872 # 8338 <malloc+0x36e>
     6a8:	00007097          	auipc	ra,0x7
     6ac:	730080e7          	jalr	1840(ra) # 7dd8 <printf>
      exit(1);
     6b0:	4505                	li	a0,1
     6b2:	00007097          	auipc	ra,0x7
     6b6:	1fe080e7          	jalr	510(ra) # 78b0 <exit>
    }
    exit(747); // OK
     6ba:	2eb00513          	li	a0,747
     6be:	00007097          	auipc	ra,0x7
     6c2:	1f2080e7          	jalr	498(ra) # 78b0 <exit>
  }

  int st = 0;
     6c6:	f4042223          	sw	zero,-188(s0)
  wait(&st);
     6ca:	f4440793          	addi	a5,s0,-188
     6ce:	853e                	mv	a0,a5
     6d0:	00007097          	auipc	ra,0x7
     6d4:	1e8080e7          	jalr	488(ra) # 78b8 <wait>
  if(st != 747){
     6d8:	f4442783          	lw	a5,-188(s0)
     6dc:	873e                	mv	a4,a5
     6de:	2eb00793          	li	a5,747
     6e2:	00f70f63          	beq	a4,a5,700 <copyinstr2+0x2b2>
    printf("exec(echo, BIG) succeeded, should have failed\n");
     6e6:	00008517          	auipc	a0,0x8
     6ea:	c7a50513          	addi	a0,a0,-902 # 8360 <malloc+0x396>
     6ee:	00007097          	auipc	ra,0x7
     6f2:	6ea080e7          	jalr	1770(ra) # 7dd8 <printf>
    exit(1);
     6f6:	4505                	li	a0,1
     6f8:	00007097          	auipc	ra,0x7
     6fc:	1b8080e7          	jalr	440(ra) # 78b0 <exit>
  }
}
     700:	0001                	nop
     702:	70ae                	ld	ra,232(sp)
     704:	740e                	ld	s0,224(sp)
     706:	616d                	addi	sp,sp,240
     708:	8082                	ret

000000000000070a <copyinstr3>:

// what if a string argument crosses over the end of last user page?
void
copyinstr3(char *s)
{
     70a:	715d                	addi	sp,sp,-80
     70c:	e486                	sd	ra,72(sp)
     70e:	e0a2                	sd	s0,64(sp)
     710:	0880                	addi	s0,sp,80
     712:	faa43c23          	sd	a0,-72(s0)
  sbrk(8192);
     716:	6509                	lui	a0,0x2
     718:	00007097          	auipc	ra,0x7
     71c:	220080e7          	jalr	544(ra) # 7938 <sbrk>
  uint64 top = (uint64) sbrk(0);
     720:	4501                	li	a0,0
     722:	00007097          	auipc	ra,0x7
     726:	216080e7          	jalr	534(ra) # 7938 <sbrk>
     72a:	87aa                	mv	a5,a0
     72c:	fef43423          	sd	a5,-24(s0)
  if((top % PGSIZE) != 0){
     730:	fe843703          	ld	a4,-24(s0)
     734:	6785                	lui	a5,0x1
     736:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
     738:	8ff9                	and	a5,a5,a4
     73a:	c39d                	beqz	a5,760 <copyinstr3+0x56>
    sbrk(PGSIZE - (top % PGSIZE));
     73c:	fe843783          	ld	a5,-24(s0)
     740:	2781                	sext.w	a5,a5
     742:	873e                	mv	a4,a5
     744:	6785                	lui	a5,0x1
     746:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
     748:	8ff9                	and	a5,a5,a4
     74a:	2781                	sext.w	a5,a5
     74c:	6705                	lui	a4,0x1
     74e:	40f707bb          	subw	a5,a4,a5
     752:	2781                	sext.w	a5,a5
     754:	2781                	sext.w	a5,a5
     756:	853e                	mv	a0,a5
     758:	00007097          	auipc	ra,0x7
     75c:	1e0080e7          	jalr	480(ra) # 7938 <sbrk>
  }
  top = (uint64) sbrk(0);
     760:	4501                	li	a0,0
     762:	00007097          	auipc	ra,0x7
     766:	1d6080e7          	jalr	470(ra) # 7938 <sbrk>
     76a:	87aa                	mv	a5,a0
     76c:	fef43423          	sd	a5,-24(s0)
  if(top % PGSIZE){
     770:	fe843703          	ld	a4,-24(s0)
     774:	6785                	lui	a5,0x1
     776:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
     778:	8ff9                	and	a5,a5,a4
     77a:	cf91                	beqz	a5,796 <copyinstr3+0x8c>
    printf("oops\n");
     77c:	00008517          	auipc	a0,0x8
     780:	c3450513          	addi	a0,a0,-972 # 83b0 <malloc+0x3e6>
     784:	00007097          	auipc	ra,0x7
     788:	654080e7          	jalr	1620(ra) # 7dd8 <printf>
    exit(1);
     78c:	4505                	li	a0,1
     78e:	00007097          	auipc	ra,0x7
     792:	122080e7          	jalr	290(ra) # 78b0 <exit>
  }

  char *b = (char *) (top - 1);
     796:	fe843783          	ld	a5,-24(s0)
     79a:	17fd                	addi	a5,a5,-1
     79c:	fef43023          	sd	a5,-32(s0)
  *b = 'x';
     7a0:	fe043783          	ld	a5,-32(s0)
     7a4:	07800713          	li	a4,120
     7a8:	00e78023          	sb	a4,0(a5)

  int ret = unlink(b);
     7ac:	fe043503          	ld	a0,-32(s0)
     7b0:	00007097          	auipc	ra,0x7
     7b4:	150080e7          	jalr	336(ra) # 7900 <unlink>
     7b8:	87aa                	mv	a5,a0
     7ba:	fcf42e23          	sw	a5,-36(s0)
  if(ret != -1){
     7be:	fdc42783          	lw	a5,-36(s0)
     7c2:	0007871b          	sext.w	a4,a5
     7c6:	57fd                	li	a5,-1
     7c8:	02f70463          	beq	a4,a5,7f0 <copyinstr3+0xe6>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
     7cc:	fdc42783          	lw	a5,-36(s0)
     7d0:	863e                	mv	a2,a5
     7d2:	fe043583          	ld	a1,-32(s0)
     7d6:	00008517          	auipc	a0,0x8
     7da:	aba50513          	addi	a0,a0,-1350 # 8290 <malloc+0x2c6>
     7de:	00007097          	auipc	ra,0x7
     7e2:	5fa080e7          	jalr	1530(ra) # 7dd8 <printf>
    exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00007097          	auipc	ra,0x7
     7ec:	0c8080e7          	jalr	200(ra) # 78b0 <exit>
  }

  int fd = open(b, O_CREATE | O_WRONLY);
     7f0:	20100593          	li	a1,513
     7f4:	fe043503          	ld	a0,-32(s0)
     7f8:	00007097          	auipc	ra,0x7
     7fc:	0f8080e7          	jalr	248(ra) # 78f0 <open>
     800:	87aa                	mv	a5,a0
     802:	fcf42c23          	sw	a5,-40(s0)
  if(fd != -1){
     806:	fd842783          	lw	a5,-40(s0)
     80a:	0007871b          	sext.w	a4,a5
     80e:	57fd                	li	a5,-1
     810:	02f70463          	beq	a4,a5,838 <copyinstr3+0x12e>
    printf("open(%s) returned %d, not -1\n", b, fd);
     814:	fd842783          	lw	a5,-40(s0)
     818:	863e                	mv	a2,a5
     81a:	fe043583          	ld	a1,-32(s0)
     81e:	00008517          	auipc	a0,0x8
     822:	a9250513          	addi	a0,a0,-1390 # 82b0 <malloc+0x2e6>
     826:	00007097          	auipc	ra,0x7
     82a:	5b2080e7          	jalr	1458(ra) # 7dd8 <printf>
    exit(1);
     82e:	4505                	li	a0,1
     830:	00007097          	auipc	ra,0x7
     834:	080080e7          	jalr	128(ra) # 78b0 <exit>
  }

  ret = link(b, b);
     838:	fe043583          	ld	a1,-32(s0)
     83c:	fe043503          	ld	a0,-32(s0)
     840:	00007097          	auipc	ra,0x7
     844:	0d0080e7          	jalr	208(ra) # 7910 <link>
     848:	87aa                	mv	a5,a0
     84a:	fcf42e23          	sw	a5,-36(s0)
  if(ret != -1){
     84e:	fdc42783          	lw	a5,-36(s0)
     852:	0007871b          	sext.w	a4,a5
     856:	57fd                	li	a5,-1
     858:	02f70663          	beq	a4,a5,884 <copyinstr3+0x17a>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
     85c:	fdc42783          	lw	a5,-36(s0)
     860:	86be                	mv	a3,a5
     862:	fe043603          	ld	a2,-32(s0)
     866:	fe043583          	ld	a1,-32(s0)
     86a:	00008517          	auipc	a0,0x8
     86e:	a6650513          	addi	a0,a0,-1434 # 82d0 <malloc+0x306>
     872:	00007097          	auipc	ra,0x7
     876:	566080e7          	jalr	1382(ra) # 7dd8 <printf>
    exit(1);
     87a:	4505                	li	a0,1
     87c:	00007097          	auipc	ra,0x7
     880:	034080e7          	jalr	52(ra) # 78b0 <exit>
  }

  char *args[] = { "xx", 0 };
     884:	00008797          	auipc	a5,0x8
     888:	a7478793          	addi	a5,a5,-1420 # 82f8 <malloc+0x32e>
     88c:	fcf43423          	sd	a5,-56(s0)
     890:	fc043823          	sd	zero,-48(s0)
  ret = exec(b, args);
     894:	fc840793          	addi	a5,s0,-56
     898:	85be                	mv	a1,a5
     89a:	fe043503          	ld	a0,-32(s0)
     89e:	00007097          	auipc	ra,0x7
     8a2:	04a080e7          	jalr	74(ra) # 78e8 <exec>
     8a6:	87aa                	mv	a5,a0
     8a8:	fcf42e23          	sw	a5,-36(s0)
  if(ret != -1){
     8ac:	fdc42783          	lw	a5,-36(s0)
     8b0:	0007871b          	sext.w	a4,a5
     8b4:	57fd                	li	a5,-1
     8b6:	02f70463          	beq	a4,a5,8de <copyinstr3+0x1d4>
    printf("exec(%s) returned %d, not -1\n", b, fd);
     8ba:	fd842783          	lw	a5,-40(s0)
     8be:	863e                	mv	a2,a5
     8c0:	fe043583          	ld	a1,-32(s0)
     8c4:	00008517          	auipc	a0,0x8
     8c8:	a3c50513          	addi	a0,a0,-1476 # 8300 <malloc+0x336>
     8cc:	00007097          	auipc	ra,0x7
     8d0:	50c080e7          	jalr	1292(ra) # 7dd8 <printf>
    exit(1);
     8d4:	4505                	li	a0,1
     8d6:	00007097          	auipc	ra,0x7
     8da:	fda080e7          	jalr	-38(ra) # 78b0 <exit>
  }
}
     8de:	0001                	nop
     8e0:	60a6                	ld	ra,72(sp)
     8e2:	6406                	ld	s0,64(sp)
     8e4:	6161                	addi	sp,sp,80
     8e6:	8082                	ret

00000000000008e8 <rwsbrk>:

// See if the kernel refuses to read/write user memory that the
// application doesn't have anymore, because it returned it.
void
rwsbrk()
{
     8e8:	1101                	addi	sp,sp,-32
     8ea:	ec06                	sd	ra,24(sp)
     8ec:	e822                	sd	s0,16(sp)
     8ee:	1000                	addi	s0,sp,32
  int fd, n;
  
  uint64 a = (uint64) sbrk(8192);
     8f0:	6509                	lui	a0,0x2
     8f2:	00007097          	auipc	ra,0x7
     8f6:	046080e7          	jalr	70(ra) # 7938 <sbrk>
     8fa:	87aa                	mv	a5,a0
     8fc:	fef43423          	sd	a5,-24(s0)

  if(a == 0xffffffffffffffffLL) {
     900:	fe843703          	ld	a4,-24(s0)
     904:	57fd                	li	a5,-1
     906:	00f71f63          	bne	a4,a5,924 <rwsbrk+0x3c>
    printf("sbrk(rwsbrk) failed\n");
     90a:	00008517          	auipc	a0,0x8
     90e:	aae50513          	addi	a0,a0,-1362 # 83b8 <malloc+0x3ee>
     912:	00007097          	auipc	ra,0x7
     916:	4c6080e7          	jalr	1222(ra) # 7dd8 <printf>
    exit(1);
     91a:	4505                	li	a0,1
     91c:	00007097          	auipc	ra,0x7
     920:	f94080e7          	jalr	-108(ra) # 78b0 <exit>
  }
  
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
     924:	7579                	lui	a0,0xffffe
     926:	00007097          	auipc	ra,0x7
     92a:	012080e7          	jalr	18(ra) # 7938 <sbrk>
     92e:	872a                	mv	a4,a0
     930:	57fd                	li	a5,-1
     932:	00f71f63          	bne	a4,a5,950 <rwsbrk+0x68>
    printf("sbrk(rwsbrk) shrink failed\n");
     936:	00008517          	auipc	a0,0x8
     93a:	a9a50513          	addi	a0,a0,-1382 # 83d0 <malloc+0x406>
     93e:	00007097          	auipc	ra,0x7
     942:	49a080e7          	jalr	1178(ra) # 7dd8 <printf>
    exit(1);
     946:	4505                	li	a0,1
     948:	00007097          	auipc	ra,0x7
     94c:	f68080e7          	jalr	-152(ra) # 78b0 <exit>
  }

  fd = open("rwsbrk", O_CREATE|O_WRONLY);
     950:	20100593          	li	a1,513
     954:	00008517          	auipc	a0,0x8
     958:	a9c50513          	addi	a0,a0,-1380 # 83f0 <malloc+0x426>
     95c:	00007097          	auipc	ra,0x7
     960:	f94080e7          	jalr	-108(ra) # 78f0 <open>
     964:	87aa                	mv	a5,a0
     966:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
     96a:	fe442783          	lw	a5,-28(s0)
     96e:	2781                	sext.w	a5,a5
     970:	0007df63          	bgez	a5,98e <rwsbrk+0xa6>
    printf("open(rwsbrk) failed\n");
     974:	00008517          	auipc	a0,0x8
     978:	a8450513          	addi	a0,a0,-1404 # 83f8 <malloc+0x42e>
     97c:	00007097          	auipc	ra,0x7
     980:	45c080e7          	jalr	1116(ra) # 7dd8 <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00007097          	auipc	ra,0x7
     98a:	f2a080e7          	jalr	-214(ra) # 78b0 <exit>
  }
  n = write(fd, (void*)(a+4096), 1024);
     98e:	fe843703          	ld	a4,-24(s0)
     992:	6785                	lui	a5,0x1
     994:	97ba                	add	a5,a5,a4
     996:	873e                	mv	a4,a5
     998:	fe442783          	lw	a5,-28(s0)
     99c:	40000613          	li	a2,1024
     9a0:	85ba                	mv	a1,a4
     9a2:	853e                	mv	a0,a5
     9a4:	00007097          	auipc	ra,0x7
     9a8:	f2c080e7          	jalr	-212(ra) # 78d0 <write>
     9ac:	87aa                	mv	a5,a0
     9ae:	fef42023          	sw	a5,-32(s0)
  if(n >= 0){
     9b2:	fe042783          	lw	a5,-32(s0)
     9b6:	2781                	sext.w	a5,a5
     9b8:	0207c763          	bltz	a5,9e6 <rwsbrk+0xfe>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
     9bc:	fe843703          	ld	a4,-24(s0)
     9c0:	6785                	lui	a5,0x1
     9c2:	97ba                	add	a5,a5,a4
     9c4:	fe042703          	lw	a4,-32(s0)
     9c8:	863a                	mv	a2,a4
     9ca:	85be                	mv	a1,a5
     9cc:	00008517          	auipc	a0,0x8
     9d0:	a4450513          	addi	a0,a0,-1468 # 8410 <malloc+0x446>
     9d4:	00007097          	auipc	ra,0x7
     9d8:	404080e7          	jalr	1028(ra) # 7dd8 <printf>
    exit(1);
     9dc:	4505                	li	a0,1
     9de:	00007097          	auipc	ra,0x7
     9e2:	ed2080e7          	jalr	-302(ra) # 78b0 <exit>
  }
  close(fd);
     9e6:	fe442783          	lw	a5,-28(s0)
     9ea:	853e                	mv	a0,a5
     9ec:	00007097          	auipc	ra,0x7
     9f0:	eec080e7          	jalr	-276(ra) # 78d8 <close>
  unlink("rwsbrk");
     9f4:	00008517          	auipc	a0,0x8
     9f8:	9fc50513          	addi	a0,a0,-1540 # 83f0 <malloc+0x426>
     9fc:	00007097          	auipc	ra,0x7
     a00:	f04080e7          	jalr	-252(ra) # 7900 <unlink>

  fd = open("README", O_RDONLY);
     a04:	4581                	li	a1,0
     a06:	00007517          	auipc	a0,0x7
     a0a:	7ca50513          	addi	a0,a0,1994 # 81d0 <malloc+0x206>
     a0e:	00007097          	auipc	ra,0x7
     a12:	ee2080e7          	jalr	-286(ra) # 78f0 <open>
     a16:	87aa                	mv	a5,a0
     a18:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
     a1c:	fe442783          	lw	a5,-28(s0)
     a20:	2781                	sext.w	a5,a5
     a22:	0007df63          	bgez	a5,a40 <rwsbrk+0x158>
    printf("open(rwsbrk) failed\n");
     a26:	00008517          	auipc	a0,0x8
     a2a:	9d250513          	addi	a0,a0,-1582 # 83f8 <malloc+0x42e>
     a2e:	00007097          	auipc	ra,0x7
     a32:	3aa080e7          	jalr	938(ra) # 7dd8 <printf>
    exit(1);
     a36:	4505                	li	a0,1
     a38:	00007097          	auipc	ra,0x7
     a3c:	e78080e7          	jalr	-392(ra) # 78b0 <exit>
  }
  n = read(fd, (void*)(a+4096), 10);
     a40:	fe843703          	ld	a4,-24(s0)
     a44:	6785                	lui	a5,0x1
     a46:	97ba                	add	a5,a5,a4
     a48:	873e                	mv	a4,a5
     a4a:	fe442783          	lw	a5,-28(s0)
     a4e:	4629                	li	a2,10
     a50:	85ba                	mv	a1,a4
     a52:	853e                	mv	a0,a5
     a54:	00007097          	auipc	ra,0x7
     a58:	e74080e7          	jalr	-396(ra) # 78c8 <read>
     a5c:	87aa                	mv	a5,a0
     a5e:	fef42023          	sw	a5,-32(s0)
  if(n >= 0){
     a62:	fe042783          	lw	a5,-32(s0)
     a66:	2781                	sext.w	a5,a5
     a68:	0207c763          	bltz	a5,a96 <rwsbrk+0x1ae>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
     a6c:	fe843703          	ld	a4,-24(s0)
     a70:	6785                	lui	a5,0x1
     a72:	97ba                	add	a5,a5,a4
     a74:	fe042703          	lw	a4,-32(s0)
     a78:	863a                	mv	a2,a4
     a7a:	85be                	mv	a1,a5
     a7c:	00008517          	auipc	a0,0x8
     a80:	9c450513          	addi	a0,a0,-1596 # 8440 <malloc+0x476>
     a84:	00007097          	auipc	ra,0x7
     a88:	354080e7          	jalr	852(ra) # 7dd8 <printf>
    exit(1);
     a8c:	4505                	li	a0,1
     a8e:	00007097          	auipc	ra,0x7
     a92:	e22080e7          	jalr	-478(ra) # 78b0 <exit>
  }
  close(fd);
     a96:	fe442783          	lw	a5,-28(s0)
     a9a:	853e                	mv	a0,a5
     a9c:	00007097          	auipc	ra,0x7
     aa0:	e3c080e7          	jalr	-452(ra) # 78d8 <close>
  
  exit(0);
     aa4:	4501                	li	a0,0
     aa6:	00007097          	auipc	ra,0x7
     aaa:	e0a080e7          	jalr	-502(ra) # 78b0 <exit>

0000000000000aae <truncate1>:
}

// test O_TRUNC.
void
truncate1(char *s)
{
     aae:	715d                	addi	sp,sp,-80
     ab0:	e486                	sd	ra,72(sp)
     ab2:	e0a2                	sd	s0,64(sp)
     ab4:	0880                	addi	s0,sp,80
     ab6:	faa43c23          	sd	a0,-72(s0)
  char buf[32];
  
  unlink("truncfile");
     aba:	00008517          	auipc	a0,0x8
     abe:	9ae50513          	addi	a0,a0,-1618 # 8468 <malloc+0x49e>
     ac2:	00007097          	auipc	ra,0x7
     ac6:	e3e080e7          	jalr	-450(ra) # 7900 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     aca:	60100593          	li	a1,1537
     ace:	00008517          	auipc	a0,0x8
     ad2:	99a50513          	addi	a0,a0,-1638 # 8468 <malloc+0x49e>
     ad6:	00007097          	auipc	ra,0x7
     ada:	e1a080e7          	jalr	-486(ra) # 78f0 <open>
     ade:	87aa                	mv	a5,a0
     ae0:	fef42623          	sw	a5,-20(s0)
  write(fd1, "abcd", 4);
     ae4:	fec42783          	lw	a5,-20(s0)
     ae8:	4611                	li	a2,4
     aea:	00008597          	auipc	a1,0x8
     aee:	98e58593          	addi	a1,a1,-1650 # 8478 <malloc+0x4ae>
     af2:	853e                	mv	a0,a5
     af4:	00007097          	auipc	ra,0x7
     af8:	ddc080e7          	jalr	-548(ra) # 78d0 <write>
  close(fd1);
     afc:	fec42783          	lw	a5,-20(s0)
     b00:	853e                	mv	a0,a5
     b02:	00007097          	auipc	ra,0x7
     b06:	dd6080e7          	jalr	-554(ra) # 78d8 <close>

  int fd2 = open("truncfile", O_RDONLY);
     b0a:	4581                	li	a1,0
     b0c:	00008517          	auipc	a0,0x8
     b10:	95c50513          	addi	a0,a0,-1700 # 8468 <malloc+0x49e>
     b14:	00007097          	auipc	ra,0x7
     b18:	ddc080e7          	jalr	-548(ra) # 78f0 <open>
     b1c:	87aa                	mv	a5,a0
     b1e:	fef42423          	sw	a5,-24(s0)
  int n = read(fd2, buf, sizeof(buf));
     b22:	fc040713          	addi	a4,s0,-64
     b26:	fe842783          	lw	a5,-24(s0)
     b2a:	02000613          	li	a2,32
     b2e:	85ba                	mv	a1,a4
     b30:	853e                	mv	a0,a5
     b32:	00007097          	auipc	ra,0x7
     b36:	d96080e7          	jalr	-618(ra) # 78c8 <read>
     b3a:	87aa                	mv	a5,a0
     b3c:	fef42223          	sw	a5,-28(s0)
  if(n != 4){
     b40:	fe442783          	lw	a5,-28(s0)
     b44:	0007871b          	sext.w	a4,a5
     b48:	4791                	li	a5,4
     b4a:	02f70463          	beq	a4,a5,b72 <truncate1+0xc4>
    printf("%s: read %d bytes, wanted 4\n", s, n);
     b4e:	fe442783          	lw	a5,-28(s0)
     b52:	863e                	mv	a2,a5
     b54:	fb843583          	ld	a1,-72(s0)
     b58:	00008517          	auipc	a0,0x8
     b5c:	92850513          	addi	a0,a0,-1752 # 8480 <malloc+0x4b6>
     b60:	00007097          	auipc	ra,0x7
     b64:	278080e7          	jalr	632(ra) # 7dd8 <printf>
    exit(1);
     b68:	4505                	li	a0,1
     b6a:	00007097          	auipc	ra,0x7
     b6e:	d46080e7          	jalr	-698(ra) # 78b0 <exit>
  }

  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     b72:	40100593          	li	a1,1025
     b76:	00008517          	auipc	a0,0x8
     b7a:	8f250513          	addi	a0,a0,-1806 # 8468 <malloc+0x49e>
     b7e:	00007097          	auipc	ra,0x7
     b82:	d72080e7          	jalr	-654(ra) # 78f0 <open>
     b86:	87aa                	mv	a5,a0
     b88:	fef42623          	sw	a5,-20(s0)

  int fd3 = open("truncfile", O_RDONLY);
     b8c:	4581                	li	a1,0
     b8e:	00008517          	auipc	a0,0x8
     b92:	8da50513          	addi	a0,a0,-1830 # 8468 <malloc+0x49e>
     b96:	00007097          	auipc	ra,0x7
     b9a:	d5a080e7          	jalr	-678(ra) # 78f0 <open>
     b9e:	87aa                	mv	a5,a0
     ba0:	fef42023          	sw	a5,-32(s0)
  n = read(fd3, buf, sizeof(buf));
     ba4:	fc040713          	addi	a4,s0,-64
     ba8:	fe042783          	lw	a5,-32(s0)
     bac:	02000613          	li	a2,32
     bb0:	85ba                	mv	a1,a4
     bb2:	853e                	mv	a0,a5
     bb4:	00007097          	auipc	ra,0x7
     bb8:	d14080e7          	jalr	-748(ra) # 78c8 <read>
     bbc:	87aa                	mv	a5,a0
     bbe:	fef42223          	sw	a5,-28(s0)
  if(n != 0){
     bc2:	fe442783          	lw	a5,-28(s0)
     bc6:	2781                	sext.w	a5,a5
     bc8:	cf95                	beqz	a5,c04 <truncate1+0x156>
    printf("aaa fd3=%d\n", fd3);
     bca:	fe042783          	lw	a5,-32(s0)
     bce:	85be                	mv	a1,a5
     bd0:	00008517          	auipc	a0,0x8
     bd4:	8d050513          	addi	a0,a0,-1840 # 84a0 <malloc+0x4d6>
     bd8:	00007097          	auipc	ra,0x7
     bdc:	200080e7          	jalr	512(ra) # 7dd8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     be0:	fe442783          	lw	a5,-28(s0)
     be4:	863e                	mv	a2,a5
     be6:	fb843583          	ld	a1,-72(s0)
     bea:	00008517          	auipc	a0,0x8
     bee:	8c650513          	addi	a0,a0,-1850 # 84b0 <malloc+0x4e6>
     bf2:	00007097          	auipc	ra,0x7
     bf6:	1e6080e7          	jalr	486(ra) # 7dd8 <printf>
    exit(1);
     bfa:	4505                	li	a0,1
     bfc:	00007097          	auipc	ra,0x7
     c00:	cb4080e7          	jalr	-844(ra) # 78b0 <exit>
  }

  n = read(fd2, buf, sizeof(buf));
     c04:	fc040713          	addi	a4,s0,-64
     c08:	fe842783          	lw	a5,-24(s0)
     c0c:	02000613          	li	a2,32
     c10:	85ba                	mv	a1,a4
     c12:	853e                	mv	a0,a5
     c14:	00007097          	auipc	ra,0x7
     c18:	cb4080e7          	jalr	-844(ra) # 78c8 <read>
     c1c:	87aa                	mv	a5,a0
     c1e:	fef42223          	sw	a5,-28(s0)
  if(n != 0){
     c22:	fe442783          	lw	a5,-28(s0)
     c26:	2781                	sext.w	a5,a5
     c28:	cf95                	beqz	a5,c64 <truncate1+0x1b6>
    printf("bbb fd2=%d\n", fd2);
     c2a:	fe842783          	lw	a5,-24(s0)
     c2e:	85be                	mv	a1,a5
     c30:	00008517          	auipc	a0,0x8
     c34:	8a050513          	addi	a0,a0,-1888 # 84d0 <malloc+0x506>
     c38:	00007097          	auipc	ra,0x7
     c3c:	1a0080e7          	jalr	416(ra) # 7dd8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     c40:	fe442783          	lw	a5,-28(s0)
     c44:	863e                	mv	a2,a5
     c46:	fb843583          	ld	a1,-72(s0)
     c4a:	00008517          	auipc	a0,0x8
     c4e:	86650513          	addi	a0,a0,-1946 # 84b0 <malloc+0x4e6>
     c52:	00007097          	auipc	ra,0x7
     c56:	186080e7          	jalr	390(ra) # 7dd8 <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	00007097          	auipc	ra,0x7
     c60:	c54080e7          	jalr	-940(ra) # 78b0 <exit>
  }
  
  write(fd1, "abcdef", 6);
     c64:	fec42783          	lw	a5,-20(s0)
     c68:	4619                	li	a2,6
     c6a:	00008597          	auipc	a1,0x8
     c6e:	87658593          	addi	a1,a1,-1930 # 84e0 <malloc+0x516>
     c72:	853e                	mv	a0,a5
     c74:	00007097          	auipc	ra,0x7
     c78:	c5c080e7          	jalr	-932(ra) # 78d0 <write>

  n = read(fd3, buf, sizeof(buf));
     c7c:	fc040713          	addi	a4,s0,-64
     c80:	fe042783          	lw	a5,-32(s0)
     c84:	02000613          	li	a2,32
     c88:	85ba                	mv	a1,a4
     c8a:	853e                	mv	a0,a5
     c8c:	00007097          	auipc	ra,0x7
     c90:	c3c080e7          	jalr	-964(ra) # 78c8 <read>
     c94:	87aa                	mv	a5,a0
     c96:	fef42223          	sw	a5,-28(s0)
  if(n != 6){
     c9a:	fe442783          	lw	a5,-28(s0)
     c9e:	0007871b          	sext.w	a4,a5
     ca2:	4799                	li	a5,6
     ca4:	02f70463          	beq	a4,a5,ccc <truncate1+0x21e>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     ca8:	fe442783          	lw	a5,-28(s0)
     cac:	863e                	mv	a2,a5
     cae:	fb843583          	ld	a1,-72(s0)
     cb2:	00008517          	auipc	a0,0x8
     cb6:	83650513          	addi	a0,a0,-1994 # 84e8 <malloc+0x51e>
     cba:	00007097          	auipc	ra,0x7
     cbe:	11e080e7          	jalr	286(ra) # 7dd8 <printf>
    exit(1);
     cc2:	4505                	li	a0,1
     cc4:	00007097          	auipc	ra,0x7
     cc8:	bec080e7          	jalr	-1044(ra) # 78b0 <exit>
  }

  n = read(fd2, buf, sizeof(buf));
     ccc:	fc040713          	addi	a4,s0,-64
     cd0:	fe842783          	lw	a5,-24(s0)
     cd4:	02000613          	li	a2,32
     cd8:	85ba                	mv	a1,a4
     cda:	853e                	mv	a0,a5
     cdc:	00007097          	auipc	ra,0x7
     ce0:	bec080e7          	jalr	-1044(ra) # 78c8 <read>
     ce4:	87aa                	mv	a5,a0
     ce6:	fef42223          	sw	a5,-28(s0)
  if(n != 2){
     cea:	fe442783          	lw	a5,-28(s0)
     cee:	0007871b          	sext.w	a4,a5
     cf2:	4789                	li	a5,2
     cf4:	02f70463          	beq	a4,a5,d1c <truncate1+0x26e>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     cf8:	fe442783          	lw	a5,-28(s0)
     cfc:	863e                	mv	a2,a5
     cfe:	fb843583          	ld	a1,-72(s0)
     d02:	00008517          	auipc	a0,0x8
     d06:	80650513          	addi	a0,a0,-2042 # 8508 <malloc+0x53e>
     d0a:	00007097          	auipc	ra,0x7
     d0e:	0ce080e7          	jalr	206(ra) # 7dd8 <printf>
    exit(1);
     d12:	4505                	li	a0,1
     d14:	00007097          	auipc	ra,0x7
     d18:	b9c080e7          	jalr	-1124(ra) # 78b0 <exit>
  }

  unlink("truncfile");
     d1c:	00007517          	auipc	a0,0x7
     d20:	74c50513          	addi	a0,a0,1868 # 8468 <malloc+0x49e>
     d24:	00007097          	auipc	ra,0x7
     d28:	bdc080e7          	jalr	-1060(ra) # 7900 <unlink>

  close(fd1);
     d2c:	fec42783          	lw	a5,-20(s0)
     d30:	853e                	mv	a0,a5
     d32:	00007097          	auipc	ra,0x7
     d36:	ba6080e7          	jalr	-1114(ra) # 78d8 <close>
  close(fd2);
     d3a:	fe842783          	lw	a5,-24(s0)
     d3e:	853e                	mv	a0,a5
     d40:	00007097          	auipc	ra,0x7
     d44:	b98080e7          	jalr	-1128(ra) # 78d8 <close>
  close(fd3);
     d48:	fe042783          	lw	a5,-32(s0)
     d4c:	853e                	mv	a0,a5
     d4e:	00007097          	auipc	ra,0x7
     d52:	b8a080e7          	jalr	-1142(ra) # 78d8 <close>
}
     d56:	0001                	nop
     d58:	60a6                	ld	ra,72(sp)
     d5a:	6406                	ld	s0,64(sp)
     d5c:	6161                	addi	sp,sp,80
     d5e:	8082                	ret

0000000000000d60 <truncate2>:
// this causes a write at an offset beyond the end of the file.
// such writes fail on xv6 (unlike POSIX) but at least
// they don't crash.
void
truncate2(char *s)
{
     d60:	7179                	addi	sp,sp,-48
     d62:	f406                	sd	ra,40(sp)
     d64:	f022                	sd	s0,32(sp)
     d66:	1800                	addi	s0,sp,48
     d68:	fca43c23          	sd	a0,-40(s0)
  unlink("truncfile");
     d6c:	00007517          	auipc	a0,0x7
     d70:	6fc50513          	addi	a0,a0,1788 # 8468 <malloc+0x49e>
     d74:	00007097          	auipc	ra,0x7
     d78:	b8c080e7          	jalr	-1140(ra) # 7900 <unlink>

  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     d7c:	60100593          	li	a1,1537
     d80:	00007517          	auipc	a0,0x7
     d84:	6e850513          	addi	a0,a0,1768 # 8468 <malloc+0x49e>
     d88:	00007097          	auipc	ra,0x7
     d8c:	b68080e7          	jalr	-1176(ra) # 78f0 <open>
     d90:	87aa                	mv	a5,a0
     d92:	fef42623          	sw	a5,-20(s0)
  write(fd1, "abcd", 4);
     d96:	fec42783          	lw	a5,-20(s0)
     d9a:	4611                	li	a2,4
     d9c:	00007597          	auipc	a1,0x7
     da0:	6dc58593          	addi	a1,a1,1756 # 8478 <malloc+0x4ae>
     da4:	853e                	mv	a0,a5
     da6:	00007097          	auipc	ra,0x7
     daa:	b2a080e7          	jalr	-1238(ra) # 78d0 <write>

  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     dae:	40100593          	li	a1,1025
     db2:	00007517          	auipc	a0,0x7
     db6:	6b650513          	addi	a0,a0,1718 # 8468 <malloc+0x49e>
     dba:	00007097          	auipc	ra,0x7
     dbe:	b36080e7          	jalr	-1226(ra) # 78f0 <open>
     dc2:	87aa                	mv	a5,a0
     dc4:	fef42423          	sw	a5,-24(s0)

  int n = write(fd1, "x", 1);
     dc8:	fec42783          	lw	a5,-20(s0)
     dcc:	4605                	li	a2,1
     dce:	00007597          	auipc	a1,0x7
     dd2:	45258593          	addi	a1,a1,1106 # 8220 <malloc+0x256>
     dd6:	853e                	mv	a0,a5
     dd8:	00007097          	auipc	ra,0x7
     ddc:	af8080e7          	jalr	-1288(ra) # 78d0 <write>
     de0:	87aa                	mv	a5,a0
     de2:	fef42223          	sw	a5,-28(s0)
  if(n != -1){
     de6:	fe442783          	lw	a5,-28(s0)
     dea:	0007871b          	sext.w	a4,a5
     dee:	57fd                	li	a5,-1
     df0:	02f70463          	beq	a4,a5,e18 <truncate2+0xb8>
    printf("%s: write returned %d, expected -1\n", s, n);
     df4:	fe442783          	lw	a5,-28(s0)
     df8:	863e                	mv	a2,a5
     dfa:	fd843583          	ld	a1,-40(s0)
     dfe:	00007517          	auipc	a0,0x7
     e02:	72a50513          	addi	a0,a0,1834 # 8528 <malloc+0x55e>
     e06:	00007097          	auipc	ra,0x7
     e0a:	fd2080e7          	jalr	-46(ra) # 7dd8 <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	00007097          	auipc	ra,0x7
     e14:	aa0080e7          	jalr	-1376(ra) # 78b0 <exit>
  }

  unlink("truncfile");
     e18:	00007517          	auipc	a0,0x7
     e1c:	65050513          	addi	a0,a0,1616 # 8468 <malloc+0x49e>
     e20:	00007097          	auipc	ra,0x7
     e24:	ae0080e7          	jalr	-1312(ra) # 7900 <unlink>
  close(fd1);
     e28:	fec42783          	lw	a5,-20(s0)
     e2c:	853e                	mv	a0,a5
     e2e:	00007097          	auipc	ra,0x7
     e32:	aaa080e7          	jalr	-1366(ra) # 78d8 <close>
  close(fd2);
     e36:	fe842783          	lw	a5,-24(s0)
     e3a:	853e                	mv	a0,a5
     e3c:	00007097          	auipc	ra,0x7
     e40:	a9c080e7          	jalr	-1380(ra) # 78d8 <close>
}
     e44:	0001                	nop
     e46:	70a2                	ld	ra,40(sp)
     e48:	7402                	ld	s0,32(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret

0000000000000e4e <truncate3>:

void
truncate3(char *s)
{
     e4e:	711d                	addi	sp,sp,-96
     e50:	ec86                	sd	ra,88(sp)
     e52:	e8a2                	sd	s0,80(sp)
     e54:	1080                	addi	s0,sp,96
     e56:	faa43423          	sd	a0,-88(s0)
  int pid, xstatus;

  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
     e5a:	60100593          	li	a1,1537
     e5e:	00007517          	auipc	a0,0x7
     e62:	60a50513          	addi	a0,a0,1546 # 8468 <malloc+0x49e>
     e66:	00007097          	auipc	ra,0x7
     e6a:	a8a080e7          	jalr	-1398(ra) # 78f0 <open>
     e6e:	87aa                	mv	a5,a0
     e70:	853e                	mv	a0,a5
     e72:	00007097          	auipc	ra,0x7
     e76:	a66080e7          	jalr	-1434(ra) # 78d8 <close>
  
  pid = fork();
     e7a:	00007097          	auipc	ra,0x7
     e7e:	a2e080e7          	jalr	-1490(ra) # 78a8 <fork>
     e82:	87aa                	mv	a5,a0
     e84:	fef42223          	sw	a5,-28(s0)
  if(pid < 0){
     e88:	fe442783          	lw	a5,-28(s0)
     e8c:	2781                	sext.w	a5,a5
     e8e:	0207d163          	bgez	a5,eb0 <truncate3+0x62>
    printf("%s: fork failed\n", s);
     e92:	fa843583          	ld	a1,-88(s0)
     e96:	00007517          	auipc	a0,0x7
     e9a:	6ba50513          	addi	a0,a0,1722 # 8550 <malloc+0x586>
     e9e:	00007097          	auipc	ra,0x7
     ea2:	f3a080e7          	jalr	-198(ra) # 7dd8 <printf>
    exit(1);
     ea6:	4505                	li	a0,1
     ea8:	00007097          	auipc	ra,0x7
     eac:	a08080e7          	jalr	-1528(ra) # 78b0 <exit>
  }

  if(pid == 0){
     eb0:	fe442783          	lw	a5,-28(s0)
     eb4:	2781                	sext.w	a5,a5
     eb6:	10079563          	bnez	a5,fc0 <truncate3+0x172>
    for(int i = 0; i < 100; i++){
     eba:	fe042623          	sw	zero,-20(s0)
     ebe:	a0e5                	j	fa6 <truncate3+0x158>
      char buf[32];
      int fd = open("truncfile", O_WRONLY);
     ec0:	4585                	li	a1,1
     ec2:	00007517          	auipc	a0,0x7
     ec6:	5a650513          	addi	a0,a0,1446 # 8468 <malloc+0x49e>
     eca:	00007097          	auipc	ra,0x7
     ece:	a26080e7          	jalr	-1498(ra) # 78f0 <open>
     ed2:	87aa                	mv	a5,a0
     ed4:	fcf42c23          	sw	a5,-40(s0)
      if(fd < 0){
     ed8:	fd842783          	lw	a5,-40(s0)
     edc:	2781                	sext.w	a5,a5
     ede:	0207d163          	bgez	a5,f00 <truncate3+0xb2>
        printf("%s: open failed\n", s);
     ee2:	fa843583          	ld	a1,-88(s0)
     ee6:	00007517          	auipc	a0,0x7
     eea:	68250513          	addi	a0,a0,1666 # 8568 <malloc+0x59e>
     eee:	00007097          	auipc	ra,0x7
     ef2:	eea080e7          	jalr	-278(ra) # 7dd8 <printf>
        exit(1);
     ef6:	4505                	li	a0,1
     ef8:	00007097          	auipc	ra,0x7
     efc:	9b8080e7          	jalr	-1608(ra) # 78b0 <exit>
      }
      int n = write(fd, "1234567890", 10);
     f00:	fd842783          	lw	a5,-40(s0)
     f04:	4629                	li	a2,10
     f06:	00007597          	auipc	a1,0x7
     f0a:	67a58593          	addi	a1,a1,1658 # 8580 <malloc+0x5b6>
     f0e:	853e                	mv	a0,a5
     f10:	00007097          	auipc	ra,0x7
     f14:	9c0080e7          	jalr	-1600(ra) # 78d0 <write>
     f18:	87aa                	mv	a5,a0
     f1a:	fcf42a23          	sw	a5,-44(s0)
      if(n != 10){
     f1e:	fd442783          	lw	a5,-44(s0)
     f22:	0007871b          	sext.w	a4,a5
     f26:	47a9                	li	a5,10
     f28:	02f70463          	beq	a4,a5,f50 <truncate3+0x102>
        printf("%s: write got %d, expected 10\n", s, n);
     f2c:	fd442783          	lw	a5,-44(s0)
     f30:	863e                	mv	a2,a5
     f32:	fa843583          	ld	a1,-88(s0)
     f36:	00007517          	auipc	a0,0x7
     f3a:	65a50513          	addi	a0,a0,1626 # 8590 <malloc+0x5c6>
     f3e:	00007097          	auipc	ra,0x7
     f42:	e9a080e7          	jalr	-358(ra) # 7dd8 <printf>
        exit(1);
     f46:	4505                	li	a0,1
     f48:	00007097          	auipc	ra,0x7
     f4c:	968080e7          	jalr	-1688(ra) # 78b0 <exit>
      }
      close(fd);
     f50:	fd842783          	lw	a5,-40(s0)
     f54:	853e                	mv	a0,a5
     f56:	00007097          	auipc	ra,0x7
     f5a:	982080e7          	jalr	-1662(ra) # 78d8 <close>
      fd = open("truncfile", O_RDONLY);
     f5e:	4581                	li	a1,0
     f60:	00007517          	auipc	a0,0x7
     f64:	50850513          	addi	a0,a0,1288 # 8468 <malloc+0x49e>
     f68:	00007097          	auipc	ra,0x7
     f6c:	988080e7          	jalr	-1656(ra) # 78f0 <open>
     f70:	87aa                	mv	a5,a0
     f72:	fcf42c23          	sw	a5,-40(s0)
      read(fd, buf, sizeof(buf));
     f76:	fb040713          	addi	a4,s0,-80
     f7a:	fd842783          	lw	a5,-40(s0)
     f7e:	02000613          	li	a2,32
     f82:	85ba                	mv	a1,a4
     f84:	853e                	mv	a0,a5
     f86:	00007097          	auipc	ra,0x7
     f8a:	942080e7          	jalr	-1726(ra) # 78c8 <read>
      close(fd);
     f8e:	fd842783          	lw	a5,-40(s0)
     f92:	853e                	mv	a0,a5
     f94:	00007097          	auipc	ra,0x7
     f98:	944080e7          	jalr	-1724(ra) # 78d8 <close>
    for(int i = 0; i < 100; i++){
     f9c:	fec42783          	lw	a5,-20(s0)
     fa0:	2785                	addiw	a5,a5,1 # 1001 <truncate3+0x1b3>
     fa2:	fef42623          	sw	a5,-20(s0)
     fa6:	fec42783          	lw	a5,-20(s0)
     faa:	0007871b          	sext.w	a4,a5
     fae:	06300793          	li	a5,99
     fb2:	f0e7d7e3          	bge	a5,a4,ec0 <truncate3+0x72>
    }
    exit(0);
     fb6:	4501                	li	a0,0
     fb8:	00007097          	auipc	ra,0x7
     fbc:	8f8080e7          	jalr	-1800(ra) # 78b0 <exit>
  }

  for(int i = 0; i < 150; i++){
     fc0:	fe042423          	sw	zero,-24(s0)
     fc4:	a075                	j	1070 <truncate3+0x222>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     fc6:	60100593          	li	a1,1537
     fca:	00007517          	auipc	a0,0x7
     fce:	49e50513          	addi	a0,a0,1182 # 8468 <malloc+0x49e>
     fd2:	00007097          	auipc	ra,0x7
     fd6:	91e080e7          	jalr	-1762(ra) # 78f0 <open>
     fda:	87aa                	mv	a5,a0
     fdc:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
     fe0:	fe042783          	lw	a5,-32(s0)
     fe4:	2781                	sext.w	a5,a5
     fe6:	0207d163          	bgez	a5,1008 <truncate3+0x1ba>
      printf("%s: open failed\n", s);
     fea:	fa843583          	ld	a1,-88(s0)
     fee:	00007517          	auipc	a0,0x7
     ff2:	57a50513          	addi	a0,a0,1402 # 8568 <malloc+0x59e>
     ff6:	00007097          	auipc	ra,0x7
     ffa:	de2080e7          	jalr	-542(ra) # 7dd8 <printf>
      exit(1);
     ffe:	4505                	li	a0,1
    1000:	00007097          	auipc	ra,0x7
    1004:	8b0080e7          	jalr	-1872(ra) # 78b0 <exit>
    }
    int n = write(fd, "xxx", 3);
    1008:	fe042783          	lw	a5,-32(s0)
    100c:	460d                	li	a2,3
    100e:	00007597          	auipc	a1,0x7
    1012:	5a258593          	addi	a1,a1,1442 # 85b0 <malloc+0x5e6>
    1016:	853e                	mv	a0,a5
    1018:	00007097          	auipc	ra,0x7
    101c:	8b8080e7          	jalr	-1864(ra) # 78d0 <write>
    1020:	87aa                	mv	a5,a0
    1022:	fcf42e23          	sw	a5,-36(s0)
    if(n != 3){
    1026:	fdc42783          	lw	a5,-36(s0)
    102a:	0007871b          	sext.w	a4,a5
    102e:	478d                	li	a5,3
    1030:	02f70463          	beq	a4,a5,1058 <truncate3+0x20a>
      printf("%s: write got %d, expected 3\n", s, n);
    1034:	fdc42783          	lw	a5,-36(s0)
    1038:	863e                	mv	a2,a5
    103a:	fa843583          	ld	a1,-88(s0)
    103e:	00007517          	auipc	a0,0x7
    1042:	57a50513          	addi	a0,a0,1402 # 85b8 <malloc+0x5ee>
    1046:	00007097          	auipc	ra,0x7
    104a:	d92080e7          	jalr	-622(ra) # 7dd8 <printf>
      exit(1);
    104e:	4505                	li	a0,1
    1050:	00007097          	auipc	ra,0x7
    1054:	860080e7          	jalr	-1952(ra) # 78b0 <exit>
    }
    close(fd);
    1058:	fe042783          	lw	a5,-32(s0)
    105c:	853e                	mv	a0,a5
    105e:	00007097          	auipc	ra,0x7
    1062:	87a080e7          	jalr	-1926(ra) # 78d8 <close>
  for(int i = 0; i < 150; i++){
    1066:	fe842783          	lw	a5,-24(s0)
    106a:	2785                	addiw	a5,a5,1
    106c:	fef42423          	sw	a5,-24(s0)
    1070:	fe842783          	lw	a5,-24(s0)
    1074:	0007871b          	sext.w	a4,a5
    1078:	09500793          	li	a5,149
    107c:	f4e7d5e3          	bge	a5,a4,fc6 <truncate3+0x178>
  }

  wait(&xstatus);
    1080:	fd040793          	addi	a5,s0,-48
    1084:	853e                	mv	a0,a5
    1086:	00007097          	auipc	ra,0x7
    108a:	832080e7          	jalr	-1998(ra) # 78b8 <wait>
  unlink("truncfile");
    108e:	00007517          	auipc	a0,0x7
    1092:	3da50513          	addi	a0,a0,986 # 8468 <malloc+0x49e>
    1096:	00007097          	auipc	ra,0x7
    109a:	86a080e7          	jalr	-1942(ra) # 7900 <unlink>
  exit(xstatus);
    109e:	fd042783          	lw	a5,-48(s0)
    10a2:	853e                	mv	a0,a5
    10a4:	00007097          	auipc	ra,0x7
    10a8:	80c080e7          	jalr	-2036(ra) # 78b0 <exit>

00000000000010ac <iputtest>:
  

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(char *s)
{
    10ac:	1101                	addi	sp,sp,-32
    10ae:	ec06                	sd	ra,24(sp)
    10b0:	e822                	sd	s0,16(sp)
    10b2:	1000                	addi	s0,sp,32
    10b4:	fea43423          	sd	a0,-24(s0)
  if(mkdir("iputdir") < 0){
    10b8:	00007517          	auipc	a0,0x7
    10bc:	52050513          	addi	a0,a0,1312 # 85d8 <malloc+0x60e>
    10c0:	00007097          	auipc	ra,0x7
    10c4:	858080e7          	jalr	-1960(ra) # 7918 <mkdir>
    10c8:	87aa                	mv	a5,a0
    10ca:	0207d163          	bgez	a5,10ec <iputtest+0x40>
    printf("%s: mkdir failed\n", s);
    10ce:	fe843583          	ld	a1,-24(s0)
    10d2:	00007517          	auipc	a0,0x7
    10d6:	50e50513          	addi	a0,a0,1294 # 85e0 <malloc+0x616>
    10da:	00007097          	auipc	ra,0x7
    10de:	cfe080e7          	jalr	-770(ra) # 7dd8 <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00006097          	auipc	ra,0x6
    10e8:	7cc080e7          	jalr	1996(ra) # 78b0 <exit>
  }
  if(chdir("iputdir") < 0){
    10ec:	00007517          	auipc	a0,0x7
    10f0:	4ec50513          	addi	a0,a0,1260 # 85d8 <malloc+0x60e>
    10f4:	00007097          	auipc	ra,0x7
    10f8:	82c080e7          	jalr	-2004(ra) # 7920 <chdir>
    10fc:	87aa                	mv	a5,a0
    10fe:	0207d163          	bgez	a5,1120 <iputtest+0x74>
    printf("%s: chdir iputdir failed\n", s);
    1102:	fe843583          	ld	a1,-24(s0)
    1106:	00007517          	auipc	a0,0x7
    110a:	4f250513          	addi	a0,a0,1266 # 85f8 <malloc+0x62e>
    110e:	00007097          	auipc	ra,0x7
    1112:	cca080e7          	jalr	-822(ra) # 7dd8 <printf>
    exit(1);
    1116:	4505                	li	a0,1
    1118:	00006097          	auipc	ra,0x6
    111c:	798080e7          	jalr	1944(ra) # 78b0 <exit>
  }
  if(unlink("../iputdir") < 0){
    1120:	00007517          	auipc	a0,0x7
    1124:	4f850513          	addi	a0,a0,1272 # 8618 <malloc+0x64e>
    1128:	00006097          	auipc	ra,0x6
    112c:	7d8080e7          	jalr	2008(ra) # 7900 <unlink>
    1130:	87aa                	mv	a5,a0
    1132:	0207d163          	bgez	a5,1154 <iputtest+0xa8>
    printf("%s: unlink ../iputdir failed\n", s);
    1136:	fe843583          	ld	a1,-24(s0)
    113a:	00007517          	auipc	a0,0x7
    113e:	4ee50513          	addi	a0,a0,1262 # 8628 <malloc+0x65e>
    1142:	00007097          	auipc	ra,0x7
    1146:	c96080e7          	jalr	-874(ra) # 7dd8 <printf>
    exit(1);
    114a:	4505                	li	a0,1
    114c:	00006097          	auipc	ra,0x6
    1150:	764080e7          	jalr	1892(ra) # 78b0 <exit>
  }
  if(chdir("/") < 0){
    1154:	00007517          	auipc	a0,0x7
    1158:	4f450513          	addi	a0,a0,1268 # 8648 <malloc+0x67e>
    115c:	00006097          	auipc	ra,0x6
    1160:	7c4080e7          	jalr	1988(ra) # 7920 <chdir>
    1164:	87aa                	mv	a5,a0
    1166:	0207d163          	bgez	a5,1188 <iputtest+0xdc>
    printf("%s: chdir / failed\n", s);
    116a:	fe843583          	ld	a1,-24(s0)
    116e:	00007517          	auipc	a0,0x7
    1172:	4e250513          	addi	a0,a0,1250 # 8650 <malloc+0x686>
    1176:	00007097          	auipc	ra,0x7
    117a:	c62080e7          	jalr	-926(ra) # 7dd8 <printf>
    exit(1);
    117e:	4505                	li	a0,1
    1180:	00006097          	auipc	ra,0x6
    1184:	730080e7          	jalr	1840(ra) # 78b0 <exit>
  }
}
    1188:	0001                	nop
    118a:	60e2                	ld	ra,24(sp)
    118c:	6442                	ld	s0,16(sp)
    118e:	6105                	addi	sp,sp,32
    1190:	8082                	ret

0000000000001192 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(char *s)
{
    1192:	7179                	addi	sp,sp,-48
    1194:	f406                	sd	ra,40(sp)
    1196:	f022                	sd	s0,32(sp)
    1198:	1800                	addi	s0,sp,48
    119a:	fca43c23          	sd	a0,-40(s0)
  int pid, xstatus;

  pid = fork();
    119e:	00006097          	auipc	ra,0x6
    11a2:	70a080e7          	jalr	1802(ra) # 78a8 <fork>
    11a6:	87aa                	mv	a5,a0
    11a8:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    11ac:	fec42783          	lw	a5,-20(s0)
    11b0:	2781                	sext.w	a5,a5
    11b2:	0207d163          	bgez	a5,11d4 <exitiputtest+0x42>
    printf("%s: fork failed\n", s);
    11b6:	fd843583          	ld	a1,-40(s0)
    11ba:	00007517          	auipc	a0,0x7
    11be:	39650513          	addi	a0,a0,918 # 8550 <malloc+0x586>
    11c2:	00007097          	auipc	ra,0x7
    11c6:	c16080e7          	jalr	-1002(ra) # 7dd8 <printf>
    exit(1);
    11ca:	4505                	li	a0,1
    11cc:	00006097          	auipc	ra,0x6
    11d0:	6e4080e7          	jalr	1764(ra) # 78b0 <exit>
  }
  if(pid == 0){
    11d4:	fec42783          	lw	a5,-20(s0)
    11d8:	2781                	sext.w	a5,a5
    11da:	e7c5                	bnez	a5,1282 <exitiputtest+0xf0>
    if(mkdir("iputdir") < 0){
    11dc:	00007517          	auipc	a0,0x7
    11e0:	3fc50513          	addi	a0,a0,1020 # 85d8 <malloc+0x60e>
    11e4:	00006097          	auipc	ra,0x6
    11e8:	734080e7          	jalr	1844(ra) # 7918 <mkdir>
    11ec:	87aa                	mv	a5,a0
    11ee:	0207d163          	bgez	a5,1210 <exitiputtest+0x7e>
      printf("%s: mkdir failed\n", s);
    11f2:	fd843583          	ld	a1,-40(s0)
    11f6:	00007517          	auipc	a0,0x7
    11fa:	3ea50513          	addi	a0,a0,1002 # 85e0 <malloc+0x616>
    11fe:	00007097          	auipc	ra,0x7
    1202:	bda080e7          	jalr	-1062(ra) # 7dd8 <printf>
      exit(1);
    1206:	4505                	li	a0,1
    1208:	00006097          	auipc	ra,0x6
    120c:	6a8080e7          	jalr	1704(ra) # 78b0 <exit>
    }
    if(chdir("iputdir") < 0){
    1210:	00007517          	auipc	a0,0x7
    1214:	3c850513          	addi	a0,a0,968 # 85d8 <malloc+0x60e>
    1218:	00006097          	auipc	ra,0x6
    121c:	708080e7          	jalr	1800(ra) # 7920 <chdir>
    1220:	87aa                	mv	a5,a0
    1222:	0207d163          	bgez	a5,1244 <exitiputtest+0xb2>
      printf("%s: child chdir failed\n", s);
    1226:	fd843583          	ld	a1,-40(s0)
    122a:	00007517          	auipc	a0,0x7
    122e:	43e50513          	addi	a0,a0,1086 # 8668 <malloc+0x69e>
    1232:	00007097          	auipc	ra,0x7
    1236:	ba6080e7          	jalr	-1114(ra) # 7dd8 <printf>
      exit(1);
    123a:	4505                	li	a0,1
    123c:	00006097          	auipc	ra,0x6
    1240:	674080e7          	jalr	1652(ra) # 78b0 <exit>
    }
    if(unlink("../iputdir") < 0){
    1244:	00007517          	auipc	a0,0x7
    1248:	3d450513          	addi	a0,a0,980 # 8618 <malloc+0x64e>
    124c:	00006097          	auipc	ra,0x6
    1250:	6b4080e7          	jalr	1716(ra) # 7900 <unlink>
    1254:	87aa                	mv	a5,a0
    1256:	0207d163          	bgez	a5,1278 <exitiputtest+0xe6>
      printf("%s: unlink ../iputdir failed\n", s);
    125a:	fd843583          	ld	a1,-40(s0)
    125e:	00007517          	auipc	a0,0x7
    1262:	3ca50513          	addi	a0,a0,970 # 8628 <malloc+0x65e>
    1266:	00007097          	auipc	ra,0x7
    126a:	b72080e7          	jalr	-1166(ra) # 7dd8 <printf>
      exit(1);
    126e:	4505                	li	a0,1
    1270:	00006097          	auipc	ra,0x6
    1274:	640080e7          	jalr	1600(ra) # 78b0 <exit>
    }
    exit(0);
    1278:	4501                	li	a0,0
    127a:	00006097          	auipc	ra,0x6
    127e:	636080e7          	jalr	1590(ra) # 78b0 <exit>
  }
  wait(&xstatus);
    1282:	fe840793          	addi	a5,s0,-24
    1286:	853e                	mv	a0,a5
    1288:	00006097          	auipc	ra,0x6
    128c:	630080e7          	jalr	1584(ra) # 78b8 <wait>
  exit(xstatus);
    1290:	fe842783          	lw	a5,-24(s0)
    1294:	853e                	mv	a0,a5
    1296:	00006097          	auipc	ra,0x6
    129a:	61a080e7          	jalr	1562(ra) # 78b0 <exit>

000000000000129e <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(char *s)
{
    129e:	7179                	addi	sp,sp,-48
    12a0:	f406                	sd	ra,40(sp)
    12a2:	f022                	sd	s0,32(sp)
    12a4:	1800                	addi	s0,sp,48
    12a6:	fca43c23          	sd	a0,-40(s0)
  int pid, xstatus;

  if(mkdir("oidir") < 0){
    12aa:	00007517          	auipc	a0,0x7
    12ae:	3d650513          	addi	a0,a0,982 # 8680 <malloc+0x6b6>
    12b2:	00006097          	auipc	ra,0x6
    12b6:	666080e7          	jalr	1638(ra) # 7918 <mkdir>
    12ba:	87aa                	mv	a5,a0
    12bc:	0207d163          	bgez	a5,12de <openiputtest+0x40>
    printf("%s: mkdir oidir failed\n", s);
    12c0:	fd843583          	ld	a1,-40(s0)
    12c4:	00007517          	auipc	a0,0x7
    12c8:	3c450513          	addi	a0,a0,964 # 8688 <malloc+0x6be>
    12cc:	00007097          	auipc	ra,0x7
    12d0:	b0c080e7          	jalr	-1268(ra) # 7dd8 <printf>
    exit(1);
    12d4:	4505                	li	a0,1
    12d6:	00006097          	auipc	ra,0x6
    12da:	5da080e7          	jalr	1498(ra) # 78b0 <exit>
  }
  pid = fork();
    12de:	00006097          	auipc	ra,0x6
    12e2:	5ca080e7          	jalr	1482(ra) # 78a8 <fork>
    12e6:	87aa                	mv	a5,a0
    12e8:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    12ec:	fec42783          	lw	a5,-20(s0)
    12f0:	2781                	sext.w	a5,a5
    12f2:	0207d163          	bgez	a5,1314 <openiputtest+0x76>
    printf("%s: fork failed\n", s);
    12f6:	fd843583          	ld	a1,-40(s0)
    12fa:	00007517          	auipc	a0,0x7
    12fe:	25650513          	addi	a0,a0,598 # 8550 <malloc+0x586>
    1302:	00007097          	auipc	ra,0x7
    1306:	ad6080e7          	jalr	-1322(ra) # 7dd8 <printf>
    exit(1);
    130a:	4505                	li	a0,1
    130c:	00006097          	auipc	ra,0x6
    1310:	5a4080e7          	jalr	1444(ra) # 78b0 <exit>
  }
  if(pid == 0){
    1314:	fec42783          	lw	a5,-20(s0)
    1318:	2781                	sext.w	a5,a5
    131a:	e7b1                	bnez	a5,1366 <openiputtest+0xc8>
    int fd = open("oidir", O_RDWR);
    131c:	4589                	li	a1,2
    131e:	00007517          	auipc	a0,0x7
    1322:	36250513          	addi	a0,a0,866 # 8680 <malloc+0x6b6>
    1326:	00006097          	auipc	ra,0x6
    132a:	5ca080e7          	jalr	1482(ra) # 78f0 <open>
    132e:	87aa                	mv	a5,a0
    1330:	fef42423          	sw	a5,-24(s0)
    if(fd >= 0){
    1334:	fe842783          	lw	a5,-24(s0)
    1338:	2781                	sext.w	a5,a5
    133a:	0207c163          	bltz	a5,135c <openiputtest+0xbe>
      printf("%s: open directory for write succeeded\n", s);
    133e:	fd843583          	ld	a1,-40(s0)
    1342:	00007517          	auipc	a0,0x7
    1346:	35e50513          	addi	a0,a0,862 # 86a0 <malloc+0x6d6>
    134a:	00007097          	auipc	ra,0x7
    134e:	a8e080e7          	jalr	-1394(ra) # 7dd8 <printf>
      exit(1);
    1352:	4505                	li	a0,1
    1354:	00006097          	auipc	ra,0x6
    1358:	55c080e7          	jalr	1372(ra) # 78b0 <exit>
    }
    exit(0);
    135c:	4501                	li	a0,0
    135e:	00006097          	auipc	ra,0x6
    1362:	552080e7          	jalr	1362(ra) # 78b0 <exit>
  }
  sleep(1);
    1366:	4505                	li	a0,1
    1368:	00006097          	auipc	ra,0x6
    136c:	5d8080e7          	jalr	1496(ra) # 7940 <sleep>
  if(unlink("oidir") != 0){
    1370:	00007517          	auipc	a0,0x7
    1374:	31050513          	addi	a0,a0,784 # 8680 <malloc+0x6b6>
    1378:	00006097          	auipc	ra,0x6
    137c:	588080e7          	jalr	1416(ra) # 7900 <unlink>
    1380:	87aa                	mv	a5,a0
    1382:	c385                	beqz	a5,13a2 <openiputtest+0x104>
    printf("%s: unlink failed\n", s);
    1384:	fd843583          	ld	a1,-40(s0)
    1388:	00007517          	auipc	a0,0x7
    138c:	34050513          	addi	a0,a0,832 # 86c8 <malloc+0x6fe>
    1390:	00007097          	auipc	ra,0x7
    1394:	a48080e7          	jalr	-1464(ra) # 7dd8 <printf>
    exit(1);
    1398:	4505                	li	a0,1
    139a:	00006097          	auipc	ra,0x6
    139e:	516080e7          	jalr	1302(ra) # 78b0 <exit>
  }
  wait(&xstatus);
    13a2:	fe440793          	addi	a5,s0,-28
    13a6:	853e                	mv	a0,a5
    13a8:	00006097          	auipc	ra,0x6
    13ac:	510080e7          	jalr	1296(ra) # 78b8 <wait>
  exit(xstatus);
    13b0:	fe442783          	lw	a5,-28(s0)
    13b4:	853e                	mv	a0,a5
    13b6:	00006097          	auipc	ra,0x6
    13ba:	4fa080e7          	jalr	1274(ra) # 78b0 <exit>

00000000000013be <opentest>:

// simple file system tests

void
opentest(char *s)
{
    13be:	7179                	addi	sp,sp,-48
    13c0:	f406                	sd	ra,40(sp)
    13c2:	f022                	sd	s0,32(sp)
    13c4:	1800                	addi	s0,sp,48
    13c6:	fca43c23          	sd	a0,-40(s0)
  int fd;

  fd = open("echo", 0);
    13ca:	4581                	li	a1,0
    13cc:	00007517          	auipc	a0,0x7
    13d0:	f6450513          	addi	a0,a0,-156 # 8330 <malloc+0x366>
    13d4:	00006097          	auipc	ra,0x6
    13d8:	51c080e7          	jalr	1308(ra) # 78f0 <open>
    13dc:	87aa                	mv	a5,a0
    13de:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    13e2:	fec42783          	lw	a5,-20(s0)
    13e6:	2781                	sext.w	a5,a5
    13e8:	0207d163          	bgez	a5,140a <opentest+0x4c>
    printf("%s: open echo failed!\n", s);
    13ec:	fd843583          	ld	a1,-40(s0)
    13f0:	00007517          	auipc	a0,0x7
    13f4:	2f050513          	addi	a0,a0,752 # 86e0 <malloc+0x716>
    13f8:	00007097          	auipc	ra,0x7
    13fc:	9e0080e7          	jalr	-1568(ra) # 7dd8 <printf>
    exit(1);
    1400:	4505                	li	a0,1
    1402:	00006097          	auipc	ra,0x6
    1406:	4ae080e7          	jalr	1198(ra) # 78b0 <exit>
  }
  close(fd);
    140a:	fec42783          	lw	a5,-20(s0)
    140e:	853e                	mv	a0,a5
    1410:	00006097          	auipc	ra,0x6
    1414:	4c8080e7          	jalr	1224(ra) # 78d8 <close>
  fd = open("doesnotexist", 0);
    1418:	4581                	li	a1,0
    141a:	00007517          	auipc	a0,0x7
    141e:	2de50513          	addi	a0,a0,734 # 86f8 <malloc+0x72e>
    1422:	00006097          	auipc	ra,0x6
    1426:	4ce080e7          	jalr	1230(ra) # 78f0 <open>
    142a:	87aa                	mv	a5,a0
    142c:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    1430:	fec42783          	lw	a5,-20(s0)
    1434:	2781                	sext.w	a5,a5
    1436:	0207c163          	bltz	a5,1458 <opentest+0x9a>
    printf("%s: open doesnotexist succeeded!\n", s);
    143a:	fd843583          	ld	a1,-40(s0)
    143e:	00007517          	auipc	a0,0x7
    1442:	2ca50513          	addi	a0,a0,714 # 8708 <malloc+0x73e>
    1446:	00007097          	auipc	ra,0x7
    144a:	992080e7          	jalr	-1646(ra) # 7dd8 <printf>
    exit(1);
    144e:	4505                	li	a0,1
    1450:	00006097          	auipc	ra,0x6
    1454:	460080e7          	jalr	1120(ra) # 78b0 <exit>
  }
}
    1458:	0001                	nop
    145a:	70a2                	ld	ra,40(sp)
    145c:	7402                	ld	s0,32(sp)
    145e:	6145                	addi	sp,sp,48
    1460:	8082                	ret

0000000000001462 <writetest>:

void
writetest(char *s)
{
    1462:	7179                	addi	sp,sp,-48
    1464:	f406                	sd	ra,40(sp)
    1466:	f022                	sd	s0,32(sp)
    1468:	1800                	addi	s0,sp,48
    146a:	fca43c23          	sd	a0,-40(s0)
  int fd;
  int i;
  enum { N=100, SZ=10 };
  
  fd = open("small", O_CREATE|O_RDWR);
    146e:	20200593          	li	a1,514
    1472:	00007517          	auipc	a0,0x7
    1476:	2be50513          	addi	a0,a0,702 # 8730 <malloc+0x766>
    147a:	00006097          	auipc	ra,0x6
    147e:	476080e7          	jalr	1142(ra) # 78f0 <open>
    1482:	87aa                	mv	a5,a0
    1484:	fef42423          	sw	a5,-24(s0)
  if(fd < 0){
    1488:	fe842783          	lw	a5,-24(s0)
    148c:	2781                	sext.w	a5,a5
    148e:	0207d163          	bgez	a5,14b0 <writetest+0x4e>
    printf("%s: error: creat small failed!\n", s);
    1492:	fd843583          	ld	a1,-40(s0)
    1496:	00007517          	auipc	a0,0x7
    149a:	2a250513          	addi	a0,a0,674 # 8738 <malloc+0x76e>
    149e:	00007097          	auipc	ra,0x7
    14a2:	93a080e7          	jalr	-1734(ra) # 7dd8 <printf>
    exit(1);
    14a6:	4505                	li	a0,1
    14a8:	00006097          	auipc	ra,0x6
    14ac:	408080e7          	jalr	1032(ra) # 78b0 <exit>
  }
  for(i = 0; i < N; i++){
    14b0:	fe042623          	sw	zero,-20(s0)
    14b4:	a861                	j	154c <writetest+0xea>
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    14b6:	fe842783          	lw	a5,-24(s0)
    14ba:	4629                	li	a2,10
    14bc:	00007597          	auipc	a1,0x7
    14c0:	29c58593          	addi	a1,a1,668 # 8758 <malloc+0x78e>
    14c4:	853e                	mv	a0,a5
    14c6:	00006097          	auipc	ra,0x6
    14ca:	40a080e7          	jalr	1034(ra) # 78d0 <write>
    14ce:	87aa                	mv	a5,a0
    14d0:	873e                	mv	a4,a5
    14d2:	47a9                	li	a5,10
    14d4:	02f70463          	beq	a4,a5,14fc <writetest+0x9a>
      printf("%s: error: write aa %d new file failed\n", s, i);
    14d8:	fec42783          	lw	a5,-20(s0)
    14dc:	863e                	mv	a2,a5
    14de:	fd843583          	ld	a1,-40(s0)
    14e2:	00007517          	auipc	a0,0x7
    14e6:	28650513          	addi	a0,a0,646 # 8768 <malloc+0x79e>
    14ea:	00007097          	auipc	ra,0x7
    14ee:	8ee080e7          	jalr	-1810(ra) # 7dd8 <printf>
      exit(1);
    14f2:	4505                	li	a0,1
    14f4:	00006097          	auipc	ra,0x6
    14f8:	3bc080e7          	jalr	956(ra) # 78b0 <exit>
    }
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    14fc:	fe842783          	lw	a5,-24(s0)
    1500:	4629                	li	a2,10
    1502:	00007597          	auipc	a1,0x7
    1506:	28e58593          	addi	a1,a1,654 # 8790 <malloc+0x7c6>
    150a:	853e                	mv	a0,a5
    150c:	00006097          	auipc	ra,0x6
    1510:	3c4080e7          	jalr	964(ra) # 78d0 <write>
    1514:	87aa                	mv	a5,a0
    1516:	873e                	mv	a4,a5
    1518:	47a9                	li	a5,10
    151a:	02f70463          	beq	a4,a5,1542 <writetest+0xe0>
      printf("%s: error: write bb %d new file failed\n", s, i);
    151e:	fec42783          	lw	a5,-20(s0)
    1522:	863e                	mv	a2,a5
    1524:	fd843583          	ld	a1,-40(s0)
    1528:	00007517          	auipc	a0,0x7
    152c:	27850513          	addi	a0,a0,632 # 87a0 <malloc+0x7d6>
    1530:	00007097          	auipc	ra,0x7
    1534:	8a8080e7          	jalr	-1880(ra) # 7dd8 <printf>
      exit(1);
    1538:	4505                	li	a0,1
    153a:	00006097          	auipc	ra,0x6
    153e:	376080e7          	jalr	886(ra) # 78b0 <exit>
  for(i = 0; i < N; i++){
    1542:	fec42783          	lw	a5,-20(s0)
    1546:	2785                	addiw	a5,a5,1
    1548:	fef42623          	sw	a5,-20(s0)
    154c:	fec42783          	lw	a5,-20(s0)
    1550:	0007871b          	sext.w	a4,a5
    1554:	06300793          	li	a5,99
    1558:	f4e7dfe3          	bge	a5,a4,14b6 <writetest+0x54>
    }
  }
  close(fd);
    155c:	fe842783          	lw	a5,-24(s0)
    1560:	853e                	mv	a0,a5
    1562:	00006097          	auipc	ra,0x6
    1566:	376080e7          	jalr	886(ra) # 78d8 <close>
  fd = open("small", O_RDONLY);
    156a:	4581                	li	a1,0
    156c:	00007517          	auipc	a0,0x7
    1570:	1c450513          	addi	a0,a0,452 # 8730 <malloc+0x766>
    1574:	00006097          	auipc	ra,0x6
    1578:	37c080e7          	jalr	892(ra) # 78f0 <open>
    157c:	87aa                	mv	a5,a0
    157e:	fef42423          	sw	a5,-24(s0)
  if(fd < 0){
    1582:	fe842783          	lw	a5,-24(s0)
    1586:	2781                	sext.w	a5,a5
    1588:	0207d163          	bgez	a5,15aa <writetest+0x148>
    printf("%s: error: open small failed!\n", s);
    158c:	fd843583          	ld	a1,-40(s0)
    1590:	00007517          	auipc	a0,0x7
    1594:	23850513          	addi	a0,a0,568 # 87c8 <malloc+0x7fe>
    1598:	00007097          	auipc	ra,0x7
    159c:	840080e7          	jalr	-1984(ra) # 7dd8 <printf>
    exit(1);
    15a0:	4505                	li	a0,1
    15a2:	00006097          	auipc	ra,0x6
    15a6:	30e080e7          	jalr	782(ra) # 78b0 <exit>
  }
  i = read(fd, buf, N*SZ*2);
    15aa:	fe842783          	lw	a5,-24(s0)
    15ae:	7d000613          	li	a2,2000
    15b2:	0000b597          	auipc	a1,0xb
    15b6:	d4e58593          	addi	a1,a1,-690 # c300 <buf>
    15ba:	853e                	mv	a0,a5
    15bc:	00006097          	auipc	ra,0x6
    15c0:	30c080e7          	jalr	780(ra) # 78c8 <read>
    15c4:	87aa                	mv	a5,a0
    15c6:	fef42623          	sw	a5,-20(s0)
  if(i != N*SZ*2){
    15ca:	fec42783          	lw	a5,-20(s0)
    15ce:	0007871b          	sext.w	a4,a5
    15d2:	7d000793          	li	a5,2000
    15d6:	02f70163          	beq	a4,a5,15f8 <writetest+0x196>
    printf("%s: read failed\n", s);
    15da:	fd843583          	ld	a1,-40(s0)
    15de:	00007517          	auipc	a0,0x7
    15e2:	20a50513          	addi	a0,a0,522 # 87e8 <malloc+0x81e>
    15e6:	00006097          	auipc	ra,0x6
    15ea:	7f2080e7          	jalr	2034(ra) # 7dd8 <printf>
    exit(1);
    15ee:	4505                	li	a0,1
    15f0:	00006097          	auipc	ra,0x6
    15f4:	2c0080e7          	jalr	704(ra) # 78b0 <exit>
  }
  close(fd);
    15f8:	fe842783          	lw	a5,-24(s0)
    15fc:	853e                	mv	a0,a5
    15fe:	00006097          	auipc	ra,0x6
    1602:	2da080e7          	jalr	730(ra) # 78d8 <close>

  if(unlink("small") < 0){
    1606:	00007517          	auipc	a0,0x7
    160a:	12a50513          	addi	a0,a0,298 # 8730 <malloc+0x766>
    160e:	00006097          	auipc	ra,0x6
    1612:	2f2080e7          	jalr	754(ra) # 7900 <unlink>
    1616:	87aa                	mv	a5,a0
    1618:	0207d163          	bgez	a5,163a <writetest+0x1d8>
    printf("%s: unlink small failed\n", s);
    161c:	fd843583          	ld	a1,-40(s0)
    1620:	00007517          	auipc	a0,0x7
    1624:	1e050513          	addi	a0,a0,480 # 8800 <malloc+0x836>
    1628:	00006097          	auipc	ra,0x6
    162c:	7b0080e7          	jalr	1968(ra) # 7dd8 <printf>
    exit(1);
    1630:	4505                	li	a0,1
    1632:	00006097          	auipc	ra,0x6
    1636:	27e080e7          	jalr	638(ra) # 78b0 <exit>
  }
}
    163a:	0001                	nop
    163c:	70a2                	ld	ra,40(sp)
    163e:	7402                	ld	s0,32(sp)
    1640:	6145                	addi	sp,sp,48
    1642:	8082                	ret

0000000000001644 <writebig>:

void
writebig(char *s)
{
    1644:	7179                	addi	sp,sp,-48
    1646:	f406                	sd	ra,40(sp)
    1648:	f022                	sd	s0,32(sp)
    164a:	1800                	addi	s0,sp,48
    164c:	fca43c23          	sd	a0,-40(s0)
  int i, fd, n;

  fd = open("big", O_CREATE|O_RDWR);
    1650:	20200593          	li	a1,514
    1654:	00007517          	auipc	a0,0x7
    1658:	1cc50513          	addi	a0,a0,460 # 8820 <malloc+0x856>
    165c:	00006097          	auipc	ra,0x6
    1660:	294080e7          	jalr	660(ra) # 78f0 <open>
    1664:	87aa                	mv	a5,a0
    1666:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    166a:	fe442783          	lw	a5,-28(s0)
    166e:	2781                	sext.w	a5,a5
    1670:	0207d163          	bgez	a5,1692 <writebig+0x4e>
    printf("%s: error: creat big failed!\n", s);
    1674:	fd843583          	ld	a1,-40(s0)
    1678:	00007517          	auipc	a0,0x7
    167c:	1b050513          	addi	a0,a0,432 # 8828 <malloc+0x85e>
    1680:	00006097          	auipc	ra,0x6
    1684:	758080e7          	jalr	1880(ra) # 7dd8 <printf>
    exit(1);
    1688:	4505                	li	a0,1
    168a:	00006097          	auipc	ra,0x6
    168e:	226080e7          	jalr	550(ra) # 78b0 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
    1692:	fe042623          	sw	zero,-20(s0)
    1696:	a095                	j	16fa <writebig+0xb6>
    ((int*)buf)[0] = i;
    1698:	0000b797          	auipc	a5,0xb
    169c:	c6878793          	addi	a5,a5,-920 # c300 <buf>
    16a0:	fec42703          	lw	a4,-20(s0)
    16a4:	c398                	sw	a4,0(a5)
    if(write(fd, buf, BSIZE) != BSIZE){
    16a6:	fe442783          	lw	a5,-28(s0)
    16aa:	40000613          	li	a2,1024
    16ae:	0000b597          	auipc	a1,0xb
    16b2:	c5258593          	addi	a1,a1,-942 # c300 <buf>
    16b6:	853e                	mv	a0,a5
    16b8:	00006097          	auipc	ra,0x6
    16bc:	218080e7          	jalr	536(ra) # 78d0 <write>
    16c0:	87aa                	mv	a5,a0
    16c2:	873e                	mv	a4,a5
    16c4:	40000793          	li	a5,1024
    16c8:	02f70463          	beq	a4,a5,16f0 <writebig+0xac>
      printf("%s: error: write big file failed\n", s, i);
    16cc:	fec42783          	lw	a5,-20(s0)
    16d0:	863e                	mv	a2,a5
    16d2:	fd843583          	ld	a1,-40(s0)
    16d6:	00007517          	auipc	a0,0x7
    16da:	17250513          	addi	a0,a0,370 # 8848 <malloc+0x87e>
    16de:	00006097          	auipc	ra,0x6
    16e2:	6fa080e7          	jalr	1786(ra) # 7dd8 <printf>
      exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00006097          	auipc	ra,0x6
    16ec:	1c8080e7          	jalr	456(ra) # 78b0 <exit>
  for(i = 0; i < MAXFILE; i++){
    16f0:	fec42783          	lw	a5,-20(s0)
    16f4:	2785                	addiw	a5,a5,1
    16f6:	fef42623          	sw	a5,-20(s0)
    16fa:	fec42783          	lw	a5,-20(s0)
    16fe:	873e                	mv	a4,a5
    1700:	10b00793          	li	a5,267
    1704:	f8e7fae3          	bgeu	a5,a4,1698 <writebig+0x54>
    }
  }

  close(fd);
    1708:	fe442783          	lw	a5,-28(s0)
    170c:	853e                	mv	a0,a5
    170e:	00006097          	auipc	ra,0x6
    1712:	1ca080e7          	jalr	458(ra) # 78d8 <close>

  fd = open("big", O_RDONLY);
    1716:	4581                	li	a1,0
    1718:	00007517          	auipc	a0,0x7
    171c:	10850513          	addi	a0,a0,264 # 8820 <malloc+0x856>
    1720:	00006097          	auipc	ra,0x6
    1724:	1d0080e7          	jalr	464(ra) # 78f0 <open>
    1728:	87aa                	mv	a5,a0
    172a:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    172e:	fe442783          	lw	a5,-28(s0)
    1732:	2781                	sext.w	a5,a5
    1734:	0207d163          	bgez	a5,1756 <writebig+0x112>
    printf("%s: error: open big failed!\n", s);
    1738:	fd843583          	ld	a1,-40(s0)
    173c:	00007517          	auipc	a0,0x7
    1740:	13450513          	addi	a0,a0,308 # 8870 <malloc+0x8a6>
    1744:	00006097          	auipc	ra,0x6
    1748:	694080e7          	jalr	1684(ra) # 7dd8 <printf>
    exit(1);
    174c:	4505                	li	a0,1
    174e:	00006097          	auipc	ra,0x6
    1752:	162080e7          	jalr	354(ra) # 78b0 <exit>
  }

  n = 0;
    1756:	fe042423          	sw	zero,-24(s0)
  for(;;){
    i = read(fd, buf, BSIZE);
    175a:	fe442783          	lw	a5,-28(s0)
    175e:	40000613          	li	a2,1024
    1762:	0000b597          	auipc	a1,0xb
    1766:	b9e58593          	addi	a1,a1,-1122 # c300 <buf>
    176a:	853e                	mv	a0,a5
    176c:	00006097          	auipc	ra,0x6
    1770:	15c080e7          	jalr	348(ra) # 78c8 <read>
    1774:	87aa                	mv	a5,a0
    1776:	fef42623          	sw	a5,-20(s0)
    if(i == 0){
    177a:	fec42783          	lw	a5,-20(s0)
    177e:	2781                	sext.w	a5,a5
    1780:	eb9d                	bnez	a5,17b6 <writebig+0x172>
      if(n == MAXFILE - 1){
    1782:	fe842783          	lw	a5,-24(s0)
    1786:	0007871b          	sext.w	a4,a5
    178a:	10b00793          	li	a5,267
    178e:	0af71663          	bne	a4,a5,183a <writebig+0x1f6>
        printf("%s: read only %d blocks from big", s, n);
    1792:	fe842783          	lw	a5,-24(s0)
    1796:	863e                	mv	a2,a5
    1798:	fd843583          	ld	a1,-40(s0)
    179c:	00007517          	auipc	a0,0x7
    17a0:	0f450513          	addi	a0,a0,244 # 8890 <malloc+0x8c6>
    17a4:	00006097          	auipc	ra,0x6
    17a8:	634080e7          	jalr	1588(ra) # 7dd8 <printf>
        exit(1);
    17ac:	4505                	li	a0,1
    17ae:	00006097          	auipc	ra,0x6
    17b2:	102080e7          	jalr	258(ra) # 78b0 <exit>
      }
      break;
    } else if(i != BSIZE){
    17b6:	fec42783          	lw	a5,-20(s0)
    17ba:	0007871b          	sext.w	a4,a5
    17be:	40000793          	li	a5,1024
    17c2:	02f70463          	beq	a4,a5,17ea <writebig+0x1a6>
      printf("%s: read failed %d\n", s, i);
    17c6:	fec42783          	lw	a5,-20(s0)
    17ca:	863e                	mv	a2,a5
    17cc:	fd843583          	ld	a1,-40(s0)
    17d0:	00007517          	auipc	a0,0x7
    17d4:	0e850513          	addi	a0,a0,232 # 88b8 <malloc+0x8ee>
    17d8:	00006097          	auipc	ra,0x6
    17dc:	600080e7          	jalr	1536(ra) # 7dd8 <printf>
      exit(1);
    17e0:	4505                	li	a0,1
    17e2:	00006097          	auipc	ra,0x6
    17e6:	0ce080e7          	jalr	206(ra) # 78b0 <exit>
    }
    if(((int*)buf)[0] != n){
    17ea:	0000b797          	auipc	a5,0xb
    17ee:	b1678793          	addi	a5,a5,-1258 # c300 <buf>
    17f2:	4398                	lw	a4,0(a5)
    17f4:	fe842783          	lw	a5,-24(s0)
    17f8:	2781                	sext.w	a5,a5
    17fa:	02e78a63          	beq	a5,a4,182e <writebig+0x1ea>
      printf("%s: read content of block %d is %d\n", s,
             n, ((int*)buf)[0]);
    17fe:	0000b797          	auipc	a5,0xb
    1802:	b0278793          	addi	a5,a5,-1278 # c300 <buf>
      printf("%s: read content of block %d is %d\n", s,
    1806:	4398                	lw	a4,0(a5)
    1808:	fe842783          	lw	a5,-24(s0)
    180c:	86ba                	mv	a3,a4
    180e:	863e                	mv	a2,a5
    1810:	fd843583          	ld	a1,-40(s0)
    1814:	00007517          	auipc	a0,0x7
    1818:	0bc50513          	addi	a0,a0,188 # 88d0 <malloc+0x906>
    181c:	00006097          	auipc	ra,0x6
    1820:	5bc080e7          	jalr	1468(ra) # 7dd8 <printf>
      exit(1);
    1824:	4505                	li	a0,1
    1826:	00006097          	auipc	ra,0x6
    182a:	08a080e7          	jalr	138(ra) # 78b0 <exit>
    }
    n++;
    182e:	fe842783          	lw	a5,-24(s0)
    1832:	2785                	addiw	a5,a5,1
    1834:	fef42423          	sw	a5,-24(s0)
    i = read(fd, buf, BSIZE);
    1838:	b70d                	j	175a <writebig+0x116>
      break;
    183a:	0001                	nop
  }
  close(fd);
    183c:	fe442783          	lw	a5,-28(s0)
    1840:	853e                	mv	a0,a5
    1842:	00006097          	auipc	ra,0x6
    1846:	096080e7          	jalr	150(ra) # 78d8 <close>
  if(unlink("big") < 0){
    184a:	00007517          	auipc	a0,0x7
    184e:	fd650513          	addi	a0,a0,-42 # 8820 <malloc+0x856>
    1852:	00006097          	auipc	ra,0x6
    1856:	0ae080e7          	jalr	174(ra) # 7900 <unlink>
    185a:	87aa                	mv	a5,a0
    185c:	0207d163          	bgez	a5,187e <writebig+0x23a>
    printf("%s: unlink big failed\n", s);
    1860:	fd843583          	ld	a1,-40(s0)
    1864:	00007517          	auipc	a0,0x7
    1868:	09450513          	addi	a0,a0,148 # 88f8 <malloc+0x92e>
    186c:	00006097          	auipc	ra,0x6
    1870:	56c080e7          	jalr	1388(ra) # 7dd8 <printf>
    exit(1);
    1874:	4505                	li	a0,1
    1876:	00006097          	auipc	ra,0x6
    187a:	03a080e7          	jalr	58(ra) # 78b0 <exit>
  }
}
    187e:	0001                	nop
    1880:	70a2                	ld	ra,40(sp)
    1882:	7402                	ld	s0,32(sp)
    1884:	6145                	addi	sp,sp,48
    1886:	8082                	ret

0000000000001888 <createtest>:

// many creates, followed by unlink test
void
createtest(char *s)
{
    1888:	7179                	addi	sp,sp,-48
    188a:	f406                	sd	ra,40(sp)
    188c:	f022                	sd	s0,32(sp)
    188e:	1800                	addi	s0,sp,48
    1890:	fca43c23          	sd	a0,-40(s0)
  int i, fd;
  enum { N=52 };

  char name[3];
  name[0] = 'a';
    1894:	06100793          	li	a5,97
    1898:	fef40023          	sb	a5,-32(s0)
  name[2] = '\0';
    189c:	fe040123          	sb	zero,-30(s0)
  for(i = 0; i < N; i++){
    18a0:	fe042623          	sw	zero,-20(s0)
    18a4:	a099                	j	18ea <createtest+0x62>
    name[1] = '0' + i;
    18a6:	fec42783          	lw	a5,-20(s0)
    18aa:	0ff7f793          	zext.b	a5,a5
    18ae:	0307879b          	addiw	a5,a5,48
    18b2:	0ff7f793          	zext.b	a5,a5
    18b6:	fef400a3          	sb	a5,-31(s0)
    fd = open(name, O_CREATE|O_RDWR);
    18ba:	fe040793          	addi	a5,s0,-32
    18be:	20200593          	li	a1,514
    18c2:	853e                	mv	a0,a5
    18c4:	00006097          	auipc	ra,0x6
    18c8:	02c080e7          	jalr	44(ra) # 78f0 <open>
    18cc:	87aa                	mv	a5,a0
    18ce:	fef42423          	sw	a5,-24(s0)
    close(fd);
    18d2:	fe842783          	lw	a5,-24(s0)
    18d6:	853e                	mv	a0,a5
    18d8:	00006097          	auipc	ra,0x6
    18dc:	000080e7          	jalr	ra # 78d8 <close>
  for(i = 0; i < N; i++){
    18e0:	fec42783          	lw	a5,-20(s0)
    18e4:	2785                	addiw	a5,a5,1
    18e6:	fef42623          	sw	a5,-20(s0)
    18ea:	fec42783          	lw	a5,-20(s0)
    18ee:	0007871b          	sext.w	a4,a5
    18f2:	03300793          	li	a5,51
    18f6:	fae7d8e3          	bge	a5,a4,18a6 <createtest+0x1e>
  }
  name[0] = 'a';
    18fa:	06100793          	li	a5,97
    18fe:	fef40023          	sb	a5,-32(s0)
  name[2] = '\0';
    1902:	fe040123          	sb	zero,-30(s0)
  for(i = 0; i < N; i++){
    1906:	fe042623          	sw	zero,-20(s0)
    190a:	a03d                	j	1938 <createtest+0xb0>
    name[1] = '0' + i;
    190c:	fec42783          	lw	a5,-20(s0)
    1910:	0ff7f793          	zext.b	a5,a5
    1914:	0307879b          	addiw	a5,a5,48
    1918:	0ff7f793          	zext.b	a5,a5
    191c:	fef400a3          	sb	a5,-31(s0)
    unlink(name);
    1920:	fe040793          	addi	a5,s0,-32
    1924:	853e                	mv	a0,a5
    1926:	00006097          	auipc	ra,0x6
    192a:	fda080e7          	jalr	-38(ra) # 7900 <unlink>
  for(i = 0; i < N; i++){
    192e:	fec42783          	lw	a5,-20(s0)
    1932:	2785                	addiw	a5,a5,1
    1934:	fef42623          	sw	a5,-20(s0)
    1938:	fec42783          	lw	a5,-20(s0)
    193c:	0007871b          	sext.w	a4,a5
    1940:	03300793          	li	a5,51
    1944:	fce7d4e3          	bge	a5,a4,190c <createtest+0x84>
  }
}
    1948:	0001                	nop
    194a:	0001                	nop
    194c:	70a2                	ld	ra,40(sp)
    194e:	7402                	ld	s0,32(sp)
    1950:	6145                	addi	sp,sp,48
    1952:	8082                	ret

0000000000001954 <dirtest>:

void dirtest(char *s)
{
    1954:	1101                	addi	sp,sp,-32
    1956:	ec06                	sd	ra,24(sp)
    1958:	e822                	sd	s0,16(sp)
    195a:	1000                	addi	s0,sp,32
    195c:	fea43423          	sd	a0,-24(s0)
  if(mkdir("dir0") < 0){
    1960:	00007517          	auipc	a0,0x7
    1964:	fb050513          	addi	a0,a0,-80 # 8910 <malloc+0x946>
    1968:	00006097          	auipc	ra,0x6
    196c:	fb0080e7          	jalr	-80(ra) # 7918 <mkdir>
    1970:	87aa                	mv	a5,a0
    1972:	0207d163          	bgez	a5,1994 <dirtest+0x40>
    printf("%s: mkdir failed\n", s);
    1976:	fe843583          	ld	a1,-24(s0)
    197a:	00007517          	auipc	a0,0x7
    197e:	c6650513          	addi	a0,a0,-922 # 85e0 <malloc+0x616>
    1982:	00006097          	auipc	ra,0x6
    1986:	456080e7          	jalr	1110(ra) # 7dd8 <printf>
    exit(1);
    198a:	4505                	li	a0,1
    198c:	00006097          	auipc	ra,0x6
    1990:	f24080e7          	jalr	-220(ra) # 78b0 <exit>
  }

  if(chdir("dir0") < 0){
    1994:	00007517          	auipc	a0,0x7
    1998:	f7c50513          	addi	a0,a0,-132 # 8910 <malloc+0x946>
    199c:	00006097          	auipc	ra,0x6
    19a0:	f84080e7          	jalr	-124(ra) # 7920 <chdir>
    19a4:	87aa                	mv	a5,a0
    19a6:	0207d163          	bgez	a5,19c8 <dirtest+0x74>
    printf("%s: chdir dir0 failed\n", s);
    19aa:	fe843583          	ld	a1,-24(s0)
    19ae:	00007517          	auipc	a0,0x7
    19b2:	f6a50513          	addi	a0,a0,-150 # 8918 <malloc+0x94e>
    19b6:	00006097          	auipc	ra,0x6
    19ba:	422080e7          	jalr	1058(ra) # 7dd8 <printf>
    exit(1);
    19be:	4505                	li	a0,1
    19c0:	00006097          	auipc	ra,0x6
    19c4:	ef0080e7          	jalr	-272(ra) # 78b0 <exit>
  }

  if(chdir("..") < 0){
    19c8:	00007517          	auipc	a0,0x7
    19cc:	f6850513          	addi	a0,a0,-152 # 8930 <malloc+0x966>
    19d0:	00006097          	auipc	ra,0x6
    19d4:	f50080e7          	jalr	-176(ra) # 7920 <chdir>
    19d8:	87aa                	mv	a5,a0
    19da:	0207d163          	bgez	a5,19fc <dirtest+0xa8>
    printf("%s: chdir .. failed\n", s);
    19de:	fe843583          	ld	a1,-24(s0)
    19e2:	00007517          	auipc	a0,0x7
    19e6:	f5650513          	addi	a0,a0,-170 # 8938 <malloc+0x96e>
    19ea:	00006097          	auipc	ra,0x6
    19ee:	3ee080e7          	jalr	1006(ra) # 7dd8 <printf>
    exit(1);
    19f2:	4505                	li	a0,1
    19f4:	00006097          	auipc	ra,0x6
    19f8:	ebc080e7          	jalr	-324(ra) # 78b0 <exit>
  }

  if(unlink("dir0") < 0){
    19fc:	00007517          	auipc	a0,0x7
    1a00:	f1450513          	addi	a0,a0,-236 # 8910 <malloc+0x946>
    1a04:	00006097          	auipc	ra,0x6
    1a08:	efc080e7          	jalr	-260(ra) # 7900 <unlink>
    1a0c:	87aa                	mv	a5,a0
    1a0e:	0207d163          	bgez	a5,1a30 <dirtest+0xdc>
    printf("%s: unlink dir0 failed\n", s);
    1a12:	fe843583          	ld	a1,-24(s0)
    1a16:	00007517          	auipc	a0,0x7
    1a1a:	f3a50513          	addi	a0,a0,-198 # 8950 <malloc+0x986>
    1a1e:	00006097          	auipc	ra,0x6
    1a22:	3ba080e7          	jalr	954(ra) # 7dd8 <printf>
    exit(1);
    1a26:	4505                	li	a0,1
    1a28:	00006097          	auipc	ra,0x6
    1a2c:	e88080e7          	jalr	-376(ra) # 78b0 <exit>
  }
}
    1a30:	0001                	nop
    1a32:	60e2                	ld	ra,24(sp)
    1a34:	6442                	ld	s0,16(sp)
    1a36:	6105                	addi	sp,sp,32
    1a38:	8082                	ret

0000000000001a3a <exectest>:

void
exectest(char *s)
{
    1a3a:	715d                	addi	sp,sp,-80
    1a3c:	e486                	sd	ra,72(sp)
    1a3e:	e0a2                	sd	s0,64(sp)
    1a40:	0880                	addi	s0,sp,80
    1a42:	faa43c23          	sd	a0,-72(s0)
  int fd, xstatus, pid;
  char *echoargv[] = { "echo", "OK", 0 };
    1a46:	00007797          	auipc	a5,0x7
    1a4a:	8ea78793          	addi	a5,a5,-1814 # 8330 <malloc+0x366>
    1a4e:	fcf43423          	sd	a5,-56(s0)
    1a52:	00007797          	auipc	a5,0x7
    1a56:	f1678793          	addi	a5,a5,-234 # 8968 <malloc+0x99e>
    1a5a:	fcf43823          	sd	a5,-48(s0)
    1a5e:	fc043c23          	sd	zero,-40(s0)
  char buf[3];

  unlink("echo-ok");
    1a62:	00007517          	auipc	a0,0x7
    1a66:	f0e50513          	addi	a0,a0,-242 # 8970 <malloc+0x9a6>
    1a6a:	00006097          	auipc	ra,0x6
    1a6e:	e96080e7          	jalr	-362(ra) # 7900 <unlink>
  pid = fork();
    1a72:	00006097          	auipc	ra,0x6
    1a76:	e36080e7          	jalr	-458(ra) # 78a8 <fork>
    1a7a:	87aa                	mv	a5,a0
    1a7c:	fef42623          	sw	a5,-20(s0)
  if(pid < 0) {
    1a80:	fec42783          	lw	a5,-20(s0)
    1a84:	2781                	sext.w	a5,a5
    1a86:	0207d163          	bgez	a5,1aa8 <exectest+0x6e>
     printf("%s: fork failed\n", s);
    1a8a:	fb843583          	ld	a1,-72(s0)
    1a8e:	00007517          	auipc	a0,0x7
    1a92:	ac250513          	addi	a0,a0,-1342 # 8550 <malloc+0x586>
    1a96:	00006097          	auipc	ra,0x6
    1a9a:	342080e7          	jalr	834(ra) # 7dd8 <printf>
     exit(1);
    1a9e:	4505                	li	a0,1
    1aa0:	00006097          	auipc	ra,0x6
    1aa4:	e10080e7          	jalr	-496(ra) # 78b0 <exit>
  }
  if(pid == 0) {
    1aa8:	fec42783          	lw	a5,-20(s0)
    1aac:	2781                	sext.w	a5,a5
    1aae:	ebd5                	bnez	a5,1b62 <exectest+0x128>
    close(1);
    1ab0:	4505                	li	a0,1
    1ab2:	00006097          	auipc	ra,0x6
    1ab6:	e26080e7          	jalr	-474(ra) # 78d8 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1aba:	20100593          	li	a1,513
    1abe:	00007517          	auipc	a0,0x7
    1ac2:	eb250513          	addi	a0,a0,-334 # 8970 <malloc+0x9a6>
    1ac6:	00006097          	auipc	ra,0x6
    1aca:	e2a080e7          	jalr	-470(ra) # 78f0 <open>
    1ace:	87aa                	mv	a5,a0
    1ad0:	fef42423          	sw	a5,-24(s0)
    if(fd < 0) {
    1ad4:	fe842783          	lw	a5,-24(s0)
    1ad8:	2781                	sext.w	a5,a5
    1ada:	0207d163          	bgez	a5,1afc <exectest+0xc2>
      printf("%s: create failed\n", s);
    1ade:	fb843583          	ld	a1,-72(s0)
    1ae2:	00007517          	auipc	a0,0x7
    1ae6:	e9650513          	addi	a0,a0,-362 # 8978 <malloc+0x9ae>
    1aea:	00006097          	auipc	ra,0x6
    1aee:	2ee080e7          	jalr	750(ra) # 7dd8 <printf>
      exit(1);
    1af2:	4505                	li	a0,1
    1af4:	00006097          	auipc	ra,0x6
    1af8:	dbc080e7          	jalr	-580(ra) # 78b0 <exit>
    }
    if(fd != 1) {
    1afc:	fe842783          	lw	a5,-24(s0)
    1b00:	0007871b          	sext.w	a4,a5
    1b04:	4785                	li	a5,1
    1b06:	02f70163          	beq	a4,a5,1b28 <exectest+0xee>
      printf("%s: wrong fd\n", s);
    1b0a:	fb843583          	ld	a1,-72(s0)
    1b0e:	00007517          	auipc	a0,0x7
    1b12:	e8250513          	addi	a0,a0,-382 # 8990 <malloc+0x9c6>
    1b16:	00006097          	auipc	ra,0x6
    1b1a:	2c2080e7          	jalr	706(ra) # 7dd8 <printf>
      exit(1);
    1b1e:	4505                	li	a0,1
    1b20:	00006097          	auipc	ra,0x6
    1b24:	d90080e7          	jalr	-624(ra) # 78b0 <exit>
    }
    if(exec("echo", echoargv) < 0){
    1b28:	fc840793          	addi	a5,s0,-56
    1b2c:	85be                	mv	a1,a5
    1b2e:	00007517          	auipc	a0,0x7
    1b32:	80250513          	addi	a0,a0,-2046 # 8330 <malloc+0x366>
    1b36:	00006097          	auipc	ra,0x6
    1b3a:	db2080e7          	jalr	-590(ra) # 78e8 <exec>
    1b3e:	87aa                	mv	a5,a0
    1b40:	0207d163          	bgez	a5,1b62 <exectest+0x128>
      printf("%s: exec echo failed\n", s);
    1b44:	fb843583          	ld	a1,-72(s0)
    1b48:	00007517          	auipc	a0,0x7
    1b4c:	e5850513          	addi	a0,a0,-424 # 89a0 <malloc+0x9d6>
    1b50:	00006097          	auipc	ra,0x6
    1b54:	288080e7          	jalr	648(ra) # 7dd8 <printf>
      exit(1);
    1b58:	4505                	li	a0,1
    1b5a:	00006097          	auipc	ra,0x6
    1b5e:	d56080e7          	jalr	-682(ra) # 78b0 <exit>
    }
    // won't get to here
  }
  if (wait(&xstatus) != pid) {
    1b62:	fe440793          	addi	a5,s0,-28
    1b66:	853e                	mv	a0,a5
    1b68:	00006097          	auipc	ra,0x6
    1b6c:	d50080e7          	jalr	-688(ra) # 78b8 <wait>
    1b70:	87aa                	mv	a5,a0
    1b72:	873e                	mv	a4,a5
    1b74:	fec42783          	lw	a5,-20(s0)
    1b78:	2781                	sext.w	a5,a5
    1b7a:	00e78c63          	beq	a5,a4,1b92 <exectest+0x158>
    printf("%s: wait failed!\n", s);
    1b7e:	fb843583          	ld	a1,-72(s0)
    1b82:	00007517          	auipc	a0,0x7
    1b86:	e3650513          	addi	a0,a0,-458 # 89b8 <malloc+0x9ee>
    1b8a:	00006097          	auipc	ra,0x6
    1b8e:	24e080e7          	jalr	590(ra) # 7dd8 <printf>
  }
  if(xstatus != 0)
    1b92:	fe442783          	lw	a5,-28(s0)
    1b96:	cb81                	beqz	a5,1ba6 <exectest+0x16c>
    exit(xstatus);
    1b98:	fe442783          	lw	a5,-28(s0)
    1b9c:	853e                	mv	a0,a5
    1b9e:	00006097          	auipc	ra,0x6
    1ba2:	d12080e7          	jalr	-750(ra) # 78b0 <exit>

  fd = open("echo-ok", O_RDONLY);
    1ba6:	4581                	li	a1,0
    1ba8:	00007517          	auipc	a0,0x7
    1bac:	dc850513          	addi	a0,a0,-568 # 8970 <malloc+0x9a6>
    1bb0:	00006097          	auipc	ra,0x6
    1bb4:	d40080e7          	jalr	-704(ra) # 78f0 <open>
    1bb8:	87aa                	mv	a5,a0
    1bba:	fef42423          	sw	a5,-24(s0)
  if(fd < 0) {
    1bbe:	fe842783          	lw	a5,-24(s0)
    1bc2:	2781                	sext.w	a5,a5
    1bc4:	0207d163          	bgez	a5,1be6 <exectest+0x1ac>
    printf("%s: open failed\n", s);
    1bc8:	fb843583          	ld	a1,-72(s0)
    1bcc:	00007517          	auipc	a0,0x7
    1bd0:	99c50513          	addi	a0,a0,-1636 # 8568 <malloc+0x59e>
    1bd4:	00006097          	auipc	ra,0x6
    1bd8:	204080e7          	jalr	516(ra) # 7dd8 <printf>
    exit(1);
    1bdc:	4505                	li	a0,1
    1bde:	00006097          	auipc	ra,0x6
    1be2:	cd2080e7          	jalr	-814(ra) # 78b0 <exit>
  }
  if (read(fd, buf, 2) != 2) {
    1be6:	fc040713          	addi	a4,s0,-64
    1bea:	fe842783          	lw	a5,-24(s0)
    1bee:	4609                	li	a2,2
    1bf0:	85ba                	mv	a1,a4
    1bf2:	853e                	mv	a0,a5
    1bf4:	00006097          	auipc	ra,0x6
    1bf8:	cd4080e7          	jalr	-812(ra) # 78c8 <read>
    1bfc:	87aa                	mv	a5,a0
    1bfe:	873e                	mv	a4,a5
    1c00:	4789                	li	a5,2
    1c02:	02f70163          	beq	a4,a5,1c24 <exectest+0x1ea>
    printf("%s: read failed\n", s);
    1c06:	fb843583          	ld	a1,-72(s0)
    1c0a:	00007517          	auipc	a0,0x7
    1c0e:	bde50513          	addi	a0,a0,-1058 # 87e8 <malloc+0x81e>
    1c12:	00006097          	auipc	ra,0x6
    1c16:	1c6080e7          	jalr	454(ra) # 7dd8 <printf>
    exit(1);
    1c1a:	4505                	li	a0,1
    1c1c:	00006097          	auipc	ra,0x6
    1c20:	c94080e7          	jalr	-876(ra) # 78b0 <exit>
  }
  unlink("echo-ok");
    1c24:	00007517          	auipc	a0,0x7
    1c28:	d4c50513          	addi	a0,a0,-692 # 8970 <malloc+0x9a6>
    1c2c:	00006097          	auipc	ra,0x6
    1c30:	cd4080e7          	jalr	-812(ra) # 7900 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1c34:	fc044783          	lbu	a5,-64(s0)
    1c38:	873e                	mv	a4,a5
    1c3a:	04f00793          	li	a5,79
    1c3e:	00f71e63          	bne	a4,a5,1c5a <exectest+0x220>
    1c42:	fc144783          	lbu	a5,-63(s0)
    1c46:	873e                	mv	a4,a5
    1c48:	04b00793          	li	a5,75
    1c4c:	00f71763          	bne	a4,a5,1c5a <exectest+0x220>
    exit(0);
    1c50:	4501                	li	a0,0
    1c52:	00006097          	auipc	ra,0x6
    1c56:	c5e080e7          	jalr	-930(ra) # 78b0 <exit>
  else {
    printf("%s: wrong output\n", s);
    1c5a:	fb843583          	ld	a1,-72(s0)
    1c5e:	00007517          	auipc	a0,0x7
    1c62:	d7250513          	addi	a0,a0,-654 # 89d0 <malloc+0xa06>
    1c66:	00006097          	auipc	ra,0x6
    1c6a:	172080e7          	jalr	370(ra) # 7dd8 <printf>
    exit(1);
    1c6e:	4505                	li	a0,1
    1c70:	00006097          	auipc	ra,0x6
    1c74:	c40080e7          	jalr	-960(ra) # 78b0 <exit>

0000000000001c78 <pipe1>:

// simple fork and pipe read/write

void
pipe1(char *s)
{
    1c78:	715d                	addi	sp,sp,-80
    1c7a:	e486                	sd	ra,72(sp)
    1c7c:	e0a2                	sd	s0,64(sp)
    1c7e:	0880                	addi	s0,sp,80
    1c80:	faa43c23          	sd	a0,-72(s0)
  int fds[2], pid, xstatus;
  int seq, i, n, cc, total;
  enum { N=5, SZ=1033 };
  
  if(pipe(fds) != 0){
    1c84:	fd040793          	addi	a5,s0,-48
    1c88:	853e                	mv	a0,a5
    1c8a:	00006097          	auipc	ra,0x6
    1c8e:	c36080e7          	jalr	-970(ra) # 78c0 <pipe>
    1c92:	87aa                	mv	a5,a0
    1c94:	c385                	beqz	a5,1cb4 <pipe1+0x3c>
    printf("%s: pipe() failed\n", s);
    1c96:	fb843583          	ld	a1,-72(s0)
    1c9a:	00007517          	auipc	a0,0x7
    1c9e:	d4e50513          	addi	a0,a0,-690 # 89e8 <malloc+0xa1e>
    1ca2:	00006097          	auipc	ra,0x6
    1ca6:	136080e7          	jalr	310(ra) # 7dd8 <printf>
    exit(1);
    1caa:	4505                	li	a0,1
    1cac:	00006097          	auipc	ra,0x6
    1cb0:	c04080e7          	jalr	-1020(ra) # 78b0 <exit>
  }
  pid = fork();
    1cb4:	00006097          	auipc	ra,0x6
    1cb8:	bf4080e7          	jalr	-1036(ra) # 78a8 <fork>
    1cbc:	87aa                	mv	a5,a0
    1cbe:	fcf42c23          	sw	a5,-40(s0)
  seq = 0;
    1cc2:	fe042623          	sw	zero,-20(s0)
  if(pid == 0){
    1cc6:	fd842783          	lw	a5,-40(s0)
    1cca:	2781                	sext.w	a5,a5
    1ccc:	efdd                	bnez	a5,1d8a <pipe1+0x112>
    close(fds[0]);
    1cce:	fd042783          	lw	a5,-48(s0)
    1cd2:	853e                	mv	a0,a5
    1cd4:	00006097          	auipc	ra,0x6
    1cd8:	c04080e7          	jalr	-1020(ra) # 78d8 <close>
    for(n = 0; n < N; n++){
    1cdc:	fe042223          	sw	zero,-28(s0)
    1ce0:	a849                	j	1d72 <pipe1+0xfa>
      for(i = 0; i < SZ; i++)
    1ce2:	fe042423          	sw	zero,-24(s0)
    1ce6:	a03d                	j	1d14 <pipe1+0x9c>
        buf[i] = seq++;
    1ce8:	fec42783          	lw	a5,-20(s0)
    1cec:	0017871b          	addiw	a4,a5,1
    1cf0:	fee42623          	sw	a4,-20(s0)
    1cf4:	0ff7f713          	zext.b	a4,a5
    1cf8:	0000a697          	auipc	a3,0xa
    1cfc:	60868693          	addi	a3,a3,1544 # c300 <buf>
    1d00:	fe842783          	lw	a5,-24(s0)
    1d04:	97b6                	add	a5,a5,a3
    1d06:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1d0a:	fe842783          	lw	a5,-24(s0)
    1d0e:	2785                	addiw	a5,a5,1
    1d10:	fef42423          	sw	a5,-24(s0)
    1d14:	fe842783          	lw	a5,-24(s0)
    1d18:	0007871b          	sext.w	a4,a5
    1d1c:	40800793          	li	a5,1032
    1d20:	fce7d4e3          	bge	a5,a4,1ce8 <pipe1+0x70>
      if(write(fds[1], buf, SZ) != SZ){
    1d24:	fd442783          	lw	a5,-44(s0)
    1d28:	40900613          	li	a2,1033
    1d2c:	0000a597          	auipc	a1,0xa
    1d30:	5d458593          	addi	a1,a1,1492 # c300 <buf>
    1d34:	853e                	mv	a0,a5
    1d36:	00006097          	auipc	ra,0x6
    1d3a:	b9a080e7          	jalr	-1126(ra) # 78d0 <write>
    1d3e:	87aa                	mv	a5,a0
    1d40:	873e                	mv	a4,a5
    1d42:	40900793          	li	a5,1033
    1d46:	02f70163          	beq	a4,a5,1d68 <pipe1+0xf0>
        printf("%s: pipe1 oops 1\n", s);
    1d4a:	fb843583          	ld	a1,-72(s0)
    1d4e:	00007517          	auipc	a0,0x7
    1d52:	cb250513          	addi	a0,a0,-846 # 8a00 <malloc+0xa36>
    1d56:	00006097          	auipc	ra,0x6
    1d5a:	082080e7          	jalr	130(ra) # 7dd8 <printf>
        exit(1);
    1d5e:	4505                	li	a0,1
    1d60:	00006097          	auipc	ra,0x6
    1d64:	b50080e7          	jalr	-1200(ra) # 78b0 <exit>
    for(n = 0; n < N; n++){
    1d68:	fe442783          	lw	a5,-28(s0)
    1d6c:	2785                	addiw	a5,a5,1
    1d6e:	fef42223          	sw	a5,-28(s0)
    1d72:	fe442783          	lw	a5,-28(s0)
    1d76:	0007871b          	sext.w	a4,a5
    1d7a:	4791                	li	a5,4
    1d7c:	f6e7d3e3          	bge	a5,a4,1ce2 <pipe1+0x6a>
      }
    }
    exit(0);
    1d80:	4501                	li	a0,0
    1d82:	00006097          	auipc	ra,0x6
    1d86:	b2e080e7          	jalr	-1234(ra) # 78b0 <exit>
  } else if(pid > 0){
    1d8a:	fd842783          	lw	a5,-40(s0)
    1d8e:	2781                	sext.w	a5,a5
    1d90:	12f05d63          	blez	a5,1eca <pipe1+0x252>
    close(fds[1]);
    1d94:	fd442783          	lw	a5,-44(s0)
    1d98:	853e                	mv	a0,a5
    1d9a:	00006097          	auipc	ra,0x6
    1d9e:	b3e080e7          	jalr	-1218(ra) # 78d8 <close>
    total = 0;
    1da2:	fc042e23          	sw	zero,-36(s0)
    cc = 1;
    1da6:	4785                	li	a5,1
    1da8:	fef42023          	sw	a5,-32(s0)
    while((n = read(fds[0], buf, cc)) > 0){
    1dac:	a859                	j	1e42 <pipe1+0x1ca>
      for(i = 0; i < n; i++){
    1dae:	fe042423          	sw	zero,-24(s0)
    1db2:	a881                	j	1e02 <pipe1+0x18a>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1db4:	0000a717          	auipc	a4,0xa
    1db8:	54c70713          	addi	a4,a4,1356 # c300 <buf>
    1dbc:	fe842783          	lw	a5,-24(s0)
    1dc0:	97ba                	add	a5,a5,a4
    1dc2:	0007c783          	lbu	a5,0(a5)
    1dc6:	0007869b          	sext.w	a3,a5
    1dca:	fec42783          	lw	a5,-20(s0)
    1dce:	0017871b          	addiw	a4,a5,1
    1dd2:	fee42623          	sw	a4,-20(s0)
    1dd6:	0ff7f793          	zext.b	a5,a5
    1dda:	2781                	sext.w	a5,a5
    1ddc:	8736                	mv	a4,a3
    1dde:	00f70d63          	beq	a4,a5,1df8 <pipe1+0x180>
          printf("%s: pipe1 oops 2\n", s);
    1de2:	fb843583          	ld	a1,-72(s0)
    1de6:	00007517          	auipc	a0,0x7
    1dea:	c3250513          	addi	a0,a0,-974 # 8a18 <malloc+0xa4e>
    1dee:	00006097          	auipc	ra,0x6
    1df2:	fea080e7          	jalr	-22(ra) # 7dd8 <printf>
          return;
    1df6:	a8cd                	j	1ee8 <pipe1+0x270>
      for(i = 0; i < n; i++){
    1df8:	fe842783          	lw	a5,-24(s0)
    1dfc:	2785                	addiw	a5,a5,1
    1dfe:	fef42423          	sw	a5,-24(s0)
    1e02:	fe842783          	lw	a5,-24(s0)
    1e06:	873e                	mv	a4,a5
    1e08:	fe442783          	lw	a5,-28(s0)
    1e0c:	2701                	sext.w	a4,a4
    1e0e:	2781                	sext.w	a5,a5
    1e10:	faf742e3          	blt	a4,a5,1db4 <pipe1+0x13c>
        }
      }
      total += n;
    1e14:	fdc42783          	lw	a5,-36(s0)
    1e18:	873e                	mv	a4,a5
    1e1a:	fe442783          	lw	a5,-28(s0)
    1e1e:	9fb9                	addw	a5,a5,a4
    1e20:	fcf42e23          	sw	a5,-36(s0)
      cc = cc * 2;
    1e24:	fe042783          	lw	a5,-32(s0)
    1e28:	0017979b          	slliw	a5,a5,0x1
    1e2c:	fef42023          	sw	a5,-32(s0)
      if(cc > sizeof(buf))
    1e30:	fe042783          	lw	a5,-32(s0)
    1e34:	873e                	mv	a4,a5
    1e36:	678d                	lui	a5,0x3
    1e38:	00e7f563          	bgeu	a5,a4,1e42 <pipe1+0x1ca>
        cc = sizeof(buf);
    1e3c:	678d                	lui	a5,0x3
    1e3e:	fef42023          	sw	a5,-32(s0)
    while((n = read(fds[0], buf, cc)) > 0){
    1e42:	fd042783          	lw	a5,-48(s0)
    1e46:	fe042703          	lw	a4,-32(s0)
    1e4a:	863a                	mv	a2,a4
    1e4c:	0000a597          	auipc	a1,0xa
    1e50:	4b458593          	addi	a1,a1,1204 # c300 <buf>
    1e54:	853e                	mv	a0,a5
    1e56:	00006097          	auipc	ra,0x6
    1e5a:	a72080e7          	jalr	-1422(ra) # 78c8 <read>
    1e5e:	87aa                	mv	a5,a0
    1e60:	fef42223          	sw	a5,-28(s0)
    1e64:	fe442783          	lw	a5,-28(s0)
    1e68:	2781                	sext.w	a5,a5
    1e6a:	f4f042e3          	bgtz	a5,1dae <pipe1+0x136>
    }
    if(total != N * SZ){
    1e6e:	fdc42783          	lw	a5,-36(s0)
    1e72:	0007871b          	sext.w	a4,a5
    1e76:	6785                	lui	a5,0x1
    1e78:	42d78793          	addi	a5,a5,1069 # 142d <opentest+0x6f>
    1e7c:	02f70263          	beq	a4,a5,1ea0 <pipe1+0x228>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1e80:	fdc42783          	lw	a5,-36(s0)
    1e84:	85be                	mv	a1,a5
    1e86:	00007517          	auipc	a0,0x7
    1e8a:	baa50513          	addi	a0,a0,-1110 # 8a30 <malloc+0xa66>
    1e8e:	00006097          	auipc	ra,0x6
    1e92:	f4a080e7          	jalr	-182(ra) # 7dd8 <printf>
      exit(1);
    1e96:	4505                	li	a0,1
    1e98:	00006097          	auipc	ra,0x6
    1e9c:	a18080e7          	jalr	-1512(ra) # 78b0 <exit>
    }
    close(fds[0]);
    1ea0:	fd042783          	lw	a5,-48(s0)
    1ea4:	853e                	mv	a0,a5
    1ea6:	00006097          	auipc	ra,0x6
    1eaa:	a32080e7          	jalr	-1486(ra) # 78d8 <close>
    wait(&xstatus);
    1eae:	fcc40793          	addi	a5,s0,-52
    1eb2:	853e                	mv	a0,a5
    1eb4:	00006097          	auipc	ra,0x6
    1eb8:	a04080e7          	jalr	-1532(ra) # 78b8 <wait>
    exit(xstatus);
    1ebc:	fcc42783          	lw	a5,-52(s0)
    1ec0:	853e                	mv	a0,a5
    1ec2:	00006097          	auipc	ra,0x6
    1ec6:	9ee080e7          	jalr	-1554(ra) # 78b0 <exit>
  } else {
    printf("%s: fork() failed\n", s);
    1eca:	fb843583          	ld	a1,-72(s0)
    1ece:	00007517          	auipc	a0,0x7
    1ed2:	b8250513          	addi	a0,a0,-1150 # 8a50 <malloc+0xa86>
    1ed6:	00006097          	auipc	ra,0x6
    1eda:	f02080e7          	jalr	-254(ra) # 7dd8 <printf>
    exit(1);
    1ede:	4505                	li	a0,1
    1ee0:	00006097          	auipc	ra,0x6
    1ee4:	9d0080e7          	jalr	-1584(ra) # 78b0 <exit>
  }
}
    1ee8:	60a6                	ld	ra,72(sp)
    1eea:	6406                	ld	s0,64(sp)
    1eec:	6161                	addi	sp,sp,80
    1eee:	8082                	ret

0000000000001ef0 <killstatus>:


// test if child is killed (status = -1)
void
killstatus(char *s)
{
    1ef0:	7179                	addi	sp,sp,-48
    1ef2:	f406                	sd	ra,40(sp)
    1ef4:	f022                	sd	s0,32(sp)
    1ef6:	1800                	addi	s0,sp,48
    1ef8:	fca43c23          	sd	a0,-40(s0)
  int xst;
  
  for(int i = 0; i < 100; i++){
    1efc:	fe042623          	sw	zero,-20(s0)
    1f00:	a055                	j	1fa4 <killstatus+0xb4>
    int pid1 = fork();
    1f02:	00006097          	auipc	ra,0x6
    1f06:	9a6080e7          	jalr	-1626(ra) # 78a8 <fork>
    1f0a:	87aa                	mv	a5,a0
    1f0c:	fef42423          	sw	a5,-24(s0)
    if(pid1 < 0){
    1f10:	fe842783          	lw	a5,-24(s0)
    1f14:	2781                	sext.w	a5,a5
    1f16:	0207d163          	bgez	a5,1f38 <killstatus+0x48>
      printf("%s: fork failed\n", s);
    1f1a:	fd843583          	ld	a1,-40(s0)
    1f1e:	00006517          	auipc	a0,0x6
    1f22:	63250513          	addi	a0,a0,1586 # 8550 <malloc+0x586>
    1f26:	00006097          	auipc	ra,0x6
    1f2a:	eb2080e7          	jalr	-334(ra) # 7dd8 <printf>
      exit(1);
    1f2e:	4505                	li	a0,1
    1f30:	00006097          	auipc	ra,0x6
    1f34:	980080e7          	jalr	-1664(ra) # 78b0 <exit>
    }
    if(pid1 == 0){
    1f38:	fe842783          	lw	a5,-24(s0)
    1f3c:	2781                	sext.w	a5,a5
    1f3e:	e791                	bnez	a5,1f4a <killstatus+0x5a>
      while(1) {
        getpid();
    1f40:	00006097          	auipc	ra,0x6
    1f44:	9f0080e7          	jalr	-1552(ra) # 7930 <getpid>
    1f48:	bfe5                	j	1f40 <killstatus+0x50>
      }
      exit(0);
    }
    sleep(1);
    1f4a:	4505                	li	a0,1
    1f4c:	00006097          	auipc	ra,0x6
    1f50:	9f4080e7          	jalr	-1548(ra) # 7940 <sleep>
    kill(pid1);
    1f54:	fe842783          	lw	a5,-24(s0)
    1f58:	853e                	mv	a0,a5
    1f5a:	00006097          	auipc	ra,0x6
    1f5e:	986080e7          	jalr	-1658(ra) # 78e0 <kill>
    wait(&xst);
    1f62:	fe440793          	addi	a5,s0,-28
    1f66:	853e                	mv	a0,a5
    1f68:	00006097          	auipc	ra,0x6
    1f6c:	950080e7          	jalr	-1712(ra) # 78b8 <wait>
    if(xst != -1) {
    1f70:	fe442783          	lw	a5,-28(s0)
    1f74:	873e                	mv	a4,a5
    1f76:	57fd                	li	a5,-1
    1f78:	02f70163          	beq	a4,a5,1f9a <killstatus+0xaa>
       printf("%s: status should be -1\n", s);
    1f7c:	fd843583          	ld	a1,-40(s0)
    1f80:	00007517          	auipc	a0,0x7
    1f84:	ae850513          	addi	a0,a0,-1304 # 8a68 <malloc+0xa9e>
    1f88:	00006097          	auipc	ra,0x6
    1f8c:	e50080e7          	jalr	-432(ra) # 7dd8 <printf>
       exit(1);
    1f90:	4505                	li	a0,1
    1f92:	00006097          	auipc	ra,0x6
    1f96:	91e080e7          	jalr	-1762(ra) # 78b0 <exit>
  for(int i = 0; i < 100; i++){
    1f9a:	fec42783          	lw	a5,-20(s0)
    1f9e:	2785                	addiw	a5,a5,1
    1fa0:	fef42623          	sw	a5,-20(s0)
    1fa4:	fec42783          	lw	a5,-20(s0)
    1fa8:	0007871b          	sext.w	a4,a5
    1fac:	06300793          	li	a5,99
    1fb0:	f4e7d9e3          	bge	a5,a4,1f02 <killstatus+0x12>
    }
  }
  exit(0);
    1fb4:	4501                	li	a0,0
    1fb6:	00006097          	auipc	ra,0x6
    1fba:	8fa080e7          	jalr	-1798(ra) # 78b0 <exit>

0000000000001fbe <preempt>:
}

// meant to be run w/ at most two CPUs
void
preempt(char *s)
{
    1fbe:	7139                	addi	sp,sp,-64
    1fc0:	fc06                	sd	ra,56(sp)
    1fc2:	f822                	sd	s0,48(sp)
    1fc4:	0080                	addi	s0,sp,64
    1fc6:	fca43423          	sd	a0,-56(s0)
  int pid1, pid2, pid3;
  int pfds[2];

  pid1 = fork();
    1fca:	00006097          	auipc	ra,0x6
    1fce:	8de080e7          	jalr	-1826(ra) # 78a8 <fork>
    1fd2:	87aa                	mv	a5,a0
    1fd4:	fef42623          	sw	a5,-20(s0)
  if(pid1 < 0) {
    1fd8:	fec42783          	lw	a5,-20(s0)
    1fdc:	2781                	sext.w	a5,a5
    1fde:	0207d163          	bgez	a5,2000 <preempt+0x42>
    printf("%s: fork failed", s);
    1fe2:	fc843583          	ld	a1,-56(s0)
    1fe6:	00007517          	auipc	a0,0x7
    1fea:	aa250513          	addi	a0,a0,-1374 # 8a88 <malloc+0xabe>
    1fee:	00006097          	auipc	ra,0x6
    1ff2:	dea080e7          	jalr	-534(ra) # 7dd8 <printf>
    exit(1);
    1ff6:	4505                	li	a0,1
    1ff8:	00006097          	auipc	ra,0x6
    1ffc:	8b8080e7          	jalr	-1864(ra) # 78b0 <exit>
  }
  if(pid1 == 0)
    2000:	fec42783          	lw	a5,-20(s0)
    2004:	2781                	sext.w	a5,a5
    2006:	e399                	bnez	a5,200c <preempt+0x4e>
    for(;;)
    2008:	0001                	nop
    200a:	bffd                	j	2008 <preempt+0x4a>
      ;

  pid2 = fork();
    200c:	00006097          	auipc	ra,0x6
    2010:	89c080e7          	jalr	-1892(ra) # 78a8 <fork>
    2014:	87aa                	mv	a5,a0
    2016:	fef42423          	sw	a5,-24(s0)
  if(pid2 < 0) {
    201a:	fe842783          	lw	a5,-24(s0)
    201e:	2781                	sext.w	a5,a5
    2020:	0207d163          	bgez	a5,2042 <preempt+0x84>
    printf("%s: fork failed\n", s);
    2024:	fc843583          	ld	a1,-56(s0)
    2028:	00006517          	auipc	a0,0x6
    202c:	52850513          	addi	a0,a0,1320 # 8550 <malloc+0x586>
    2030:	00006097          	auipc	ra,0x6
    2034:	da8080e7          	jalr	-600(ra) # 7dd8 <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	00006097          	auipc	ra,0x6
    203e:	876080e7          	jalr	-1930(ra) # 78b0 <exit>
  }
  if(pid2 == 0)
    2042:	fe842783          	lw	a5,-24(s0)
    2046:	2781                	sext.w	a5,a5
    2048:	e399                	bnez	a5,204e <preempt+0x90>
    for(;;)
    204a:	0001                	nop
    204c:	bffd                	j	204a <preempt+0x8c>
      ;

  pipe(pfds);
    204e:	fd840793          	addi	a5,s0,-40
    2052:	853e                	mv	a0,a5
    2054:	00006097          	auipc	ra,0x6
    2058:	86c080e7          	jalr	-1940(ra) # 78c0 <pipe>
  pid3 = fork();
    205c:	00006097          	auipc	ra,0x6
    2060:	84c080e7          	jalr	-1972(ra) # 78a8 <fork>
    2064:	87aa                	mv	a5,a0
    2066:	fef42223          	sw	a5,-28(s0)
  if(pid3 < 0) {
    206a:	fe442783          	lw	a5,-28(s0)
    206e:	2781                	sext.w	a5,a5
    2070:	0207d163          	bgez	a5,2092 <preempt+0xd4>
     printf("%s: fork failed\n", s);
    2074:	fc843583          	ld	a1,-56(s0)
    2078:	00006517          	auipc	a0,0x6
    207c:	4d850513          	addi	a0,a0,1240 # 8550 <malloc+0x586>
    2080:	00006097          	auipc	ra,0x6
    2084:	d58080e7          	jalr	-680(ra) # 7dd8 <printf>
     exit(1);
    2088:	4505                	li	a0,1
    208a:	00006097          	auipc	ra,0x6
    208e:	826080e7          	jalr	-2010(ra) # 78b0 <exit>
  }
  if(pid3 == 0){
    2092:	fe442783          	lw	a5,-28(s0)
    2096:	2781                	sext.w	a5,a5
    2098:	efa1                	bnez	a5,20f0 <preempt+0x132>
    close(pfds[0]);
    209a:	fd842783          	lw	a5,-40(s0)
    209e:	853e                	mv	a0,a5
    20a0:	00006097          	auipc	ra,0x6
    20a4:	838080e7          	jalr	-1992(ra) # 78d8 <close>
    if(write(pfds[1], "x", 1) != 1)
    20a8:	fdc42783          	lw	a5,-36(s0)
    20ac:	4605                	li	a2,1
    20ae:	00006597          	auipc	a1,0x6
    20b2:	17258593          	addi	a1,a1,370 # 8220 <malloc+0x256>
    20b6:	853e                	mv	a0,a5
    20b8:	00006097          	auipc	ra,0x6
    20bc:	818080e7          	jalr	-2024(ra) # 78d0 <write>
    20c0:	87aa                	mv	a5,a0
    20c2:	873e                	mv	a4,a5
    20c4:	4785                	li	a5,1
    20c6:	00f70c63          	beq	a4,a5,20de <preempt+0x120>
      printf("%s: preempt write error", s);
    20ca:	fc843583          	ld	a1,-56(s0)
    20ce:	00007517          	auipc	a0,0x7
    20d2:	9ca50513          	addi	a0,a0,-1590 # 8a98 <malloc+0xace>
    20d6:	00006097          	auipc	ra,0x6
    20da:	d02080e7          	jalr	-766(ra) # 7dd8 <printf>
    close(pfds[1]);
    20de:	fdc42783          	lw	a5,-36(s0)
    20e2:	853e                	mv	a0,a5
    20e4:	00005097          	auipc	ra,0x5
    20e8:	7f4080e7          	jalr	2036(ra) # 78d8 <close>
    for(;;)
    20ec:	0001                	nop
    20ee:	bffd                	j	20ec <preempt+0x12e>
      ;
  }

  close(pfds[1]);
    20f0:	fdc42783          	lw	a5,-36(s0)
    20f4:	853e                	mv	a0,a5
    20f6:	00005097          	auipc	ra,0x5
    20fa:	7e2080e7          	jalr	2018(ra) # 78d8 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    20fe:	fd842783          	lw	a5,-40(s0)
    2102:	660d                	lui	a2,0x3
    2104:	0000a597          	auipc	a1,0xa
    2108:	1fc58593          	addi	a1,a1,508 # c300 <buf>
    210c:	853e                	mv	a0,a5
    210e:	00005097          	auipc	ra,0x5
    2112:	7ba080e7          	jalr	1978(ra) # 78c8 <read>
    2116:	87aa                	mv	a5,a0
    2118:	873e                	mv	a4,a5
    211a:	4785                	li	a5,1
    211c:	00f70d63          	beq	a4,a5,2136 <preempt+0x178>
    printf("%s: preempt read error", s);
    2120:	fc843583          	ld	a1,-56(s0)
    2124:	00007517          	auipc	a0,0x7
    2128:	98c50513          	addi	a0,a0,-1652 # 8ab0 <malloc+0xae6>
    212c:	00006097          	auipc	ra,0x6
    2130:	cac080e7          	jalr	-852(ra) # 7dd8 <printf>
    2134:	a8a5                	j	21ac <preempt+0x1ee>
    return;
  }
  close(pfds[0]);
    2136:	fd842783          	lw	a5,-40(s0)
    213a:	853e                	mv	a0,a5
    213c:	00005097          	auipc	ra,0x5
    2140:	79c080e7          	jalr	1948(ra) # 78d8 <close>
  printf("kill... ");
    2144:	00007517          	auipc	a0,0x7
    2148:	98450513          	addi	a0,a0,-1660 # 8ac8 <malloc+0xafe>
    214c:	00006097          	auipc	ra,0x6
    2150:	c8c080e7          	jalr	-884(ra) # 7dd8 <printf>
  kill(pid1);
    2154:	fec42783          	lw	a5,-20(s0)
    2158:	853e                	mv	a0,a5
    215a:	00005097          	auipc	ra,0x5
    215e:	786080e7          	jalr	1926(ra) # 78e0 <kill>
  kill(pid2);
    2162:	fe842783          	lw	a5,-24(s0)
    2166:	853e                	mv	a0,a5
    2168:	00005097          	auipc	ra,0x5
    216c:	778080e7          	jalr	1912(ra) # 78e0 <kill>
  kill(pid3);
    2170:	fe442783          	lw	a5,-28(s0)
    2174:	853e                	mv	a0,a5
    2176:	00005097          	auipc	ra,0x5
    217a:	76a080e7          	jalr	1898(ra) # 78e0 <kill>
  printf("wait... ");
    217e:	00007517          	auipc	a0,0x7
    2182:	95a50513          	addi	a0,a0,-1702 # 8ad8 <malloc+0xb0e>
    2186:	00006097          	auipc	ra,0x6
    218a:	c52080e7          	jalr	-942(ra) # 7dd8 <printf>
  wait(0);
    218e:	4501                	li	a0,0
    2190:	00005097          	auipc	ra,0x5
    2194:	728080e7          	jalr	1832(ra) # 78b8 <wait>
  wait(0);
    2198:	4501                	li	a0,0
    219a:	00005097          	auipc	ra,0x5
    219e:	71e080e7          	jalr	1822(ra) # 78b8 <wait>
  wait(0);
    21a2:	4501                	li	a0,0
    21a4:	00005097          	auipc	ra,0x5
    21a8:	714080e7          	jalr	1812(ra) # 78b8 <wait>
}
    21ac:	70e2                	ld	ra,56(sp)
    21ae:	7442                	ld	s0,48(sp)
    21b0:	6121                	addi	sp,sp,64
    21b2:	8082                	ret

00000000000021b4 <exitwait>:

// try to find any races between exit and wait
void
exitwait(char *s)
{
    21b4:	7179                	addi	sp,sp,-48
    21b6:	f406                	sd	ra,40(sp)
    21b8:	f022                	sd	s0,32(sp)
    21ba:	1800                	addi	s0,sp,48
    21bc:	fca43c23          	sd	a0,-40(s0)
  int i, pid;

  for(i = 0; i < 100; i++){
    21c0:	fe042623          	sw	zero,-20(s0)
    21c4:	a87d                	j	2282 <exitwait+0xce>
    pid = fork();
    21c6:	00005097          	auipc	ra,0x5
    21ca:	6e2080e7          	jalr	1762(ra) # 78a8 <fork>
    21ce:	87aa                	mv	a5,a0
    21d0:	fef42423          	sw	a5,-24(s0)
    if(pid < 0){
    21d4:	fe842783          	lw	a5,-24(s0)
    21d8:	2781                	sext.w	a5,a5
    21da:	0207d163          	bgez	a5,21fc <exitwait+0x48>
      printf("%s: fork failed\n", s);
    21de:	fd843583          	ld	a1,-40(s0)
    21e2:	00006517          	auipc	a0,0x6
    21e6:	36e50513          	addi	a0,a0,878 # 8550 <malloc+0x586>
    21ea:	00006097          	auipc	ra,0x6
    21ee:	bee080e7          	jalr	-1042(ra) # 7dd8 <printf>
      exit(1);
    21f2:	4505                	li	a0,1
    21f4:	00005097          	auipc	ra,0x5
    21f8:	6bc080e7          	jalr	1724(ra) # 78b0 <exit>
    }
    if(pid){
    21fc:	fe842783          	lw	a5,-24(s0)
    2200:	2781                	sext.w	a5,a5
    2202:	c7a5                	beqz	a5,226a <exitwait+0xb6>
      int xstate;
      if(wait(&xstate) != pid){
    2204:	fe440793          	addi	a5,s0,-28
    2208:	853e                	mv	a0,a5
    220a:	00005097          	auipc	ra,0x5
    220e:	6ae080e7          	jalr	1710(ra) # 78b8 <wait>
    2212:	87aa                	mv	a5,a0
    2214:	873e                	mv	a4,a5
    2216:	fe842783          	lw	a5,-24(s0)
    221a:	2781                	sext.w	a5,a5
    221c:	02e78163          	beq	a5,a4,223e <exitwait+0x8a>
        printf("%s: wait wrong pid\n", s);
    2220:	fd843583          	ld	a1,-40(s0)
    2224:	00007517          	auipc	a0,0x7
    2228:	8c450513          	addi	a0,a0,-1852 # 8ae8 <malloc+0xb1e>
    222c:	00006097          	auipc	ra,0x6
    2230:	bac080e7          	jalr	-1108(ra) # 7dd8 <printf>
        exit(1);
    2234:	4505                	li	a0,1
    2236:	00005097          	auipc	ra,0x5
    223a:	67a080e7          	jalr	1658(ra) # 78b0 <exit>
      }
      if(i != xstate) {
    223e:	fe442703          	lw	a4,-28(s0)
    2242:	fec42783          	lw	a5,-20(s0)
    2246:	2781                	sext.w	a5,a5
    2248:	02e78863          	beq	a5,a4,2278 <exitwait+0xc4>
        printf("%s: wait wrong exit status\n", s);
    224c:	fd843583          	ld	a1,-40(s0)
    2250:	00007517          	auipc	a0,0x7
    2254:	8b050513          	addi	a0,a0,-1872 # 8b00 <malloc+0xb36>
    2258:	00006097          	auipc	ra,0x6
    225c:	b80080e7          	jalr	-1152(ra) # 7dd8 <printf>
        exit(1);
    2260:	4505                	li	a0,1
    2262:	00005097          	auipc	ra,0x5
    2266:	64e080e7          	jalr	1614(ra) # 78b0 <exit>
      }
    } else {
      exit(i);
    226a:	fec42783          	lw	a5,-20(s0)
    226e:	853e                	mv	a0,a5
    2270:	00005097          	auipc	ra,0x5
    2274:	640080e7          	jalr	1600(ra) # 78b0 <exit>
  for(i = 0; i < 100; i++){
    2278:	fec42783          	lw	a5,-20(s0)
    227c:	2785                	addiw	a5,a5,1
    227e:	fef42623          	sw	a5,-20(s0)
    2282:	fec42783          	lw	a5,-20(s0)
    2286:	0007871b          	sext.w	a4,a5
    228a:	06300793          	li	a5,99
    228e:	f2e7dce3          	bge	a5,a4,21c6 <exitwait+0x12>
    }
  }
}
    2292:	0001                	nop
    2294:	0001                	nop
    2296:	70a2                	ld	ra,40(sp)
    2298:	7402                	ld	s0,32(sp)
    229a:	6145                	addi	sp,sp,48
    229c:	8082                	ret

000000000000229e <reparent>:
// try to find races in the reparenting
// code that handles a parent exiting
// when it still has live children.
void
reparent(char *s)
{
    229e:	7179                	addi	sp,sp,-48
    22a0:	f406                	sd	ra,40(sp)
    22a2:	f022                	sd	s0,32(sp)
    22a4:	1800                	addi	s0,sp,48
    22a6:	fca43c23          	sd	a0,-40(s0)
  int master_pid = getpid();
    22aa:	00005097          	auipc	ra,0x5
    22ae:	686080e7          	jalr	1670(ra) # 7930 <getpid>
    22b2:	87aa                	mv	a5,a0
    22b4:	fef42423          	sw	a5,-24(s0)
  for(int i = 0; i < 200; i++){
    22b8:	fe042623          	sw	zero,-20(s0)
    22bc:	a86d                	j	2376 <reparent+0xd8>
    int pid = fork();
    22be:	00005097          	auipc	ra,0x5
    22c2:	5ea080e7          	jalr	1514(ra) # 78a8 <fork>
    22c6:	87aa                	mv	a5,a0
    22c8:	fef42223          	sw	a5,-28(s0)
    if(pid < 0){
    22cc:	fe442783          	lw	a5,-28(s0)
    22d0:	2781                	sext.w	a5,a5
    22d2:	0207d163          	bgez	a5,22f4 <reparent+0x56>
      printf("%s: fork failed\n", s);
    22d6:	fd843583          	ld	a1,-40(s0)
    22da:	00006517          	auipc	a0,0x6
    22de:	27650513          	addi	a0,a0,630 # 8550 <malloc+0x586>
    22e2:	00006097          	auipc	ra,0x6
    22e6:	af6080e7          	jalr	-1290(ra) # 7dd8 <printf>
      exit(1);
    22ea:	4505                	li	a0,1
    22ec:	00005097          	auipc	ra,0x5
    22f0:	5c4080e7          	jalr	1476(ra) # 78b0 <exit>
    }
    if(pid){
    22f4:	fe442783          	lw	a5,-28(s0)
    22f8:	2781                	sext.w	a5,a5
    22fa:	cf85                	beqz	a5,2332 <reparent+0x94>
      if(wait(0) != pid){
    22fc:	4501                	li	a0,0
    22fe:	00005097          	auipc	ra,0x5
    2302:	5ba080e7          	jalr	1466(ra) # 78b8 <wait>
    2306:	87aa                	mv	a5,a0
    2308:	873e                	mv	a4,a5
    230a:	fe442783          	lw	a5,-28(s0)
    230e:	2781                	sext.w	a5,a5
    2310:	04e78e63          	beq	a5,a4,236c <reparent+0xce>
        printf("%s: wait wrong pid\n", s);
    2314:	fd843583          	ld	a1,-40(s0)
    2318:	00006517          	auipc	a0,0x6
    231c:	7d050513          	addi	a0,a0,2000 # 8ae8 <malloc+0xb1e>
    2320:	00006097          	auipc	ra,0x6
    2324:	ab8080e7          	jalr	-1352(ra) # 7dd8 <printf>
        exit(1);
    2328:	4505                	li	a0,1
    232a:	00005097          	auipc	ra,0x5
    232e:	586080e7          	jalr	1414(ra) # 78b0 <exit>
      }
    } else {
      int pid2 = fork();
    2332:	00005097          	auipc	ra,0x5
    2336:	576080e7          	jalr	1398(ra) # 78a8 <fork>
    233a:	87aa                	mv	a5,a0
    233c:	fef42023          	sw	a5,-32(s0)
      if(pid2 < 0){
    2340:	fe042783          	lw	a5,-32(s0)
    2344:	2781                	sext.w	a5,a5
    2346:	0007de63          	bgez	a5,2362 <reparent+0xc4>
        kill(master_pid);
    234a:	fe842783          	lw	a5,-24(s0)
    234e:	853e                	mv	a0,a5
    2350:	00005097          	auipc	ra,0x5
    2354:	590080e7          	jalr	1424(ra) # 78e0 <kill>
        exit(1);
    2358:	4505                	li	a0,1
    235a:	00005097          	auipc	ra,0x5
    235e:	556080e7          	jalr	1366(ra) # 78b0 <exit>
      }
      exit(0);
    2362:	4501                	li	a0,0
    2364:	00005097          	auipc	ra,0x5
    2368:	54c080e7          	jalr	1356(ra) # 78b0 <exit>
  for(int i = 0; i < 200; i++){
    236c:	fec42783          	lw	a5,-20(s0)
    2370:	2785                	addiw	a5,a5,1
    2372:	fef42623          	sw	a5,-20(s0)
    2376:	fec42783          	lw	a5,-20(s0)
    237a:	0007871b          	sext.w	a4,a5
    237e:	0c700793          	li	a5,199
    2382:	f2e7dee3          	bge	a5,a4,22be <reparent+0x20>
    }
  }
  exit(0);
    2386:	4501                	li	a0,0
    2388:	00005097          	auipc	ra,0x5
    238c:	528080e7          	jalr	1320(ra) # 78b0 <exit>

0000000000002390 <twochildren>:
}

// what if two children exit() at the same time?
void
twochildren(char *s)
{
    2390:	7179                	addi	sp,sp,-48
    2392:	f406                	sd	ra,40(sp)
    2394:	f022                	sd	s0,32(sp)
    2396:	1800                	addi	s0,sp,48
    2398:	fca43c23          	sd	a0,-40(s0)
  for(int i = 0; i < 1000; i++){
    239c:	fe042623          	sw	zero,-20(s0)
    23a0:	a845                	j	2450 <twochildren+0xc0>
    int pid1 = fork();
    23a2:	00005097          	auipc	ra,0x5
    23a6:	506080e7          	jalr	1286(ra) # 78a8 <fork>
    23aa:	87aa                	mv	a5,a0
    23ac:	fef42423          	sw	a5,-24(s0)
    if(pid1 < 0){
    23b0:	fe842783          	lw	a5,-24(s0)
    23b4:	2781                	sext.w	a5,a5
    23b6:	0207d163          	bgez	a5,23d8 <twochildren+0x48>
      printf("%s: fork failed\n", s);
    23ba:	fd843583          	ld	a1,-40(s0)
    23be:	00006517          	auipc	a0,0x6
    23c2:	19250513          	addi	a0,a0,402 # 8550 <malloc+0x586>
    23c6:	00006097          	auipc	ra,0x6
    23ca:	a12080e7          	jalr	-1518(ra) # 7dd8 <printf>
      exit(1);
    23ce:	4505                	li	a0,1
    23d0:	00005097          	auipc	ra,0x5
    23d4:	4e0080e7          	jalr	1248(ra) # 78b0 <exit>
    }
    if(pid1 == 0){
    23d8:	fe842783          	lw	a5,-24(s0)
    23dc:	2781                	sext.w	a5,a5
    23de:	e791                	bnez	a5,23ea <twochildren+0x5a>
      exit(0);
    23e0:	4501                	li	a0,0
    23e2:	00005097          	auipc	ra,0x5
    23e6:	4ce080e7          	jalr	1230(ra) # 78b0 <exit>
    } else {
      int pid2 = fork();
    23ea:	00005097          	auipc	ra,0x5
    23ee:	4be080e7          	jalr	1214(ra) # 78a8 <fork>
    23f2:	87aa                	mv	a5,a0
    23f4:	fef42223          	sw	a5,-28(s0)
      if(pid2 < 0){
    23f8:	fe442783          	lw	a5,-28(s0)
    23fc:	2781                	sext.w	a5,a5
    23fe:	0207d163          	bgez	a5,2420 <twochildren+0x90>
        printf("%s: fork failed\n", s);
    2402:	fd843583          	ld	a1,-40(s0)
    2406:	00006517          	auipc	a0,0x6
    240a:	14a50513          	addi	a0,a0,330 # 8550 <malloc+0x586>
    240e:	00006097          	auipc	ra,0x6
    2412:	9ca080e7          	jalr	-1590(ra) # 7dd8 <printf>
        exit(1);
    2416:	4505                	li	a0,1
    2418:	00005097          	auipc	ra,0x5
    241c:	498080e7          	jalr	1176(ra) # 78b0 <exit>
      }
      if(pid2 == 0){
    2420:	fe442783          	lw	a5,-28(s0)
    2424:	2781                	sext.w	a5,a5
    2426:	e791                	bnez	a5,2432 <twochildren+0xa2>
        exit(0);
    2428:	4501                	li	a0,0
    242a:	00005097          	auipc	ra,0x5
    242e:	486080e7          	jalr	1158(ra) # 78b0 <exit>
      } else {
        wait(0);
    2432:	4501                	li	a0,0
    2434:	00005097          	auipc	ra,0x5
    2438:	484080e7          	jalr	1156(ra) # 78b8 <wait>
        wait(0);
    243c:	4501                	li	a0,0
    243e:	00005097          	auipc	ra,0x5
    2442:	47a080e7          	jalr	1146(ra) # 78b8 <wait>
  for(int i = 0; i < 1000; i++){
    2446:	fec42783          	lw	a5,-20(s0)
    244a:	2785                	addiw	a5,a5,1
    244c:	fef42623          	sw	a5,-20(s0)
    2450:	fec42783          	lw	a5,-20(s0)
    2454:	0007871b          	sext.w	a4,a5
    2458:	3e700793          	li	a5,999
    245c:	f4e7d3e3          	bge	a5,a4,23a2 <twochildren+0x12>
      }
    }
  }
}
    2460:	0001                	nop
    2462:	0001                	nop
    2464:	70a2                	ld	ra,40(sp)
    2466:	7402                	ld	s0,32(sp)
    2468:	6145                	addi	sp,sp,48
    246a:	8082                	ret

000000000000246c <forkfork>:

// concurrent forks to try to expose locking bugs.
void
forkfork(char *s)
{
    246c:	7139                	addi	sp,sp,-64
    246e:	fc06                	sd	ra,56(sp)
    2470:	f822                	sd	s0,48(sp)
    2472:	0080                	addi	s0,sp,64
    2474:	fca43423          	sd	a0,-56(s0)
  enum { N=2 };
  
  for(int i = 0; i < N; i++){
    2478:	fe042623          	sw	zero,-20(s0)
    247c:	a84d                	j	252e <forkfork+0xc2>
    int pid = fork();
    247e:	00005097          	auipc	ra,0x5
    2482:	42a080e7          	jalr	1066(ra) # 78a8 <fork>
    2486:	87aa                	mv	a5,a0
    2488:	fef42023          	sw	a5,-32(s0)
    if(pid < 0){
    248c:	fe042783          	lw	a5,-32(s0)
    2490:	2781                	sext.w	a5,a5
    2492:	0207d163          	bgez	a5,24b4 <forkfork+0x48>
      printf("%s: fork failed", s);
    2496:	fc843583          	ld	a1,-56(s0)
    249a:	00006517          	auipc	a0,0x6
    249e:	5ee50513          	addi	a0,a0,1518 # 8a88 <malloc+0xabe>
    24a2:	00006097          	auipc	ra,0x6
    24a6:	936080e7          	jalr	-1738(ra) # 7dd8 <printf>
      exit(1);
    24aa:	4505                	li	a0,1
    24ac:	00005097          	auipc	ra,0x5
    24b0:	404080e7          	jalr	1028(ra) # 78b0 <exit>
    }
    if(pid == 0){
    24b4:	fe042783          	lw	a5,-32(s0)
    24b8:	2781                	sext.w	a5,a5
    24ba:	e7ad                	bnez	a5,2524 <forkfork+0xb8>
      for(int j = 0; j < 200; j++){
    24bc:	fe042423          	sw	zero,-24(s0)
    24c0:	a0a9                	j	250a <forkfork+0x9e>
        int pid1 = fork();
    24c2:	00005097          	auipc	ra,0x5
    24c6:	3e6080e7          	jalr	998(ra) # 78a8 <fork>
    24ca:	87aa                	mv	a5,a0
    24cc:	fcf42e23          	sw	a5,-36(s0)
        if(pid1 < 0){
    24d0:	fdc42783          	lw	a5,-36(s0)
    24d4:	2781                	sext.w	a5,a5
    24d6:	0007d763          	bgez	a5,24e4 <forkfork+0x78>
          exit(1);
    24da:	4505                	li	a0,1
    24dc:	00005097          	auipc	ra,0x5
    24e0:	3d4080e7          	jalr	980(ra) # 78b0 <exit>
        }
        if(pid1 == 0){
    24e4:	fdc42783          	lw	a5,-36(s0)
    24e8:	2781                	sext.w	a5,a5
    24ea:	e791                	bnez	a5,24f6 <forkfork+0x8a>
          exit(0);
    24ec:	4501                	li	a0,0
    24ee:	00005097          	auipc	ra,0x5
    24f2:	3c2080e7          	jalr	962(ra) # 78b0 <exit>
        }
        wait(0);
    24f6:	4501                	li	a0,0
    24f8:	00005097          	auipc	ra,0x5
    24fc:	3c0080e7          	jalr	960(ra) # 78b8 <wait>
      for(int j = 0; j < 200; j++){
    2500:	fe842783          	lw	a5,-24(s0)
    2504:	2785                	addiw	a5,a5,1
    2506:	fef42423          	sw	a5,-24(s0)
    250a:	fe842783          	lw	a5,-24(s0)
    250e:	0007871b          	sext.w	a4,a5
    2512:	0c700793          	li	a5,199
    2516:	fae7d6e3          	bge	a5,a4,24c2 <forkfork+0x56>
      }
      exit(0);
    251a:	4501                	li	a0,0
    251c:	00005097          	auipc	ra,0x5
    2520:	394080e7          	jalr	916(ra) # 78b0 <exit>
  for(int i = 0; i < N; i++){
    2524:	fec42783          	lw	a5,-20(s0)
    2528:	2785                	addiw	a5,a5,1
    252a:	fef42623          	sw	a5,-20(s0)
    252e:	fec42783          	lw	a5,-20(s0)
    2532:	0007871b          	sext.w	a4,a5
    2536:	4785                	li	a5,1
    2538:	f4e7d3e3          	bge	a5,a4,247e <forkfork+0x12>
    }
  }

  int xstatus;
  for(int i = 0; i < N; i++){
    253c:	fe042223          	sw	zero,-28(s0)
    2540:	a83d                	j	257e <forkfork+0x112>
    wait(&xstatus);
    2542:	fd840793          	addi	a5,s0,-40
    2546:	853e                	mv	a0,a5
    2548:	00005097          	auipc	ra,0x5
    254c:	370080e7          	jalr	880(ra) # 78b8 <wait>
    if(xstatus != 0) {
    2550:	fd842783          	lw	a5,-40(s0)
    2554:	c385                	beqz	a5,2574 <forkfork+0x108>
      printf("%s: fork in child failed", s);
    2556:	fc843583          	ld	a1,-56(s0)
    255a:	00006517          	auipc	a0,0x6
    255e:	5c650513          	addi	a0,a0,1478 # 8b20 <malloc+0xb56>
    2562:	00006097          	auipc	ra,0x6
    2566:	876080e7          	jalr	-1930(ra) # 7dd8 <printf>
      exit(1);
    256a:	4505                	li	a0,1
    256c:	00005097          	auipc	ra,0x5
    2570:	344080e7          	jalr	836(ra) # 78b0 <exit>
  for(int i = 0; i < N; i++){
    2574:	fe442783          	lw	a5,-28(s0)
    2578:	2785                	addiw	a5,a5,1
    257a:	fef42223          	sw	a5,-28(s0)
    257e:	fe442783          	lw	a5,-28(s0)
    2582:	0007871b          	sext.w	a4,a5
    2586:	4785                	li	a5,1
    2588:	fae7dde3          	bge	a5,a4,2542 <forkfork+0xd6>
    }
  }
}
    258c:	0001                	nop
    258e:	0001                	nop
    2590:	70e2                	ld	ra,56(sp)
    2592:	7442                	ld	s0,48(sp)
    2594:	6121                	addi	sp,sp,64
    2596:	8082                	ret

0000000000002598 <forkforkfork>:

void
forkforkfork(char *s)
{
    2598:	7179                	addi	sp,sp,-48
    259a:	f406                	sd	ra,40(sp)
    259c:	f022                	sd	s0,32(sp)
    259e:	1800                	addi	s0,sp,48
    25a0:	fca43c23          	sd	a0,-40(s0)
  unlink("stopforking");
    25a4:	00006517          	auipc	a0,0x6
    25a8:	59c50513          	addi	a0,a0,1436 # 8b40 <malloc+0xb76>
    25ac:	00005097          	auipc	ra,0x5
    25b0:	354080e7          	jalr	852(ra) # 7900 <unlink>

  int pid = fork();
    25b4:	00005097          	auipc	ra,0x5
    25b8:	2f4080e7          	jalr	756(ra) # 78a8 <fork>
    25bc:	87aa                	mv	a5,a0
    25be:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    25c2:	fec42783          	lw	a5,-20(s0)
    25c6:	2781                	sext.w	a5,a5
    25c8:	0207d163          	bgez	a5,25ea <forkforkfork+0x52>
    printf("%s: fork failed", s);
    25cc:	fd843583          	ld	a1,-40(s0)
    25d0:	00006517          	auipc	a0,0x6
    25d4:	4b850513          	addi	a0,a0,1208 # 8a88 <malloc+0xabe>
    25d8:	00006097          	auipc	ra,0x6
    25dc:	800080e7          	jalr	-2048(ra) # 7dd8 <printf>
    exit(1);
    25e0:	4505                	li	a0,1
    25e2:	00005097          	auipc	ra,0x5
    25e6:	2ce080e7          	jalr	718(ra) # 78b0 <exit>
  }
  if(pid == 0){
    25ea:	fec42783          	lw	a5,-20(s0)
    25ee:	2781                	sext.w	a5,a5
    25f0:	efb9                	bnez	a5,264e <forkforkfork+0xb6>
    while(1){
      int fd = open("stopforking", 0);
    25f2:	4581                	li	a1,0
    25f4:	00006517          	auipc	a0,0x6
    25f8:	54c50513          	addi	a0,a0,1356 # 8b40 <malloc+0xb76>
    25fc:	00005097          	auipc	ra,0x5
    2600:	2f4080e7          	jalr	756(ra) # 78f0 <open>
    2604:	87aa                	mv	a5,a0
    2606:	fef42423          	sw	a5,-24(s0)
      if(fd >= 0){
    260a:	fe842783          	lw	a5,-24(s0)
    260e:	2781                	sext.w	a5,a5
    2610:	0007c763          	bltz	a5,261e <forkforkfork+0x86>
        exit(0);
    2614:	4501                	li	a0,0
    2616:	00005097          	auipc	ra,0x5
    261a:	29a080e7          	jalr	666(ra) # 78b0 <exit>
      }
      if(fork() < 0){
    261e:	00005097          	auipc	ra,0x5
    2622:	28a080e7          	jalr	650(ra) # 78a8 <fork>
    2626:	87aa                	mv	a5,a0
    2628:	fc07d5e3          	bgez	a5,25f2 <forkforkfork+0x5a>
        close(open("stopforking", O_CREATE|O_RDWR));
    262c:	20200593          	li	a1,514
    2630:	00006517          	auipc	a0,0x6
    2634:	51050513          	addi	a0,a0,1296 # 8b40 <malloc+0xb76>
    2638:	00005097          	auipc	ra,0x5
    263c:	2b8080e7          	jalr	696(ra) # 78f0 <open>
    2640:	87aa                	mv	a5,a0
    2642:	853e                	mv	a0,a5
    2644:	00005097          	auipc	ra,0x5
    2648:	294080e7          	jalr	660(ra) # 78d8 <close>
    while(1){
    264c:	b75d                	j	25f2 <forkforkfork+0x5a>
    }

    exit(0);
  }

  sleep(20); // two seconds
    264e:	4551                	li	a0,20
    2650:	00005097          	auipc	ra,0x5
    2654:	2f0080e7          	jalr	752(ra) # 7940 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    2658:	20200593          	li	a1,514
    265c:	00006517          	auipc	a0,0x6
    2660:	4e450513          	addi	a0,a0,1252 # 8b40 <malloc+0xb76>
    2664:	00005097          	auipc	ra,0x5
    2668:	28c080e7          	jalr	652(ra) # 78f0 <open>
    266c:	87aa                	mv	a5,a0
    266e:	853e                	mv	a0,a5
    2670:	00005097          	auipc	ra,0x5
    2674:	268080e7          	jalr	616(ra) # 78d8 <close>
  wait(0);
    2678:	4501                	li	a0,0
    267a:	00005097          	auipc	ra,0x5
    267e:	23e080e7          	jalr	574(ra) # 78b8 <wait>
  sleep(10); // one second
    2682:	4529                	li	a0,10
    2684:	00005097          	auipc	ra,0x5
    2688:	2bc080e7          	jalr	700(ra) # 7940 <sleep>
}
    268c:	0001                	nop
    268e:	70a2                	ld	ra,40(sp)
    2690:	7402                	ld	s0,32(sp)
    2692:	6145                	addi	sp,sp,48
    2694:	8082                	ret

0000000000002696 <reparent2>:
// deadlocks against init's wait()? also used to trigger a "panic:
// release" due to exit() releasing a different p->parent->lock than
// it acquired.
void
reparent2(char *s)
{
    2696:	7179                	addi	sp,sp,-48
    2698:	f406                	sd	ra,40(sp)
    269a:	f022                	sd	s0,32(sp)
    269c:	1800                	addi	s0,sp,48
    269e:	fca43c23          	sd	a0,-40(s0)
  for(int i = 0; i < 800; i++){
    26a2:	fe042623          	sw	zero,-20(s0)
    26a6:	a0ad                	j	2710 <reparent2+0x7a>
    int pid1 = fork();
    26a8:	00005097          	auipc	ra,0x5
    26ac:	200080e7          	jalr	512(ra) # 78a8 <fork>
    26b0:	87aa                	mv	a5,a0
    26b2:	fef42423          	sw	a5,-24(s0)
    if(pid1 < 0){
    26b6:	fe842783          	lw	a5,-24(s0)
    26ba:	2781                	sext.w	a5,a5
    26bc:	0007df63          	bgez	a5,26da <reparent2+0x44>
      printf("fork failed\n");
    26c0:	00006517          	auipc	a0,0x6
    26c4:	c6050513          	addi	a0,a0,-928 # 8320 <malloc+0x356>
    26c8:	00005097          	auipc	ra,0x5
    26cc:	710080e7          	jalr	1808(ra) # 7dd8 <printf>
      exit(1);
    26d0:	4505                	li	a0,1
    26d2:	00005097          	auipc	ra,0x5
    26d6:	1de080e7          	jalr	478(ra) # 78b0 <exit>
    }
    if(pid1 == 0){
    26da:	fe842783          	lw	a5,-24(s0)
    26de:	2781                	sext.w	a5,a5
    26e0:	ef91                	bnez	a5,26fc <reparent2+0x66>
      fork();
    26e2:	00005097          	auipc	ra,0x5
    26e6:	1c6080e7          	jalr	454(ra) # 78a8 <fork>
      fork();
    26ea:	00005097          	auipc	ra,0x5
    26ee:	1be080e7          	jalr	446(ra) # 78a8 <fork>
      exit(0);
    26f2:	4501                	li	a0,0
    26f4:	00005097          	auipc	ra,0x5
    26f8:	1bc080e7          	jalr	444(ra) # 78b0 <exit>
    }
    wait(0);
    26fc:	4501                	li	a0,0
    26fe:	00005097          	auipc	ra,0x5
    2702:	1ba080e7          	jalr	442(ra) # 78b8 <wait>
  for(int i = 0; i < 800; i++){
    2706:	fec42783          	lw	a5,-20(s0)
    270a:	2785                	addiw	a5,a5,1
    270c:	fef42623          	sw	a5,-20(s0)
    2710:	fec42783          	lw	a5,-20(s0)
    2714:	0007871b          	sext.w	a4,a5
    2718:	31f00793          	li	a5,799
    271c:	f8e7d6e3          	bge	a5,a4,26a8 <reparent2+0x12>
  }

  exit(0);
    2720:	4501                	li	a0,0
    2722:	00005097          	auipc	ra,0x5
    2726:	18e080e7          	jalr	398(ra) # 78b0 <exit>

000000000000272a <mem>:
}

// allocate all mem, free it, and allocate again
void
mem(char *s)
{
    272a:	7139                	addi	sp,sp,-64
    272c:	fc06                	sd	ra,56(sp)
    272e:	f822                	sd	s0,48(sp)
    2730:	0080                	addi	s0,sp,64
    2732:	fca43423          	sd	a0,-56(s0)
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    2736:	00005097          	auipc	ra,0x5
    273a:	172080e7          	jalr	370(ra) # 78a8 <fork>
    273e:	87aa                	mv	a5,a0
    2740:	fef42223          	sw	a5,-28(s0)
    2744:	fe442783          	lw	a5,-28(s0)
    2748:	2781                	sext.w	a5,a5
    274a:	e3c5                	bnez	a5,27ea <mem+0xc0>
    m1 = 0;
    274c:	fe043423          	sd	zero,-24(s0)
    while((m2 = malloc(10001)) != 0){
    2750:	a811                	j	2764 <mem+0x3a>
      *(char**)m2 = m1;
    2752:	fd843783          	ld	a5,-40(s0)
    2756:	fe843703          	ld	a4,-24(s0)
    275a:	e398                	sd	a4,0(a5)
      m1 = m2;
    275c:	fd843783          	ld	a5,-40(s0)
    2760:	fef43423          	sd	a5,-24(s0)
    while((m2 = malloc(10001)) != 0){
    2764:	6789                	lui	a5,0x2
    2766:	71178513          	addi	a0,a5,1809 # 2711 <reparent2+0x7b>
    276a:	00006097          	auipc	ra,0x6
    276e:	860080e7          	jalr	-1952(ra) # 7fca <malloc>
    2772:	fca43c23          	sd	a0,-40(s0)
    2776:	fd843783          	ld	a5,-40(s0)
    277a:	ffe1                	bnez	a5,2752 <mem+0x28>
    }
    while(m1){
    277c:	a005                	j	279c <mem+0x72>
      m2 = *(char**)m1;
    277e:	fe843783          	ld	a5,-24(s0)
    2782:	639c                	ld	a5,0(a5)
    2784:	fcf43c23          	sd	a5,-40(s0)
      free(m1);
    2788:	fe843503          	ld	a0,-24(s0)
    278c:	00005097          	auipc	ra,0x5
    2790:	69c080e7          	jalr	1692(ra) # 7e28 <free>
      m1 = m2;
    2794:	fd843783          	ld	a5,-40(s0)
    2798:	fef43423          	sd	a5,-24(s0)
    while(m1){
    279c:	fe843783          	ld	a5,-24(s0)
    27a0:	fff9                	bnez	a5,277e <mem+0x54>
    }
    m1 = malloc(1024*20);
    27a2:	6515                	lui	a0,0x5
    27a4:	00006097          	auipc	ra,0x6
    27a8:	826080e7          	jalr	-2010(ra) # 7fca <malloc>
    27ac:	fea43423          	sd	a0,-24(s0)
    if(m1 == 0){
    27b0:	fe843783          	ld	a5,-24(s0)
    27b4:	e385                	bnez	a5,27d4 <mem+0xaa>
      printf("couldn't allocate mem?!!\n", s);
    27b6:	fc843583          	ld	a1,-56(s0)
    27ba:	00006517          	auipc	a0,0x6
    27be:	39650513          	addi	a0,a0,918 # 8b50 <malloc+0xb86>
    27c2:	00005097          	auipc	ra,0x5
    27c6:	616080e7          	jalr	1558(ra) # 7dd8 <printf>
      exit(1);
    27ca:	4505                	li	a0,1
    27cc:	00005097          	auipc	ra,0x5
    27d0:	0e4080e7          	jalr	228(ra) # 78b0 <exit>
    }
    free(m1);
    27d4:	fe843503          	ld	a0,-24(s0)
    27d8:	00005097          	auipc	ra,0x5
    27dc:	650080e7          	jalr	1616(ra) # 7e28 <free>
    exit(0);
    27e0:	4501                	li	a0,0
    27e2:	00005097          	auipc	ra,0x5
    27e6:	0ce080e7          	jalr	206(ra) # 78b0 <exit>
  } else {
    int xstatus;
    wait(&xstatus);
    27ea:	fd440793          	addi	a5,s0,-44
    27ee:	853e                	mv	a0,a5
    27f0:	00005097          	auipc	ra,0x5
    27f4:	0c8080e7          	jalr	200(ra) # 78b8 <wait>
    if(xstatus == -1){
    27f8:	fd442783          	lw	a5,-44(s0)
    27fc:	873e                	mv	a4,a5
    27fe:	57fd                	li	a5,-1
    2800:	00f71763          	bne	a4,a5,280e <mem+0xe4>
      // probably page fault, so might be lazy lab,
      // so OK.
      exit(0);
    2804:	4501                	li	a0,0
    2806:	00005097          	auipc	ra,0x5
    280a:	0aa080e7          	jalr	170(ra) # 78b0 <exit>
    }
    exit(xstatus);
    280e:	fd442783          	lw	a5,-44(s0)
    2812:	853e                	mv	a0,a5
    2814:	00005097          	auipc	ra,0x5
    2818:	09c080e7          	jalr	156(ra) # 78b0 <exit>

000000000000281c <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(char *s)
{
    281c:	715d                	addi	sp,sp,-80
    281e:	e486                	sd	ra,72(sp)
    2820:	e0a2                	sd	s0,64(sp)
    2822:	0880                	addi	s0,sp,80
    2824:	faa43c23          	sd	a0,-72(s0)
  int fd, pid, i, n, nc, np;
  enum { N = 1000, SZ=10};
  char buf[SZ];

  unlink("sharedfd");
    2828:	00006517          	auipc	a0,0x6
    282c:	34850513          	addi	a0,a0,840 # 8b70 <malloc+0xba6>
    2830:	00005097          	auipc	ra,0x5
    2834:	0d0080e7          	jalr	208(ra) # 7900 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    2838:	20200593          	li	a1,514
    283c:	00006517          	auipc	a0,0x6
    2840:	33450513          	addi	a0,a0,820 # 8b70 <malloc+0xba6>
    2844:	00005097          	auipc	ra,0x5
    2848:	0ac080e7          	jalr	172(ra) # 78f0 <open>
    284c:	87aa                	mv	a5,a0
    284e:	fef42023          	sw	a5,-32(s0)
  if(fd < 0){
    2852:	fe042783          	lw	a5,-32(s0)
    2856:	2781                	sext.w	a5,a5
    2858:	0207d163          	bgez	a5,287a <sharedfd+0x5e>
    printf("%s: cannot open sharedfd for writing", s);
    285c:	fb843583          	ld	a1,-72(s0)
    2860:	00006517          	auipc	a0,0x6
    2864:	32050513          	addi	a0,a0,800 # 8b80 <malloc+0xbb6>
    2868:	00005097          	auipc	ra,0x5
    286c:	570080e7          	jalr	1392(ra) # 7dd8 <printf>
    exit(1);
    2870:	4505                	li	a0,1
    2872:	00005097          	auipc	ra,0x5
    2876:	03e080e7          	jalr	62(ra) # 78b0 <exit>
  }
  pid = fork();
    287a:	00005097          	auipc	ra,0x5
    287e:	02e080e7          	jalr	46(ra) # 78a8 <fork>
    2882:	87aa                	mv	a5,a0
    2884:	fcf42e23          	sw	a5,-36(s0)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2888:	fdc42783          	lw	a5,-36(s0)
    288c:	2781                	sext.w	a5,a5
    288e:	e781                	bnez	a5,2896 <sharedfd+0x7a>
    2890:	06300793          	li	a5,99
    2894:	a019                	j	289a <sharedfd+0x7e>
    2896:	07000793          	li	a5,112
    289a:	fc840713          	addi	a4,s0,-56
    289e:	4629                	li	a2,10
    28a0:	85be                	mv	a1,a5
    28a2:	853a                	mv	a0,a4
    28a4:	00005097          	auipc	ra,0x5
    28a8:	c60080e7          	jalr	-928(ra) # 7504 <memset>
  for(i = 0; i < N; i++){
    28ac:	fe042623          	sw	zero,-20(s0)
    28b0:	a0a9                	j	28fa <sharedfd+0xde>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    28b2:	fc840713          	addi	a4,s0,-56
    28b6:	fe042783          	lw	a5,-32(s0)
    28ba:	4629                	li	a2,10
    28bc:	85ba                	mv	a1,a4
    28be:	853e                	mv	a0,a5
    28c0:	00005097          	auipc	ra,0x5
    28c4:	010080e7          	jalr	16(ra) # 78d0 <write>
    28c8:	87aa                	mv	a5,a0
    28ca:	873e                	mv	a4,a5
    28cc:	47a9                	li	a5,10
    28ce:	02f70163          	beq	a4,a5,28f0 <sharedfd+0xd4>
      printf("%s: write sharedfd failed\n", s);
    28d2:	fb843583          	ld	a1,-72(s0)
    28d6:	00006517          	auipc	a0,0x6
    28da:	2d250513          	addi	a0,a0,722 # 8ba8 <malloc+0xbde>
    28de:	00005097          	auipc	ra,0x5
    28e2:	4fa080e7          	jalr	1274(ra) # 7dd8 <printf>
      exit(1);
    28e6:	4505                	li	a0,1
    28e8:	00005097          	auipc	ra,0x5
    28ec:	fc8080e7          	jalr	-56(ra) # 78b0 <exit>
  for(i = 0; i < N; i++){
    28f0:	fec42783          	lw	a5,-20(s0)
    28f4:	2785                	addiw	a5,a5,1
    28f6:	fef42623          	sw	a5,-20(s0)
    28fa:	fec42783          	lw	a5,-20(s0)
    28fe:	0007871b          	sext.w	a4,a5
    2902:	3e700793          	li	a5,999
    2906:	fae7d6e3          	bge	a5,a4,28b2 <sharedfd+0x96>
    }
  }
  if(pid == 0) {
    290a:	fdc42783          	lw	a5,-36(s0)
    290e:	2781                	sext.w	a5,a5
    2910:	e791                	bnez	a5,291c <sharedfd+0x100>
    exit(0);
    2912:	4501                	li	a0,0
    2914:	00005097          	auipc	ra,0x5
    2918:	f9c080e7          	jalr	-100(ra) # 78b0 <exit>
  } else {
    int xstatus;
    wait(&xstatus);
    291c:	fc440793          	addi	a5,s0,-60
    2920:	853e                	mv	a0,a5
    2922:	00005097          	auipc	ra,0x5
    2926:	f96080e7          	jalr	-106(ra) # 78b8 <wait>
    if(xstatus != 0)
    292a:	fc442783          	lw	a5,-60(s0)
    292e:	cb81                	beqz	a5,293e <sharedfd+0x122>
      exit(xstatus);
    2930:	fc442783          	lw	a5,-60(s0)
    2934:	853e                	mv	a0,a5
    2936:	00005097          	auipc	ra,0x5
    293a:	f7a080e7          	jalr	-134(ra) # 78b0 <exit>
  }
  
  close(fd);
    293e:	fe042783          	lw	a5,-32(s0)
    2942:	853e                	mv	a0,a5
    2944:	00005097          	auipc	ra,0x5
    2948:	f94080e7          	jalr	-108(ra) # 78d8 <close>
  fd = open("sharedfd", 0);
    294c:	4581                	li	a1,0
    294e:	00006517          	auipc	a0,0x6
    2952:	22250513          	addi	a0,a0,546 # 8b70 <malloc+0xba6>
    2956:	00005097          	auipc	ra,0x5
    295a:	f9a080e7          	jalr	-102(ra) # 78f0 <open>
    295e:	87aa                	mv	a5,a0
    2960:	fef42023          	sw	a5,-32(s0)
  if(fd < 0){
    2964:	fe042783          	lw	a5,-32(s0)
    2968:	2781                	sext.w	a5,a5
    296a:	0207d163          	bgez	a5,298c <sharedfd+0x170>
    printf("%s: cannot open sharedfd for reading\n", s);
    296e:	fb843583          	ld	a1,-72(s0)
    2972:	00006517          	auipc	a0,0x6
    2976:	25650513          	addi	a0,a0,598 # 8bc8 <malloc+0xbfe>
    297a:	00005097          	auipc	ra,0x5
    297e:	45e080e7          	jalr	1118(ra) # 7dd8 <printf>
    exit(1);
    2982:	4505                	li	a0,1
    2984:	00005097          	auipc	ra,0x5
    2988:	f2c080e7          	jalr	-212(ra) # 78b0 <exit>
  }
  nc = np = 0;
    298c:	fe042223          	sw	zero,-28(s0)
    2990:	fe442783          	lw	a5,-28(s0)
    2994:	fef42423          	sw	a5,-24(s0)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    2998:	a8b9                	j	29f6 <sharedfd+0x1da>
    for(i = 0; i < sizeof(buf); i++){
    299a:	fe042623          	sw	zero,-20(s0)
    299e:	a0b1                	j	29ea <sharedfd+0x1ce>
      if(buf[i] == 'c')
    29a0:	fec42783          	lw	a5,-20(s0)
    29a4:	17c1                	addi	a5,a5,-16
    29a6:	97a2                	add	a5,a5,s0
    29a8:	fd87c783          	lbu	a5,-40(a5)
    29ac:	873e                	mv	a4,a5
    29ae:	06300793          	li	a5,99
    29b2:	00f71763          	bne	a4,a5,29c0 <sharedfd+0x1a4>
        nc++;
    29b6:	fe842783          	lw	a5,-24(s0)
    29ba:	2785                	addiw	a5,a5,1
    29bc:	fef42423          	sw	a5,-24(s0)
      if(buf[i] == 'p')
    29c0:	fec42783          	lw	a5,-20(s0)
    29c4:	17c1                	addi	a5,a5,-16
    29c6:	97a2                	add	a5,a5,s0
    29c8:	fd87c783          	lbu	a5,-40(a5)
    29cc:	873e                	mv	a4,a5
    29ce:	07000793          	li	a5,112
    29d2:	00f71763          	bne	a4,a5,29e0 <sharedfd+0x1c4>
        np++;
    29d6:	fe442783          	lw	a5,-28(s0)
    29da:	2785                	addiw	a5,a5,1
    29dc:	fef42223          	sw	a5,-28(s0)
    for(i = 0; i < sizeof(buf); i++){
    29e0:	fec42783          	lw	a5,-20(s0)
    29e4:	2785                	addiw	a5,a5,1
    29e6:	fef42623          	sw	a5,-20(s0)
    29ea:	fec42783          	lw	a5,-20(s0)
    29ee:	873e                	mv	a4,a5
    29f0:	47a5                	li	a5,9
    29f2:	fae7f7e3          	bgeu	a5,a4,29a0 <sharedfd+0x184>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    29f6:	fc840713          	addi	a4,s0,-56
    29fa:	fe042783          	lw	a5,-32(s0)
    29fe:	4629                	li	a2,10
    2a00:	85ba                	mv	a1,a4
    2a02:	853e                	mv	a0,a5
    2a04:	00005097          	auipc	ra,0x5
    2a08:	ec4080e7          	jalr	-316(ra) # 78c8 <read>
    2a0c:	87aa                	mv	a5,a0
    2a0e:	fcf42c23          	sw	a5,-40(s0)
    2a12:	fd842783          	lw	a5,-40(s0)
    2a16:	2781                	sext.w	a5,a5
    2a18:	f8f041e3          	bgtz	a5,299a <sharedfd+0x17e>
    }
  }
  close(fd);
    2a1c:	fe042783          	lw	a5,-32(s0)
    2a20:	853e                	mv	a0,a5
    2a22:	00005097          	auipc	ra,0x5
    2a26:	eb6080e7          	jalr	-330(ra) # 78d8 <close>
  unlink("sharedfd");
    2a2a:	00006517          	auipc	a0,0x6
    2a2e:	14650513          	addi	a0,a0,326 # 8b70 <malloc+0xba6>
    2a32:	00005097          	auipc	ra,0x5
    2a36:	ece080e7          	jalr	-306(ra) # 7900 <unlink>
  if(nc == N*SZ && np == N*SZ){
    2a3a:	fe842783          	lw	a5,-24(s0)
    2a3e:	0007871b          	sext.w	a4,a5
    2a42:	6789                	lui	a5,0x2
    2a44:	71078793          	addi	a5,a5,1808 # 2710 <reparent2+0x7a>
    2a48:	02f71063          	bne	a4,a5,2a68 <sharedfd+0x24c>
    2a4c:	fe442783          	lw	a5,-28(s0)
    2a50:	0007871b          	sext.w	a4,a5
    2a54:	6789                	lui	a5,0x2
    2a56:	71078793          	addi	a5,a5,1808 # 2710 <reparent2+0x7a>
    2a5a:	00f71763          	bne	a4,a5,2a68 <sharedfd+0x24c>
    exit(0);
    2a5e:	4501                	li	a0,0
    2a60:	00005097          	auipc	ra,0x5
    2a64:	e50080e7          	jalr	-432(ra) # 78b0 <exit>
  } else {
    printf("%s: nc/np test fails\n", s);
    2a68:	fb843583          	ld	a1,-72(s0)
    2a6c:	00006517          	auipc	a0,0x6
    2a70:	18450513          	addi	a0,a0,388 # 8bf0 <malloc+0xc26>
    2a74:	00005097          	auipc	ra,0x5
    2a78:	364080e7          	jalr	868(ra) # 7dd8 <printf>
    exit(1);
    2a7c:	4505                	li	a0,1
    2a7e:	00005097          	auipc	ra,0x5
    2a82:	e32080e7          	jalr	-462(ra) # 78b0 <exit>

0000000000002a86 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(char *s)
{
    2a86:	7159                	addi	sp,sp,-112
    2a88:	f486                	sd	ra,104(sp)
    2a8a:	f0a2                	sd	s0,96(sp)
    2a8c:	1880                	addi	s0,sp,112
    2a8e:	f8a43c23          	sd	a0,-104(s0)
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    2a92:	00006797          	auipc	a5,0x6
    2a96:	1e678793          	addi	a5,a5,486 # 8c78 <malloc+0xcae>
    2a9a:	6390                	ld	a2,0(a5)
    2a9c:	6794                	ld	a3,8(a5)
    2a9e:	6b98                	ld	a4,16(a5)
    2aa0:	6f9c                	ld	a5,24(a5)
    2aa2:	fac43423          	sd	a2,-88(s0)
    2aa6:	fad43823          	sd	a3,-80(s0)
    2aaa:	fae43c23          	sd	a4,-72(s0)
    2aae:	fcf43023          	sd	a5,-64(s0)
  char *fname;
  enum { N=12, NCHILD=4, SZ=500 };
  
  for(pi = 0; pi < NCHILD; pi++){
    2ab2:	fe042023          	sw	zero,-32(s0)
    2ab6:	aa3d                	j	2bf4 <fourfiles+0x16e>
    fname = names[pi];
    2ab8:	fe042783          	lw	a5,-32(s0)
    2abc:	078e                	slli	a5,a5,0x3
    2abe:	17c1                	addi	a5,a5,-16
    2ac0:	97a2                	add	a5,a5,s0
    2ac2:	fb87b783          	ld	a5,-72(a5)
    2ac6:	fcf43c23          	sd	a5,-40(s0)
    unlink(fname);
    2aca:	fd843503          	ld	a0,-40(s0)
    2ace:	00005097          	auipc	ra,0x5
    2ad2:	e32080e7          	jalr	-462(ra) # 7900 <unlink>

    pid = fork();
    2ad6:	00005097          	auipc	ra,0x5
    2ada:	dd2080e7          	jalr	-558(ra) # 78a8 <fork>
    2ade:	87aa                	mv	a5,a0
    2ae0:	fcf42623          	sw	a5,-52(s0)
    if(pid < 0){
    2ae4:	fcc42783          	lw	a5,-52(s0)
    2ae8:	2781                	sext.w	a5,a5
    2aea:	0207d163          	bgez	a5,2b0c <fourfiles+0x86>
      printf("fork failed\n", s);
    2aee:	f9843583          	ld	a1,-104(s0)
    2af2:	00006517          	auipc	a0,0x6
    2af6:	82e50513          	addi	a0,a0,-2002 # 8320 <malloc+0x356>
    2afa:	00005097          	auipc	ra,0x5
    2afe:	2de080e7          	jalr	734(ra) # 7dd8 <printf>
      exit(1);
    2b02:	4505                	li	a0,1
    2b04:	00005097          	auipc	ra,0x5
    2b08:	dac080e7          	jalr	-596(ra) # 78b0 <exit>
    }

    if(pid == 0){
    2b0c:	fcc42783          	lw	a5,-52(s0)
    2b10:	2781                	sext.w	a5,a5
    2b12:	efe1                	bnez	a5,2bea <fourfiles+0x164>
      fd = open(fname, O_CREATE | O_RDWR);
    2b14:	20200593          	li	a1,514
    2b18:	fd843503          	ld	a0,-40(s0)
    2b1c:	00005097          	auipc	ra,0x5
    2b20:	dd4080e7          	jalr	-556(ra) # 78f0 <open>
    2b24:	87aa                	mv	a5,a0
    2b26:	fcf42a23          	sw	a5,-44(s0)
      if(fd < 0){
    2b2a:	fd442783          	lw	a5,-44(s0)
    2b2e:	2781                	sext.w	a5,a5
    2b30:	0207d163          	bgez	a5,2b52 <fourfiles+0xcc>
        printf("create failed\n", s);
    2b34:	f9843583          	ld	a1,-104(s0)
    2b38:	00006517          	auipc	a0,0x6
    2b3c:	0d050513          	addi	a0,a0,208 # 8c08 <malloc+0xc3e>
    2b40:	00005097          	auipc	ra,0x5
    2b44:	298080e7          	jalr	664(ra) # 7dd8 <printf>
        exit(1);
    2b48:	4505                	li	a0,1
    2b4a:	00005097          	auipc	ra,0x5
    2b4e:	d66080e7          	jalr	-666(ra) # 78b0 <exit>
      }

      memset(buf, '0'+pi, SZ);
    2b52:	fe042783          	lw	a5,-32(s0)
    2b56:	0307879b          	addiw	a5,a5,48
    2b5a:	2781                	sext.w	a5,a5
    2b5c:	1f400613          	li	a2,500
    2b60:	85be                	mv	a1,a5
    2b62:	00009517          	auipc	a0,0x9
    2b66:	79e50513          	addi	a0,a0,1950 # c300 <buf>
    2b6a:	00005097          	auipc	ra,0x5
    2b6e:	99a080e7          	jalr	-1638(ra) # 7504 <memset>
      for(i = 0; i < N; i++){
    2b72:	fe042623          	sw	zero,-20(s0)
    2b76:	a8b1                	j	2bd2 <fourfiles+0x14c>
        if((n = write(fd, buf, SZ)) != SZ){
    2b78:	fd442783          	lw	a5,-44(s0)
    2b7c:	1f400613          	li	a2,500
    2b80:	00009597          	auipc	a1,0x9
    2b84:	78058593          	addi	a1,a1,1920 # c300 <buf>
    2b88:	853e                	mv	a0,a5
    2b8a:	00005097          	auipc	ra,0x5
    2b8e:	d46080e7          	jalr	-698(ra) # 78d0 <write>
    2b92:	87aa                	mv	a5,a0
    2b94:	fcf42823          	sw	a5,-48(s0)
    2b98:	fd042783          	lw	a5,-48(s0)
    2b9c:	0007871b          	sext.w	a4,a5
    2ba0:	1f400793          	li	a5,500
    2ba4:	02f70263          	beq	a4,a5,2bc8 <fourfiles+0x142>
          printf("write failed %d\n", n);
    2ba8:	fd042783          	lw	a5,-48(s0)
    2bac:	85be                	mv	a1,a5
    2bae:	00006517          	auipc	a0,0x6
    2bb2:	06a50513          	addi	a0,a0,106 # 8c18 <malloc+0xc4e>
    2bb6:	00005097          	auipc	ra,0x5
    2bba:	222080e7          	jalr	546(ra) # 7dd8 <printf>
          exit(1);
    2bbe:	4505                	li	a0,1
    2bc0:	00005097          	auipc	ra,0x5
    2bc4:	cf0080e7          	jalr	-784(ra) # 78b0 <exit>
      for(i = 0; i < N; i++){
    2bc8:	fec42783          	lw	a5,-20(s0)
    2bcc:	2785                	addiw	a5,a5,1
    2bce:	fef42623          	sw	a5,-20(s0)
    2bd2:	fec42783          	lw	a5,-20(s0)
    2bd6:	0007871b          	sext.w	a4,a5
    2bda:	47ad                	li	a5,11
    2bdc:	f8e7dee3          	bge	a5,a4,2b78 <fourfiles+0xf2>
        }
      }
      exit(0);
    2be0:	4501                	li	a0,0
    2be2:	00005097          	auipc	ra,0x5
    2be6:	cce080e7          	jalr	-818(ra) # 78b0 <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2bea:	fe042783          	lw	a5,-32(s0)
    2bee:	2785                	addiw	a5,a5,1
    2bf0:	fef42023          	sw	a5,-32(s0)
    2bf4:	fe042783          	lw	a5,-32(s0)
    2bf8:	0007871b          	sext.w	a4,a5
    2bfc:	478d                	li	a5,3
    2bfe:	eae7dde3          	bge	a5,a4,2ab8 <fourfiles+0x32>
    }
  }

  int xstatus;
  for(pi = 0; pi < NCHILD; pi++){
    2c02:	fe042023          	sw	zero,-32(s0)
    2c06:	a03d                	j	2c34 <fourfiles+0x1ae>
    wait(&xstatus);
    2c08:	fa440793          	addi	a5,s0,-92
    2c0c:	853e                	mv	a0,a5
    2c0e:	00005097          	auipc	ra,0x5
    2c12:	caa080e7          	jalr	-854(ra) # 78b8 <wait>
    if(xstatus != 0)
    2c16:	fa442783          	lw	a5,-92(s0)
    2c1a:	cb81                	beqz	a5,2c2a <fourfiles+0x1a4>
      exit(xstatus);
    2c1c:	fa442783          	lw	a5,-92(s0)
    2c20:	853e                	mv	a0,a5
    2c22:	00005097          	auipc	ra,0x5
    2c26:	c8e080e7          	jalr	-882(ra) # 78b0 <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2c2a:	fe042783          	lw	a5,-32(s0)
    2c2e:	2785                	addiw	a5,a5,1
    2c30:	fef42023          	sw	a5,-32(s0)
    2c34:	fe042783          	lw	a5,-32(s0)
    2c38:	0007871b          	sext.w	a4,a5
    2c3c:	478d                	li	a5,3
    2c3e:	fce7d5e3          	bge	a5,a4,2c08 <fourfiles+0x182>
  }

  for(i = 0; i < NCHILD; i++){
    2c42:	fe042623          	sw	zero,-20(s0)
    2c46:	a205                	j	2d66 <fourfiles+0x2e0>
    fname = names[i];
    2c48:	fec42783          	lw	a5,-20(s0)
    2c4c:	078e                	slli	a5,a5,0x3
    2c4e:	17c1                	addi	a5,a5,-16
    2c50:	97a2                	add	a5,a5,s0
    2c52:	fb87b783          	ld	a5,-72(a5)
    2c56:	fcf43c23          	sd	a5,-40(s0)
    fd = open(fname, 0);
    2c5a:	4581                	li	a1,0
    2c5c:	fd843503          	ld	a0,-40(s0)
    2c60:	00005097          	auipc	ra,0x5
    2c64:	c90080e7          	jalr	-880(ra) # 78f0 <open>
    2c68:	87aa                	mv	a5,a0
    2c6a:	fcf42a23          	sw	a5,-44(s0)
    total = 0;
    2c6e:	fe042223          	sw	zero,-28(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2c72:	a89d                	j	2ce8 <fourfiles+0x262>
      for(j = 0; j < n; j++){
    2c74:	fe042423          	sw	zero,-24(s0)
    2c78:	a0b9                	j	2cc6 <fourfiles+0x240>
        if(buf[j] != '0'+i){
    2c7a:	00009717          	auipc	a4,0x9
    2c7e:	68670713          	addi	a4,a4,1670 # c300 <buf>
    2c82:	fe842783          	lw	a5,-24(s0)
    2c86:	97ba                	add	a5,a5,a4
    2c88:	0007c783          	lbu	a5,0(a5)
    2c8c:	0007871b          	sext.w	a4,a5
    2c90:	fec42783          	lw	a5,-20(s0)
    2c94:	0307879b          	addiw	a5,a5,48
    2c98:	2781                	sext.w	a5,a5
    2c9a:	02f70163          	beq	a4,a5,2cbc <fourfiles+0x236>
          printf("wrong char\n", s);
    2c9e:	f9843583          	ld	a1,-104(s0)
    2ca2:	00006517          	auipc	a0,0x6
    2ca6:	f8e50513          	addi	a0,a0,-114 # 8c30 <malloc+0xc66>
    2caa:	00005097          	auipc	ra,0x5
    2cae:	12e080e7          	jalr	302(ra) # 7dd8 <printf>
          exit(1);
    2cb2:	4505                	li	a0,1
    2cb4:	00005097          	auipc	ra,0x5
    2cb8:	bfc080e7          	jalr	-1028(ra) # 78b0 <exit>
      for(j = 0; j < n; j++){
    2cbc:	fe842783          	lw	a5,-24(s0)
    2cc0:	2785                	addiw	a5,a5,1
    2cc2:	fef42423          	sw	a5,-24(s0)
    2cc6:	fe842783          	lw	a5,-24(s0)
    2cca:	873e                	mv	a4,a5
    2ccc:	fd042783          	lw	a5,-48(s0)
    2cd0:	2701                	sext.w	a4,a4
    2cd2:	2781                	sext.w	a5,a5
    2cd4:	faf743e3          	blt	a4,a5,2c7a <fourfiles+0x1f4>
        }
      }
      total += n;
    2cd8:	fe442783          	lw	a5,-28(s0)
    2cdc:	873e                	mv	a4,a5
    2cde:	fd042783          	lw	a5,-48(s0)
    2ce2:	9fb9                	addw	a5,a5,a4
    2ce4:	fef42223          	sw	a5,-28(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2ce8:	fd442783          	lw	a5,-44(s0)
    2cec:	660d                	lui	a2,0x3
    2cee:	00009597          	auipc	a1,0x9
    2cf2:	61258593          	addi	a1,a1,1554 # c300 <buf>
    2cf6:	853e                	mv	a0,a5
    2cf8:	00005097          	auipc	ra,0x5
    2cfc:	bd0080e7          	jalr	-1072(ra) # 78c8 <read>
    2d00:	87aa                	mv	a5,a0
    2d02:	fcf42823          	sw	a5,-48(s0)
    2d06:	fd042783          	lw	a5,-48(s0)
    2d0a:	2781                	sext.w	a5,a5
    2d0c:	f6f044e3          	bgtz	a5,2c74 <fourfiles+0x1ee>
    }
    close(fd);
    2d10:	fd442783          	lw	a5,-44(s0)
    2d14:	853e                	mv	a0,a5
    2d16:	00005097          	auipc	ra,0x5
    2d1a:	bc2080e7          	jalr	-1086(ra) # 78d8 <close>
    if(total != N*SZ){
    2d1e:	fe442783          	lw	a5,-28(s0)
    2d22:	0007871b          	sext.w	a4,a5
    2d26:	6785                	lui	a5,0x1
    2d28:	77078793          	addi	a5,a5,1904 # 1770 <writebig+0x12c>
    2d2c:	02f70263          	beq	a4,a5,2d50 <fourfiles+0x2ca>
      printf("wrong length %d\n", total);
    2d30:	fe442783          	lw	a5,-28(s0)
    2d34:	85be                	mv	a1,a5
    2d36:	00006517          	auipc	a0,0x6
    2d3a:	f0a50513          	addi	a0,a0,-246 # 8c40 <malloc+0xc76>
    2d3e:	00005097          	auipc	ra,0x5
    2d42:	09a080e7          	jalr	154(ra) # 7dd8 <printf>
      exit(1);
    2d46:	4505                	li	a0,1
    2d48:	00005097          	auipc	ra,0x5
    2d4c:	b68080e7          	jalr	-1176(ra) # 78b0 <exit>
    }
    unlink(fname);
    2d50:	fd843503          	ld	a0,-40(s0)
    2d54:	00005097          	auipc	ra,0x5
    2d58:	bac080e7          	jalr	-1108(ra) # 7900 <unlink>
  for(i = 0; i < NCHILD; i++){
    2d5c:	fec42783          	lw	a5,-20(s0)
    2d60:	2785                	addiw	a5,a5,1
    2d62:	fef42623          	sw	a5,-20(s0)
    2d66:	fec42783          	lw	a5,-20(s0)
    2d6a:	0007871b          	sext.w	a4,a5
    2d6e:	478d                	li	a5,3
    2d70:	ece7dce3          	bge	a5,a4,2c48 <fourfiles+0x1c2>
  }
}
    2d74:	0001                	nop
    2d76:	0001                	nop
    2d78:	70a6                	ld	ra,104(sp)
    2d7a:	7406                	ld	s0,96(sp)
    2d7c:	6165                	addi	sp,sp,112
    2d7e:	8082                	ret

0000000000002d80 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(char *s)
{
    2d80:	711d                	addi	sp,sp,-96
    2d82:	ec86                	sd	ra,88(sp)
    2d84:	e8a2                	sd	s0,80(sp)
    2d86:	1080                	addi	s0,sp,96
    2d88:	faa43423          	sd	a0,-88(s0)
  enum { N = 20, NCHILD=4 };
  int pid, i, fd, pi;
  char name[32];

  for(pi = 0; pi < NCHILD; pi++){
    2d8c:	fe042423          	sw	zero,-24(s0)
    2d90:	aa91                	j	2ee4 <createdelete+0x164>
    pid = fork();
    2d92:	00005097          	auipc	ra,0x5
    2d96:	b16080e7          	jalr	-1258(ra) # 78a8 <fork>
    2d9a:	87aa                	mv	a5,a0
    2d9c:	fef42023          	sw	a5,-32(s0)
    if(pid < 0){
    2da0:	fe042783          	lw	a5,-32(s0)
    2da4:	2781                	sext.w	a5,a5
    2da6:	0207d163          	bgez	a5,2dc8 <createdelete+0x48>
      printf("fork failed\n", s);
    2daa:	fa843583          	ld	a1,-88(s0)
    2dae:	00005517          	auipc	a0,0x5
    2db2:	57250513          	addi	a0,a0,1394 # 8320 <malloc+0x356>
    2db6:	00005097          	auipc	ra,0x5
    2dba:	022080e7          	jalr	34(ra) # 7dd8 <printf>
      exit(1);
    2dbe:	4505                	li	a0,1
    2dc0:	00005097          	auipc	ra,0x5
    2dc4:	af0080e7          	jalr	-1296(ra) # 78b0 <exit>
    }

    if(pid == 0){
    2dc8:	fe042783          	lw	a5,-32(s0)
    2dcc:	2781                	sext.w	a5,a5
    2dce:	10079663          	bnez	a5,2eda <createdelete+0x15a>
      name[0] = 'p' + pi;
    2dd2:	fe842783          	lw	a5,-24(s0)
    2dd6:	0ff7f793          	zext.b	a5,a5
    2dda:	0707879b          	addiw	a5,a5,112
    2dde:	0ff7f793          	zext.b	a5,a5
    2de2:	fcf40023          	sb	a5,-64(s0)
      name[2] = '\0';
    2de6:	fc040123          	sb	zero,-62(s0)
      for(i = 0; i < N; i++){
    2dea:	fe042623          	sw	zero,-20(s0)
    2dee:	a8d1                	j	2ec2 <createdelete+0x142>
        name[1] = '0' + i;
    2df0:	fec42783          	lw	a5,-20(s0)
    2df4:	0ff7f793          	zext.b	a5,a5
    2df8:	0307879b          	addiw	a5,a5,48
    2dfc:	0ff7f793          	zext.b	a5,a5
    2e00:	fcf400a3          	sb	a5,-63(s0)
        fd = open(name, O_CREATE | O_RDWR);
    2e04:	fc040793          	addi	a5,s0,-64
    2e08:	20200593          	li	a1,514
    2e0c:	853e                	mv	a0,a5
    2e0e:	00005097          	auipc	ra,0x5
    2e12:	ae2080e7          	jalr	-1310(ra) # 78f0 <open>
    2e16:	87aa                	mv	a5,a0
    2e18:	fef42223          	sw	a5,-28(s0)
        if(fd < 0){
    2e1c:	fe442783          	lw	a5,-28(s0)
    2e20:	2781                	sext.w	a5,a5
    2e22:	0207d163          	bgez	a5,2e44 <createdelete+0xc4>
          printf("%s: create failed\n", s);
    2e26:	fa843583          	ld	a1,-88(s0)
    2e2a:	00006517          	auipc	a0,0x6
    2e2e:	b4e50513          	addi	a0,a0,-1202 # 8978 <malloc+0x9ae>
    2e32:	00005097          	auipc	ra,0x5
    2e36:	fa6080e7          	jalr	-90(ra) # 7dd8 <printf>
          exit(1);
    2e3a:	4505                	li	a0,1
    2e3c:	00005097          	auipc	ra,0x5
    2e40:	a74080e7          	jalr	-1420(ra) # 78b0 <exit>
        }
        close(fd);
    2e44:	fe442783          	lw	a5,-28(s0)
    2e48:	853e                	mv	a0,a5
    2e4a:	00005097          	auipc	ra,0x5
    2e4e:	a8e080e7          	jalr	-1394(ra) # 78d8 <close>
        if(i > 0 && (i % 2 ) == 0){
    2e52:	fec42783          	lw	a5,-20(s0)
    2e56:	2781                	sext.w	a5,a5
    2e58:	06f05063          	blez	a5,2eb8 <createdelete+0x138>
    2e5c:	fec42783          	lw	a5,-20(s0)
    2e60:	8b85                	andi	a5,a5,1
    2e62:	2781                	sext.w	a5,a5
    2e64:	ebb1                	bnez	a5,2eb8 <createdelete+0x138>
          name[1] = '0' + (i / 2);
    2e66:	fec42783          	lw	a5,-20(s0)
    2e6a:	01f7d71b          	srliw	a4,a5,0x1f
    2e6e:	9fb9                	addw	a5,a5,a4
    2e70:	4017d79b          	sraiw	a5,a5,0x1
    2e74:	2781                	sext.w	a5,a5
    2e76:	0ff7f793          	zext.b	a5,a5
    2e7a:	0307879b          	addiw	a5,a5,48
    2e7e:	0ff7f793          	zext.b	a5,a5
    2e82:	fcf400a3          	sb	a5,-63(s0)
          if(unlink(name) < 0){
    2e86:	fc040793          	addi	a5,s0,-64
    2e8a:	853e                	mv	a0,a5
    2e8c:	00005097          	auipc	ra,0x5
    2e90:	a74080e7          	jalr	-1420(ra) # 7900 <unlink>
    2e94:	87aa                	mv	a5,a0
    2e96:	0207d163          	bgez	a5,2eb8 <createdelete+0x138>
            printf("%s: unlink failed\n", s);
    2e9a:	fa843583          	ld	a1,-88(s0)
    2e9e:	00006517          	auipc	a0,0x6
    2ea2:	82a50513          	addi	a0,a0,-2006 # 86c8 <malloc+0x6fe>
    2ea6:	00005097          	auipc	ra,0x5
    2eaa:	f32080e7          	jalr	-206(ra) # 7dd8 <printf>
            exit(1);
    2eae:	4505                	li	a0,1
    2eb0:	00005097          	auipc	ra,0x5
    2eb4:	a00080e7          	jalr	-1536(ra) # 78b0 <exit>
      for(i = 0; i < N; i++){
    2eb8:	fec42783          	lw	a5,-20(s0)
    2ebc:	2785                	addiw	a5,a5,1
    2ebe:	fef42623          	sw	a5,-20(s0)
    2ec2:	fec42783          	lw	a5,-20(s0)
    2ec6:	0007871b          	sext.w	a4,a5
    2eca:	47cd                	li	a5,19
    2ecc:	f2e7d2e3          	bge	a5,a4,2df0 <createdelete+0x70>
          }
        }
      }
      exit(0);
    2ed0:	4501                	li	a0,0
    2ed2:	00005097          	auipc	ra,0x5
    2ed6:	9de080e7          	jalr	-1570(ra) # 78b0 <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2eda:	fe842783          	lw	a5,-24(s0)
    2ede:	2785                	addiw	a5,a5,1
    2ee0:	fef42423          	sw	a5,-24(s0)
    2ee4:	fe842783          	lw	a5,-24(s0)
    2ee8:	0007871b          	sext.w	a4,a5
    2eec:	478d                	li	a5,3
    2eee:	eae7d2e3          	bge	a5,a4,2d92 <createdelete+0x12>
    }
  }

  int xstatus;
  for(pi = 0; pi < NCHILD; pi++){
    2ef2:	fe042423          	sw	zero,-24(s0)
    2ef6:	a02d                	j	2f20 <createdelete+0x1a0>
    wait(&xstatus);
    2ef8:	fbc40793          	addi	a5,s0,-68
    2efc:	853e                	mv	a0,a5
    2efe:	00005097          	auipc	ra,0x5
    2f02:	9ba080e7          	jalr	-1606(ra) # 78b8 <wait>
    if(xstatus != 0)
    2f06:	fbc42783          	lw	a5,-68(s0)
    2f0a:	c791                	beqz	a5,2f16 <createdelete+0x196>
      exit(1);
    2f0c:	4505                	li	a0,1
    2f0e:	00005097          	auipc	ra,0x5
    2f12:	9a2080e7          	jalr	-1630(ra) # 78b0 <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2f16:	fe842783          	lw	a5,-24(s0)
    2f1a:	2785                	addiw	a5,a5,1
    2f1c:	fef42423          	sw	a5,-24(s0)
    2f20:	fe842783          	lw	a5,-24(s0)
    2f24:	0007871b          	sext.w	a4,a5
    2f28:	478d                	li	a5,3
    2f2a:	fce7d7e3          	bge	a5,a4,2ef8 <createdelete+0x178>
  }

  name[0] = name[1] = name[2] = 0;
    2f2e:	fc040123          	sb	zero,-62(s0)
    2f32:	fc244783          	lbu	a5,-62(s0)
    2f36:	fcf400a3          	sb	a5,-63(s0)
    2f3a:	fc144783          	lbu	a5,-63(s0)
    2f3e:	fcf40023          	sb	a5,-64(s0)
  for(i = 0; i < N; i++){
    2f42:	fe042623          	sw	zero,-20(s0)
    2f46:	a229                	j	3050 <createdelete+0x2d0>
    for(pi = 0; pi < NCHILD; pi++){
    2f48:	fe042423          	sw	zero,-24(s0)
    2f4c:	a0f5                	j	3038 <createdelete+0x2b8>
      name[0] = 'p' + pi;
    2f4e:	fe842783          	lw	a5,-24(s0)
    2f52:	0ff7f793          	zext.b	a5,a5
    2f56:	0707879b          	addiw	a5,a5,112
    2f5a:	0ff7f793          	zext.b	a5,a5
    2f5e:	fcf40023          	sb	a5,-64(s0)
      name[1] = '0' + i;
    2f62:	fec42783          	lw	a5,-20(s0)
    2f66:	0ff7f793          	zext.b	a5,a5
    2f6a:	0307879b          	addiw	a5,a5,48
    2f6e:	0ff7f793          	zext.b	a5,a5
    2f72:	fcf400a3          	sb	a5,-63(s0)
      fd = open(name, 0);
    2f76:	fc040793          	addi	a5,s0,-64
    2f7a:	4581                	li	a1,0
    2f7c:	853e                	mv	a0,a5
    2f7e:	00005097          	auipc	ra,0x5
    2f82:	972080e7          	jalr	-1678(ra) # 78f0 <open>
    2f86:	87aa                	mv	a5,a0
    2f88:	fef42223          	sw	a5,-28(s0)
      if((i == 0 || i >= N/2) && fd < 0){
    2f8c:	fec42783          	lw	a5,-20(s0)
    2f90:	2781                	sext.w	a5,a5
    2f92:	cb81                	beqz	a5,2fa2 <createdelete+0x222>
    2f94:	fec42783          	lw	a5,-20(s0)
    2f98:	0007871b          	sext.w	a4,a5
    2f9c:	47a5                	li	a5,9
    2f9e:	02e7d963          	bge	a5,a4,2fd0 <createdelete+0x250>
    2fa2:	fe442783          	lw	a5,-28(s0)
    2fa6:	2781                	sext.w	a5,a5
    2fa8:	0207d463          	bgez	a5,2fd0 <createdelete+0x250>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    2fac:	fc040793          	addi	a5,s0,-64
    2fb0:	863e                	mv	a2,a5
    2fb2:	fa843583          	ld	a1,-88(s0)
    2fb6:	00006517          	auipc	a0,0x6
    2fba:	ce250513          	addi	a0,a0,-798 # 8c98 <malloc+0xcce>
    2fbe:	00005097          	auipc	ra,0x5
    2fc2:	e1a080e7          	jalr	-486(ra) # 7dd8 <printf>
        exit(1);
    2fc6:	4505                	li	a0,1
    2fc8:	00005097          	auipc	ra,0x5
    2fcc:	8e8080e7          	jalr	-1816(ra) # 78b0 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2fd0:	fec42783          	lw	a5,-20(s0)
    2fd4:	2781                	sext.w	a5,a5
    2fd6:	04f05063          	blez	a5,3016 <createdelete+0x296>
    2fda:	fec42783          	lw	a5,-20(s0)
    2fde:	0007871b          	sext.w	a4,a5
    2fe2:	47a5                	li	a5,9
    2fe4:	02e7c963          	blt	a5,a4,3016 <createdelete+0x296>
    2fe8:	fe442783          	lw	a5,-28(s0)
    2fec:	2781                	sext.w	a5,a5
    2fee:	0207c463          	bltz	a5,3016 <createdelete+0x296>
        printf("%s: oops createdelete %s did exist\n", s, name);
    2ff2:	fc040793          	addi	a5,s0,-64
    2ff6:	863e                	mv	a2,a5
    2ff8:	fa843583          	ld	a1,-88(s0)
    2ffc:	00006517          	auipc	a0,0x6
    3000:	cc450513          	addi	a0,a0,-828 # 8cc0 <malloc+0xcf6>
    3004:	00005097          	auipc	ra,0x5
    3008:	dd4080e7          	jalr	-556(ra) # 7dd8 <printf>
        exit(1);
    300c:	4505                	li	a0,1
    300e:	00005097          	auipc	ra,0x5
    3012:	8a2080e7          	jalr	-1886(ra) # 78b0 <exit>
      }
      if(fd >= 0)
    3016:	fe442783          	lw	a5,-28(s0)
    301a:	2781                	sext.w	a5,a5
    301c:	0007c963          	bltz	a5,302e <createdelete+0x2ae>
        close(fd);
    3020:	fe442783          	lw	a5,-28(s0)
    3024:	853e                	mv	a0,a5
    3026:	00005097          	auipc	ra,0x5
    302a:	8b2080e7          	jalr	-1870(ra) # 78d8 <close>
    for(pi = 0; pi < NCHILD; pi++){
    302e:	fe842783          	lw	a5,-24(s0)
    3032:	2785                	addiw	a5,a5,1
    3034:	fef42423          	sw	a5,-24(s0)
    3038:	fe842783          	lw	a5,-24(s0)
    303c:	0007871b          	sext.w	a4,a5
    3040:	478d                	li	a5,3
    3042:	f0e7d6e3          	bge	a5,a4,2f4e <createdelete+0x1ce>
  for(i = 0; i < N; i++){
    3046:	fec42783          	lw	a5,-20(s0)
    304a:	2785                	addiw	a5,a5,1
    304c:	fef42623          	sw	a5,-20(s0)
    3050:	fec42783          	lw	a5,-20(s0)
    3054:	0007871b          	sext.w	a4,a5
    3058:	47cd                	li	a5,19
    305a:	eee7d7e3          	bge	a5,a4,2f48 <createdelete+0x1c8>
    }
  }

  for(i = 0; i < N; i++){
    305e:	fe042623          	sw	zero,-20(s0)
    3062:	a085                	j	30c2 <createdelete+0x342>
    for(pi = 0; pi < NCHILD; pi++){
    3064:	fe042423          	sw	zero,-24(s0)
    3068:	a089                	j	30aa <createdelete+0x32a>
      name[0] = 'p' + i;
    306a:	fec42783          	lw	a5,-20(s0)
    306e:	0ff7f793          	zext.b	a5,a5
    3072:	0707879b          	addiw	a5,a5,112
    3076:	0ff7f793          	zext.b	a5,a5
    307a:	fcf40023          	sb	a5,-64(s0)
      name[1] = '0' + i;
    307e:	fec42783          	lw	a5,-20(s0)
    3082:	0ff7f793          	zext.b	a5,a5
    3086:	0307879b          	addiw	a5,a5,48
    308a:	0ff7f793          	zext.b	a5,a5
    308e:	fcf400a3          	sb	a5,-63(s0)
      unlink(name);
    3092:	fc040793          	addi	a5,s0,-64
    3096:	853e                	mv	a0,a5
    3098:	00005097          	auipc	ra,0x5
    309c:	868080e7          	jalr	-1944(ra) # 7900 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    30a0:	fe842783          	lw	a5,-24(s0)
    30a4:	2785                	addiw	a5,a5,1
    30a6:	fef42423          	sw	a5,-24(s0)
    30aa:	fe842783          	lw	a5,-24(s0)
    30ae:	0007871b          	sext.w	a4,a5
    30b2:	478d                	li	a5,3
    30b4:	fae7dbe3          	bge	a5,a4,306a <createdelete+0x2ea>
  for(i = 0; i < N; i++){
    30b8:	fec42783          	lw	a5,-20(s0)
    30bc:	2785                	addiw	a5,a5,1
    30be:	fef42623          	sw	a5,-20(s0)
    30c2:	fec42783          	lw	a5,-20(s0)
    30c6:	0007871b          	sext.w	a4,a5
    30ca:	47cd                	li	a5,19
    30cc:	f8e7dce3          	bge	a5,a4,3064 <createdelete+0x2e4>
    }
  }
}
    30d0:	0001                	nop
    30d2:	0001                	nop
    30d4:	60e6                	ld	ra,88(sp)
    30d6:	6446                	ld	s0,80(sp)
    30d8:	6125                	addi	sp,sp,96
    30da:	8082                	ret

00000000000030dc <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(char *s)
{
    30dc:	7179                	addi	sp,sp,-48
    30de:	f406                	sd	ra,40(sp)
    30e0:	f022                	sd	s0,32(sp)
    30e2:	1800                	addi	s0,sp,48
    30e4:	fca43c23          	sd	a0,-40(s0)
  enum { SZ = 5 };
  int fd, fd1;

  fd = open("unlinkread", O_CREATE | O_RDWR);
    30e8:	20200593          	li	a1,514
    30ec:	00006517          	auipc	a0,0x6
    30f0:	bfc50513          	addi	a0,a0,-1028 # 8ce8 <malloc+0xd1e>
    30f4:	00004097          	auipc	ra,0x4
    30f8:	7fc080e7          	jalr	2044(ra) # 78f0 <open>
    30fc:	87aa                	mv	a5,a0
    30fe:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3102:	fec42783          	lw	a5,-20(s0)
    3106:	2781                	sext.w	a5,a5
    3108:	0207d163          	bgez	a5,312a <unlinkread+0x4e>
    printf("%s: create unlinkread failed\n", s);
    310c:	fd843583          	ld	a1,-40(s0)
    3110:	00006517          	auipc	a0,0x6
    3114:	be850513          	addi	a0,a0,-1048 # 8cf8 <malloc+0xd2e>
    3118:	00005097          	auipc	ra,0x5
    311c:	cc0080e7          	jalr	-832(ra) # 7dd8 <printf>
    exit(1);
    3120:	4505                	li	a0,1
    3122:	00004097          	auipc	ra,0x4
    3126:	78e080e7          	jalr	1934(ra) # 78b0 <exit>
  }
  write(fd, "hello", SZ);
    312a:	fec42783          	lw	a5,-20(s0)
    312e:	4615                	li	a2,5
    3130:	00006597          	auipc	a1,0x6
    3134:	be858593          	addi	a1,a1,-1048 # 8d18 <malloc+0xd4e>
    3138:	853e                	mv	a0,a5
    313a:	00004097          	auipc	ra,0x4
    313e:	796080e7          	jalr	1942(ra) # 78d0 <write>
  close(fd);
    3142:	fec42783          	lw	a5,-20(s0)
    3146:	853e                	mv	a0,a5
    3148:	00004097          	auipc	ra,0x4
    314c:	790080e7          	jalr	1936(ra) # 78d8 <close>

  fd = open("unlinkread", O_RDWR);
    3150:	4589                	li	a1,2
    3152:	00006517          	auipc	a0,0x6
    3156:	b9650513          	addi	a0,a0,-1130 # 8ce8 <malloc+0xd1e>
    315a:	00004097          	auipc	ra,0x4
    315e:	796080e7          	jalr	1942(ra) # 78f0 <open>
    3162:	87aa                	mv	a5,a0
    3164:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3168:	fec42783          	lw	a5,-20(s0)
    316c:	2781                	sext.w	a5,a5
    316e:	0207d163          	bgez	a5,3190 <unlinkread+0xb4>
    printf("%s: open unlinkread failed\n", s);
    3172:	fd843583          	ld	a1,-40(s0)
    3176:	00006517          	auipc	a0,0x6
    317a:	baa50513          	addi	a0,a0,-1110 # 8d20 <malloc+0xd56>
    317e:	00005097          	auipc	ra,0x5
    3182:	c5a080e7          	jalr	-934(ra) # 7dd8 <printf>
    exit(1);
    3186:	4505                	li	a0,1
    3188:	00004097          	auipc	ra,0x4
    318c:	728080e7          	jalr	1832(ra) # 78b0 <exit>
  }
  if(unlink("unlinkread") != 0){
    3190:	00006517          	auipc	a0,0x6
    3194:	b5850513          	addi	a0,a0,-1192 # 8ce8 <malloc+0xd1e>
    3198:	00004097          	auipc	ra,0x4
    319c:	768080e7          	jalr	1896(ra) # 7900 <unlink>
    31a0:	87aa                	mv	a5,a0
    31a2:	c385                	beqz	a5,31c2 <unlinkread+0xe6>
    printf("%s: unlink unlinkread failed\n", s);
    31a4:	fd843583          	ld	a1,-40(s0)
    31a8:	00006517          	auipc	a0,0x6
    31ac:	b9850513          	addi	a0,a0,-1128 # 8d40 <malloc+0xd76>
    31b0:	00005097          	auipc	ra,0x5
    31b4:	c28080e7          	jalr	-984(ra) # 7dd8 <printf>
    exit(1);
    31b8:	4505                	li	a0,1
    31ba:	00004097          	auipc	ra,0x4
    31be:	6f6080e7          	jalr	1782(ra) # 78b0 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    31c2:	20200593          	li	a1,514
    31c6:	00006517          	auipc	a0,0x6
    31ca:	b2250513          	addi	a0,a0,-1246 # 8ce8 <malloc+0xd1e>
    31ce:	00004097          	auipc	ra,0x4
    31d2:	722080e7          	jalr	1826(ra) # 78f0 <open>
    31d6:	87aa                	mv	a5,a0
    31d8:	fef42423          	sw	a5,-24(s0)
  write(fd1, "yyy", 3);
    31dc:	fe842783          	lw	a5,-24(s0)
    31e0:	460d                	li	a2,3
    31e2:	00006597          	auipc	a1,0x6
    31e6:	b7e58593          	addi	a1,a1,-1154 # 8d60 <malloc+0xd96>
    31ea:	853e                	mv	a0,a5
    31ec:	00004097          	auipc	ra,0x4
    31f0:	6e4080e7          	jalr	1764(ra) # 78d0 <write>
  close(fd1);
    31f4:	fe842783          	lw	a5,-24(s0)
    31f8:	853e                	mv	a0,a5
    31fa:	00004097          	auipc	ra,0x4
    31fe:	6de080e7          	jalr	1758(ra) # 78d8 <close>

  if(read(fd, buf, sizeof(buf)) != SZ){
    3202:	fec42783          	lw	a5,-20(s0)
    3206:	660d                	lui	a2,0x3
    3208:	00009597          	auipc	a1,0x9
    320c:	0f858593          	addi	a1,a1,248 # c300 <buf>
    3210:	853e                	mv	a0,a5
    3212:	00004097          	auipc	ra,0x4
    3216:	6b6080e7          	jalr	1718(ra) # 78c8 <read>
    321a:	87aa                	mv	a5,a0
    321c:	873e                	mv	a4,a5
    321e:	4795                	li	a5,5
    3220:	02f70163          	beq	a4,a5,3242 <unlinkread+0x166>
    printf("%s: unlinkread read failed", s);
    3224:	fd843583          	ld	a1,-40(s0)
    3228:	00006517          	auipc	a0,0x6
    322c:	b4050513          	addi	a0,a0,-1216 # 8d68 <malloc+0xd9e>
    3230:	00005097          	auipc	ra,0x5
    3234:	ba8080e7          	jalr	-1112(ra) # 7dd8 <printf>
    exit(1);
    3238:	4505                	li	a0,1
    323a:	00004097          	auipc	ra,0x4
    323e:	676080e7          	jalr	1654(ra) # 78b0 <exit>
  }
  if(buf[0] != 'h'){
    3242:	00009797          	auipc	a5,0x9
    3246:	0be78793          	addi	a5,a5,190 # c300 <buf>
    324a:	0007c783          	lbu	a5,0(a5)
    324e:	873e                	mv	a4,a5
    3250:	06800793          	li	a5,104
    3254:	02f70163          	beq	a4,a5,3276 <unlinkread+0x19a>
    printf("%s: unlinkread wrong data\n", s);
    3258:	fd843583          	ld	a1,-40(s0)
    325c:	00006517          	auipc	a0,0x6
    3260:	b2c50513          	addi	a0,a0,-1236 # 8d88 <malloc+0xdbe>
    3264:	00005097          	auipc	ra,0x5
    3268:	b74080e7          	jalr	-1164(ra) # 7dd8 <printf>
    exit(1);
    326c:	4505                	li	a0,1
    326e:	00004097          	auipc	ra,0x4
    3272:	642080e7          	jalr	1602(ra) # 78b0 <exit>
  }
  if(write(fd, buf, 10) != 10){
    3276:	fec42783          	lw	a5,-20(s0)
    327a:	4629                	li	a2,10
    327c:	00009597          	auipc	a1,0x9
    3280:	08458593          	addi	a1,a1,132 # c300 <buf>
    3284:	853e                	mv	a0,a5
    3286:	00004097          	auipc	ra,0x4
    328a:	64a080e7          	jalr	1610(ra) # 78d0 <write>
    328e:	87aa                	mv	a5,a0
    3290:	873e                	mv	a4,a5
    3292:	47a9                	li	a5,10
    3294:	02f70163          	beq	a4,a5,32b6 <unlinkread+0x1da>
    printf("%s: unlinkread write failed\n", s);
    3298:	fd843583          	ld	a1,-40(s0)
    329c:	00006517          	auipc	a0,0x6
    32a0:	b0c50513          	addi	a0,a0,-1268 # 8da8 <malloc+0xdde>
    32a4:	00005097          	auipc	ra,0x5
    32a8:	b34080e7          	jalr	-1228(ra) # 7dd8 <printf>
    exit(1);
    32ac:	4505                	li	a0,1
    32ae:	00004097          	auipc	ra,0x4
    32b2:	602080e7          	jalr	1538(ra) # 78b0 <exit>
  }
  close(fd);
    32b6:	fec42783          	lw	a5,-20(s0)
    32ba:	853e                	mv	a0,a5
    32bc:	00004097          	auipc	ra,0x4
    32c0:	61c080e7          	jalr	1564(ra) # 78d8 <close>
  unlink("unlinkread");
    32c4:	00006517          	auipc	a0,0x6
    32c8:	a2450513          	addi	a0,a0,-1500 # 8ce8 <malloc+0xd1e>
    32cc:	00004097          	auipc	ra,0x4
    32d0:	634080e7          	jalr	1588(ra) # 7900 <unlink>
}
    32d4:	0001                	nop
    32d6:	70a2                	ld	ra,40(sp)
    32d8:	7402                	ld	s0,32(sp)
    32da:	6145                	addi	sp,sp,48
    32dc:	8082                	ret

00000000000032de <linktest>:

void
linktest(char *s)
{
    32de:	7179                	addi	sp,sp,-48
    32e0:	f406                	sd	ra,40(sp)
    32e2:	f022                	sd	s0,32(sp)
    32e4:	1800                	addi	s0,sp,48
    32e6:	fca43c23          	sd	a0,-40(s0)
  enum { SZ = 5 };
  int fd;

  unlink("lf1");
    32ea:	00006517          	auipc	a0,0x6
    32ee:	ade50513          	addi	a0,a0,-1314 # 8dc8 <malloc+0xdfe>
    32f2:	00004097          	auipc	ra,0x4
    32f6:	60e080e7          	jalr	1550(ra) # 7900 <unlink>
  unlink("lf2");
    32fa:	00006517          	auipc	a0,0x6
    32fe:	ad650513          	addi	a0,a0,-1322 # 8dd0 <malloc+0xe06>
    3302:	00004097          	auipc	ra,0x4
    3306:	5fe080e7          	jalr	1534(ra) # 7900 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    330a:	20200593          	li	a1,514
    330e:	00006517          	auipc	a0,0x6
    3312:	aba50513          	addi	a0,a0,-1350 # 8dc8 <malloc+0xdfe>
    3316:	00004097          	auipc	ra,0x4
    331a:	5da080e7          	jalr	1498(ra) # 78f0 <open>
    331e:	87aa                	mv	a5,a0
    3320:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3324:	fec42783          	lw	a5,-20(s0)
    3328:	2781                	sext.w	a5,a5
    332a:	0207d163          	bgez	a5,334c <linktest+0x6e>
    printf("%s: create lf1 failed\n", s);
    332e:	fd843583          	ld	a1,-40(s0)
    3332:	00006517          	auipc	a0,0x6
    3336:	aa650513          	addi	a0,a0,-1370 # 8dd8 <malloc+0xe0e>
    333a:	00005097          	auipc	ra,0x5
    333e:	a9e080e7          	jalr	-1378(ra) # 7dd8 <printf>
    exit(1);
    3342:	4505                	li	a0,1
    3344:	00004097          	auipc	ra,0x4
    3348:	56c080e7          	jalr	1388(ra) # 78b0 <exit>
  }
  if(write(fd, "hello", SZ) != SZ){
    334c:	fec42783          	lw	a5,-20(s0)
    3350:	4615                	li	a2,5
    3352:	00006597          	auipc	a1,0x6
    3356:	9c658593          	addi	a1,a1,-1594 # 8d18 <malloc+0xd4e>
    335a:	853e                	mv	a0,a5
    335c:	00004097          	auipc	ra,0x4
    3360:	574080e7          	jalr	1396(ra) # 78d0 <write>
    3364:	87aa                	mv	a5,a0
    3366:	873e                	mv	a4,a5
    3368:	4795                	li	a5,5
    336a:	02f70163          	beq	a4,a5,338c <linktest+0xae>
    printf("%s: write lf1 failed\n", s);
    336e:	fd843583          	ld	a1,-40(s0)
    3372:	00006517          	auipc	a0,0x6
    3376:	a7e50513          	addi	a0,a0,-1410 # 8df0 <malloc+0xe26>
    337a:	00005097          	auipc	ra,0x5
    337e:	a5e080e7          	jalr	-1442(ra) # 7dd8 <printf>
    exit(1);
    3382:	4505                	li	a0,1
    3384:	00004097          	auipc	ra,0x4
    3388:	52c080e7          	jalr	1324(ra) # 78b0 <exit>
  }
  close(fd);
    338c:	fec42783          	lw	a5,-20(s0)
    3390:	853e                	mv	a0,a5
    3392:	00004097          	auipc	ra,0x4
    3396:	546080e7          	jalr	1350(ra) # 78d8 <close>

  if(link("lf1", "lf2") < 0){
    339a:	00006597          	auipc	a1,0x6
    339e:	a3658593          	addi	a1,a1,-1482 # 8dd0 <malloc+0xe06>
    33a2:	00006517          	auipc	a0,0x6
    33a6:	a2650513          	addi	a0,a0,-1498 # 8dc8 <malloc+0xdfe>
    33aa:	00004097          	auipc	ra,0x4
    33ae:	566080e7          	jalr	1382(ra) # 7910 <link>
    33b2:	87aa                	mv	a5,a0
    33b4:	0207d163          	bgez	a5,33d6 <linktest+0xf8>
    printf("%s: link lf1 lf2 failed\n", s);
    33b8:	fd843583          	ld	a1,-40(s0)
    33bc:	00006517          	auipc	a0,0x6
    33c0:	a4c50513          	addi	a0,a0,-1460 # 8e08 <malloc+0xe3e>
    33c4:	00005097          	auipc	ra,0x5
    33c8:	a14080e7          	jalr	-1516(ra) # 7dd8 <printf>
    exit(1);
    33cc:	4505                	li	a0,1
    33ce:	00004097          	auipc	ra,0x4
    33d2:	4e2080e7          	jalr	1250(ra) # 78b0 <exit>
  }
  unlink("lf1");
    33d6:	00006517          	auipc	a0,0x6
    33da:	9f250513          	addi	a0,a0,-1550 # 8dc8 <malloc+0xdfe>
    33de:	00004097          	auipc	ra,0x4
    33e2:	522080e7          	jalr	1314(ra) # 7900 <unlink>

  if(open("lf1", 0) >= 0){
    33e6:	4581                	li	a1,0
    33e8:	00006517          	auipc	a0,0x6
    33ec:	9e050513          	addi	a0,a0,-1568 # 8dc8 <malloc+0xdfe>
    33f0:	00004097          	auipc	ra,0x4
    33f4:	500080e7          	jalr	1280(ra) # 78f0 <open>
    33f8:	87aa                	mv	a5,a0
    33fa:	0207c163          	bltz	a5,341c <linktest+0x13e>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    33fe:	fd843583          	ld	a1,-40(s0)
    3402:	00006517          	auipc	a0,0x6
    3406:	a2650513          	addi	a0,a0,-1498 # 8e28 <malloc+0xe5e>
    340a:	00005097          	auipc	ra,0x5
    340e:	9ce080e7          	jalr	-1586(ra) # 7dd8 <printf>
    exit(1);
    3412:	4505                	li	a0,1
    3414:	00004097          	auipc	ra,0x4
    3418:	49c080e7          	jalr	1180(ra) # 78b0 <exit>
  }

  fd = open("lf2", 0);
    341c:	4581                	li	a1,0
    341e:	00006517          	auipc	a0,0x6
    3422:	9b250513          	addi	a0,a0,-1614 # 8dd0 <malloc+0xe06>
    3426:	00004097          	auipc	ra,0x4
    342a:	4ca080e7          	jalr	1226(ra) # 78f0 <open>
    342e:	87aa                	mv	a5,a0
    3430:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3434:	fec42783          	lw	a5,-20(s0)
    3438:	2781                	sext.w	a5,a5
    343a:	0207d163          	bgez	a5,345c <linktest+0x17e>
    printf("%s: open lf2 failed\n", s);
    343e:	fd843583          	ld	a1,-40(s0)
    3442:	00006517          	auipc	a0,0x6
    3446:	a1650513          	addi	a0,a0,-1514 # 8e58 <malloc+0xe8e>
    344a:	00005097          	auipc	ra,0x5
    344e:	98e080e7          	jalr	-1650(ra) # 7dd8 <printf>
    exit(1);
    3452:	4505                	li	a0,1
    3454:	00004097          	auipc	ra,0x4
    3458:	45c080e7          	jalr	1116(ra) # 78b0 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != SZ){
    345c:	fec42783          	lw	a5,-20(s0)
    3460:	660d                	lui	a2,0x3
    3462:	00009597          	auipc	a1,0x9
    3466:	e9e58593          	addi	a1,a1,-354 # c300 <buf>
    346a:	853e                	mv	a0,a5
    346c:	00004097          	auipc	ra,0x4
    3470:	45c080e7          	jalr	1116(ra) # 78c8 <read>
    3474:	87aa                	mv	a5,a0
    3476:	873e                	mv	a4,a5
    3478:	4795                	li	a5,5
    347a:	02f70163          	beq	a4,a5,349c <linktest+0x1be>
    printf("%s: read lf2 failed\n", s);
    347e:	fd843583          	ld	a1,-40(s0)
    3482:	00006517          	auipc	a0,0x6
    3486:	9ee50513          	addi	a0,a0,-1554 # 8e70 <malloc+0xea6>
    348a:	00005097          	auipc	ra,0x5
    348e:	94e080e7          	jalr	-1714(ra) # 7dd8 <printf>
    exit(1);
    3492:	4505                	li	a0,1
    3494:	00004097          	auipc	ra,0x4
    3498:	41c080e7          	jalr	1052(ra) # 78b0 <exit>
  }
  close(fd);
    349c:	fec42783          	lw	a5,-20(s0)
    34a0:	853e                	mv	a0,a5
    34a2:	00004097          	auipc	ra,0x4
    34a6:	436080e7          	jalr	1078(ra) # 78d8 <close>

  if(link("lf2", "lf2") >= 0){
    34aa:	00006597          	auipc	a1,0x6
    34ae:	92658593          	addi	a1,a1,-1754 # 8dd0 <malloc+0xe06>
    34b2:	00006517          	auipc	a0,0x6
    34b6:	91e50513          	addi	a0,a0,-1762 # 8dd0 <malloc+0xe06>
    34ba:	00004097          	auipc	ra,0x4
    34be:	456080e7          	jalr	1110(ra) # 7910 <link>
    34c2:	87aa                	mv	a5,a0
    34c4:	0207c163          	bltz	a5,34e6 <linktest+0x208>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    34c8:	fd843583          	ld	a1,-40(s0)
    34cc:	00006517          	auipc	a0,0x6
    34d0:	9bc50513          	addi	a0,a0,-1604 # 8e88 <malloc+0xebe>
    34d4:	00005097          	auipc	ra,0x5
    34d8:	904080e7          	jalr	-1788(ra) # 7dd8 <printf>
    exit(1);
    34dc:	4505                	li	a0,1
    34de:	00004097          	auipc	ra,0x4
    34e2:	3d2080e7          	jalr	978(ra) # 78b0 <exit>
  }

  unlink("lf2");
    34e6:	00006517          	auipc	a0,0x6
    34ea:	8ea50513          	addi	a0,a0,-1814 # 8dd0 <malloc+0xe06>
    34ee:	00004097          	auipc	ra,0x4
    34f2:	412080e7          	jalr	1042(ra) # 7900 <unlink>
  if(link("lf2", "lf1") >= 0){
    34f6:	00006597          	auipc	a1,0x6
    34fa:	8d258593          	addi	a1,a1,-1838 # 8dc8 <malloc+0xdfe>
    34fe:	00006517          	auipc	a0,0x6
    3502:	8d250513          	addi	a0,a0,-1838 # 8dd0 <malloc+0xe06>
    3506:	00004097          	auipc	ra,0x4
    350a:	40a080e7          	jalr	1034(ra) # 7910 <link>
    350e:	87aa                	mv	a5,a0
    3510:	0207c163          	bltz	a5,3532 <linktest+0x254>
    printf("%s: link non-existent succeeded! oops\n", s);
    3514:	fd843583          	ld	a1,-40(s0)
    3518:	00006517          	auipc	a0,0x6
    351c:	99850513          	addi	a0,a0,-1640 # 8eb0 <malloc+0xee6>
    3520:	00005097          	auipc	ra,0x5
    3524:	8b8080e7          	jalr	-1864(ra) # 7dd8 <printf>
    exit(1);
    3528:	4505                	li	a0,1
    352a:	00004097          	auipc	ra,0x4
    352e:	386080e7          	jalr	902(ra) # 78b0 <exit>
  }

  if(link(".", "lf1") >= 0){
    3532:	00006597          	auipc	a1,0x6
    3536:	89658593          	addi	a1,a1,-1898 # 8dc8 <malloc+0xdfe>
    353a:	00006517          	auipc	a0,0x6
    353e:	99e50513          	addi	a0,a0,-1634 # 8ed8 <malloc+0xf0e>
    3542:	00004097          	auipc	ra,0x4
    3546:	3ce080e7          	jalr	974(ra) # 7910 <link>
    354a:	87aa                	mv	a5,a0
    354c:	0207c163          	bltz	a5,356e <linktest+0x290>
    printf("%s: link . lf1 succeeded! oops\n", s);
    3550:	fd843583          	ld	a1,-40(s0)
    3554:	00006517          	auipc	a0,0x6
    3558:	98c50513          	addi	a0,a0,-1652 # 8ee0 <malloc+0xf16>
    355c:	00005097          	auipc	ra,0x5
    3560:	87c080e7          	jalr	-1924(ra) # 7dd8 <printf>
    exit(1);
    3564:	4505                	li	a0,1
    3566:	00004097          	auipc	ra,0x4
    356a:	34a080e7          	jalr	842(ra) # 78b0 <exit>
  }
}
    356e:	0001                	nop
    3570:	70a2                	ld	ra,40(sp)
    3572:	7402                	ld	s0,32(sp)
    3574:	6145                	addi	sp,sp,48
    3576:	8082                	ret

0000000000003578 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(char *s)
{
    3578:	7119                	addi	sp,sp,-128
    357a:	fc86                	sd	ra,120(sp)
    357c:	f8a2                	sd	s0,112(sp)
    357e:	0100                	addi	s0,sp,128
    3580:	f8a43423          	sd	a0,-120(s0)
  struct {
    ushort inum;
    char name[DIRSIZ];
  } de;

  file[0] = 'C';
    3584:	04300793          	li	a5,67
    3588:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
    358c:	fc040d23          	sb	zero,-38(s0)
  for(i = 0; i < N; i++){
    3590:	fe042623          	sw	zero,-20(s0)
    3594:	a225                	j	36bc <concreate+0x144>
    file[1] = '0' + i;
    3596:	fec42783          	lw	a5,-20(s0)
    359a:	0ff7f793          	zext.b	a5,a5
    359e:	0307879b          	addiw	a5,a5,48
    35a2:	0ff7f793          	zext.b	a5,a5
    35a6:	fcf40ca3          	sb	a5,-39(s0)
    unlink(file);
    35aa:	fd840793          	addi	a5,s0,-40
    35ae:	853e                	mv	a0,a5
    35b0:	00004097          	auipc	ra,0x4
    35b4:	350080e7          	jalr	848(ra) # 7900 <unlink>
    pid = fork();
    35b8:	00004097          	auipc	ra,0x4
    35bc:	2f0080e7          	jalr	752(ra) # 78a8 <fork>
    35c0:	87aa                	mv	a5,a0
    35c2:	fef42023          	sw	a5,-32(s0)
    if(pid && (i % 3) == 1){
    35c6:	fe042783          	lw	a5,-32(s0)
    35ca:	2781                	sext.w	a5,a5
    35cc:	cb85                	beqz	a5,35fc <concreate+0x84>
    35ce:	fec42783          	lw	a5,-20(s0)
    35d2:	873e                	mv	a4,a5
    35d4:	478d                	li	a5,3
    35d6:	02f767bb          	remw	a5,a4,a5
    35da:	2781                	sext.w	a5,a5
    35dc:	873e                	mv	a4,a5
    35de:	4785                	li	a5,1
    35e0:	00f71e63          	bne	a4,a5,35fc <concreate+0x84>
      link("C0", file);
    35e4:	fd840793          	addi	a5,s0,-40
    35e8:	85be                	mv	a1,a5
    35ea:	00006517          	auipc	a0,0x6
    35ee:	91650513          	addi	a0,a0,-1770 # 8f00 <malloc+0xf36>
    35f2:	00004097          	auipc	ra,0x4
    35f6:	31e080e7          	jalr	798(ra) # 7910 <link>
    35fa:	a061                	j	3682 <concreate+0x10a>
    } else if(pid == 0 && (i % 5) == 1){
    35fc:	fe042783          	lw	a5,-32(s0)
    3600:	2781                	sext.w	a5,a5
    3602:	eb85                	bnez	a5,3632 <concreate+0xba>
    3604:	fec42783          	lw	a5,-20(s0)
    3608:	873e                	mv	a4,a5
    360a:	4795                	li	a5,5
    360c:	02f767bb          	remw	a5,a4,a5
    3610:	2781                	sext.w	a5,a5
    3612:	873e                	mv	a4,a5
    3614:	4785                	li	a5,1
    3616:	00f71e63          	bne	a4,a5,3632 <concreate+0xba>
      link("C0", file);
    361a:	fd840793          	addi	a5,s0,-40
    361e:	85be                	mv	a1,a5
    3620:	00006517          	auipc	a0,0x6
    3624:	8e050513          	addi	a0,a0,-1824 # 8f00 <malloc+0xf36>
    3628:	00004097          	auipc	ra,0x4
    362c:	2e8080e7          	jalr	744(ra) # 7910 <link>
    3630:	a889                	j	3682 <concreate+0x10a>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    3632:	fd840793          	addi	a5,s0,-40
    3636:	20200593          	li	a1,514
    363a:	853e                	mv	a0,a5
    363c:	00004097          	auipc	ra,0x4
    3640:	2b4080e7          	jalr	692(ra) # 78f0 <open>
    3644:	87aa                	mv	a5,a0
    3646:	fef42223          	sw	a5,-28(s0)
      if(fd < 0){
    364a:	fe442783          	lw	a5,-28(s0)
    364e:	2781                	sext.w	a5,a5
    3650:	0207d263          	bgez	a5,3674 <concreate+0xfc>
        printf("concreate create %s failed\n", file);
    3654:	fd840793          	addi	a5,s0,-40
    3658:	85be                	mv	a1,a5
    365a:	00006517          	auipc	a0,0x6
    365e:	8ae50513          	addi	a0,a0,-1874 # 8f08 <malloc+0xf3e>
    3662:	00004097          	auipc	ra,0x4
    3666:	776080e7          	jalr	1910(ra) # 7dd8 <printf>
        exit(1);
    366a:	4505                	li	a0,1
    366c:	00004097          	auipc	ra,0x4
    3670:	244080e7          	jalr	580(ra) # 78b0 <exit>
      }
      close(fd);
    3674:	fe442783          	lw	a5,-28(s0)
    3678:	853e                	mv	a0,a5
    367a:	00004097          	auipc	ra,0x4
    367e:	25e080e7          	jalr	606(ra) # 78d8 <close>
    }
    if(pid == 0) {
    3682:	fe042783          	lw	a5,-32(s0)
    3686:	2781                	sext.w	a5,a5
    3688:	e791                	bnez	a5,3694 <concreate+0x11c>
      exit(0);
    368a:	4501                	li	a0,0
    368c:	00004097          	auipc	ra,0x4
    3690:	224080e7          	jalr	548(ra) # 78b0 <exit>
    } else {
      int xstatus;
      wait(&xstatus);
    3694:	f9c40793          	addi	a5,s0,-100
    3698:	853e                	mv	a0,a5
    369a:	00004097          	auipc	ra,0x4
    369e:	21e080e7          	jalr	542(ra) # 78b8 <wait>
      if(xstatus != 0)
    36a2:	f9c42783          	lw	a5,-100(s0)
    36a6:	c791                	beqz	a5,36b2 <concreate+0x13a>
        exit(1);
    36a8:	4505                	li	a0,1
    36aa:	00004097          	auipc	ra,0x4
    36ae:	206080e7          	jalr	518(ra) # 78b0 <exit>
  for(i = 0; i < N; i++){
    36b2:	fec42783          	lw	a5,-20(s0)
    36b6:	2785                	addiw	a5,a5,1
    36b8:	fef42623          	sw	a5,-20(s0)
    36bc:	fec42783          	lw	a5,-20(s0)
    36c0:	0007871b          	sext.w	a4,a5
    36c4:	02700793          	li	a5,39
    36c8:	ece7d7e3          	bge	a5,a4,3596 <concreate+0x1e>
    }
  }

  memset(fa, 0, sizeof(fa));
    36cc:	fb040793          	addi	a5,s0,-80
    36d0:	02800613          	li	a2,40
    36d4:	4581                	li	a1,0
    36d6:	853e                	mv	a0,a5
    36d8:	00004097          	auipc	ra,0x4
    36dc:	e2c080e7          	jalr	-468(ra) # 7504 <memset>
  fd = open(".", 0);
    36e0:	4581                	li	a1,0
    36e2:	00005517          	auipc	a0,0x5
    36e6:	7f650513          	addi	a0,a0,2038 # 8ed8 <malloc+0xf0e>
    36ea:	00004097          	auipc	ra,0x4
    36ee:	206080e7          	jalr	518(ra) # 78f0 <open>
    36f2:	87aa                	mv	a5,a0
    36f4:	fef42223          	sw	a5,-28(s0)
  n = 0;
    36f8:	fe042423          	sw	zero,-24(s0)
  while(read(fd, &de, sizeof(de)) > 0){
    36fc:	a865                	j	37b4 <concreate+0x23c>
    if(de.inum == 0)
    36fe:	fa045783          	lhu	a5,-96(s0)
    3702:	cbc5                	beqz	a5,37b2 <concreate+0x23a>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3704:	fa244783          	lbu	a5,-94(s0)
    3708:	873e                	mv	a4,a5
    370a:	04300793          	li	a5,67
    370e:	0af71363          	bne	a4,a5,37b4 <concreate+0x23c>
    3712:	fa444783          	lbu	a5,-92(s0)
    3716:	efd9                	bnez	a5,37b4 <concreate+0x23c>
      i = de.name[1] - '0';
    3718:	fa344783          	lbu	a5,-93(s0)
    371c:	2781                	sext.w	a5,a5
    371e:	fd07879b          	addiw	a5,a5,-48
    3722:	fef42623          	sw	a5,-20(s0)
      if(i < 0 || i >= sizeof(fa)){
    3726:	fec42783          	lw	a5,-20(s0)
    372a:	2781                	sext.w	a5,a5
    372c:	0007c963          	bltz	a5,373e <concreate+0x1c6>
    3730:	fec42783          	lw	a5,-20(s0)
    3734:	873e                	mv	a4,a5
    3736:	02700793          	li	a5,39
    373a:	02e7f563          	bgeu	a5,a4,3764 <concreate+0x1ec>
        printf("%s: concreate weird file %s\n", s, de.name);
    373e:	fa040793          	addi	a5,s0,-96
    3742:	0789                	addi	a5,a5,2
    3744:	863e                	mv	a2,a5
    3746:	f8843583          	ld	a1,-120(s0)
    374a:	00005517          	auipc	a0,0x5
    374e:	7de50513          	addi	a0,a0,2014 # 8f28 <malloc+0xf5e>
    3752:	00004097          	auipc	ra,0x4
    3756:	686080e7          	jalr	1670(ra) # 7dd8 <printf>
        exit(1);
    375a:	4505                	li	a0,1
    375c:	00004097          	auipc	ra,0x4
    3760:	154080e7          	jalr	340(ra) # 78b0 <exit>
      }
      if(fa[i]){
    3764:	fec42783          	lw	a5,-20(s0)
    3768:	17c1                	addi	a5,a5,-16
    376a:	97a2                	add	a5,a5,s0
    376c:	fc07c783          	lbu	a5,-64(a5)
    3770:	c785                	beqz	a5,3798 <concreate+0x220>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3772:	fa040793          	addi	a5,s0,-96
    3776:	0789                	addi	a5,a5,2
    3778:	863e                	mv	a2,a5
    377a:	f8843583          	ld	a1,-120(s0)
    377e:	00005517          	auipc	a0,0x5
    3782:	7ca50513          	addi	a0,a0,1994 # 8f48 <malloc+0xf7e>
    3786:	00004097          	auipc	ra,0x4
    378a:	652080e7          	jalr	1618(ra) # 7dd8 <printf>
        exit(1);
    378e:	4505                	li	a0,1
    3790:	00004097          	auipc	ra,0x4
    3794:	120080e7          	jalr	288(ra) # 78b0 <exit>
      }
      fa[i] = 1;
    3798:	fec42783          	lw	a5,-20(s0)
    379c:	17c1                	addi	a5,a5,-16
    379e:	97a2                	add	a5,a5,s0
    37a0:	4705                	li	a4,1
    37a2:	fce78023          	sb	a4,-64(a5)
      n++;
    37a6:	fe842783          	lw	a5,-24(s0)
    37aa:	2785                	addiw	a5,a5,1
    37ac:	fef42423          	sw	a5,-24(s0)
    37b0:	a011                	j	37b4 <concreate+0x23c>
      continue;
    37b2:	0001                	nop
  while(read(fd, &de, sizeof(de)) > 0){
    37b4:	fa040713          	addi	a4,s0,-96
    37b8:	fe442783          	lw	a5,-28(s0)
    37bc:	4641                	li	a2,16
    37be:	85ba                	mv	a1,a4
    37c0:	853e                	mv	a0,a5
    37c2:	00004097          	auipc	ra,0x4
    37c6:	106080e7          	jalr	262(ra) # 78c8 <read>
    37ca:	87aa                	mv	a5,a0
    37cc:	f2f049e3          	bgtz	a5,36fe <concreate+0x186>
    }
  }
  close(fd);
    37d0:	fe442783          	lw	a5,-28(s0)
    37d4:	853e                	mv	a0,a5
    37d6:	00004097          	auipc	ra,0x4
    37da:	102080e7          	jalr	258(ra) # 78d8 <close>

  if(n != N){
    37de:	fe842783          	lw	a5,-24(s0)
    37e2:	0007871b          	sext.w	a4,a5
    37e6:	02800793          	li	a5,40
    37ea:	02f70163          	beq	a4,a5,380c <concreate+0x294>
    printf("%s: concreate not enough files in directory listing\n", s);
    37ee:	f8843583          	ld	a1,-120(s0)
    37f2:	00005517          	auipc	a0,0x5
    37f6:	77e50513          	addi	a0,a0,1918 # 8f70 <malloc+0xfa6>
    37fa:	00004097          	auipc	ra,0x4
    37fe:	5de080e7          	jalr	1502(ra) # 7dd8 <printf>
    exit(1);
    3802:	4505                	li	a0,1
    3804:	00004097          	auipc	ra,0x4
    3808:	0ac080e7          	jalr	172(ra) # 78b0 <exit>
  }

  for(i = 0; i < N; i++){
    380c:	fe042623          	sw	zero,-20(s0)
    3810:	a25d                	j	39b6 <concreate+0x43e>
    file[1] = '0' + i;
    3812:	fec42783          	lw	a5,-20(s0)
    3816:	0ff7f793          	zext.b	a5,a5
    381a:	0307879b          	addiw	a5,a5,48
    381e:	0ff7f793          	zext.b	a5,a5
    3822:	fcf40ca3          	sb	a5,-39(s0)
    pid = fork();
    3826:	00004097          	auipc	ra,0x4
    382a:	082080e7          	jalr	130(ra) # 78a8 <fork>
    382e:	87aa                	mv	a5,a0
    3830:	fef42023          	sw	a5,-32(s0)
    if(pid < 0){
    3834:	fe042783          	lw	a5,-32(s0)
    3838:	2781                	sext.w	a5,a5
    383a:	0207d163          	bgez	a5,385c <concreate+0x2e4>
      printf("%s: fork failed\n", s);
    383e:	f8843583          	ld	a1,-120(s0)
    3842:	00005517          	auipc	a0,0x5
    3846:	d0e50513          	addi	a0,a0,-754 # 8550 <malloc+0x586>
    384a:	00004097          	auipc	ra,0x4
    384e:	58e080e7          	jalr	1422(ra) # 7dd8 <printf>
      exit(1);
    3852:	4505                	li	a0,1
    3854:	00004097          	auipc	ra,0x4
    3858:	05c080e7          	jalr	92(ra) # 78b0 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    385c:	fec42783          	lw	a5,-20(s0)
    3860:	873e                	mv	a4,a5
    3862:	478d                	li	a5,3
    3864:	02f767bb          	remw	a5,a4,a5
    3868:	2781                	sext.w	a5,a5
    386a:	e789                	bnez	a5,3874 <concreate+0x2fc>
    386c:	fe042783          	lw	a5,-32(s0)
    3870:	2781                	sext.w	a5,a5
    3872:	c385                	beqz	a5,3892 <concreate+0x31a>
       ((i % 3) == 1 && pid != 0)){
    3874:	fec42783          	lw	a5,-20(s0)
    3878:	873e                	mv	a4,a5
    387a:	478d                	li	a5,3
    387c:	02f767bb          	remw	a5,a4,a5
    3880:	2781                	sext.w	a5,a5
    if(((i % 3) == 0 && pid == 0) ||
    3882:	873e                	mv	a4,a5
    3884:	4785                	li	a5,1
    3886:	0af71b63          	bne	a4,a5,393c <concreate+0x3c4>
       ((i % 3) == 1 && pid != 0)){
    388a:	fe042783          	lw	a5,-32(s0)
    388e:	2781                	sext.w	a5,a5
    3890:	c7d5                	beqz	a5,393c <concreate+0x3c4>
      close(open(file, 0));
    3892:	fd840793          	addi	a5,s0,-40
    3896:	4581                	li	a1,0
    3898:	853e                	mv	a0,a5
    389a:	00004097          	auipc	ra,0x4
    389e:	056080e7          	jalr	86(ra) # 78f0 <open>
    38a2:	87aa                	mv	a5,a0
    38a4:	853e                	mv	a0,a5
    38a6:	00004097          	auipc	ra,0x4
    38aa:	032080e7          	jalr	50(ra) # 78d8 <close>
      close(open(file, 0));
    38ae:	fd840793          	addi	a5,s0,-40
    38b2:	4581                	li	a1,0
    38b4:	853e                	mv	a0,a5
    38b6:	00004097          	auipc	ra,0x4
    38ba:	03a080e7          	jalr	58(ra) # 78f0 <open>
    38be:	87aa                	mv	a5,a0
    38c0:	853e                	mv	a0,a5
    38c2:	00004097          	auipc	ra,0x4
    38c6:	016080e7          	jalr	22(ra) # 78d8 <close>
      close(open(file, 0));
    38ca:	fd840793          	addi	a5,s0,-40
    38ce:	4581                	li	a1,0
    38d0:	853e                	mv	a0,a5
    38d2:	00004097          	auipc	ra,0x4
    38d6:	01e080e7          	jalr	30(ra) # 78f0 <open>
    38da:	87aa                	mv	a5,a0
    38dc:	853e                	mv	a0,a5
    38de:	00004097          	auipc	ra,0x4
    38e2:	ffa080e7          	jalr	-6(ra) # 78d8 <close>
      close(open(file, 0));
    38e6:	fd840793          	addi	a5,s0,-40
    38ea:	4581                	li	a1,0
    38ec:	853e                	mv	a0,a5
    38ee:	00004097          	auipc	ra,0x4
    38f2:	002080e7          	jalr	2(ra) # 78f0 <open>
    38f6:	87aa                	mv	a5,a0
    38f8:	853e                	mv	a0,a5
    38fa:	00004097          	auipc	ra,0x4
    38fe:	fde080e7          	jalr	-34(ra) # 78d8 <close>
      close(open(file, 0));
    3902:	fd840793          	addi	a5,s0,-40
    3906:	4581                	li	a1,0
    3908:	853e                	mv	a0,a5
    390a:	00004097          	auipc	ra,0x4
    390e:	fe6080e7          	jalr	-26(ra) # 78f0 <open>
    3912:	87aa                	mv	a5,a0
    3914:	853e                	mv	a0,a5
    3916:	00004097          	auipc	ra,0x4
    391a:	fc2080e7          	jalr	-62(ra) # 78d8 <close>
      close(open(file, 0));
    391e:	fd840793          	addi	a5,s0,-40
    3922:	4581                	li	a1,0
    3924:	853e                	mv	a0,a5
    3926:	00004097          	auipc	ra,0x4
    392a:	fca080e7          	jalr	-54(ra) # 78f0 <open>
    392e:	87aa                	mv	a5,a0
    3930:	853e                	mv	a0,a5
    3932:	00004097          	auipc	ra,0x4
    3936:	fa6080e7          	jalr	-90(ra) # 78d8 <close>
    393a:	a899                	j	3990 <concreate+0x418>
    } else {
      unlink(file);
    393c:	fd840793          	addi	a5,s0,-40
    3940:	853e                	mv	a0,a5
    3942:	00004097          	auipc	ra,0x4
    3946:	fbe080e7          	jalr	-66(ra) # 7900 <unlink>
      unlink(file);
    394a:	fd840793          	addi	a5,s0,-40
    394e:	853e                	mv	a0,a5
    3950:	00004097          	auipc	ra,0x4
    3954:	fb0080e7          	jalr	-80(ra) # 7900 <unlink>
      unlink(file);
    3958:	fd840793          	addi	a5,s0,-40
    395c:	853e                	mv	a0,a5
    395e:	00004097          	auipc	ra,0x4
    3962:	fa2080e7          	jalr	-94(ra) # 7900 <unlink>
      unlink(file);
    3966:	fd840793          	addi	a5,s0,-40
    396a:	853e                	mv	a0,a5
    396c:	00004097          	auipc	ra,0x4
    3970:	f94080e7          	jalr	-108(ra) # 7900 <unlink>
      unlink(file);
    3974:	fd840793          	addi	a5,s0,-40
    3978:	853e                	mv	a0,a5
    397a:	00004097          	auipc	ra,0x4
    397e:	f86080e7          	jalr	-122(ra) # 7900 <unlink>
      unlink(file);
    3982:	fd840793          	addi	a5,s0,-40
    3986:	853e                	mv	a0,a5
    3988:	00004097          	auipc	ra,0x4
    398c:	f78080e7          	jalr	-136(ra) # 7900 <unlink>
    }
    if(pid == 0)
    3990:	fe042783          	lw	a5,-32(s0)
    3994:	2781                	sext.w	a5,a5
    3996:	e791                	bnez	a5,39a2 <concreate+0x42a>
      exit(0);
    3998:	4501                	li	a0,0
    399a:	00004097          	auipc	ra,0x4
    399e:	f16080e7          	jalr	-234(ra) # 78b0 <exit>
    else
      wait(0);
    39a2:	4501                	li	a0,0
    39a4:	00004097          	auipc	ra,0x4
    39a8:	f14080e7          	jalr	-236(ra) # 78b8 <wait>
  for(i = 0; i < N; i++){
    39ac:	fec42783          	lw	a5,-20(s0)
    39b0:	2785                	addiw	a5,a5,1
    39b2:	fef42623          	sw	a5,-20(s0)
    39b6:	fec42783          	lw	a5,-20(s0)
    39ba:	0007871b          	sext.w	a4,a5
    39be:	02700793          	li	a5,39
    39c2:	e4e7d8e3          	bge	a5,a4,3812 <concreate+0x29a>
  }
}
    39c6:	0001                	nop
    39c8:	0001                	nop
    39ca:	70e6                	ld	ra,120(sp)
    39cc:	7446                	ld	s0,112(sp)
    39ce:	6109                	addi	sp,sp,128
    39d0:	8082                	ret

00000000000039d2 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink(char *s)
{
    39d2:	7179                	addi	sp,sp,-48
    39d4:	f406                	sd	ra,40(sp)
    39d6:	f022                	sd	s0,32(sp)
    39d8:	1800                	addi	s0,sp,48
    39da:	fca43c23          	sd	a0,-40(s0)
  int pid, i;

  unlink("x");
    39de:	00005517          	auipc	a0,0x5
    39e2:	84250513          	addi	a0,a0,-1982 # 8220 <malloc+0x256>
    39e6:	00004097          	auipc	ra,0x4
    39ea:	f1a080e7          	jalr	-230(ra) # 7900 <unlink>
  pid = fork();
    39ee:	00004097          	auipc	ra,0x4
    39f2:	eba080e7          	jalr	-326(ra) # 78a8 <fork>
    39f6:	87aa                	mv	a5,a0
    39f8:	fef42223          	sw	a5,-28(s0)
  if(pid < 0){
    39fc:	fe442783          	lw	a5,-28(s0)
    3a00:	2781                	sext.w	a5,a5
    3a02:	0207d163          	bgez	a5,3a24 <linkunlink+0x52>
    printf("%s: fork failed\n", s);
    3a06:	fd843583          	ld	a1,-40(s0)
    3a0a:	00005517          	auipc	a0,0x5
    3a0e:	b4650513          	addi	a0,a0,-1210 # 8550 <malloc+0x586>
    3a12:	00004097          	auipc	ra,0x4
    3a16:	3c6080e7          	jalr	966(ra) # 7dd8 <printf>
    exit(1);
    3a1a:	4505                	li	a0,1
    3a1c:	00004097          	auipc	ra,0x4
    3a20:	e94080e7          	jalr	-364(ra) # 78b0 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    3a24:	fe442783          	lw	a5,-28(s0)
    3a28:	2781                	sext.w	a5,a5
    3a2a:	c399                	beqz	a5,3a30 <linkunlink+0x5e>
    3a2c:	4785                	li	a5,1
    3a2e:	a019                	j	3a34 <linkunlink+0x62>
    3a30:	06100793          	li	a5,97
    3a34:	fef42423          	sw	a5,-24(s0)
  for(i = 0; i < 100; i++){
    3a38:	fe042623          	sw	zero,-20(s0)
    3a3c:	a045                	j	3adc <linkunlink+0x10a>
    x = x * 1103515245 + 12345;
    3a3e:	fe842783          	lw	a5,-24(s0)
    3a42:	873e                	mv	a4,a5
    3a44:	41c657b7          	lui	a5,0x41c65
    3a48:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <freep+0x41c52345>
    3a4c:	02f707bb          	mulw	a5,a4,a5
    3a50:	0007871b          	sext.w	a4,a5
    3a54:	678d                	lui	a5,0x3
    3a56:	0397879b          	addiw	a5,a5,57 # 3039 <createdelete+0x2b9>
    3a5a:	9fb9                	addw	a5,a5,a4
    3a5c:	fef42423          	sw	a5,-24(s0)
    if((x % 3) == 0){
    3a60:	fe842783          	lw	a5,-24(s0)
    3a64:	873e                	mv	a4,a5
    3a66:	478d                	li	a5,3
    3a68:	02f777bb          	remuw	a5,a4,a5
    3a6c:	2781                	sext.w	a5,a5
    3a6e:	e395                	bnez	a5,3a92 <linkunlink+0xc0>
      close(open("x", O_RDWR | O_CREATE));
    3a70:	20200593          	li	a1,514
    3a74:	00004517          	auipc	a0,0x4
    3a78:	7ac50513          	addi	a0,a0,1964 # 8220 <malloc+0x256>
    3a7c:	00004097          	auipc	ra,0x4
    3a80:	e74080e7          	jalr	-396(ra) # 78f0 <open>
    3a84:	87aa                	mv	a5,a0
    3a86:	853e                	mv	a0,a5
    3a88:	00004097          	auipc	ra,0x4
    3a8c:	e50080e7          	jalr	-432(ra) # 78d8 <close>
    3a90:	a089                	j	3ad2 <linkunlink+0x100>
    } else if((x % 3) == 1){
    3a92:	fe842783          	lw	a5,-24(s0)
    3a96:	873e                	mv	a4,a5
    3a98:	478d                	li	a5,3
    3a9a:	02f777bb          	remuw	a5,a4,a5
    3a9e:	2781                	sext.w	a5,a5
    3aa0:	873e                	mv	a4,a5
    3aa2:	4785                	li	a5,1
    3aa4:	00f71f63          	bne	a4,a5,3ac2 <linkunlink+0xf0>
      link("cat", "x");
    3aa8:	00004597          	auipc	a1,0x4
    3aac:	77858593          	addi	a1,a1,1912 # 8220 <malloc+0x256>
    3ab0:	00005517          	auipc	a0,0x5
    3ab4:	4f850513          	addi	a0,a0,1272 # 8fa8 <malloc+0xfde>
    3ab8:	00004097          	auipc	ra,0x4
    3abc:	e58080e7          	jalr	-424(ra) # 7910 <link>
    3ac0:	a809                	j	3ad2 <linkunlink+0x100>
    } else {
      unlink("x");
    3ac2:	00004517          	auipc	a0,0x4
    3ac6:	75e50513          	addi	a0,a0,1886 # 8220 <malloc+0x256>
    3aca:	00004097          	auipc	ra,0x4
    3ace:	e36080e7          	jalr	-458(ra) # 7900 <unlink>
  for(i = 0; i < 100; i++){
    3ad2:	fec42783          	lw	a5,-20(s0)
    3ad6:	2785                	addiw	a5,a5,1
    3ad8:	fef42623          	sw	a5,-20(s0)
    3adc:	fec42783          	lw	a5,-20(s0)
    3ae0:	0007871b          	sext.w	a4,a5
    3ae4:	06300793          	li	a5,99
    3ae8:	f4e7dbe3          	bge	a5,a4,3a3e <linkunlink+0x6c>
    }
  }

  if(pid)
    3aec:	fe442783          	lw	a5,-28(s0)
    3af0:	2781                	sext.w	a5,a5
    3af2:	c799                	beqz	a5,3b00 <linkunlink+0x12e>
    wait(0);
    3af4:	4501                	li	a0,0
    3af6:	00004097          	auipc	ra,0x4
    3afa:	dc2080e7          	jalr	-574(ra) # 78b8 <wait>
  else
    exit(0);
}
    3afe:	a031                	j	3b0a <linkunlink+0x138>
    exit(0);
    3b00:	4501                	li	a0,0
    3b02:	00004097          	auipc	ra,0x4
    3b06:	dae080e7          	jalr	-594(ra) # 78b0 <exit>
}
    3b0a:	70a2                	ld	ra,40(sp)
    3b0c:	7402                	ld	s0,32(sp)
    3b0e:	6145                	addi	sp,sp,48
    3b10:	8082                	ret

0000000000003b12 <subdir>:


void
subdir(char *s)
{
    3b12:	7179                	addi	sp,sp,-48
    3b14:	f406                	sd	ra,40(sp)
    3b16:	f022                	sd	s0,32(sp)
    3b18:	1800                	addi	s0,sp,48
    3b1a:	fca43c23          	sd	a0,-40(s0)
  int fd, cc;

  unlink("ff");
    3b1e:	00005517          	auipc	a0,0x5
    3b22:	49250513          	addi	a0,a0,1170 # 8fb0 <malloc+0xfe6>
    3b26:	00004097          	auipc	ra,0x4
    3b2a:	dda080e7          	jalr	-550(ra) # 7900 <unlink>
  if(mkdir("dd") != 0){
    3b2e:	00005517          	auipc	a0,0x5
    3b32:	48a50513          	addi	a0,a0,1162 # 8fb8 <malloc+0xfee>
    3b36:	00004097          	auipc	ra,0x4
    3b3a:	de2080e7          	jalr	-542(ra) # 7918 <mkdir>
    3b3e:	87aa                	mv	a5,a0
    3b40:	c385                	beqz	a5,3b60 <subdir+0x4e>
    printf("%s: mkdir dd failed\n", s);
    3b42:	fd843583          	ld	a1,-40(s0)
    3b46:	00005517          	auipc	a0,0x5
    3b4a:	47a50513          	addi	a0,a0,1146 # 8fc0 <malloc+0xff6>
    3b4e:	00004097          	auipc	ra,0x4
    3b52:	28a080e7          	jalr	650(ra) # 7dd8 <printf>
    exit(1);
    3b56:	4505                	li	a0,1
    3b58:	00004097          	auipc	ra,0x4
    3b5c:	d58080e7          	jalr	-680(ra) # 78b0 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    3b60:	20200593          	li	a1,514
    3b64:	00005517          	auipc	a0,0x5
    3b68:	47450513          	addi	a0,a0,1140 # 8fd8 <malloc+0x100e>
    3b6c:	00004097          	auipc	ra,0x4
    3b70:	d84080e7          	jalr	-636(ra) # 78f0 <open>
    3b74:	87aa                	mv	a5,a0
    3b76:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3b7a:	fec42783          	lw	a5,-20(s0)
    3b7e:	2781                	sext.w	a5,a5
    3b80:	0207d163          	bgez	a5,3ba2 <subdir+0x90>
    printf("%s: create dd/ff failed\n", s);
    3b84:	fd843583          	ld	a1,-40(s0)
    3b88:	00005517          	auipc	a0,0x5
    3b8c:	45850513          	addi	a0,a0,1112 # 8fe0 <malloc+0x1016>
    3b90:	00004097          	auipc	ra,0x4
    3b94:	248080e7          	jalr	584(ra) # 7dd8 <printf>
    exit(1);
    3b98:	4505                	li	a0,1
    3b9a:	00004097          	auipc	ra,0x4
    3b9e:	d16080e7          	jalr	-746(ra) # 78b0 <exit>
  }
  write(fd, "ff", 2);
    3ba2:	fec42783          	lw	a5,-20(s0)
    3ba6:	4609                	li	a2,2
    3ba8:	00005597          	auipc	a1,0x5
    3bac:	40858593          	addi	a1,a1,1032 # 8fb0 <malloc+0xfe6>
    3bb0:	853e                	mv	a0,a5
    3bb2:	00004097          	auipc	ra,0x4
    3bb6:	d1e080e7          	jalr	-738(ra) # 78d0 <write>
  close(fd);
    3bba:	fec42783          	lw	a5,-20(s0)
    3bbe:	853e                	mv	a0,a5
    3bc0:	00004097          	auipc	ra,0x4
    3bc4:	d18080e7          	jalr	-744(ra) # 78d8 <close>

  if(unlink("dd") >= 0){
    3bc8:	00005517          	auipc	a0,0x5
    3bcc:	3f050513          	addi	a0,a0,1008 # 8fb8 <malloc+0xfee>
    3bd0:	00004097          	auipc	ra,0x4
    3bd4:	d30080e7          	jalr	-720(ra) # 7900 <unlink>
    3bd8:	87aa                	mv	a5,a0
    3bda:	0207c163          	bltz	a5,3bfc <subdir+0xea>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3bde:	fd843583          	ld	a1,-40(s0)
    3be2:	00005517          	auipc	a0,0x5
    3be6:	41e50513          	addi	a0,a0,1054 # 9000 <malloc+0x1036>
    3bea:	00004097          	auipc	ra,0x4
    3bee:	1ee080e7          	jalr	494(ra) # 7dd8 <printf>
    exit(1);
    3bf2:	4505                	li	a0,1
    3bf4:	00004097          	auipc	ra,0x4
    3bf8:	cbc080e7          	jalr	-836(ra) # 78b0 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    3bfc:	00005517          	auipc	a0,0x5
    3c00:	43450513          	addi	a0,a0,1076 # 9030 <malloc+0x1066>
    3c04:	00004097          	auipc	ra,0x4
    3c08:	d14080e7          	jalr	-748(ra) # 7918 <mkdir>
    3c0c:	87aa                	mv	a5,a0
    3c0e:	c385                	beqz	a5,3c2e <subdir+0x11c>
    printf("subdir mkdir dd/dd failed\n", s);
    3c10:	fd843583          	ld	a1,-40(s0)
    3c14:	00005517          	auipc	a0,0x5
    3c18:	42450513          	addi	a0,a0,1060 # 9038 <malloc+0x106e>
    3c1c:	00004097          	auipc	ra,0x4
    3c20:	1bc080e7          	jalr	444(ra) # 7dd8 <printf>
    exit(1);
    3c24:	4505                	li	a0,1
    3c26:	00004097          	auipc	ra,0x4
    3c2a:	c8a080e7          	jalr	-886(ra) # 78b0 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3c2e:	20200593          	li	a1,514
    3c32:	00005517          	auipc	a0,0x5
    3c36:	42650513          	addi	a0,a0,1062 # 9058 <malloc+0x108e>
    3c3a:	00004097          	auipc	ra,0x4
    3c3e:	cb6080e7          	jalr	-842(ra) # 78f0 <open>
    3c42:	87aa                	mv	a5,a0
    3c44:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3c48:	fec42783          	lw	a5,-20(s0)
    3c4c:	2781                	sext.w	a5,a5
    3c4e:	0207d163          	bgez	a5,3c70 <subdir+0x15e>
    printf("%s: create dd/dd/ff failed\n", s);
    3c52:	fd843583          	ld	a1,-40(s0)
    3c56:	00005517          	auipc	a0,0x5
    3c5a:	41250513          	addi	a0,a0,1042 # 9068 <malloc+0x109e>
    3c5e:	00004097          	auipc	ra,0x4
    3c62:	17a080e7          	jalr	378(ra) # 7dd8 <printf>
    exit(1);
    3c66:	4505                	li	a0,1
    3c68:	00004097          	auipc	ra,0x4
    3c6c:	c48080e7          	jalr	-952(ra) # 78b0 <exit>
  }
  write(fd, "FF", 2);
    3c70:	fec42783          	lw	a5,-20(s0)
    3c74:	4609                	li	a2,2
    3c76:	00005597          	auipc	a1,0x5
    3c7a:	41258593          	addi	a1,a1,1042 # 9088 <malloc+0x10be>
    3c7e:	853e                	mv	a0,a5
    3c80:	00004097          	auipc	ra,0x4
    3c84:	c50080e7          	jalr	-944(ra) # 78d0 <write>
  close(fd);
    3c88:	fec42783          	lw	a5,-20(s0)
    3c8c:	853e                	mv	a0,a5
    3c8e:	00004097          	auipc	ra,0x4
    3c92:	c4a080e7          	jalr	-950(ra) # 78d8 <close>

  fd = open("dd/dd/../ff", 0);
    3c96:	4581                	li	a1,0
    3c98:	00005517          	auipc	a0,0x5
    3c9c:	3f850513          	addi	a0,a0,1016 # 9090 <malloc+0x10c6>
    3ca0:	00004097          	auipc	ra,0x4
    3ca4:	c50080e7          	jalr	-944(ra) # 78f0 <open>
    3ca8:	87aa                	mv	a5,a0
    3caa:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3cae:	fec42783          	lw	a5,-20(s0)
    3cb2:	2781                	sext.w	a5,a5
    3cb4:	0207d163          	bgez	a5,3cd6 <subdir+0x1c4>
    printf("%s: open dd/dd/../ff failed\n", s);
    3cb8:	fd843583          	ld	a1,-40(s0)
    3cbc:	00005517          	auipc	a0,0x5
    3cc0:	3e450513          	addi	a0,a0,996 # 90a0 <malloc+0x10d6>
    3cc4:	00004097          	auipc	ra,0x4
    3cc8:	114080e7          	jalr	276(ra) # 7dd8 <printf>
    exit(1);
    3ccc:	4505                	li	a0,1
    3cce:	00004097          	auipc	ra,0x4
    3cd2:	be2080e7          	jalr	-1054(ra) # 78b0 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    3cd6:	fec42783          	lw	a5,-20(s0)
    3cda:	660d                	lui	a2,0x3
    3cdc:	00008597          	auipc	a1,0x8
    3ce0:	62458593          	addi	a1,a1,1572 # c300 <buf>
    3ce4:	853e                	mv	a0,a5
    3ce6:	00004097          	auipc	ra,0x4
    3cea:	be2080e7          	jalr	-1054(ra) # 78c8 <read>
    3cee:	87aa                	mv	a5,a0
    3cf0:	fef42423          	sw	a5,-24(s0)
  if(cc != 2 || buf[0] != 'f'){
    3cf4:	fe842783          	lw	a5,-24(s0)
    3cf8:	0007871b          	sext.w	a4,a5
    3cfc:	4789                	li	a5,2
    3cfe:	00f71d63          	bne	a4,a5,3d18 <subdir+0x206>
    3d02:	00008797          	auipc	a5,0x8
    3d06:	5fe78793          	addi	a5,a5,1534 # c300 <buf>
    3d0a:	0007c783          	lbu	a5,0(a5)
    3d0e:	873e                	mv	a4,a5
    3d10:	06600793          	li	a5,102
    3d14:	02f70163          	beq	a4,a5,3d36 <subdir+0x224>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3d18:	fd843583          	ld	a1,-40(s0)
    3d1c:	00005517          	auipc	a0,0x5
    3d20:	3a450513          	addi	a0,a0,932 # 90c0 <malloc+0x10f6>
    3d24:	00004097          	auipc	ra,0x4
    3d28:	0b4080e7          	jalr	180(ra) # 7dd8 <printf>
    exit(1);
    3d2c:	4505                	li	a0,1
    3d2e:	00004097          	auipc	ra,0x4
    3d32:	b82080e7          	jalr	-1150(ra) # 78b0 <exit>
  }
  close(fd);
    3d36:	fec42783          	lw	a5,-20(s0)
    3d3a:	853e                	mv	a0,a5
    3d3c:	00004097          	auipc	ra,0x4
    3d40:	b9c080e7          	jalr	-1124(ra) # 78d8 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3d44:	00005597          	auipc	a1,0x5
    3d48:	39c58593          	addi	a1,a1,924 # 90e0 <malloc+0x1116>
    3d4c:	00005517          	auipc	a0,0x5
    3d50:	30c50513          	addi	a0,a0,780 # 9058 <malloc+0x108e>
    3d54:	00004097          	auipc	ra,0x4
    3d58:	bbc080e7          	jalr	-1092(ra) # 7910 <link>
    3d5c:	87aa                	mv	a5,a0
    3d5e:	c385                	beqz	a5,3d7e <subdir+0x26c>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3d60:	fd843583          	ld	a1,-40(s0)
    3d64:	00005517          	auipc	a0,0x5
    3d68:	38c50513          	addi	a0,a0,908 # 90f0 <malloc+0x1126>
    3d6c:	00004097          	auipc	ra,0x4
    3d70:	06c080e7          	jalr	108(ra) # 7dd8 <printf>
    exit(1);
    3d74:	4505                	li	a0,1
    3d76:	00004097          	auipc	ra,0x4
    3d7a:	b3a080e7          	jalr	-1222(ra) # 78b0 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    3d7e:	00005517          	auipc	a0,0x5
    3d82:	2da50513          	addi	a0,a0,730 # 9058 <malloc+0x108e>
    3d86:	00004097          	auipc	ra,0x4
    3d8a:	b7a080e7          	jalr	-1158(ra) # 7900 <unlink>
    3d8e:	87aa                	mv	a5,a0
    3d90:	c385                	beqz	a5,3db0 <subdir+0x29e>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3d92:	fd843583          	ld	a1,-40(s0)
    3d96:	00005517          	auipc	a0,0x5
    3d9a:	38250513          	addi	a0,a0,898 # 9118 <malloc+0x114e>
    3d9e:	00004097          	auipc	ra,0x4
    3da2:	03a080e7          	jalr	58(ra) # 7dd8 <printf>
    exit(1);
    3da6:	4505                	li	a0,1
    3da8:	00004097          	auipc	ra,0x4
    3dac:	b08080e7          	jalr	-1272(ra) # 78b0 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3db0:	4581                	li	a1,0
    3db2:	00005517          	auipc	a0,0x5
    3db6:	2a650513          	addi	a0,a0,678 # 9058 <malloc+0x108e>
    3dba:	00004097          	auipc	ra,0x4
    3dbe:	b36080e7          	jalr	-1226(ra) # 78f0 <open>
    3dc2:	87aa                	mv	a5,a0
    3dc4:	0207c163          	bltz	a5,3de6 <subdir+0x2d4>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3dc8:	fd843583          	ld	a1,-40(s0)
    3dcc:	00005517          	auipc	a0,0x5
    3dd0:	36c50513          	addi	a0,a0,876 # 9138 <malloc+0x116e>
    3dd4:	00004097          	auipc	ra,0x4
    3dd8:	004080e7          	jalr	4(ra) # 7dd8 <printf>
    exit(1);
    3ddc:	4505                	li	a0,1
    3dde:	00004097          	auipc	ra,0x4
    3de2:	ad2080e7          	jalr	-1326(ra) # 78b0 <exit>
  }

  if(chdir("dd") != 0){
    3de6:	00005517          	auipc	a0,0x5
    3dea:	1d250513          	addi	a0,a0,466 # 8fb8 <malloc+0xfee>
    3dee:	00004097          	auipc	ra,0x4
    3df2:	b32080e7          	jalr	-1230(ra) # 7920 <chdir>
    3df6:	87aa                	mv	a5,a0
    3df8:	c385                	beqz	a5,3e18 <subdir+0x306>
    printf("%s: chdir dd failed\n", s);
    3dfa:	fd843583          	ld	a1,-40(s0)
    3dfe:	00005517          	auipc	a0,0x5
    3e02:	36250513          	addi	a0,a0,866 # 9160 <malloc+0x1196>
    3e06:	00004097          	auipc	ra,0x4
    3e0a:	fd2080e7          	jalr	-46(ra) # 7dd8 <printf>
    exit(1);
    3e0e:	4505                	li	a0,1
    3e10:	00004097          	auipc	ra,0x4
    3e14:	aa0080e7          	jalr	-1376(ra) # 78b0 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    3e18:	00005517          	auipc	a0,0x5
    3e1c:	36050513          	addi	a0,a0,864 # 9178 <malloc+0x11ae>
    3e20:	00004097          	auipc	ra,0x4
    3e24:	b00080e7          	jalr	-1280(ra) # 7920 <chdir>
    3e28:	87aa                	mv	a5,a0
    3e2a:	c385                	beqz	a5,3e4a <subdir+0x338>
    printf("%s: chdir dd/../../dd failed\n", s);
    3e2c:	fd843583          	ld	a1,-40(s0)
    3e30:	00005517          	auipc	a0,0x5
    3e34:	35850513          	addi	a0,a0,856 # 9188 <malloc+0x11be>
    3e38:	00004097          	auipc	ra,0x4
    3e3c:	fa0080e7          	jalr	-96(ra) # 7dd8 <printf>
    exit(1);
    3e40:	4505                	li	a0,1
    3e42:	00004097          	auipc	ra,0x4
    3e46:	a6e080e7          	jalr	-1426(ra) # 78b0 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    3e4a:	00005517          	auipc	a0,0x5
    3e4e:	35e50513          	addi	a0,a0,862 # 91a8 <malloc+0x11de>
    3e52:	00004097          	auipc	ra,0x4
    3e56:	ace080e7          	jalr	-1330(ra) # 7920 <chdir>
    3e5a:	87aa                	mv	a5,a0
    3e5c:	c385                	beqz	a5,3e7c <subdir+0x36a>
    printf("chdir dd/../../dd failed\n", s);
    3e5e:	fd843583          	ld	a1,-40(s0)
    3e62:	00005517          	auipc	a0,0x5
    3e66:	35650513          	addi	a0,a0,854 # 91b8 <malloc+0x11ee>
    3e6a:	00004097          	auipc	ra,0x4
    3e6e:	f6e080e7          	jalr	-146(ra) # 7dd8 <printf>
    exit(1);
    3e72:	4505                	li	a0,1
    3e74:	00004097          	auipc	ra,0x4
    3e78:	a3c080e7          	jalr	-1476(ra) # 78b0 <exit>
  }
  if(chdir("./..") != 0){
    3e7c:	00005517          	auipc	a0,0x5
    3e80:	35c50513          	addi	a0,a0,860 # 91d8 <malloc+0x120e>
    3e84:	00004097          	auipc	ra,0x4
    3e88:	a9c080e7          	jalr	-1380(ra) # 7920 <chdir>
    3e8c:	87aa                	mv	a5,a0
    3e8e:	c385                	beqz	a5,3eae <subdir+0x39c>
    printf("%s: chdir ./.. failed\n", s);
    3e90:	fd843583          	ld	a1,-40(s0)
    3e94:	00005517          	auipc	a0,0x5
    3e98:	34c50513          	addi	a0,a0,844 # 91e0 <malloc+0x1216>
    3e9c:	00004097          	auipc	ra,0x4
    3ea0:	f3c080e7          	jalr	-196(ra) # 7dd8 <printf>
    exit(1);
    3ea4:	4505                	li	a0,1
    3ea6:	00004097          	auipc	ra,0x4
    3eaa:	a0a080e7          	jalr	-1526(ra) # 78b0 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    3eae:	4581                	li	a1,0
    3eb0:	00005517          	auipc	a0,0x5
    3eb4:	23050513          	addi	a0,a0,560 # 90e0 <malloc+0x1116>
    3eb8:	00004097          	auipc	ra,0x4
    3ebc:	a38080e7          	jalr	-1480(ra) # 78f0 <open>
    3ec0:	87aa                	mv	a5,a0
    3ec2:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3ec6:	fec42783          	lw	a5,-20(s0)
    3eca:	2781                	sext.w	a5,a5
    3ecc:	0207d163          	bgez	a5,3eee <subdir+0x3dc>
    printf("%s: open dd/dd/ffff failed\n", s);
    3ed0:	fd843583          	ld	a1,-40(s0)
    3ed4:	00005517          	auipc	a0,0x5
    3ed8:	32450513          	addi	a0,a0,804 # 91f8 <malloc+0x122e>
    3edc:	00004097          	auipc	ra,0x4
    3ee0:	efc080e7          	jalr	-260(ra) # 7dd8 <printf>
    exit(1);
    3ee4:	4505                	li	a0,1
    3ee6:	00004097          	auipc	ra,0x4
    3eea:	9ca080e7          	jalr	-1590(ra) # 78b0 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    3eee:	fec42783          	lw	a5,-20(s0)
    3ef2:	660d                	lui	a2,0x3
    3ef4:	00008597          	auipc	a1,0x8
    3ef8:	40c58593          	addi	a1,a1,1036 # c300 <buf>
    3efc:	853e                	mv	a0,a5
    3efe:	00004097          	auipc	ra,0x4
    3f02:	9ca080e7          	jalr	-1590(ra) # 78c8 <read>
    3f06:	87aa                	mv	a5,a0
    3f08:	873e                	mv	a4,a5
    3f0a:	4789                	li	a5,2
    3f0c:	02f70163          	beq	a4,a5,3f2e <subdir+0x41c>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3f10:	fd843583          	ld	a1,-40(s0)
    3f14:	00005517          	auipc	a0,0x5
    3f18:	30450513          	addi	a0,a0,772 # 9218 <malloc+0x124e>
    3f1c:	00004097          	auipc	ra,0x4
    3f20:	ebc080e7          	jalr	-324(ra) # 7dd8 <printf>
    exit(1);
    3f24:	4505                	li	a0,1
    3f26:	00004097          	auipc	ra,0x4
    3f2a:	98a080e7          	jalr	-1654(ra) # 78b0 <exit>
  }
  close(fd);
    3f2e:	fec42783          	lw	a5,-20(s0)
    3f32:	853e                	mv	a0,a5
    3f34:	00004097          	auipc	ra,0x4
    3f38:	9a4080e7          	jalr	-1628(ra) # 78d8 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3f3c:	4581                	li	a1,0
    3f3e:	00005517          	auipc	a0,0x5
    3f42:	11a50513          	addi	a0,a0,282 # 9058 <malloc+0x108e>
    3f46:	00004097          	auipc	ra,0x4
    3f4a:	9aa080e7          	jalr	-1622(ra) # 78f0 <open>
    3f4e:	87aa                	mv	a5,a0
    3f50:	0207c163          	bltz	a5,3f72 <subdir+0x460>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3f54:	fd843583          	ld	a1,-40(s0)
    3f58:	00005517          	auipc	a0,0x5
    3f5c:	2e050513          	addi	a0,a0,736 # 9238 <malloc+0x126e>
    3f60:	00004097          	auipc	ra,0x4
    3f64:	e78080e7          	jalr	-392(ra) # 7dd8 <printf>
    exit(1);
    3f68:	4505                	li	a0,1
    3f6a:	00004097          	auipc	ra,0x4
    3f6e:	946080e7          	jalr	-1722(ra) # 78b0 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3f72:	20200593          	li	a1,514
    3f76:	00005517          	auipc	a0,0x5
    3f7a:	2f250513          	addi	a0,a0,754 # 9268 <malloc+0x129e>
    3f7e:	00004097          	auipc	ra,0x4
    3f82:	972080e7          	jalr	-1678(ra) # 78f0 <open>
    3f86:	87aa                	mv	a5,a0
    3f88:	0207c163          	bltz	a5,3faa <subdir+0x498>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3f8c:	fd843583          	ld	a1,-40(s0)
    3f90:	00005517          	auipc	a0,0x5
    3f94:	2e850513          	addi	a0,a0,744 # 9278 <malloc+0x12ae>
    3f98:	00004097          	auipc	ra,0x4
    3f9c:	e40080e7          	jalr	-448(ra) # 7dd8 <printf>
    exit(1);
    3fa0:	4505                	li	a0,1
    3fa2:	00004097          	auipc	ra,0x4
    3fa6:	90e080e7          	jalr	-1778(ra) # 78b0 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3faa:	20200593          	li	a1,514
    3fae:	00005517          	auipc	a0,0x5
    3fb2:	2ea50513          	addi	a0,a0,746 # 9298 <malloc+0x12ce>
    3fb6:	00004097          	auipc	ra,0x4
    3fba:	93a080e7          	jalr	-1734(ra) # 78f0 <open>
    3fbe:	87aa                	mv	a5,a0
    3fc0:	0207c163          	bltz	a5,3fe2 <subdir+0x4d0>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3fc4:	fd843583          	ld	a1,-40(s0)
    3fc8:	00005517          	auipc	a0,0x5
    3fcc:	2e050513          	addi	a0,a0,736 # 92a8 <malloc+0x12de>
    3fd0:	00004097          	auipc	ra,0x4
    3fd4:	e08080e7          	jalr	-504(ra) # 7dd8 <printf>
    exit(1);
    3fd8:	4505                	li	a0,1
    3fda:	00004097          	auipc	ra,0x4
    3fde:	8d6080e7          	jalr	-1834(ra) # 78b0 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    3fe2:	20000593          	li	a1,512
    3fe6:	00005517          	auipc	a0,0x5
    3fea:	fd250513          	addi	a0,a0,-46 # 8fb8 <malloc+0xfee>
    3fee:	00004097          	auipc	ra,0x4
    3ff2:	902080e7          	jalr	-1790(ra) # 78f0 <open>
    3ff6:	87aa                	mv	a5,a0
    3ff8:	0207c163          	bltz	a5,401a <subdir+0x508>
    printf("%s: create dd succeeded!\n", s);
    3ffc:	fd843583          	ld	a1,-40(s0)
    4000:	00005517          	auipc	a0,0x5
    4004:	2c850513          	addi	a0,a0,712 # 92c8 <malloc+0x12fe>
    4008:	00004097          	auipc	ra,0x4
    400c:	dd0080e7          	jalr	-560(ra) # 7dd8 <printf>
    exit(1);
    4010:	4505                	li	a0,1
    4012:	00004097          	auipc	ra,0x4
    4016:	89e080e7          	jalr	-1890(ra) # 78b0 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    401a:	4589                	li	a1,2
    401c:	00005517          	auipc	a0,0x5
    4020:	f9c50513          	addi	a0,a0,-100 # 8fb8 <malloc+0xfee>
    4024:	00004097          	auipc	ra,0x4
    4028:	8cc080e7          	jalr	-1844(ra) # 78f0 <open>
    402c:	87aa                	mv	a5,a0
    402e:	0207c163          	bltz	a5,4050 <subdir+0x53e>
    printf("%s: open dd rdwr succeeded!\n", s);
    4032:	fd843583          	ld	a1,-40(s0)
    4036:	00005517          	auipc	a0,0x5
    403a:	2b250513          	addi	a0,a0,690 # 92e8 <malloc+0x131e>
    403e:	00004097          	auipc	ra,0x4
    4042:	d9a080e7          	jalr	-614(ra) # 7dd8 <printf>
    exit(1);
    4046:	4505                	li	a0,1
    4048:	00004097          	auipc	ra,0x4
    404c:	868080e7          	jalr	-1944(ra) # 78b0 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    4050:	4585                	li	a1,1
    4052:	00005517          	auipc	a0,0x5
    4056:	f6650513          	addi	a0,a0,-154 # 8fb8 <malloc+0xfee>
    405a:	00004097          	auipc	ra,0x4
    405e:	896080e7          	jalr	-1898(ra) # 78f0 <open>
    4062:	87aa                	mv	a5,a0
    4064:	0207c163          	bltz	a5,4086 <subdir+0x574>
    printf("%s: open dd wronly succeeded!\n", s);
    4068:	fd843583          	ld	a1,-40(s0)
    406c:	00005517          	auipc	a0,0x5
    4070:	29c50513          	addi	a0,a0,668 # 9308 <malloc+0x133e>
    4074:	00004097          	auipc	ra,0x4
    4078:	d64080e7          	jalr	-668(ra) # 7dd8 <printf>
    exit(1);
    407c:	4505                	li	a0,1
    407e:	00004097          	auipc	ra,0x4
    4082:	832080e7          	jalr	-1998(ra) # 78b0 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    4086:	00005597          	auipc	a1,0x5
    408a:	2a258593          	addi	a1,a1,674 # 9328 <malloc+0x135e>
    408e:	00005517          	auipc	a0,0x5
    4092:	1da50513          	addi	a0,a0,474 # 9268 <malloc+0x129e>
    4096:	00004097          	auipc	ra,0x4
    409a:	87a080e7          	jalr	-1926(ra) # 7910 <link>
    409e:	87aa                	mv	a5,a0
    40a0:	e385                	bnez	a5,40c0 <subdir+0x5ae>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    40a2:	fd843583          	ld	a1,-40(s0)
    40a6:	00005517          	auipc	a0,0x5
    40aa:	29250513          	addi	a0,a0,658 # 9338 <malloc+0x136e>
    40ae:	00004097          	auipc	ra,0x4
    40b2:	d2a080e7          	jalr	-726(ra) # 7dd8 <printf>
    exit(1);
    40b6:	4505                	li	a0,1
    40b8:	00003097          	auipc	ra,0x3
    40bc:	7f8080e7          	jalr	2040(ra) # 78b0 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    40c0:	00005597          	auipc	a1,0x5
    40c4:	26858593          	addi	a1,a1,616 # 9328 <malloc+0x135e>
    40c8:	00005517          	auipc	a0,0x5
    40cc:	1d050513          	addi	a0,a0,464 # 9298 <malloc+0x12ce>
    40d0:	00004097          	auipc	ra,0x4
    40d4:	840080e7          	jalr	-1984(ra) # 7910 <link>
    40d8:	87aa                	mv	a5,a0
    40da:	e385                	bnez	a5,40fa <subdir+0x5e8>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    40dc:	fd843583          	ld	a1,-40(s0)
    40e0:	00005517          	auipc	a0,0x5
    40e4:	28050513          	addi	a0,a0,640 # 9360 <malloc+0x1396>
    40e8:	00004097          	auipc	ra,0x4
    40ec:	cf0080e7          	jalr	-784(ra) # 7dd8 <printf>
    exit(1);
    40f0:	4505                	li	a0,1
    40f2:	00003097          	auipc	ra,0x3
    40f6:	7be080e7          	jalr	1982(ra) # 78b0 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    40fa:	00005597          	auipc	a1,0x5
    40fe:	fe658593          	addi	a1,a1,-26 # 90e0 <malloc+0x1116>
    4102:	00005517          	auipc	a0,0x5
    4106:	ed650513          	addi	a0,a0,-298 # 8fd8 <malloc+0x100e>
    410a:	00004097          	auipc	ra,0x4
    410e:	806080e7          	jalr	-2042(ra) # 7910 <link>
    4112:	87aa                	mv	a5,a0
    4114:	e385                	bnez	a5,4134 <subdir+0x622>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    4116:	fd843583          	ld	a1,-40(s0)
    411a:	00005517          	auipc	a0,0x5
    411e:	26e50513          	addi	a0,a0,622 # 9388 <malloc+0x13be>
    4122:	00004097          	auipc	ra,0x4
    4126:	cb6080e7          	jalr	-842(ra) # 7dd8 <printf>
    exit(1);
    412a:	4505                	li	a0,1
    412c:	00003097          	auipc	ra,0x3
    4130:	784080e7          	jalr	1924(ra) # 78b0 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    4134:	00005517          	auipc	a0,0x5
    4138:	13450513          	addi	a0,a0,308 # 9268 <malloc+0x129e>
    413c:	00003097          	auipc	ra,0x3
    4140:	7dc080e7          	jalr	2012(ra) # 7918 <mkdir>
    4144:	87aa                	mv	a5,a0
    4146:	e385                	bnez	a5,4166 <subdir+0x654>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    4148:	fd843583          	ld	a1,-40(s0)
    414c:	00005517          	auipc	a0,0x5
    4150:	26450513          	addi	a0,a0,612 # 93b0 <malloc+0x13e6>
    4154:	00004097          	auipc	ra,0x4
    4158:	c84080e7          	jalr	-892(ra) # 7dd8 <printf>
    exit(1);
    415c:	4505                	li	a0,1
    415e:	00003097          	auipc	ra,0x3
    4162:	752080e7          	jalr	1874(ra) # 78b0 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    4166:	00005517          	auipc	a0,0x5
    416a:	13250513          	addi	a0,a0,306 # 9298 <malloc+0x12ce>
    416e:	00003097          	auipc	ra,0x3
    4172:	7aa080e7          	jalr	1962(ra) # 7918 <mkdir>
    4176:	87aa                	mv	a5,a0
    4178:	e385                	bnez	a5,4198 <subdir+0x686>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    417a:	fd843583          	ld	a1,-40(s0)
    417e:	00005517          	auipc	a0,0x5
    4182:	25250513          	addi	a0,a0,594 # 93d0 <malloc+0x1406>
    4186:	00004097          	auipc	ra,0x4
    418a:	c52080e7          	jalr	-942(ra) # 7dd8 <printf>
    exit(1);
    418e:	4505                	li	a0,1
    4190:	00003097          	auipc	ra,0x3
    4194:	720080e7          	jalr	1824(ra) # 78b0 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    4198:	00005517          	auipc	a0,0x5
    419c:	f4850513          	addi	a0,a0,-184 # 90e0 <malloc+0x1116>
    41a0:	00003097          	auipc	ra,0x3
    41a4:	778080e7          	jalr	1912(ra) # 7918 <mkdir>
    41a8:	87aa                	mv	a5,a0
    41aa:	e385                	bnez	a5,41ca <subdir+0x6b8>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    41ac:	fd843583          	ld	a1,-40(s0)
    41b0:	00005517          	auipc	a0,0x5
    41b4:	24050513          	addi	a0,a0,576 # 93f0 <malloc+0x1426>
    41b8:	00004097          	auipc	ra,0x4
    41bc:	c20080e7          	jalr	-992(ra) # 7dd8 <printf>
    exit(1);
    41c0:	4505                	li	a0,1
    41c2:	00003097          	auipc	ra,0x3
    41c6:	6ee080e7          	jalr	1774(ra) # 78b0 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    41ca:	00005517          	auipc	a0,0x5
    41ce:	0ce50513          	addi	a0,a0,206 # 9298 <malloc+0x12ce>
    41d2:	00003097          	auipc	ra,0x3
    41d6:	72e080e7          	jalr	1838(ra) # 7900 <unlink>
    41da:	87aa                	mv	a5,a0
    41dc:	e385                	bnez	a5,41fc <subdir+0x6ea>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    41de:	fd843583          	ld	a1,-40(s0)
    41e2:	00005517          	auipc	a0,0x5
    41e6:	23650513          	addi	a0,a0,566 # 9418 <malloc+0x144e>
    41ea:	00004097          	auipc	ra,0x4
    41ee:	bee080e7          	jalr	-1042(ra) # 7dd8 <printf>
    exit(1);
    41f2:	4505                	li	a0,1
    41f4:	00003097          	auipc	ra,0x3
    41f8:	6bc080e7          	jalr	1724(ra) # 78b0 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    41fc:	00005517          	auipc	a0,0x5
    4200:	06c50513          	addi	a0,a0,108 # 9268 <malloc+0x129e>
    4204:	00003097          	auipc	ra,0x3
    4208:	6fc080e7          	jalr	1788(ra) # 7900 <unlink>
    420c:	87aa                	mv	a5,a0
    420e:	e385                	bnez	a5,422e <subdir+0x71c>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    4210:	fd843583          	ld	a1,-40(s0)
    4214:	00005517          	auipc	a0,0x5
    4218:	22450513          	addi	a0,a0,548 # 9438 <malloc+0x146e>
    421c:	00004097          	auipc	ra,0x4
    4220:	bbc080e7          	jalr	-1092(ra) # 7dd8 <printf>
    exit(1);
    4224:	4505                	li	a0,1
    4226:	00003097          	auipc	ra,0x3
    422a:	68a080e7          	jalr	1674(ra) # 78b0 <exit>
  }
  if(chdir("dd/ff") == 0){
    422e:	00005517          	auipc	a0,0x5
    4232:	daa50513          	addi	a0,a0,-598 # 8fd8 <malloc+0x100e>
    4236:	00003097          	auipc	ra,0x3
    423a:	6ea080e7          	jalr	1770(ra) # 7920 <chdir>
    423e:	87aa                	mv	a5,a0
    4240:	e385                	bnez	a5,4260 <subdir+0x74e>
    printf("%s: chdir dd/ff succeeded!\n", s);
    4242:	fd843583          	ld	a1,-40(s0)
    4246:	00005517          	auipc	a0,0x5
    424a:	21250513          	addi	a0,a0,530 # 9458 <malloc+0x148e>
    424e:	00004097          	auipc	ra,0x4
    4252:	b8a080e7          	jalr	-1142(ra) # 7dd8 <printf>
    exit(1);
    4256:	4505                	li	a0,1
    4258:	00003097          	auipc	ra,0x3
    425c:	658080e7          	jalr	1624(ra) # 78b0 <exit>
  }
  if(chdir("dd/xx") == 0){
    4260:	00005517          	auipc	a0,0x5
    4264:	21850513          	addi	a0,a0,536 # 9478 <malloc+0x14ae>
    4268:	00003097          	auipc	ra,0x3
    426c:	6b8080e7          	jalr	1720(ra) # 7920 <chdir>
    4270:	87aa                	mv	a5,a0
    4272:	e385                	bnez	a5,4292 <subdir+0x780>
    printf("%s: chdir dd/xx succeeded!\n", s);
    4274:	fd843583          	ld	a1,-40(s0)
    4278:	00005517          	auipc	a0,0x5
    427c:	20850513          	addi	a0,a0,520 # 9480 <malloc+0x14b6>
    4280:	00004097          	auipc	ra,0x4
    4284:	b58080e7          	jalr	-1192(ra) # 7dd8 <printf>
    exit(1);
    4288:	4505                	li	a0,1
    428a:	00003097          	auipc	ra,0x3
    428e:	626080e7          	jalr	1574(ra) # 78b0 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    4292:	00005517          	auipc	a0,0x5
    4296:	e4e50513          	addi	a0,a0,-434 # 90e0 <malloc+0x1116>
    429a:	00003097          	auipc	ra,0x3
    429e:	666080e7          	jalr	1638(ra) # 7900 <unlink>
    42a2:	87aa                	mv	a5,a0
    42a4:	c385                	beqz	a5,42c4 <subdir+0x7b2>
    printf("%s: unlink dd/dd/ff failed\n", s);
    42a6:	fd843583          	ld	a1,-40(s0)
    42aa:	00005517          	auipc	a0,0x5
    42ae:	e6e50513          	addi	a0,a0,-402 # 9118 <malloc+0x114e>
    42b2:	00004097          	auipc	ra,0x4
    42b6:	b26080e7          	jalr	-1242(ra) # 7dd8 <printf>
    exit(1);
    42ba:	4505                	li	a0,1
    42bc:	00003097          	auipc	ra,0x3
    42c0:	5f4080e7          	jalr	1524(ra) # 78b0 <exit>
  }
  if(unlink("dd/ff") != 0){
    42c4:	00005517          	auipc	a0,0x5
    42c8:	d1450513          	addi	a0,a0,-748 # 8fd8 <malloc+0x100e>
    42cc:	00003097          	auipc	ra,0x3
    42d0:	634080e7          	jalr	1588(ra) # 7900 <unlink>
    42d4:	87aa                	mv	a5,a0
    42d6:	c385                	beqz	a5,42f6 <subdir+0x7e4>
    printf("%s: unlink dd/ff failed\n", s);
    42d8:	fd843583          	ld	a1,-40(s0)
    42dc:	00005517          	auipc	a0,0x5
    42e0:	1c450513          	addi	a0,a0,452 # 94a0 <malloc+0x14d6>
    42e4:	00004097          	auipc	ra,0x4
    42e8:	af4080e7          	jalr	-1292(ra) # 7dd8 <printf>
    exit(1);
    42ec:	4505                	li	a0,1
    42ee:	00003097          	auipc	ra,0x3
    42f2:	5c2080e7          	jalr	1474(ra) # 78b0 <exit>
  }
  if(unlink("dd") == 0){
    42f6:	00005517          	auipc	a0,0x5
    42fa:	cc250513          	addi	a0,a0,-830 # 8fb8 <malloc+0xfee>
    42fe:	00003097          	auipc	ra,0x3
    4302:	602080e7          	jalr	1538(ra) # 7900 <unlink>
    4306:	87aa                	mv	a5,a0
    4308:	e385                	bnez	a5,4328 <subdir+0x816>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    430a:	fd843583          	ld	a1,-40(s0)
    430e:	00005517          	auipc	a0,0x5
    4312:	1b250513          	addi	a0,a0,434 # 94c0 <malloc+0x14f6>
    4316:	00004097          	auipc	ra,0x4
    431a:	ac2080e7          	jalr	-1342(ra) # 7dd8 <printf>
    exit(1);
    431e:	4505                	li	a0,1
    4320:	00003097          	auipc	ra,0x3
    4324:	590080e7          	jalr	1424(ra) # 78b0 <exit>
  }
  if(unlink("dd/dd") < 0){
    4328:	00005517          	auipc	a0,0x5
    432c:	1c050513          	addi	a0,a0,448 # 94e8 <malloc+0x151e>
    4330:	00003097          	auipc	ra,0x3
    4334:	5d0080e7          	jalr	1488(ra) # 7900 <unlink>
    4338:	87aa                	mv	a5,a0
    433a:	0207d163          	bgez	a5,435c <subdir+0x84a>
    printf("%s: unlink dd/dd failed\n", s);
    433e:	fd843583          	ld	a1,-40(s0)
    4342:	00005517          	auipc	a0,0x5
    4346:	1ae50513          	addi	a0,a0,430 # 94f0 <malloc+0x1526>
    434a:	00004097          	auipc	ra,0x4
    434e:	a8e080e7          	jalr	-1394(ra) # 7dd8 <printf>
    exit(1);
    4352:	4505                	li	a0,1
    4354:	00003097          	auipc	ra,0x3
    4358:	55c080e7          	jalr	1372(ra) # 78b0 <exit>
  }
  if(unlink("dd") < 0){
    435c:	00005517          	auipc	a0,0x5
    4360:	c5c50513          	addi	a0,a0,-932 # 8fb8 <malloc+0xfee>
    4364:	00003097          	auipc	ra,0x3
    4368:	59c080e7          	jalr	1436(ra) # 7900 <unlink>
    436c:	87aa                	mv	a5,a0
    436e:	0207d163          	bgez	a5,4390 <subdir+0x87e>
    printf("%s: unlink dd failed\n", s);
    4372:	fd843583          	ld	a1,-40(s0)
    4376:	00005517          	auipc	a0,0x5
    437a:	19a50513          	addi	a0,a0,410 # 9510 <malloc+0x1546>
    437e:	00004097          	auipc	ra,0x4
    4382:	a5a080e7          	jalr	-1446(ra) # 7dd8 <printf>
    exit(1);
    4386:	4505                	li	a0,1
    4388:	00003097          	auipc	ra,0x3
    438c:	528080e7          	jalr	1320(ra) # 78b0 <exit>
  }
}
    4390:	0001                	nop
    4392:	70a2                	ld	ra,40(sp)
    4394:	7402                	ld	s0,32(sp)
    4396:	6145                	addi	sp,sp,48
    4398:	8082                	ret

000000000000439a <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(char *s)
{
    439a:	7179                	addi	sp,sp,-48
    439c:	f406                	sd	ra,40(sp)
    439e:	f022                	sd	s0,32(sp)
    43a0:	1800                	addi	s0,sp,48
    43a2:	fca43c23          	sd	a0,-40(s0)
  int fd, sz;

  unlink("bigwrite");
    43a6:	00005517          	auipc	a0,0x5
    43aa:	18250513          	addi	a0,a0,386 # 9528 <malloc+0x155e>
    43ae:	00003097          	auipc	ra,0x3
    43b2:	552080e7          	jalr	1362(ra) # 7900 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    43b6:	1f300793          	li	a5,499
    43ba:	fef42623          	sw	a5,-20(s0)
    43be:	a0ed                	j	44a8 <bigwrite+0x10e>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    43c0:	20200593          	li	a1,514
    43c4:	00005517          	auipc	a0,0x5
    43c8:	16450513          	addi	a0,a0,356 # 9528 <malloc+0x155e>
    43cc:	00003097          	auipc	ra,0x3
    43d0:	524080e7          	jalr	1316(ra) # 78f0 <open>
    43d4:	87aa                	mv	a5,a0
    43d6:	fef42223          	sw	a5,-28(s0)
    if(fd < 0){
    43da:	fe442783          	lw	a5,-28(s0)
    43de:	2781                	sext.w	a5,a5
    43e0:	0207d163          	bgez	a5,4402 <bigwrite+0x68>
      printf("%s: cannot create bigwrite\n", s);
    43e4:	fd843583          	ld	a1,-40(s0)
    43e8:	00005517          	auipc	a0,0x5
    43ec:	15050513          	addi	a0,a0,336 # 9538 <malloc+0x156e>
    43f0:	00004097          	auipc	ra,0x4
    43f4:	9e8080e7          	jalr	-1560(ra) # 7dd8 <printf>
      exit(1);
    43f8:	4505                	li	a0,1
    43fa:	00003097          	auipc	ra,0x3
    43fe:	4b6080e7          	jalr	1206(ra) # 78b0 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    4402:	fe042423          	sw	zero,-24(s0)
    4406:	a0ad                	j	4470 <bigwrite+0xd6>
      int cc = write(fd, buf, sz);
    4408:	fec42703          	lw	a4,-20(s0)
    440c:	fe442783          	lw	a5,-28(s0)
    4410:	863a                	mv	a2,a4
    4412:	00008597          	auipc	a1,0x8
    4416:	eee58593          	addi	a1,a1,-274 # c300 <buf>
    441a:	853e                	mv	a0,a5
    441c:	00003097          	auipc	ra,0x3
    4420:	4b4080e7          	jalr	1204(ra) # 78d0 <write>
    4424:	87aa                	mv	a5,a0
    4426:	fef42023          	sw	a5,-32(s0)
      if(cc != sz){
    442a:	fe042783          	lw	a5,-32(s0)
    442e:	873e                	mv	a4,a5
    4430:	fec42783          	lw	a5,-20(s0)
    4434:	2701                	sext.w	a4,a4
    4436:	2781                	sext.w	a5,a5
    4438:	02f70763          	beq	a4,a5,4466 <bigwrite+0xcc>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
    443c:	fe042703          	lw	a4,-32(s0)
    4440:	fec42783          	lw	a5,-20(s0)
    4444:	86ba                	mv	a3,a4
    4446:	863e                	mv	a2,a5
    4448:	fd843583          	ld	a1,-40(s0)
    444c:	00005517          	auipc	a0,0x5
    4450:	10c50513          	addi	a0,a0,268 # 9558 <malloc+0x158e>
    4454:	00004097          	auipc	ra,0x4
    4458:	984080e7          	jalr	-1660(ra) # 7dd8 <printf>
        exit(1);
    445c:	4505                	li	a0,1
    445e:	00003097          	auipc	ra,0x3
    4462:	452080e7          	jalr	1106(ra) # 78b0 <exit>
    for(i = 0; i < 2; i++){
    4466:	fe842783          	lw	a5,-24(s0)
    446a:	2785                	addiw	a5,a5,1
    446c:	fef42423          	sw	a5,-24(s0)
    4470:	fe842783          	lw	a5,-24(s0)
    4474:	0007871b          	sext.w	a4,a5
    4478:	4785                	li	a5,1
    447a:	f8e7d7e3          	bge	a5,a4,4408 <bigwrite+0x6e>
      }
    }
    close(fd);
    447e:	fe442783          	lw	a5,-28(s0)
    4482:	853e                	mv	a0,a5
    4484:	00003097          	auipc	ra,0x3
    4488:	454080e7          	jalr	1108(ra) # 78d8 <close>
    unlink("bigwrite");
    448c:	00005517          	auipc	a0,0x5
    4490:	09c50513          	addi	a0,a0,156 # 9528 <malloc+0x155e>
    4494:	00003097          	auipc	ra,0x3
    4498:	46c080e7          	jalr	1132(ra) # 7900 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    449c:	fec42783          	lw	a5,-20(s0)
    44a0:	1d77879b          	addiw	a5,a5,471
    44a4:	fef42623          	sw	a5,-20(s0)
    44a8:	fec42783          	lw	a5,-20(s0)
    44ac:	0007871b          	sext.w	a4,a5
    44b0:	678d                	lui	a5,0x3
    44b2:	f0f747e3          	blt	a4,a5,43c0 <bigwrite+0x26>
  }
}
    44b6:	0001                	nop
    44b8:	0001                	nop
    44ba:	70a2                	ld	ra,40(sp)
    44bc:	7402                	ld	s0,32(sp)
    44be:	6145                	addi	sp,sp,48
    44c0:	8082                	ret

00000000000044c2 <bigfile>:


void
bigfile(char *s)
{
    44c2:	7179                	addi	sp,sp,-48
    44c4:	f406                	sd	ra,40(sp)
    44c6:	f022                	sd	s0,32(sp)
    44c8:	1800                	addi	s0,sp,48
    44ca:	fca43c23          	sd	a0,-40(s0)
  enum { N = 20, SZ=600 };
  int fd, i, total, cc;

  unlink("bigfile.dat");
    44ce:	00005517          	auipc	a0,0x5
    44d2:	0a250513          	addi	a0,a0,162 # 9570 <malloc+0x15a6>
    44d6:	00003097          	auipc	ra,0x3
    44da:	42a080e7          	jalr	1066(ra) # 7900 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    44de:	20200593          	li	a1,514
    44e2:	00005517          	auipc	a0,0x5
    44e6:	08e50513          	addi	a0,a0,142 # 9570 <malloc+0x15a6>
    44ea:	00003097          	auipc	ra,0x3
    44ee:	406080e7          	jalr	1030(ra) # 78f0 <open>
    44f2:	87aa                	mv	a5,a0
    44f4:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    44f8:	fe442783          	lw	a5,-28(s0)
    44fc:	2781                	sext.w	a5,a5
    44fe:	0207d163          	bgez	a5,4520 <bigfile+0x5e>
    printf("%s: cannot create bigfile", s);
    4502:	fd843583          	ld	a1,-40(s0)
    4506:	00005517          	auipc	a0,0x5
    450a:	07a50513          	addi	a0,a0,122 # 9580 <malloc+0x15b6>
    450e:	00004097          	auipc	ra,0x4
    4512:	8ca080e7          	jalr	-1846(ra) # 7dd8 <printf>
    exit(1);
    4516:	4505                	li	a0,1
    4518:	00003097          	auipc	ra,0x3
    451c:	398080e7          	jalr	920(ra) # 78b0 <exit>
  }
  for(i = 0; i < N; i++){
    4520:	fe042623          	sw	zero,-20(s0)
    4524:	a0ad                	j	458e <bigfile+0xcc>
    memset(buf, i, SZ);
    4526:	fec42783          	lw	a5,-20(s0)
    452a:	25800613          	li	a2,600
    452e:	85be                	mv	a1,a5
    4530:	00008517          	auipc	a0,0x8
    4534:	dd050513          	addi	a0,a0,-560 # c300 <buf>
    4538:	00003097          	auipc	ra,0x3
    453c:	fcc080e7          	jalr	-52(ra) # 7504 <memset>
    if(write(fd, buf, SZ) != SZ){
    4540:	fe442783          	lw	a5,-28(s0)
    4544:	25800613          	li	a2,600
    4548:	00008597          	auipc	a1,0x8
    454c:	db858593          	addi	a1,a1,-584 # c300 <buf>
    4550:	853e                	mv	a0,a5
    4552:	00003097          	auipc	ra,0x3
    4556:	37e080e7          	jalr	894(ra) # 78d0 <write>
    455a:	87aa                	mv	a5,a0
    455c:	873e                	mv	a4,a5
    455e:	25800793          	li	a5,600
    4562:	02f70163          	beq	a4,a5,4584 <bigfile+0xc2>
      printf("%s: write bigfile failed\n", s);
    4566:	fd843583          	ld	a1,-40(s0)
    456a:	00005517          	auipc	a0,0x5
    456e:	03650513          	addi	a0,a0,54 # 95a0 <malloc+0x15d6>
    4572:	00004097          	auipc	ra,0x4
    4576:	866080e7          	jalr	-1946(ra) # 7dd8 <printf>
      exit(1);
    457a:	4505                	li	a0,1
    457c:	00003097          	auipc	ra,0x3
    4580:	334080e7          	jalr	820(ra) # 78b0 <exit>
  for(i = 0; i < N; i++){
    4584:	fec42783          	lw	a5,-20(s0)
    4588:	2785                	addiw	a5,a5,1 # 3001 <createdelete+0x281>
    458a:	fef42623          	sw	a5,-20(s0)
    458e:	fec42783          	lw	a5,-20(s0)
    4592:	0007871b          	sext.w	a4,a5
    4596:	47cd                	li	a5,19
    4598:	f8e7d7e3          	bge	a5,a4,4526 <bigfile+0x64>
    }
  }
  close(fd);
    459c:	fe442783          	lw	a5,-28(s0)
    45a0:	853e                	mv	a0,a5
    45a2:	00003097          	auipc	ra,0x3
    45a6:	336080e7          	jalr	822(ra) # 78d8 <close>

  fd = open("bigfile.dat", 0);
    45aa:	4581                	li	a1,0
    45ac:	00005517          	auipc	a0,0x5
    45b0:	fc450513          	addi	a0,a0,-60 # 9570 <malloc+0x15a6>
    45b4:	00003097          	auipc	ra,0x3
    45b8:	33c080e7          	jalr	828(ra) # 78f0 <open>
    45bc:	87aa                	mv	a5,a0
    45be:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    45c2:	fe442783          	lw	a5,-28(s0)
    45c6:	2781                	sext.w	a5,a5
    45c8:	0207d163          	bgez	a5,45ea <bigfile+0x128>
    printf("%s: cannot open bigfile\n", s);
    45cc:	fd843583          	ld	a1,-40(s0)
    45d0:	00005517          	auipc	a0,0x5
    45d4:	ff050513          	addi	a0,a0,-16 # 95c0 <malloc+0x15f6>
    45d8:	00004097          	auipc	ra,0x4
    45dc:	800080e7          	jalr	-2048(ra) # 7dd8 <printf>
    exit(1);
    45e0:	4505                	li	a0,1
    45e2:	00003097          	auipc	ra,0x3
    45e6:	2ce080e7          	jalr	718(ra) # 78b0 <exit>
  }
  total = 0;
    45ea:	fe042423          	sw	zero,-24(s0)
  for(i = 0; ; i++){
    45ee:	fe042623          	sw	zero,-20(s0)
    cc = read(fd, buf, SZ/2);
    45f2:	fe442783          	lw	a5,-28(s0)
    45f6:	12c00613          	li	a2,300
    45fa:	00008597          	auipc	a1,0x8
    45fe:	d0658593          	addi	a1,a1,-762 # c300 <buf>
    4602:	853e                	mv	a0,a5
    4604:	00003097          	auipc	ra,0x3
    4608:	2c4080e7          	jalr	708(ra) # 78c8 <read>
    460c:	87aa                	mv	a5,a0
    460e:	fef42023          	sw	a5,-32(s0)
    if(cc < 0){
    4612:	fe042783          	lw	a5,-32(s0)
    4616:	2781                	sext.w	a5,a5
    4618:	0207d163          	bgez	a5,463a <bigfile+0x178>
      printf("%s: read bigfile failed\n", s);
    461c:	fd843583          	ld	a1,-40(s0)
    4620:	00005517          	auipc	a0,0x5
    4624:	fc050513          	addi	a0,a0,-64 # 95e0 <malloc+0x1616>
    4628:	00003097          	auipc	ra,0x3
    462c:	7b0080e7          	jalr	1968(ra) # 7dd8 <printf>
      exit(1);
    4630:	4505                	li	a0,1
    4632:	00003097          	auipc	ra,0x3
    4636:	27e080e7          	jalr	638(ra) # 78b0 <exit>
    }
    if(cc == 0)
    463a:	fe042783          	lw	a5,-32(s0)
    463e:	2781                	sext.w	a5,a5
    4640:	cbdd                	beqz	a5,46f6 <bigfile+0x234>
      break;
    if(cc != SZ/2){
    4642:	fe042783          	lw	a5,-32(s0)
    4646:	0007871b          	sext.w	a4,a5
    464a:	12c00793          	li	a5,300
    464e:	02f70163          	beq	a4,a5,4670 <bigfile+0x1ae>
      printf("%s: short read bigfile\n", s);
    4652:	fd843583          	ld	a1,-40(s0)
    4656:	00005517          	auipc	a0,0x5
    465a:	faa50513          	addi	a0,a0,-86 # 9600 <malloc+0x1636>
    465e:	00003097          	auipc	ra,0x3
    4662:	77a080e7          	jalr	1914(ra) # 7dd8 <printf>
      exit(1);
    4666:	4505                	li	a0,1
    4668:	00003097          	auipc	ra,0x3
    466c:	248080e7          	jalr	584(ra) # 78b0 <exit>
    }
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4670:	00008797          	auipc	a5,0x8
    4674:	c9078793          	addi	a5,a5,-880 # c300 <buf>
    4678:	0007c783          	lbu	a5,0(a5)
    467c:	0007869b          	sext.w	a3,a5
    4680:	fec42783          	lw	a5,-20(s0)
    4684:	01f7d71b          	srliw	a4,a5,0x1f
    4688:	9fb9                	addw	a5,a5,a4
    468a:	4017d79b          	sraiw	a5,a5,0x1
    468e:	2781                	sext.w	a5,a5
    4690:	8736                	mv	a4,a3
    4692:	02f71563          	bne	a4,a5,46bc <bigfile+0x1fa>
    4696:	00008797          	auipc	a5,0x8
    469a:	c6a78793          	addi	a5,a5,-918 # c300 <buf>
    469e:	12b7c783          	lbu	a5,299(a5)
    46a2:	0007869b          	sext.w	a3,a5
    46a6:	fec42783          	lw	a5,-20(s0)
    46aa:	01f7d71b          	srliw	a4,a5,0x1f
    46ae:	9fb9                	addw	a5,a5,a4
    46b0:	4017d79b          	sraiw	a5,a5,0x1
    46b4:	2781                	sext.w	a5,a5
    46b6:	8736                	mv	a4,a3
    46b8:	02f70163          	beq	a4,a5,46da <bigfile+0x218>
      printf("%s: read bigfile wrong data\n", s);
    46bc:	fd843583          	ld	a1,-40(s0)
    46c0:	00005517          	auipc	a0,0x5
    46c4:	f5850513          	addi	a0,a0,-168 # 9618 <malloc+0x164e>
    46c8:	00003097          	auipc	ra,0x3
    46cc:	710080e7          	jalr	1808(ra) # 7dd8 <printf>
      exit(1);
    46d0:	4505                	li	a0,1
    46d2:	00003097          	auipc	ra,0x3
    46d6:	1de080e7          	jalr	478(ra) # 78b0 <exit>
    }
    total += cc;
    46da:	fe842783          	lw	a5,-24(s0)
    46de:	873e                	mv	a4,a5
    46e0:	fe042783          	lw	a5,-32(s0)
    46e4:	9fb9                	addw	a5,a5,a4
    46e6:	fef42423          	sw	a5,-24(s0)
  for(i = 0; ; i++){
    46ea:	fec42783          	lw	a5,-20(s0)
    46ee:	2785                	addiw	a5,a5,1
    46f0:	fef42623          	sw	a5,-20(s0)
    cc = read(fd, buf, SZ/2);
    46f4:	bdfd                	j	45f2 <bigfile+0x130>
      break;
    46f6:	0001                	nop
  }
  close(fd);
    46f8:	fe442783          	lw	a5,-28(s0)
    46fc:	853e                	mv	a0,a5
    46fe:	00003097          	auipc	ra,0x3
    4702:	1da080e7          	jalr	474(ra) # 78d8 <close>
  if(total != N*SZ){
    4706:	fe842783          	lw	a5,-24(s0)
    470a:	0007871b          	sext.w	a4,a5
    470e:	678d                	lui	a5,0x3
    4710:	ee078793          	addi	a5,a5,-288 # 2ee0 <createdelete+0x160>
    4714:	02f70163          	beq	a4,a5,4736 <bigfile+0x274>
    printf("%s: read bigfile wrong total\n", s);
    4718:	fd843583          	ld	a1,-40(s0)
    471c:	00005517          	auipc	a0,0x5
    4720:	f1c50513          	addi	a0,a0,-228 # 9638 <malloc+0x166e>
    4724:	00003097          	auipc	ra,0x3
    4728:	6b4080e7          	jalr	1716(ra) # 7dd8 <printf>
    exit(1);
    472c:	4505                	li	a0,1
    472e:	00003097          	auipc	ra,0x3
    4732:	182080e7          	jalr	386(ra) # 78b0 <exit>
  }
  unlink("bigfile.dat");
    4736:	00005517          	auipc	a0,0x5
    473a:	e3a50513          	addi	a0,a0,-454 # 9570 <malloc+0x15a6>
    473e:	00003097          	auipc	ra,0x3
    4742:	1c2080e7          	jalr	450(ra) # 7900 <unlink>
}
    4746:	0001                	nop
    4748:	70a2                	ld	ra,40(sp)
    474a:	7402                	ld	s0,32(sp)
    474c:	6145                	addi	sp,sp,48
    474e:	8082                	ret

0000000000004750 <fourteen>:

void
fourteen(char *s)
{
    4750:	7179                	addi	sp,sp,-48
    4752:	f406                	sd	ra,40(sp)
    4754:	f022                	sd	s0,32(sp)
    4756:	1800                	addi	s0,sp,48
    4758:	fca43c23          	sd	a0,-40(s0)
  int fd;

  // DIRSIZ is 14.

  if(mkdir("12345678901234") != 0){
    475c:	00005517          	auipc	a0,0x5
    4760:	efc50513          	addi	a0,a0,-260 # 9658 <malloc+0x168e>
    4764:	00003097          	auipc	ra,0x3
    4768:	1b4080e7          	jalr	436(ra) # 7918 <mkdir>
    476c:	87aa                	mv	a5,a0
    476e:	c385                	beqz	a5,478e <fourteen+0x3e>
    printf("%s: mkdir 12345678901234 failed\n", s);
    4770:	fd843583          	ld	a1,-40(s0)
    4774:	00005517          	auipc	a0,0x5
    4778:	ef450513          	addi	a0,a0,-268 # 9668 <malloc+0x169e>
    477c:	00003097          	auipc	ra,0x3
    4780:	65c080e7          	jalr	1628(ra) # 7dd8 <printf>
    exit(1);
    4784:	4505                	li	a0,1
    4786:	00003097          	auipc	ra,0x3
    478a:	12a080e7          	jalr	298(ra) # 78b0 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    478e:	00005517          	auipc	a0,0x5
    4792:	f0250513          	addi	a0,a0,-254 # 9690 <malloc+0x16c6>
    4796:	00003097          	auipc	ra,0x3
    479a:	182080e7          	jalr	386(ra) # 7918 <mkdir>
    479e:	87aa                	mv	a5,a0
    47a0:	c385                	beqz	a5,47c0 <fourteen+0x70>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    47a2:	fd843583          	ld	a1,-40(s0)
    47a6:	00005517          	auipc	a0,0x5
    47aa:	f0a50513          	addi	a0,a0,-246 # 96b0 <malloc+0x16e6>
    47ae:	00003097          	auipc	ra,0x3
    47b2:	62a080e7          	jalr	1578(ra) # 7dd8 <printf>
    exit(1);
    47b6:	4505                	li	a0,1
    47b8:	00003097          	auipc	ra,0x3
    47bc:	0f8080e7          	jalr	248(ra) # 78b0 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    47c0:	20000593          	li	a1,512
    47c4:	00005517          	auipc	a0,0x5
    47c8:	f2450513          	addi	a0,a0,-220 # 96e8 <malloc+0x171e>
    47cc:	00003097          	auipc	ra,0x3
    47d0:	124080e7          	jalr	292(ra) # 78f0 <open>
    47d4:	87aa                	mv	a5,a0
    47d6:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    47da:	fec42783          	lw	a5,-20(s0)
    47de:	2781                	sext.w	a5,a5
    47e0:	0207d163          	bgez	a5,4802 <fourteen+0xb2>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    47e4:	fd843583          	ld	a1,-40(s0)
    47e8:	00005517          	auipc	a0,0x5
    47ec:	f3050513          	addi	a0,a0,-208 # 9718 <malloc+0x174e>
    47f0:	00003097          	auipc	ra,0x3
    47f4:	5e8080e7          	jalr	1512(ra) # 7dd8 <printf>
    exit(1);
    47f8:	4505                	li	a0,1
    47fa:	00003097          	auipc	ra,0x3
    47fe:	0b6080e7          	jalr	182(ra) # 78b0 <exit>
  }
  close(fd);
    4802:	fec42783          	lw	a5,-20(s0)
    4806:	853e                	mv	a0,a5
    4808:	00003097          	auipc	ra,0x3
    480c:	0d0080e7          	jalr	208(ra) # 78d8 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    4810:	4581                	li	a1,0
    4812:	00005517          	auipc	a0,0x5
    4816:	f4e50513          	addi	a0,a0,-178 # 9760 <malloc+0x1796>
    481a:	00003097          	auipc	ra,0x3
    481e:	0d6080e7          	jalr	214(ra) # 78f0 <open>
    4822:	87aa                	mv	a5,a0
    4824:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    4828:	fec42783          	lw	a5,-20(s0)
    482c:	2781                	sext.w	a5,a5
    482e:	0207d163          	bgez	a5,4850 <fourteen+0x100>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    4832:	fd843583          	ld	a1,-40(s0)
    4836:	00005517          	auipc	a0,0x5
    483a:	f5a50513          	addi	a0,a0,-166 # 9790 <malloc+0x17c6>
    483e:	00003097          	auipc	ra,0x3
    4842:	59a080e7          	jalr	1434(ra) # 7dd8 <printf>
    exit(1);
    4846:	4505                	li	a0,1
    4848:	00003097          	auipc	ra,0x3
    484c:	068080e7          	jalr	104(ra) # 78b0 <exit>
  }
  close(fd);
    4850:	fec42783          	lw	a5,-20(s0)
    4854:	853e                	mv	a0,a5
    4856:	00003097          	auipc	ra,0x3
    485a:	082080e7          	jalr	130(ra) # 78d8 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    485e:	00005517          	auipc	a0,0x5
    4862:	f7250513          	addi	a0,a0,-142 # 97d0 <malloc+0x1806>
    4866:	00003097          	auipc	ra,0x3
    486a:	0b2080e7          	jalr	178(ra) # 7918 <mkdir>
    486e:	87aa                	mv	a5,a0
    4870:	e385                	bnez	a5,4890 <fourteen+0x140>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    4872:	fd843583          	ld	a1,-40(s0)
    4876:	00005517          	auipc	a0,0x5
    487a:	f7a50513          	addi	a0,a0,-134 # 97f0 <malloc+0x1826>
    487e:	00003097          	auipc	ra,0x3
    4882:	55a080e7          	jalr	1370(ra) # 7dd8 <printf>
    exit(1);
    4886:	4505                	li	a0,1
    4888:	00003097          	auipc	ra,0x3
    488c:	028080e7          	jalr	40(ra) # 78b0 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    4890:	00005517          	auipc	a0,0x5
    4894:	f9850513          	addi	a0,a0,-104 # 9828 <malloc+0x185e>
    4898:	00003097          	auipc	ra,0x3
    489c:	080080e7          	jalr	128(ra) # 7918 <mkdir>
    48a0:	87aa                	mv	a5,a0
    48a2:	e385                	bnez	a5,48c2 <fourteen+0x172>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    48a4:	fd843583          	ld	a1,-40(s0)
    48a8:	00005517          	auipc	a0,0x5
    48ac:	fa050513          	addi	a0,a0,-96 # 9848 <malloc+0x187e>
    48b0:	00003097          	auipc	ra,0x3
    48b4:	528080e7          	jalr	1320(ra) # 7dd8 <printf>
    exit(1);
    48b8:	4505                	li	a0,1
    48ba:	00003097          	auipc	ra,0x3
    48be:	ff6080e7          	jalr	-10(ra) # 78b0 <exit>
  }

  // clean up
  unlink("123456789012345/12345678901234");
    48c2:	00005517          	auipc	a0,0x5
    48c6:	f6650513          	addi	a0,a0,-154 # 9828 <malloc+0x185e>
    48ca:	00003097          	auipc	ra,0x3
    48ce:	036080e7          	jalr	54(ra) # 7900 <unlink>
  unlink("12345678901234/12345678901234");
    48d2:	00005517          	auipc	a0,0x5
    48d6:	efe50513          	addi	a0,a0,-258 # 97d0 <malloc+0x1806>
    48da:	00003097          	auipc	ra,0x3
    48de:	026080e7          	jalr	38(ra) # 7900 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    48e2:	00005517          	auipc	a0,0x5
    48e6:	e7e50513          	addi	a0,a0,-386 # 9760 <malloc+0x1796>
    48ea:	00003097          	auipc	ra,0x3
    48ee:	016080e7          	jalr	22(ra) # 7900 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    48f2:	00005517          	auipc	a0,0x5
    48f6:	df650513          	addi	a0,a0,-522 # 96e8 <malloc+0x171e>
    48fa:	00003097          	auipc	ra,0x3
    48fe:	006080e7          	jalr	6(ra) # 7900 <unlink>
  unlink("12345678901234/123456789012345");
    4902:	00005517          	auipc	a0,0x5
    4906:	d8e50513          	addi	a0,a0,-626 # 9690 <malloc+0x16c6>
    490a:	00003097          	auipc	ra,0x3
    490e:	ff6080e7          	jalr	-10(ra) # 7900 <unlink>
  unlink("12345678901234");
    4912:	00005517          	auipc	a0,0x5
    4916:	d4650513          	addi	a0,a0,-698 # 9658 <malloc+0x168e>
    491a:	00003097          	auipc	ra,0x3
    491e:	fe6080e7          	jalr	-26(ra) # 7900 <unlink>
}
    4922:	0001                	nop
    4924:	70a2                	ld	ra,40(sp)
    4926:	7402                	ld	s0,32(sp)
    4928:	6145                	addi	sp,sp,48
    492a:	8082                	ret

000000000000492c <rmdot>:

void
rmdot(char *s)
{
    492c:	1101                	addi	sp,sp,-32
    492e:	ec06                	sd	ra,24(sp)
    4930:	e822                	sd	s0,16(sp)
    4932:	1000                	addi	s0,sp,32
    4934:	fea43423          	sd	a0,-24(s0)
  if(mkdir("dots") != 0){
    4938:	00005517          	auipc	a0,0x5
    493c:	f4850513          	addi	a0,a0,-184 # 9880 <malloc+0x18b6>
    4940:	00003097          	auipc	ra,0x3
    4944:	fd8080e7          	jalr	-40(ra) # 7918 <mkdir>
    4948:	87aa                	mv	a5,a0
    494a:	c385                	beqz	a5,496a <rmdot+0x3e>
    printf("%s: mkdir dots failed\n", s);
    494c:	fe843583          	ld	a1,-24(s0)
    4950:	00005517          	auipc	a0,0x5
    4954:	f3850513          	addi	a0,a0,-200 # 9888 <malloc+0x18be>
    4958:	00003097          	auipc	ra,0x3
    495c:	480080e7          	jalr	1152(ra) # 7dd8 <printf>
    exit(1);
    4960:	4505                	li	a0,1
    4962:	00003097          	auipc	ra,0x3
    4966:	f4e080e7          	jalr	-178(ra) # 78b0 <exit>
  }
  if(chdir("dots") != 0){
    496a:	00005517          	auipc	a0,0x5
    496e:	f1650513          	addi	a0,a0,-234 # 9880 <malloc+0x18b6>
    4972:	00003097          	auipc	ra,0x3
    4976:	fae080e7          	jalr	-82(ra) # 7920 <chdir>
    497a:	87aa                	mv	a5,a0
    497c:	c385                	beqz	a5,499c <rmdot+0x70>
    printf("%s: chdir dots failed\n", s);
    497e:	fe843583          	ld	a1,-24(s0)
    4982:	00005517          	auipc	a0,0x5
    4986:	f1e50513          	addi	a0,a0,-226 # 98a0 <malloc+0x18d6>
    498a:	00003097          	auipc	ra,0x3
    498e:	44e080e7          	jalr	1102(ra) # 7dd8 <printf>
    exit(1);
    4992:	4505                	li	a0,1
    4994:	00003097          	auipc	ra,0x3
    4998:	f1c080e7          	jalr	-228(ra) # 78b0 <exit>
  }
  if(unlink(".") == 0){
    499c:	00004517          	auipc	a0,0x4
    49a0:	53c50513          	addi	a0,a0,1340 # 8ed8 <malloc+0xf0e>
    49a4:	00003097          	auipc	ra,0x3
    49a8:	f5c080e7          	jalr	-164(ra) # 7900 <unlink>
    49ac:	87aa                	mv	a5,a0
    49ae:	e385                	bnez	a5,49ce <rmdot+0xa2>
    printf("%s: rm . worked!\n", s);
    49b0:	fe843583          	ld	a1,-24(s0)
    49b4:	00005517          	auipc	a0,0x5
    49b8:	f0450513          	addi	a0,a0,-252 # 98b8 <malloc+0x18ee>
    49bc:	00003097          	auipc	ra,0x3
    49c0:	41c080e7          	jalr	1052(ra) # 7dd8 <printf>
    exit(1);
    49c4:	4505                	li	a0,1
    49c6:	00003097          	auipc	ra,0x3
    49ca:	eea080e7          	jalr	-278(ra) # 78b0 <exit>
  }
  if(unlink("..") == 0){
    49ce:	00004517          	auipc	a0,0x4
    49d2:	f6250513          	addi	a0,a0,-158 # 8930 <malloc+0x966>
    49d6:	00003097          	auipc	ra,0x3
    49da:	f2a080e7          	jalr	-214(ra) # 7900 <unlink>
    49de:	87aa                	mv	a5,a0
    49e0:	e385                	bnez	a5,4a00 <rmdot+0xd4>
    printf("%s: rm .. worked!\n", s);
    49e2:	fe843583          	ld	a1,-24(s0)
    49e6:	00005517          	auipc	a0,0x5
    49ea:	eea50513          	addi	a0,a0,-278 # 98d0 <malloc+0x1906>
    49ee:	00003097          	auipc	ra,0x3
    49f2:	3ea080e7          	jalr	1002(ra) # 7dd8 <printf>
    exit(1);
    49f6:	4505                	li	a0,1
    49f8:	00003097          	auipc	ra,0x3
    49fc:	eb8080e7          	jalr	-328(ra) # 78b0 <exit>
  }
  if(chdir("/") != 0){
    4a00:	00004517          	auipc	a0,0x4
    4a04:	c4850513          	addi	a0,a0,-952 # 8648 <malloc+0x67e>
    4a08:	00003097          	auipc	ra,0x3
    4a0c:	f18080e7          	jalr	-232(ra) # 7920 <chdir>
    4a10:	87aa                	mv	a5,a0
    4a12:	c385                	beqz	a5,4a32 <rmdot+0x106>
    printf("%s: chdir / failed\n", s);
    4a14:	fe843583          	ld	a1,-24(s0)
    4a18:	00004517          	auipc	a0,0x4
    4a1c:	c3850513          	addi	a0,a0,-968 # 8650 <malloc+0x686>
    4a20:	00003097          	auipc	ra,0x3
    4a24:	3b8080e7          	jalr	952(ra) # 7dd8 <printf>
    exit(1);
    4a28:	4505                	li	a0,1
    4a2a:	00003097          	auipc	ra,0x3
    4a2e:	e86080e7          	jalr	-378(ra) # 78b0 <exit>
  }
  if(unlink("dots/.") == 0){
    4a32:	00005517          	auipc	a0,0x5
    4a36:	eb650513          	addi	a0,a0,-330 # 98e8 <malloc+0x191e>
    4a3a:	00003097          	auipc	ra,0x3
    4a3e:	ec6080e7          	jalr	-314(ra) # 7900 <unlink>
    4a42:	87aa                	mv	a5,a0
    4a44:	e385                	bnez	a5,4a64 <rmdot+0x138>
    printf("%s: unlink dots/. worked!\n", s);
    4a46:	fe843583          	ld	a1,-24(s0)
    4a4a:	00005517          	auipc	a0,0x5
    4a4e:	ea650513          	addi	a0,a0,-346 # 98f0 <malloc+0x1926>
    4a52:	00003097          	auipc	ra,0x3
    4a56:	386080e7          	jalr	902(ra) # 7dd8 <printf>
    exit(1);
    4a5a:	4505                	li	a0,1
    4a5c:	00003097          	auipc	ra,0x3
    4a60:	e54080e7          	jalr	-428(ra) # 78b0 <exit>
  }
  if(unlink("dots/..") == 0){
    4a64:	00005517          	auipc	a0,0x5
    4a68:	eac50513          	addi	a0,a0,-340 # 9910 <malloc+0x1946>
    4a6c:	00003097          	auipc	ra,0x3
    4a70:	e94080e7          	jalr	-364(ra) # 7900 <unlink>
    4a74:	87aa                	mv	a5,a0
    4a76:	e385                	bnez	a5,4a96 <rmdot+0x16a>
    printf("%s: unlink dots/.. worked!\n", s);
    4a78:	fe843583          	ld	a1,-24(s0)
    4a7c:	00005517          	auipc	a0,0x5
    4a80:	e9c50513          	addi	a0,a0,-356 # 9918 <malloc+0x194e>
    4a84:	00003097          	auipc	ra,0x3
    4a88:	354080e7          	jalr	852(ra) # 7dd8 <printf>
    exit(1);
    4a8c:	4505                	li	a0,1
    4a8e:	00003097          	auipc	ra,0x3
    4a92:	e22080e7          	jalr	-478(ra) # 78b0 <exit>
  }
  if(unlink("dots") != 0){
    4a96:	00005517          	auipc	a0,0x5
    4a9a:	dea50513          	addi	a0,a0,-534 # 9880 <malloc+0x18b6>
    4a9e:	00003097          	auipc	ra,0x3
    4aa2:	e62080e7          	jalr	-414(ra) # 7900 <unlink>
    4aa6:	87aa                	mv	a5,a0
    4aa8:	c385                	beqz	a5,4ac8 <rmdot+0x19c>
    printf("%s: unlink dots failed!\n", s);
    4aaa:	fe843583          	ld	a1,-24(s0)
    4aae:	00005517          	auipc	a0,0x5
    4ab2:	e8a50513          	addi	a0,a0,-374 # 9938 <malloc+0x196e>
    4ab6:	00003097          	auipc	ra,0x3
    4aba:	322080e7          	jalr	802(ra) # 7dd8 <printf>
    exit(1);
    4abe:	4505                	li	a0,1
    4ac0:	00003097          	auipc	ra,0x3
    4ac4:	df0080e7          	jalr	-528(ra) # 78b0 <exit>
  }
}
    4ac8:	0001                	nop
    4aca:	60e2                	ld	ra,24(sp)
    4acc:	6442                	ld	s0,16(sp)
    4ace:	6105                	addi	sp,sp,32
    4ad0:	8082                	ret

0000000000004ad2 <dirfile>:

void
dirfile(char *s)
{
    4ad2:	7179                	addi	sp,sp,-48
    4ad4:	f406                	sd	ra,40(sp)
    4ad6:	f022                	sd	s0,32(sp)
    4ad8:	1800                	addi	s0,sp,48
    4ada:	fca43c23          	sd	a0,-40(s0)
  int fd;

  fd = open("dirfile", O_CREATE);
    4ade:	20000593          	li	a1,512
    4ae2:	00005517          	auipc	a0,0x5
    4ae6:	e7650513          	addi	a0,a0,-394 # 9958 <malloc+0x198e>
    4aea:	00003097          	auipc	ra,0x3
    4aee:	e06080e7          	jalr	-506(ra) # 78f0 <open>
    4af2:	87aa                	mv	a5,a0
    4af4:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    4af8:	fec42783          	lw	a5,-20(s0)
    4afc:	2781                	sext.w	a5,a5
    4afe:	0207d163          	bgez	a5,4b20 <dirfile+0x4e>
    printf("%s: create dirfile failed\n", s);
    4b02:	fd843583          	ld	a1,-40(s0)
    4b06:	00005517          	auipc	a0,0x5
    4b0a:	e5a50513          	addi	a0,a0,-422 # 9960 <malloc+0x1996>
    4b0e:	00003097          	auipc	ra,0x3
    4b12:	2ca080e7          	jalr	714(ra) # 7dd8 <printf>
    exit(1);
    4b16:	4505                	li	a0,1
    4b18:	00003097          	auipc	ra,0x3
    4b1c:	d98080e7          	jalr	-616(ra) # 78b0 <exit>
  }
  close(fd);
    4b20:	fec42783          	lw	a5,-20(s0)
    4b24:	853e                	mv	a0,a5
    4b26:	00003097          	auipc	ra,0x3
    4b2a:	db2080e7          	jalr	-590(ra) # 78d8 <close>
  if(chdir("dirfile") == 0){
    4b2e:	00005517          	auipc	a0,0x5
    4b32:	e2a50513          	addi	a0,a0,-470 # 9958 <malloc+0x198e>
    4b36:	00003097          	auipc	ra,0x3
    4b3a:	dea080e7          	jalr	-534(ra) # 7920 <chdir>
    4b3e:	87aa                	mv	a5,a0
    4b40:	e385                	bnez	a5,4b60 <dirfile+0x8e>
    printf("%s: chdir dirfile succeeded!\n", s);
    4b42:	fd843583          	ld	a1,-40(s0)
    4b46:	00005517          	auipc	a0,0x5
    4b4a:	e3a50513          	addi	a0,a0,-454 # 9980 <malloc+0x19b6>
    4b4e:	00003097          	auipc	ra,0x3
    4b52:	28a080e7          	jalr	650(ra) # 7dd8 <printf>
    exit(1);
    4b56:	4505                	li	a0,1
    4b58:	00003097          	auipc	ra,0x3
    4b5c:	d58080e7          	jalr	-680(ra) # 78b0 <exit>
  }
  fd = open("dirfile/xx", 0);
    4b60:	4581                	li	a1,0
    4b62:	00005517          	auipc	a0,0x5
    4b66:	e3e50513          	addi	a0,a0,-450 # 99a0 <malloc+0x19d6>
    4b6a:	00003097          	auipc	ra,0x3
    4b6e:	d86080e7          	jalr	-634(ra) # 78f0 <open>
    4b72:	87aa                	mv	a5,a0
    4b74:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    4b78:	fec42783          	lw	a5,-20(s0)
    4b7c:	2781                	sext.w	a5,a5
    4b7e:	0207c163          	bltz	a5,4ba0 <dirfile+0xce>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4b82:	fd843583          	ld	a1,-40(s0)
    4b86:	00005517          	auipc	a0,0x5
    4b8a:	e2a50513          	addi	a0,a0,-470 # 99b0 <malloc+0x19e6>
    4b8e:	00003097          	auipc	ra,0x3
    4b92:	24a080e7          	jalr	586(ra) # 7dd8 <printf>
    exit(1);
    4b96:	4505                	li	a0,1
    4b98:	00003097          	auipc	ra,0x3
    4b9c:	d18080e7          	jalr	-744(ra) # 78b0 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    4ba0:	20000593          	li	a1,512
    4ba4:	00005517          	auipc	a0,0x5
    4ba8:	dfc50513          	addi	a0,a0,-516 # 99a0 <malloc+0x19d6>
    4bac:	00003097          	auipc	ra,0x3
    4bb0:	d44080e7          	jalr	-700(ra) # 78f0 <open>
    4bb4:	87aa                	mv	a5,a0
    4bb6:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    4bba:	fec42783          	lw	a5,-20(s0)
    4bbe:	2781                	sext.w	a5,a5
    4bc0:	0207c163          	bltz	a5,4be2 <dirfile+0x110>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4bc4:	fd843583          	ld	a1,-40(s0)
    4bc8:	00005517          	auipc	a0,0x5
    4bcc:	de850513          	addi	a0,a0,-536 # 99b0 <malloc+0x19e6>
    4bd0:	00003097          	auipc	ra,0x3
    4bd4:	208080e7          	jalr	520(ra) # 7dd8 <printf>
    exit(1);
    4bd8:	4505                	li	a0,1
    4bda:	00003097          	auipc	ra,0x3
    4bde:	cd6080e7          	jalr	-810(ra) # 78b0 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    4be2:	00005517          	auipc	a0,0x5
    4be6:	dbe50513          	addi	a0,a0,-578 # 99a0 <malloc+0x19d6>
    4bea:	00003097          	auipc	ra,0x3
    4bee:	d2e080e7          	jalr	-722(ra) # 7918 <mkdir>
    4bf2:	87aa                	mv	a5,a0
    4bf4:	e385                	bnez	a5,4c14 <dirfile+0x142>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4bf6:	fd843583          	ld	a1,-40(s0)
    4bfa:	00005517          	auipc	a0,0x5
    4bfe:	dde50513          	addi	a0,a0,-546 # 99d8 <malloc+0x1a0e>
    4c02:	00003097          	auipc	ra,0x3
    4c06:	1d6080e7          	jalr	470(ra) # 7dd8 <printf>
    exit(1);
    4c0a:	4505                	li	a0,1
    4c0c:	00003097          	auipc	ra,0x3
    4c10:	ca4080e7          	jalr	-860(ra) # 78b0 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    4c14:	00005517          	auipc	a0,0x5
    4c18:	d8c50513          	addi	a0,a0,-628 # 99a0 <malloc+0x19d6>
    4c1c:	00003097          	auipc	ra,0x3
    4c20:	ce4080e7          	jalr	-796(ra) # 7900 <unlink>
    4c24:	87aa                	mv	a5,a0
    4c26:	e385                	bnez	a5,4c46 <dirfile+0x174>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4c28:	fd843583          	ld	a1,-40(s0)
    4c2c:	00005517          	auipc	a0,0x5
    4c30:	dd450513          	addi	a0,a0,-556 # 9a00 <malloc+0x1a36>
    4c34:	00003097          	auipc	ra,0x3
    4c38:	1a4080e7          	jalr	420(ra) # 7dd8 <printf>
    exit(1);
    4c3c:	4505                	li	a0,1
    4c3e:	00003097          	auipc	ra,0x3
    4c42:	c72080e7          	jalr	-910(ra) # 78b0 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    4c46:	00005597          	auipc	a1,0x5
    4c4a:	d5a58593          	addi	a1,a1,-678 # 99a0 <malloc+0x19d6>
    4c4e:	00003517          	auipc	a0,0x3
    4c52:	58250513          	addi	a0,a0,1410 # 81d0 <malloc+0x206>
    4c56:	00003097          	auipc	ra,0x3
    4c5a:	cba080e7          	jalr	-838(ra) # 7910 <link>
    4c5e:	87aa                	mv	a5,a0
    4c60:	e385                	bnez	a5,4c80 <dirfile+0x1ae>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4c62:	fd843583          	ld	a1,-40(s0)
    4c66:	00005517          	auipc	a0,0x5
    4c6a:	dc250513          	addi	a0,a0,-574 # 9a28 <malloc+0x1a5e>
    4c6e:	00003097          	auipc	ra,0x3
    4c72:	16a080e7          	jalr	362(ra) # 7dd8 <printf>
    exit(1);
    4c76:	4505                	li	a0,1
    4c78:	00003097          	auipc	ra,0x3
    4c7c:	c38080e7          	jalr	-968(ra) # 78b0 <exit>
  }
  if(unlink("dirfile") != 0){
    4c80:	00005517          	auipc	a0,0x5
    4c84:	cd850513          	addi	a0,a0,-808 # 9958 <malloc+0x198e>
    4c88:	00003097          	auipc	ra,0x3
    4c8c:	c78080e7          	jalr	-904(ra) # 7900 <unlink>
    4c90:	87aa                	mv	a5,a0
    4c92:	c385                	beqz	a5,4cb2 <dirfile+0x1e0>
    printf("%s: unlink dirfile failed!\n", s);
    4c94:	fd843583          	ld	a1,-40(s0)
    4c98:	00005517          	auipc	a0,0x5
    4c9c:	db850513          	addi	a0,a0,-584 # 9a50 <malloc+0x1a86>
    4ca0:	00003097          	auipc	ra,0x3
    4ca4:	138080e7          	jalr	312(ra) # 7dd8 <printf>
    exit(1);
    4ca8:	4505                	li	a0,1
    4caa:	00003097          	auipc	ra,0x3
    4cae:	c06080e7          	jalr	-1018(ra) # 78b0 <exit>
  }

  fd = open(".", O_RDWR);
    4cb2:	4589                	li	a1,2
    4cb4:	00004517          	auipc	a0,0x4
    4cb8:	22450513          	addi	a0,a0,548 # 8ed8 <malloc+0xf0e>
    4cbc:	00003097          	auipc	ra,0x3
    4cc0:	c34080e7          	jalr	-972(ra) # 78f0 <open>
    4cc4:	87aa                	mv	a5,a0
    4cc6:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    4cca:	fec42783          	lw	a5,-20(s0)
    4cce:	2781                	sext.w	a5,a5
    4cd0:	0207c163          	bltz	a5,4cf2 <dirfile+0x220>
    printf("%s: open . for writing succeeded!\n", s);
    4cd4:	fd843583          	ld	a1,-40(s0)
    4cd8:	00005517          	auipc	a0,0x5
    4cdc:	d9850513          	addi	a0,a0,-616 # 9a70 <malloc+0x1aa6>
    4ce0:	00003097          	auipc	ra,0x3
    4ce4:	0f8080e7          	jalr	248(ra) # 7dd8 <printf>
    exit(1);
    4ce8:	4505                	li	a0,1
    4cea:	00003097          	auipc	ra,0x3
    4cee:	bc6080e7          	jalr	-1082(ra) # 78b0 <exit>
  }
  fd = open(".", 0);
    4cf2:	4581                	li	a1,0
    4cf4:	00004517          	auipc	a0,0x4
    4cf8:	1e450513          	addi	a0,a0,484 # 8ed8 <malloc+0xf0e>
    4cfc:	00003097          	auipc	ra,0x3
    4d00:	bf4080e7          	jalr	-1036(ra) # 78f0 <open>
    4d04:	87aa                	mv	a5,a0
    4d06:	fef42623          	sw	a5,-20(s0)
  if(write(fd, "x", 1) > 0){
    4d0a:	fec42783          	lw	a5,-20(s0)
    4d0e:	4605                	li	a2,1
    4d10:	00003597          	auipc	a1,0x3
    4d14:	51058593          	addi	a1,a1,1296 # 8220 <malloc+0x256>
    4d18:	853e                	mv	a0,a5
    4d1a:	00003097          	auipc	ra,0x3
    4d1e:	bb6080e7          	jalr	-1098(ra) # 78d0 <write>
    4d22:	87aa                	mv	a5,a0
    4d24:	02f05163          	blez	a5,4d46 <dirfile+0x274>
    printf("%s: write . succeeded!\n", s);
    4d28:	fd843583          	ld	a1,-40(s0)
    4d2c:	00005517          	auipc	a0,0x5
    4d30:	d6c50513          	addi	a0,a0,-660 # 9a98 <malloc+0x1ace>
    4d34:	00003097          	auipc	ra,0x3
    4d38:	0a4080e7          	jalr	164(ra) # 7dd8 <printf>
    exit(1);
    4d3c:	4505                	li	a0,1
    4d3e:	00003097          	auipc	ra,0x3
    4d42:	b72080e7          	jalr	-1166(ra) # 78b0 <exit>
  }
  close(fd);
    4d46:	fec42783          	lw	a5,-20(s0)
    4d4a:	853e                	mv	a0,a5
    4d4c:	00003097          	auipc	ra,0x3
    4d50:	b8c080e7          	jalr	-1140(ra) # 78d8 <close>
}
    4d54:	0001                	nop
    4d56:	70a2                	ld	ra,40(sp)
    4d58:	7402                	ld	s0,32(sp)
    4d5a:	6145                	addi	sp,sp,48
    4d5c:	8082                	ret

0000000000004d5e <iref>:

// test that iput() is called at the end of _namei().
// also tests empty file names.
void
iref(char *s)
{
    4d5e:	7179                	addi	sp,sp,-48
    4d60:	f406                	sd	ra,40(sp)
    4d62:	f022                	sd	s0,32(sp)
    4d64:	1800                	addi	s0,sp,48
    4d66:	fca43c23          	sd	a0,-40(s0)
  int i, fd;

  for(i = 0; i < NINODE + 1; i++){
    4d6a:	fe042623          	sw	zero,-20(s0)
    4d6e:	a231                	j	4e7a <iref+0x11c>
    if(mkdir("irefd") != 0){
    4d70:	00005517          	auipc	a0,0x5
    4d74:	d4050513          	addi	a0,a0,-704 # 9ab0 <malloc+0x1ae6>
    4d78:	00003097          	auipc	ra,0x3
    4d7c:	ba0080e7          	jalr	-1120(ra) # 7918 <mkdir>
    4d80:	87aa                	mv	a5,a0
    4d82:	c385                	beqz	a5,4da2 <iref+0x44>
      printf("%s: mkdir irefd failed\n", s);
    4d84:	fd843583          	ld	a1,-40(s0)
    4d88:	00005517          	auipc	a0,0x5
    4d8c:	d3050513          	addi	a0,a0,-720 # 9ab8 <malloc+0x1aee>
    4d90:	00003097          	auipc	ra,0x3
    4d94:	048080e7          	jalr	72(ra) # 7dd8 <printf>
      exit(1);
    4d98:	4505                	li	a0,1
    4d9a:	00003097          	auipc	ra,0x3
    4d9e:	b16080e7          	jalr	-1258(ra) # 78b0 <exit>
    }
    if(chdir("irefd") != 0){
    4da2:	00005517          	auipc	a0,0x5
    4da6:	d0e50513          	addi	a0,a0,-754 # 9ab0 <malloc+0x1ae6>
    4daa:	00003097          	auipc	ra,0x3
    4dae:	b76080e7          	jalr	-1162(ra) # 7920 <chdir>
    4db2:	87aa                	mv	a5,a0
    4db4:	c385                	beqz	a5,4dd4 <iref+0x76>
      printf("%s: chdir irefd failed\n", s);
    4db6:	fd843583          	ld	a1,-40(s0)
    4dba:	00005517          	auipc	a0,0x5
    4dbe:	d1650513          	addi	a0,a0,-746 # 9ad0 <malloc+0x1b06>
    4dc2:	00003097          	auipc	ra,0x3
    4dc6:	016080e7          	jalr	22(ra) # 7dd8 <printf>
      exit(1);
    4dca:	4505                	li	a0,1
    4dcc:	00003097          	auipc	ra,0x3
    4dd0:	ae4080e7          	jalr	-1308(ra) # 78b0 <exit>
    }

    mkdir("");
    4dd4:	00005517          	auipc	a0,0x5
    4dd8:	d1450513          	addi	a0,a0,-748 # 9ae8 <malloc+0x1b1e>
    4ddc:	00003097          	auipc	ra,0x3
    4de0:	b3c080e7          	jalr	-1220(ra) # 7918 <mkdir>
    link("README", "");
    4de4:	00005597          	auipc	a1,0x5
    4de8:	d0458593          	addi	a1,a1,-764 # 9ae8 <malloc+0x1b1e>
    4dec:	00003517          	auipc	a0,0x3
    4df0:	3e450513          	addi	a0,a0,996 # 81d0 <malloc+0x206>
    4df4:	00003097          	auipc	ra,0x3
    4df8:	b1c080e7          	jalr	-1252(ra) # 7910 <link>
    fd = open("", O_CREATE);
    4dfc:	20000593          	li	a1,512
    4e00:	00005517          	auipc	a0,0x5
    4e04:	ce850513          	addi	a0,a0,-792 # 9ae8 <malloc+0x1b1e>
    4e08:	00003097          	auipc	ra,0x3
    4e0c:	ae8080e7          	jalr	-1304(ra) # 78f0 <open>
    4e10:	87aa                	mv	a5,a0
    4e12:	fef42423          	sw	a5,-24(s0)
    if(fd >= 0)
    4e16:	fe842783          	lw	a5,-24(s0)
    4e1a:	2781                	sext.w	a5,a5
    4e1c:	0007c963          	bltz	a5,4e2e <iref+0xd0>
      close(fd);
    4e20:	fe842783          	lw	a5,-24(s0)
    4e24:	853e                	mv	a0,a5
    4e26:	00003097          	auipc	ra,0x3
    4e2a:	ab2080e7          	jalr	-1358(ra) # 78d8 <close>
    fd = open("xx", O_CREATE);
    4e2e:	20000593          	li	a1,512
    4e32:	00003517          	auipc	a0,0x3
    4e36:	4c650513          	addi	a0,a0,1222 # 82f8 <malloc+0x32e>
    4e3a:	00003097          	auipc	ra,0x3
    4e3e:	ab6080e7          	jalr	-1354(ra) # 78f0 <open>
    4e42:	87aa                	mv	a5,a0
    4e44:	fef42423          	sw	a5,-24(s0)
    if(fd >= 0)
    4e48:	fe842783          	lw	a5,-24(s0)
    4e4c:	2781                	sext.w	a5,a5
    4e4e:	0007c963          	bltz	a5,4e60 <iref+0x102>
      close(fd);
    4e52:	fe842783          	lw	a5,-24(s0)
    4e56:	853e                	mv	a0,a5
    4e58:	00003097          	auipc	ra,0x3
    4e5c:	a80080e7          	jalr	-1408(ra) # 78d8 <close>
    unlink("xx");
    4e60:	00003517          	auipc	a0,0x3
    4e64:	49850513          	addi	a0,a0,1176 # 82f8 <malloc+0x32e>
    4e68:	00003097          	auipc	ra,0x3
    4e6c:	a98080e7          	jalr	-1384(ra) # 7900 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4e70:	fec42783          	lw	a5,-20(s0)
    4e74:	2785                	addiw	a5,a5,1
    4e76:	fef42623          	sw	a5,-20(s0)
    4e7a:	fec42783          	lw	a5,-20(s0)
    4e7e:	0007871b          	sext.w	a4,a5
    4e82:	03200793          	li	a5,50
    4e86:	eee7d5e3          	bge	a5,a4,4d70 <iref+0x12>
  }

  // clean up
  for(i = 0; i < NINODE + 1; i++){
    4e8a:	fe042623          	sw	zero,-20(s0)
    4e8e:	a035                	j	4eba <iref+0x15c>
    chdir("..");
    4e90:	00004517          	auipc	a0,0x4
    4e94:	aa050513          	addi	a0,a0,-1376 # 8930 <malloc+0x966>
    4e98:	00003097          	auipc	ra,0x3
    4e9c:	a88080e7          	jalr	-1400(ra) # 7920 <chdir>
    unlink("irefd");
    4ea0:	00005517          	auipc	a0,0x5
    4ea4:	c1050513          	addi	a0,a0,-1008 # 9ab0 <malloc+0x1ae6>
    4ea8:	00003097          	auipc	ra,0x3
    4eac:	a58080e7          	jalr	-1448(ra) # 7900 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4eb0:	fec42783          	lw	a5,-20(s0)
    4eb4:	2785                	addiw	a5,a5,1
    4eb6:	fef42623          	sw	a5,-20(s0)
    4eba:	fec42783          	lw	a5,-20(s0)
    4ebe:	0007871b          	sext.w	a4,a5
    4ec2:	03200793          	li	a5,50
    4ec6:	fce7d5e3          	bge	a5,a4,4e90 <iref+0x132>
  }

  chdir("/");
    4eca:	00003517          	auipc	a0,0x3
    4ece:	77e50513          	addi	a0,a0,1918 # 8648 <malloc+0x67e>
    4ed2:	00003097          	auipc	ra,0x3
    4ed6:	a4e080e7          	jalr	-1458(ra) # 7920 <chdir>
}
    4eda:	0001                	nop
    4edc:	70a2                	ld	ra,40(sp)
    4ede:	7402                	ld	s0,32(sp)
    4ee0:	6145                	addi	sp,sp,48
    4ee2:	8082                	ret

0000000000004ee4 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(char *s)
{
    4ee4:	7179                	addi	sp,sp,-48
    4ee6:	f406                	sd	ra,40(sp)
    4ee8:	f022                	sd	s0,32(sp)
    4eea:	1800                	addi	s0,sp,48
    4eec:	fca43c23          	sd	a0,-40(s0)
  enum{ N = 1000 };
  int n, pid;

  for(n=0; n<N; n++){
    4ef0:	fe042623          	sw	zero,-20(s0)
    4ef4:	a81d                	j	4f2a <forktest+0x46>
    pid = fork();
    4ef6:	00003097          	auipc	ra,0x3
    4efa:	9b2080e7          	jalr	-1614(ra) # 78a8 <fork>
    4efe:	87aa                	mv	a5,a0
    4f00:	fef42423          	sw	a5,-24(s0)
    if(pid < 0)
    4f04:	fe842783          	lw	a5,-24(s0)
    4f08:	2781                	sext.w	a5,a5
    4f0a:	0207c963          	bltz	a5,4f3c <forktest+0x58>
      break;
    if(pid == 0)
    4f0e:	fe842783          	lw	a5,-24(s0)
    4f12:	2781                	sext.w	a5,a5
    4f14:	e791                	bnez	a5,4f20 <forktest+0x3c>
      exit(0);
    4f16:	4501                	li	a0,0
    4f18:	00003097          	auipc	ra,0x3
    4f1c:	998080e7          	jalr	-1640(ra) # 78b0 <exit>
  for(n=0; n<N; n++){
    4f20:	fec42783          	lw	a5,-20(s0)
    4f24:	2785                	addiw	a5,a5,1
    4f26:	fef42623          	sw	a5,-20(s0)
    4f2a:	fec42783          	lw	a5,-20(s0)
    4f2e:	0007871b          	sext.w	a4,a5
    4f32:	3e700793          	li	a5,999
    4f36:	fce7d0e3          	bge	a5,a4,4ef6 <forktest+0x12>
    4f3a:	a011                	j	4f3e <forktest+0x5a>
      break;
    4f3c:	0001                	nop
  }

  if (n == 0) {
    4f3e:	fec42783          	lw	a5,-20(s0)
    4f42:	2781                	sext.w	a5,a5
    4f44:	e385                	bnez	a5,4f64 <forktest+0x80>
    printf("%s: no fork at all!\n", s);
    4f46:	fd843583          	ld	a1,-40(s0)
    4f4a:	00005517          	auipc	a0,0x5
    4f4e:	ba650513          	addi	a0,a0,-1114 # 9af0 <malloc+0x1b26>
    4f52:	00003097          	auipc	ra,0x3
    4f56:	e86080e7          	jalr	-378(ra) # 7dd8 <printf>
    exit(1);
    4f5a:	4505                	li	a0,1
    4f5c:	00003097          	auipc	ra,0x3
    4f60:	954080e7          	jalr	-1708(ra) # 78b0 <exit>
  }

  if(n == N){
    4f64:	fec42783          	lw	a5,-20(s0)
    4f68:	0007871b          	sext.w	a4,a5
    4f6c:	3e800793          	li	a5,1000
    4f70:	04f71d63          	bne	a4,a5,4fca <forktest+0xe6>
    printf("%s: fork claimed to work 1000 times!\n", s);
    4f74:	fd843583          	ld	a1,-40(s0)
    4f78:	00005517          	auipc	a0,0x5
    4f7c:	b9050513          	addi	a0,a0,-1136 # 9b08 <malloc+0x1b3e>
    4f80:	00003097          	auipc	ra,0x3
    4f84:	e58080e7          	jalr	-424(ra) # 7dd8 <printf>
    exit(1);
    4f88:	4505                	li	a0,1
    4f8a:	00003097          	auipc	ra,0x3
    4f8e:	926080e7          	jalr	-1754(ra) # 78b0 <exit>
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
    4f92:	4501                	li	a0,0
    4f94:	00003097          	auipc	ra,0x3
    4f98:	924080e7          	jalr	-1756(ra) # 78b8 <wait>
    4f9c:	87aa                	mv	a5,a0
    4f9e:	0207d163          	bgez	a5,4fc0 <forktest+0xdc>
      printf("%s: wait stopped early\n", s);
    4fa2:	fd843583          	ld	a1,-40(s0)
    4fa6:	00005517          	auipc	a0,0x5
    4faa:	b8a50513          	addi	a0,a0,-1142 # 9b30 <malloc+0x1b66>
    4fae:	00003097          	auipc	ra,0x3
    4fb2:	e2a080e7          	jalr	-470(ra) # 7dd8 <printf>
      exit(1);
    4fb6:	4505                	li	a0,1
    4fb8:	00003097          	auipc	ra,0x3
    4fbc:	8f8080e7          	jalr	-1800(ra) # 78b0 <exit>
  for(; n > 0; n--){
    4fc0:	fec42783          	lw	a5,-20(s0)
    4fc4:	37fd                	addiw	a5,a5,-1
    4fc6:	fef42623          	sw	a5,-20(s0)
    4fca:	fec42783          	lw	a5,-20(s0)
    4fce:	2781                	sext.w	a5,a5
    4fd0:	fcf041e3          	bgtz	a5,4f92 <forktest+0xae>
    }
  }

  if(wait(0) != -1){
    4fd4:	4501                	li	a0,0
    4fd6:	00003097          	auipc	ra,0x3
    4fda:	8e2080e7          	jalr	-1822(ra) # 78b8 <wait>
    4fde:	87aa                	mv	a5,a0
    4fe0:	873e                	mv	a4,a5
    4fe2:	57fd                	li	a5,-1
    4fe4:	02f70163          	beq	a4,a5,5006 <forktest+0x122>
    printf("%s: wait got too many\n", s);
    4fe8:	fd843583          	ld	a1,-40(s0)
    4fec:	00005517          	auipc	a0,0x5
    4ff0:	b5c50513          	addi	a0,a0,-1188 # 9b48 <malloc+0x1b7e>
    4ff4:	00003097          	auipc	ra,0x3
    4ff8:	de4080e7          	jalr	-540(ra) # 7dd8 <printf>
    exit(1);
    4ffc:	4505                	li	a0,1
    4ffe:	00003097          	auipc	ra,0x3
    5002:	8b2080e7          	jalr	-1870(ra) # 78b0 <exit>
  }
}
    5006:	0001                	nop
    5008:	70a2                	ld	ra,40(sp)
    500a:	7402                	ld	s0,32(sp)
    500c:	6145                	addi	sp,sp,48
    500e:	8082                	ret

0000000000005010 <sbrkbasic>:

void
sbrkbasic(char *s)
{
    5010:	715d                	addi	sp,sp,-80
    5012:	e486                	sd	ra,72(sp)
    5014:	e0a2                	sd	s0,64(sp)
    5016:	0880                	addi	s0,sp,80
    5018:	faa43c23          	sd	a0,-72(s0)
  enum { TOOMUCH=1024*1024*1024};
  int i, pid, xstatus;
  char *c, *a, *b;

  // does sbrk() return the expected failure value?
  pid = fork();
    501c:	00003097          	auipc	ra,0x3
    5020:	88c080e7          	jalr	-1908(ra) # 78a8 <fork>
    5024:	87aa                	mv	a5,a0
    5026:	fcf42a23          	sw	a5,-44(s0)
  if(pid < 0){
    502a:	fd442783          	lw	a5,-44(s0)
    502e:	2781                	sext.w	a5,a5
    5030:	0007df63          	bgez	a5,504e <sbrkbasic+0x3e>
    printf("fork failed in sbrkbasic\n");
    5034:	00005517          	auipc	a0,0x5
    5038:	b2c50513          	addi	a0,a0,-1236 # 9b60 <malloc+0x1b96>
    503c:	00003097          	auipc	ra,0x3
    5040:	d9c080e7          	jalr	-612(ra) # 7dd8 <printf>
    exit(1);
    5044:	4505                	li	a0,1
    5046:	00003097          	auipc	ra,0x3
    504a:	86a080e7          	jalr	-1942(ra) # 78b0 <exit>
  }
  if(pid == 0){
    504e:	fd442783          	lw	a5,-44(s0)
    5052:	2781                	sext.w	a5,a5
    5054:	e3b5                	bnez	a5,50b8 <sbrkbasic+0xa8>
    a = sbrk(TOOMUCH);
    5056:	40000537          	lui	a0,0x40000
    505a:	00003097          	auipc	ra,0x3
    505e:	8de080e7          	jalr	-1826(ra) # 7938 <sbrk>
    5062:	fea43023          	sd	a0,-32(s0)
    if(a == (char*)0xffffffffffffffffL){
    5066:	fe043703          	ld	a4,-32(s0)
    506a:	57fd                	li	a5,-1
    506c:	00f71763          	bne	a4,a5,507a <sbrkbasic+0x6a>
      // it's OK if this fails.
      exit(0);
    5070:	4501                	li	a0,0
    5072:	00003097          	auipc	ra,0x3
    5076:	83e080e7          	jalr	-1986(ra) # 78b0 <exit>
    }
    
    for(b = a; b < a+TOOMUCH; b += 4096){
    507a:	fe043783          	ld	a5,-32(s0)
    507e:	fcf43c23          	sd	a5,-40(s0)
    5082:	a829                	j	509c <sbrkbasic+0x8c>
      *b = 99;
    5084:	fd843783          	ld	a5,-40(s0)
    5088:	06300713          	li	a4,99
    508c:	00e78023          	sb	a4,0(a5)
    for(b = a; b < a+TOOMUCH; b += 4096){
    5090:	fd843703          	ld	a4,-40(s0)
    5094:	6785                	lui	a5,0x1
    5096:	97ba                	add	a5,a5,a4
    5098:	fcf43c23          	sd	a5,-40(s0)
    509c:	fe043703          	ld	a4,-32(s0)
    50a0:	400007b7          	lui	a5,0x40000
    50a4:	97ba                	add	a5,a5,a4
    50a6:	fd843703          	ld	a4,-40(s0)
    50aa:	fcf76de3          	bltu	a4,a5,5084 <sbrkbasic+0x74>
    }
    
    // we should not get here! either sbrk(TOOMUCH)
    // should have failed, or (with lazy allocation)
    // a pagefault should have killed this process.
    exit(1);
    50ae:	4505                	li	a0,1
    50b0:	00003097          	auipc	ra,0x3
    50b4:	800080e7          	jalr	-2048(ra) # 78b0 <exit>
  }

  wait(&xstatus);
    50b8:	fc440793          	addi	a5,s0,-60
    50bc:	853e                	mv	a0,a5
    50be:	00002097          	auipc	ra,0x2
    50c2:	7fa080e7          	jalr	2042(ra) # 78b8 <wait>
  if(xstatus == 1){
    50c6:	fc442783          	lw	a5,-60(s0)
    50ca:	873e                	mv	a4,a5
    50cc:	4785                	li	a5,1
    50ce:	02f71163          	bne	a4,a5,50f0 <sbrkbasic+0xe0>
    printf("%s: too much memory allocated!\n", s);
    50d2:	fb843583          	ld	a1,-72(s0)
    50d6:	00005517          	auipc	a0,0x5
    50da:	aaa50513          	addi	a0,a0,-1366 # 9b80 <malloc+0x1bb6>
    50de:	00003097          	auipc	ra,0x3
    50e2:	cfa080e7          	jalr	-774(ra) # 7dd8 <printf>
    exit(1);
    50e6:	4505                	li	a0,1
    50e8:	00002097          	auipc	ra,0x2
    50ec:	7c8080e7          	jalr	1992(ra) # 78b0 <exit>
  }

  // can one sbrk() less than a page?
  a = sbrk(0);
    50f0:	4501                	li	a0,0
    50f2:	00003097          	auipc	ra,0x3
    50f6:	846080e7          	jalr	-1978(ra) # 7938 <sbrk>
    50fa:	fea43023          	sd	a0,-32(s0)
  for(i = 0; i < 5000; i++){
    50fe:	fe042623          	sw	zero,-20(s0)
    5102:	a09d                	j	5168 <sbrkbasic+0x158>
    b = sbrk(1);
    5104:	4505                	li	a0,1
    5106:	00003097          	auipc	ra,0x3
    510a:	832080e7          	jalr	-1998(ra) # 7938 <sbrk>
    510e:	fca43c23          	sd	a0,-40(s0)
    if(b != a){
    5112:	fd843703          	ld	a4,-40(s0)
    5116:	fe043783          	ld	a5,-32(s0)
    511a:	02f70863          	beq	a4,a5,514a <sbrkbasic+0x13a>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    511e:	fec42783          	lw	a5,-20(s0)
    5122:	fd843703          	ld	a4,-40(s0)
    5126:	fe043683          	ld	a3,-32(s0)
    512a:	863e                	mv	a2,a5
    512c:	fb843583          	ld	a1,-72(s0)
    5130:	00005517          	auipc	a0,0x5
    5134:	a7050513          	addi	a0,a0,-1424 # 9ba0 <malloc+0x1bd6>
    5138:	00003097          	auipc	ra,0x3
    513c:	ca0080e7          	jalr	-864(ra) # 7dd8 <printf>
      exit(1);
    5140:	4505                	li	a0,1
    5142:	00002097          	auipc	ra,0x2
    5146:	76e080e7          	jalr	1902(ra) # 78b0 <exit>
    }
    *b = 1;
    514a:	fd843783          	ld	a5,-40(s0)
    514e:	4705                	li	a4,1
    5150:	00e78023          	sb	a4,0(a5) # 40000000 <freep+0x3ffed4d8>
    a = b + 1;
    5154:	fd843783          	ld	a5,-40(s0)
    5158:	0785                	addi	a5,a5,1
    515a:	fef43023          	sd	a5,-32(s0)
  for(i = 0; i < 5000; i++){
    515e:	fec42783          	lw	a5,-20(s0)
    5162:	2785                	addiw	a5,a5,1
    5164:	fef42623          	sw	a5,-20(s0)
    5168:	fec42783          	lw	a5,-20(s0)
    516c:	0007871b          	sext.w	a4,a5
    5170:	6785                	lui	a5,0x1
    5172:	38778793          	addi	a5,a5,903 # 1387 <openiputtest+0xe9>
    5176:	f8e7d7e3          	bge	a5,a4,5104 <sbrkbasic+0xf4>
  }
  pid = fork();
    517a:	00002097          	auipc	ra,0x2
    517e:	72e080e7          	jalr	1838(ra) # 78a8 <fork>
    5182:	87aa                	mv	a5,a0
    5184:	fcf42a23          	sw	a5,-44(s0)
  if(pid < 0){
    5188:	fd442783          	lw	a5,-44(s0)
    518c:	2781                	sext.w	a5,a5
    518e:	0207d163          	bgez	a5,51b0 <sbrkbasic+0x1a0>
    printf("%s: sbrk test fork failed\n", s);
    5192:	fb843583          	ld	a1,-72(s0)
    5196:	00005517          	auipc	a0,0x5
    519a:	a2a50513          	addi	a0,a0,-1494 # 9bc0 <malloc+0x1bf6>
    519e:	00003097          	auipc	ra,0x3
    51a2:	c3a080e7          	jalr	-966(ra) # 7dd8 <printf>
    exit(1);
    51a6:	4505                	li	a0,1
    51a8:	00002097          	auipc	ra,0x2
    51ac:	708080e7          	jalr	1800(ra) # 78b0 <exit>
  }
  c = sbrk(1);
    51b0:	4505                	li	a0,1
    51b2:	00002097          	auipc	ra,0x2
    51b6:	786080e7          	jalr	1926(ra) # 7938 <sbrk>
    51ba:	fca43423          	sd	a0,-56(s0)
  c = sbrk(1);
    51be:	4505                	li	a0,1
    51c0:	00002097          	auipc	ra,0x2
    51c4:	778080e7          	jalr	1912(ra) # 7938 <sbrk>
    51c8:	fca43423          	sd	a0,-56(s0)
  if(c != a + 1){
    51cc:	fe043783          	ld	a5,-32(s0)
    51d0:	0785                	addi	a5,a5,1
    51d2:	fc843703          	ld	a4,-56(s0)
    51d6:	02f70163          	beq	a4,a5,51f8 <sbrkbasic+0x1e8>
    printf("%s: sbrk test failed post-fork\n", s);
    51da:	fb843583          	ld	a1,-72(s0)
    51de:	00005517          	auipc	a0,0x5
    51e2:	a0250513          	addi	a0,a0,-1534 # 9be0 <malloc+0x1c16>
    51e6:	00003097          	auipc	ra,0x3
    51ea:	bf2080e7          	jalr	-1038(ra) # 7dd8 <printf>
    exit(1);
    51ee:	4505                	li	a0,1
    51f0:	00002097          	auipc	ra,0x2
    51f4:	6c0080e7          	jalr	1728(ra) # 78b0 <exit>
  }
  if(pid == 0)
    51f8:	fd442783          	lw	a5,-44(s0)
    51fc:	2781                	sext.w	a5,a5
    51fe:	e791                	bnez	a5,520a <sbrkbasic+0x1fa>
    exit(0);
    5200:	4501                	li	a0,0
    5202:	00002097          	auipc	ra,0x2
    5206:	6ae080e7          	jalr	1710(ra) # 78b0 <exit>
  wait(&xstatus);
    520a:	fc440793          	addi	a5,s0,-60
    520e:	853e                	mv	a0,a5
    5210:	00002097          	auipc	ra,0x2
    5214:	6a8080e7          	jalr	1704(ra) # 78b8 <wait>
  exit(xstatus);
    5218:	fc442783          	lw	a5,-60(s0)
    521c:	853e                	mv	a0,a5
    521e:	00002097          	auipc	ra,0x2
    5222:	692080e7          	jalr	1682(ra) # 78b0 <exit>

0000000000005226 <sbrkmuch>:
}

void
sbrkmuch(char *s)
{
    5226:	711d                	addi	sp,sp,-96
    5228:	ec86                	sd	ra,88(sp)
    522a:	e8a2                	sd	s0,80(sp)
    522c:	1080                	addi	s0,sp,96
    522e:	faa43423          	sd	a0,-88(s0)
  enum { BIG=100*1024*1024 };
  char *c, *oldbrk, *a, *lastaddr, *p;
  uint64 amt;

  oldbrk = sbrk(0);
    5232:	4501                	li	a0,0
    5234:	00002097          	auipc	ra,0x2
    5238:	704080e7          	jalr	1796(ra) # 7938 <sbrk>
    523c:	fea43023          	sd	a0,-32(s0)

  // can one grow address space to something big?
  a = sbrk(0);
    5240:	4501                	li	a0,0
    5242:	00002097          	auipc	ra,0x2
    5246:	6f6080e7          	jalr	1782(ra) # 7938 <sbrk>
    524a:	fca43c23          	sd	a0,-40(s0)
  amt = BIG - (uint64)a;
    524e:	fd843783          	ld	a5,-40(s0)
    5252:	06400737          	lui	a4,0x6400
    5256:	40f707b3          	sub	a5,a4,a5
    525a:	fcf43823          	sd	a5,-48(s0)
  p = sbrk(amt);
    525e:	fd043783          	ld	a5,-48(s0)
    5262:	2781                	sext.w	a5,a5
    5264:	853e                	mv	a0,a5
    5266:	00002097          	auipc	ra,0x2
    526a:	6d2080e7          	jalr	1746(ra) # 7938 <sbrk>
    526e:	fca43423          	sd	a0,-56(s0)
  if (p != a) {
    5272:	fc843703          	ld	a4,-56(s0)
    5276:	fd843783          	ld	a5,-40(s0)
    527a:	02f70163          	beq	a4,a5,529c <sbrkmuch+0x76>
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    527e:	fa843583          	ld	a1,-88(s0)
    5282:	00005517          	auipc	a0,0x5
    5286:	97e50513          	addi	a0,a0,-1666 # 9c00 <malloc+0x1c36>
    528a:	00003097          	auipc	ra,0x3
    528e:	b4e080e7          	jalr	-1202(ra) # 7dd8 <printf>
    exit(1);
    5292:	4505                	li	a0,1
    5294:	00002097          	auipc	ra,0x2
    5298:	61c080e7          	jalr	1564(ra) # 78b0 <exit>
  }

  // touch each page to make sure it exists.
  char *eee = sbrk(0);
    529c:	4501                	li	a0,0
    529e:	00002097          	auipc	ra,0x2
    52a2:	69a080e7          	jalr	1690(ra) # 7938 <sbrk>
    52a6:	fca43023          	sd	a0,-64(s0)
  for(char *pp = a; pp < eee; pp += 4096)
    52aa:	fd843783          	ld	a5,-40(s0)
    52ae:	fef43423          	sd	a5,-24(s0)
    52b2:	a821                	j	52ca <sbrkmuch+0xa4>
    *pp = 1;
    52b4:	fe843783          	ld	a5,-24(s0)
    52b8:	4705                	li	a4,1
    52ba:	00e78023          	sb	a4,0(a5)
  for(char *pp = a; pp < eee; pp += 4096)
    52be:	fe843703          	ld	a4,-24(s0)
    52c2:	6785                	lui	a5,0x1
    52c4:	97ba                	add	a5,a5,a4
    52c6:	fef43423          	sd	a5,-24(s0)
    52ca:	fe843703          	ld	a4,-24(s0)
    52ce:	fc043783          	ld	a5,-64(s0)
    52d2:	fef761e3          	bltu	a4,a5,52b4 <sbrkmuch+0x8e>

  lastaddr = (char*) (BIG-1);
    52d6:	064007b7          	lui	a5,0x6400
    52da:	17fd                	addi	a5,a5,-1 # 63fffff <freep+0x63ed4d7>
    52dc:	faf43c23          	sd	a5,-72(s0)
  *lastaddr = 99;
    52e0:	fb843783          	ld	a5,-72(s0)
    52e4:	06300713          	li	a4,99
    52e8:	00e78023          	sb	a4,0(a5)

  // can one de-allocate?
  a = sbrk(0);
    52ec:	4501                	li	a0,0
    52ee:	00002097          	auipc	ra,0x2
    52f2:	64a080e7          	jalr	1610(ra) # 7938 <sbrk>
    52f6:	fca43c23          	sd	a0,-40(s0)
  c = sbrk(-PGSIZE);
    52fa:	757d                	lui	a0,0xfffff
    52fc:	00002097          	auipc	ra,0x2
    5300:	63c080e7          	jalr	1596(ra) # 7938 <sbrk>
    5304:	faa43823          	sd	a0,-80(s0)
  if(c == (char*)0xffffffffffffffffL){
    5308:	fb043703          	ld	a4,-80(s0)
    530c:	57fd                	li	a5,-1
    530e:	02f71163          	bne	a4,a5,5330 <sbrkmuch+0x10a>
    printf("%s: sbrk could not deallocate\n", s);
    5312:	fa843583          	ld	a1,-88(s0)
    5316:	00005517          	auipc	a0,0x5
    531a:	93250513          	addi	a0,a0,-1742 # 9c48 <malloc+0x1c7e>
    531e:	00003097          	auipc	ra,0x3
    5322:	aba080e7          	jalr	-1350(ra) # 7dd8 <printf>
    exit(1);
    5326:	4505                	li	a0,1
    5328:	00002097          	auipc	ra,0x2
    532c:	588080e7          	jalr	1416(ra) # 78b0 <exit>
  }
  c = sbrk(0);
    5330:	4501                	li	a0,0
    5332:	00002097          	auipc	ra,0x2
    5336:	606080e7          	jalr	1542(ra) # 7938 <sbrk>
    533a:	faa43823          	sd	a0,-80(s0)
  if(c != a - PGSIZE){
    533e:	fd843703          	ld	a4,-40(s0)
    5342:	77fd                	lui	a5,0xfffff
    5344:	97ba                	add	a5,a5,a4
    5346:	fb043703          	ld	a4,-80(s0)
    534a:	02f70563          	beq	a4,a5,5374 <sbrkmuch+0x14e>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    534e:	fb043683          	ld	a3,-80(s0)
    5352:	fd843603          	ld	a2,-40(s0)
    5356:	fa843583          	ld	a1,-88(s0)
    535a:	00005517          	auipc	a0,0x5
    535e:	90e50513          	addi	a0,a0,-1778 # 9c68 <malloc+0x1c9e>
    5362:	00003097          	auipc	ra,0x3
    5366:	a76080e7          	jalr	-1418(ra) # 7dd8 <printf>
    exit(1);
    536a:	4505                	li	a0,1
    536c:	00002097          	auipc	ra,0x2
    5370:	544080e7          	jalr	1348(ra) # 78b0 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    5374:	4501                	li	a0,0
    5376:	00002097          	auipc	ra,0x2
    537a:	5c2080e7          	jalr	1474(ra) # 7938 <sbrk>
    537e:	fca43c23          	sd	a0,-40(s0)
  c = sbrk(PGSIZE);
    5382:	6505                	lui	a0,0x1
    5384:	00002097          	auipc	ra,0x2
    5388:	5b4080e7          	jalr	1460(ra) # 7938 <sbrk>
    538c:	faa43823          	sd	a0,-80(s0)
  if(c != a || sbrk(0) != a + PGSIZE){
    5390:	fb043703          	ld	a4,-80(s0)
    5394:	fd843783          	ld	a5,-40(s0)
    5398:	00f71e63          	bne	a4,a5,53b4 <sbrkmuch+0x18e>
    539c:	4501                	li	a0,0
    539e:	00002097          	auipc	ra,0x2
    53a2:	59a080e7          	jalr	1434(ra) # 7938 <sbrk>
    53a6:	86aa                	mv	a3,a0
    53a8:	fd843703          	ld	a4,-40(s0)
    53ac:	6785                	lui	a5,0x1
    53ae:	97ba                	add	a5,a5,a4
    53b0:	02f68563          	beq	a3,a5,53da <sbrkmuch+0x1b4>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    53b4:	fb043683          	ld	a3,-80(s0)
    53b8:	fd843603          	ld	a2,-40(s0)
    53bc:	fa843583          	ld	a1,-88(s0)
    53c0:	00005517          	auipc	a0,0x5
    53c4:	8e850513          	addi	a0,a0,-1816 # 9ca8 <malloc+0x1cde>
    53c8:	00003097          	auipc	ra,0x3
    53cc:	a10080e7          	jalr	-1520(ra) # 7dd8 <printf>
    exit(1);
    53d0:	4505                	li	a0,1
    53d2:	00002097          	auipc	ra,0x2
    53d6:	4de080e7          	jalr	1246(ra) # 78b0 <exit>
  }
  if(*lastaddr == 99){
    53da:	fb843783          	ld	a5,-72(s0)
    53de:	0007c783          	lbu	a5,0(a5) # 1000 <truncate3+0x1b2>
    53e2:	873e                	mv	a4,a5
    53e4:	06300793          	li	a5,99
    53e8:	02f71163          	bne	a4,a5,540a <sbrkmuch+0x1e4>
    // should be zero
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    53ec:	fa843583          	ld	a1,-88(s0)
    53f0:	00005517          	auipc	a0,0x5
    53f4:	8e850513          	addi	a0,a0,-1816 # 9cd8 <malloc+0x1d0e>
    53f8:	00003097          	auipc	ra,0x3
    53fc:	9e0080e7          	jalr	-1568(ra) # 7dd8 <printf>
    exit(1);
    5400:	4505                	li	a0,1
    5402:	00002097          	auipc	ra,0x2
    5406:	4ae080e7          	jalr	1198(ra) # 78b0 <exit>
  }

  a = sbrk(0);
    540a:	4501                	li	a0,0
    540c:	00002097          	auipc	ra,0x2
    5410:	52c080e7          	jalr	1324(ra) # 7938 <sbrk>
    5414:	fca43c23          	sd	a0,-40(s0)
  c = sbrk(-(sbrk(0) - oldbrk));
    5418:	4501                	li	a0,0
    541a:	00002097          	auipc	ra,0x2
    541e:	51e080e7          	jalr	1310(ra) # 7938 <sbrk>
    5422:	872a                	mv	a4,a0
    5424:	fe043783          	ld	a5,-32(s0)
    5428:	8f99                	sub	a5,a5,a4
    542a:	2781                	sext.w	a5,a5
    542c:	853e                	mv	a0,a5
    542e:	00002097          	auipc	ra,0x2
    5432:	50a080e7          	jalr	1290(ra) # 7938 <sbrk>
    5436:	faa43823          	sd	a0,-80(s0)
  if(c != a){
    543a:	fb043703          	ld	a4,-80(s0)
    543e:	fd843783          	ld	a5,-40(s0)
    5442:	02f70563          	beq	a4,a5,546c <sbrkmuch+0x246>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    5446:	fb043683          	ld	a3,-80(s0)
    544a:	fd843603          	ld	a2,-40(s0)
    544e:	fa843583          	ld	a1,-88(s0)
    5452:	00005517          	auipc	a0,0x5
    5456:	8be50513          	addi	a0,a0,-1858 # 9d10 <malloc+0x1d46>
    545a:	00003097          	auipc	ra,0x3
    545e:	97e080e7          	jalr	-1666(ra) # 7dd8 <printf>
    exit(1);
    5462:	4505                	li	a0,1
    5464:	00002097          	auipc	ra,0x2
    5468:	44c080e7          	jalr	1100(ra) # 78b0 <exit>
  }
}
    546c:	0001                	nop
    546e:	60e6                	ld	ra,88(sp)
    5470:	6446                	ld	s0,80(sp)
    5472:	6125                	addi	sp,sp,96
    5474:	8082                	ret

0000000000005476 <kernmem>:

// can we read the kernel's memory?
void
kernmem(char *s)
{
    5476:	7179                	addi	sp,sp,-48
    5478:	f406                	sd	ra,40(sp)
    547a:	f022                	sd	s0,32(sp)
    547c:	1800                	addi	s0,sp,48
    547e:	fca43c23          	sd	a0,-40(s0)
  char *a;
  int pid;

  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    5482:	4785                	li	a5,1
    5484:	07fe                	slli	a5,a5,0x1f
    5486:	fef43423          	sd	a5,-24(s0)
    548a:	a04d                	j	552c <kernmem+0xb6>
    pid = fork();
    548c:	00002097          	auipc	ra,0x2
    5490:	41c080e7          	jalr	1052(ra) # 78a8 <fork>
    5494:	87aa                	mv	a5,a0
    5496:	fef42223          	sw	a5,-28(s0)
    if(pid < 0){
    549a:	fe442783          	lw	a5,-28(s0)
    549e:	2781                	sext.w	a5,a5
    54a0:	0207d163          	bgez	a5,54c2 <kernmem+0x4c>
      printf("%s: fork failed\n", s);
    54a4:	fd843583          	ld	a1,-40(s0)
    54a8:	00003517          	auipc	a0,0x3
    54ac:	0a850513          	addi	a0,a0,168 # 8550 <malloc+0x586>
    54b0:	00003097          	auipc	ra,0x3
    54b4:	928080e7          	jalr	-1752(ra) # 7dd8 <printf>
      exit(1);
    54b8:	4505                	li	a0,1
    54ba:	00002097          	auipc	ra,0x2
    54be:	3f6080e7          	jalr	1014(ra) # 78b0 <exit>
    }
    if(pid == 0){
    54c2:	fe442783          	lw	a5,-28(s0)
    54c6:	2781                	sext.w	a5,a5
    54c8:	eb85                	bnez	a5,54f8 <kernmem+0x82>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    54ca:	fe843783          	ld	a5,-24(s0)
    54ce:	0007c783          	lbu	a5,0(a5)
    54d2:	2781                	sext.w	a5,a5
    54d4:	86be                	mv	a3,a5
    54d6:	fe843603          	ld	a2,-24(s0)
    54da:	fd843583          	ld	a1,-40(s0)
    54de:	00005517          	auipc	a0,0x5
    54e2:	85a50513          	addi	a0,a0,-1958 # 9d38 <malloc+0x1d6e>
    54e6:	00003097          	auipc	ra,0x3
    54ea:	8f2080e7          	jalr	-1806(ra) # 7dd8 <printf>
      exit(1);
    54ee:	4505                	li	a0,1
    54f0:	00002097          	auipc	ra,0x2
    54f4:	3c0080e7          	jalr	960(ra) # 78b0 <exit>
    }
    int xstatus;
    wait(&xstatus);
    54f8:	fe040793          	addi	a5,s0,-32
    54fc:	853e                	mv	a0,a5
    54fe:	00002097          	auipc	ra,0x2
    5502:	3ba080e7          	jalr	954(ra) # 78b8 <wait>
    if(xstatus != -1)  // did kernel kill child?
    5506:	fe042783          	lw	a5,-32(s0)
    550a:	873e                	mv	a4,a5
    550c:	57fd                	li	a5,-1
    550e:	00f70763          	beq	a4,a5,551c <kernmem+0xa6>
      exit(1);
    5512:	4505                	li	a0,1
    5514:	00002097          	auipc	ra,0x2
    5518:	39c080e7          	jalr	924(ra) # 78b0 <exit>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    551c:	fe843703          	ld	a4,-24(s0)
    5520:	67b1                	lui	a5,0xc
    5522:	35078793          	addi	a5,a5,848 # c350 <buf+0x50>
    5526:	97ba                	add	a5,a5,a4
    5528:	fef43423          	sd	a5,-24(s0)
    552c:	fe843703          	ld	a4,-24(s0)
    5530:	1003d7b7          	lui	a5,0x1003d
    5534:	078e                	slli	a5,a5,0x3
    5536:	47f78793          	addi	a5,a5,1151 # 1003d47f <freep+0x1002a957>
    553a:	f4e7f9e3          	bgeu	a5,a4,548c <kernmem+0x16>
  }
}
    553e:	0001                	nop
    5540:	0001                	nop
    5542:	70a2                	ld	ra,40(sp)
    5544:	7402                	ld	s0,32(sp)
    5546:	6145                	addi	sp,sp,48
    5548:	8082                	ret

000000000000554a <MAXVAplus>:

// user code should not be able to write to addresses above MAXVA.
void
MAXVAplus(char *s)
{
    554a:	7139                	addi	sp,sp,-64
    554c:	fc06                	sd	ra,56(sp)
    554e:	f822                	sd	s0,48(sp)
    5550:	0080                	addi	s0,sp,64
    5552:	fca43423          	sd	a0,-56(s0)
  volatile uint64 a = MAXVA;
    5556:	4785                	li	a5,1
    5558:	179a                	slli	a5,a5,0x26
    555a:	fef43023          	sd	a5,-32(s0)
  for( ; a != 0; a <<= 1){
    555e:	a045                	j	55fe <MAXVAplus+0xb4>
    int pid;
    pid = fork();
    5560:	00002097          	auipc	ra,0x2
    5564:	348080e7          	jalr	840(ra) # 78a8 <fork>
    5568:	87aa                	mv	a5,a0
    556a:	fef42623          	sw	a5,-20(s0)
    if(pid < 0){
    556e:	fec42783          	lw	a5,-20(s0)
    5572:	2781                	sext.w	a5,a5
    5574:	0207d163          	bgez	a5,5596 <MAXVAplus+0x4c>
      printf("%s: fork failed\n", s);
    5578:	fc843583          	ld	a1,-56(s0)
    557c:	00003517          	auipc	a0,0x3
    5580:	fd450513          	addi	a0,a0,-44 # 8550 <malloc+0x586>
    5584:	00003097          	auipc	ra,0x3
    5588:	854080e7          	jalr	-1964(ra) # 7dd8 <printf>
      exit(1);
    558c:	4505                	li	a0,1
    558e:	00002097          	auipc	ra,0x2
    5592:	322080e7          	jalr	802(ra) # 78b0 <exit>
    }
    if(pid == 0){
    5596:	fec42783          	lw	a5,-20(s0)
    559a:	2781                	sext.w	a5,a5
    559c:	eb95                	bnez	a5,55d0 <MAXVAplus+0x86>
      *(char*)a = 99;
    559e:	fe043783          	ld	a5,-32(s0)
    55a2:	873e                	mv	a4,a5
    55a4:	06300793          	li	a5,99
    55a8:	00f70023          	sb	a5,0(a4) # 6400000 <freep+0x63ed4d8>
      printf("%s: oops wrote %x\n", s, a);
    55ac:	fe043783          	ld	a5,-32(s0)
    55b0:	863e                	mv	a2,a5
    55b2:	fc843583          	ld	a1,-56(s0)
    55b6:	00004517          	auipc	a0,0x4
    55ba:	7a250513          	addi	a0,a0,1954 # 9d58 <malloc+0x1d8e>
    55be:	00003097          	auipc	ra,0x3
    55c2:	81a080e7          	jalr	-2022(ra) # 7dd8 <printf>
      exit(1);
    55c6:	4505                	li	a0,1
    55c8:	00002097          	auipc	ra,0x2
    55cc:	2e8080e7          	jalr	744(ra) # 78b0 <exit>
    }
    int xstatus;
    wait(&xstatus);
    55d0:	fdc40793          	addi	a5,s0,-36
    55d4:	853e                	mv	a0,a5
    55d6:	00002097          	auipc	ra,0x2
    55da:	2e2080e7          	jalr	738(ra) # 78b8 <wait>
    if(xstatus != -1)  // did kernel kill child?
    55de:	fdc42783          	lw	a5,-36(s0)
    55e2:	873e                	mv	a4,a5
    55e4:	57fd                	li	a5,-1
    55e6:	00f70763          	beq	a4,a5,55f4 <MAXVAplus+0xaa>
      exit(1);
    55ea:	4505                	li	a0,1
    55ec:	00002097          	auipc	ra,0x2
    55f0:	2c4080e7          	jalr	708(ra) # 78b0 <exit>
  for( ; a != 0; a <<= 1){
    55f4:	fe043783          	ld	a5,-32(s0)
    55f8:	0786                	slli	a5,a5,0x1
    55fa:	fef43023          	sd	a5,-32(s0)
    55fe:	fe043783          	ld	a5,-32(s0)
    5602:	ffb9                	bnez	a5,5560 <MAXVAplus+0x16>
  }
}
    5604:	0001                	nop
    5606:	0001                	nop
    5608:	70e2                	ld	ra,56(sp)
    560a:	7442                	ld	s0,48(sp)
    560c:	6121                	addi	sp,sp,64
    560e:	8082                	ret

0000000000005610 <sbrkfail>:

// if we run the system out of memory, does it clean up the last
// failed allocation?
void
sbrkfail(char *s)
{
    5610:	7119                	addi	sp,sp,-128
    5612:	fc86                	sd	ra,120(sp)
    5614:	f8a2                	sd	s0,112(sp)
    5616:	0100                	addi	s0,sp,128
    5618:	f8a43423          	sd	a0,-120(s0)
  char scratch;
  char *c, *a;
  int pids[10];
  int pid;
 
  if(pipe(fds) != 0){
    561c:	fc040793          	addi	a5,s0,-64
    5620:	853e                	mv	a0,a5
    5622:	00002097          	auipc	ra,0x2
    5626:	29e080e7          	jalr	670(ra) # 78c0 <pipe>
    562a:	87aa                	mv	a5,a0
    562c:	c385                	beqz	a5,564c <sbrkfail+0x3c>
    printf("%s: pipe() failed\n", s);
    562e:	f8843583          	ld	a1,-120(s0)
    5632:	00003517          	auipc	a0,0x3
    5636:	3b650513          	addi	a0,a0,950 # 89e8 <malloc+0xa1e>
    563a:	00002097          	auipc	ra,0x2
    563e:	79e080e7          	jalr	1950(ra) # 7dd8 <printf>
    exit(1);
    5642:	4505                	li	a0,1
    5644:	00002097          	auipc	ra,0x2
    5648:	26c080e7          	jalr	620(ra) # 78b0 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    564c:	fe042623          	sw	zero,-20(s0)
    5650:	a075                	j	56fc <sbrkfail+0xec>
    if((pids[i] = fork()) == 0){
    5652:	00002097          	auipc	ra,0x2
    5656:	256080e7          	jalr	598(ra) # 78a8 <fork>
    565a:	87aa                	mv	a5,a0
    565c:	873e                	mv	a4,a5
    565e:	fec42783          	lw	a5,-20(s0)
    5662:	078a                	slli	a5,a5,0x2
    5664:	17c1                	addi	a5,a5,-16
    5666:	97a2                	add	a5,a5,s0
    5668:	fae7a023          	sw	a4,-96(a5)
    566c:	fec42783          	lw	a5,-20(s0)
    5670:	078a                	slli	a5,a5,0x2
    5672:	17c1                	addi	a5,a5,-16
    5674:	97a2                	add	a5,a5,s0
    5676:	fa07a783          	lw	a5,-96(a5)
    567a:	e7b1                	bnez	a5,56c6 <sbrkfail+0xb6>
      // allocate a lot of memory
      sbrk(BIG - (uint64)sbrk(0));
    567c:	4501                	li	a0,0
    567e:	00002097          	auipc	ra,0x2
    5682:	2ba080e7          	jalr	698(ra) # 7938 <sbrk>
    5686:	87aa                	mv	a5,a0
    5688:	2781                	sext.w	a5,a5
    568a:	06400737          	lui	a4,0x6400
    568e:	40f707bb          	subw	a5,a4,a5
    5692:	2781                	sext.w	a5,a5
    5694:	2781                	sext.w	a5,a5
    5696:	853e                	mv	a0,a5
    5698:	00002097          	auipc	ra,0x2
    569c:	2a0080e7          	jalr	672(ra) # 7938 <sbrk>
      write(fds[1], "x", 1);
    56a0:	fc442783          	lw	a5,-60(s0)
    56a4:	4605                	li	a2,1
    56a6:	00003597          	auipc	a1,0x3
    56aa:	b7a58593          	addi	a1,a1,-1158 # 8220 <malloc+0x256>
    56ae:	853e                	mv	a0,a5
    56b0:	00002097          	auipc	ra,0x2
    56b4:	220080e7          	jalr	544(ra) # 78d0 <write>
      // sit around until killed
      for(;;) sleep(1000);
    56b8:	3e800513          	li	a0,1000
    56bc:	00002097          	auipc	ra,0x2
    56c0:	284080e7          	jalr	644(ra) # 7940 <sleep>
    56c4:	bfd5                	j	56b8 <sbrkfail+0xa8>
    }
    if(pids[i] != -1)
    56c6:	fec42783          	lw	a5,-20(s0)
    56ca:	078a                	slli	a5,a5,0x2
    56cc:	17c1                	addi	a5,a5,-16
    56ce:	97a2                	add	a5,a5,s0
    56d0:	fa07a783          	lw	a5,-96(a5)
    56d4:	873e                	mv	a4,a5
    56d6:	57fd                	li	a5,-1
    56d8:	00f70d63          	beq	a4,a5,56f2 <sbrkfail+0xe2>
      read(fds[0], &scratch, 1);
    56dc:	fc042783          	lw	a5,-64(s0)
    56e0:	fbf40713          	addi	a4,s0,-65
    56e4:	4605                	li	a2,1
    56e6:	85ba                	mv	a1,a4
    56e8:	853e                	mv	a0,a5
    56ea:	00002097          	auipc	ra,0x2
    56ee:	1de080e7          	jalr	478(ra) # 78c8 <read>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    56f2:	fec42783          	lw	a5,-20(s0)
    56f6:	2785                	addiw	a5,a5,1
    56f8:	fef42623          	sw	a5,-20(s0)
    56fc:	fec42783          	lw	a5,-20(s0)
    5700:	873e                	mv	a4,a5
    5702:	47a5                	li	a5,9
    5704:	f4e7f7e3          	bgeu	a5,a4,5652 <sbrkfail+0x42>
  }

  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(PGSIZE);
    5708:	6505                	lui	a0,0x1
    570a:	00002097          	auipc	ra,0x2
    570e:	22e080e7          	jalr	558(ra) # 7938 <sbrk>
    5712:	fea43023          	sd	a0,-32(s0)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    5716:	fe042623          	sw	zero,-20(s0)
    571a:	a0a1                	j	5762 <sbrkfail+0x152>
    if(pids[i] == -1)
    571c:	fec42783          	lw	a5,-20(s0)
    5720:	078a                	slli	a5,a5,0x2
    5722:	17c1                	addi	a5,a5,-16
    5724:	97a2                	add	a5,a5,s0
    5726:	fa07a783          	lw	a5,-96(a5)
    572a:	873e                	mv	a4,a5
    572c:	57fd                	li	a5,-1
    572e:	02f70463          	beq	a4,a5,5756 <sbrkfail+0x146>
      continue;
    kill(pids[i]);
    5732:	fec42783          	lw	a5,-20(s0)
    5736:	078a                	slli	a5,a5,0x2
    5738:	17c1                	addi	a5,a5,-16
    573a:	97a2                	add	a5,a5,s0
    573c:	fa07a783          	lw	a5,-96(a5)
    5740:	853e                	mv	a0,a5
    5742:	00002097          	auipc	ra,0x2
    5746:	19e080e7          	jalr	414(ra) # 78e0 <kill>
    wait(0);
    574a:	4501                	li	a0,0
    574c:	00002097          	auipc	ra,0x2
    5750:	16c080e7          	jalr	364(ra) # 78b8 <wait>
    5754:	a011                	j	5758 <sbrkfail+0x148>
      continue;
    5756:	0001                	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    5758:	fec42783          	lw	a5,-20(s0)
    575c:	2785                	addiw	a5,a5,1
    575e:	fef42623          	sw	a5,-20(s0)
    5762:	fec42783          	lw	a5,-20(s0)
    5766:	873e                	mv	a4,a5
    5768:	47a5                	li	a5,9
    576a:	fae7f9e3          	bgeu	a5,a4,571c <sbrkfail+0x10c>
  }
  if(c == (char*)0xffffffffffffffffL){
    576e:	fe043703          	ld	a4,-32(s0)
    5772:	57fd                	li	a5,-1
    5774:	02f71163          	bne	a4,a5,5796 <sbrkfail+0x186>
    printf("%s: failed sbrk leaked memory\n", s);
    5778:	f8843583          	ld	a1,-120(s0)
    577c:	00004517          	auipc	a0,0x4
    5780:	5f450513          	addi	a0,a0,1524 # 9d70 <malloc+0x1da6>
    5784:	00002097          	auipc	ra,0x2
    5788:	654080e7          	jalr	1620(ra) # 7dd8 <printf>
    exit(1);
    578c:	4505                	li	a0,1
    578e:	00002097          	auipc	ra,0x2
    5792:	122080e7          	jalr	290(ra) # 78b0 <exit>
  }

  // test running fork with the above allocated page 
  pid = fork();
    5796:	00002097          	auipc	ra,0x2
    579a:	112080e7          	jalr	274(ra) # 78a8 <fork>
    579e:	87aa                	mv	a5,a0
    57a0:	fcf42e23          	sw	a5,-36(s0)
  if(pid < 0){
    57a4:	fdc42783          	lw	a5,-36(s0)
    57a8:	2781                	sext.w	a5,a5
    57aa:	0207d163          	bgez	a5,57cc <sbrkfail+0x1bc>
    printf("%s: fork failed\n", s);
    57ae:	f8843583          	ld	a1,-120(s0)
    57b2:	00003517          	auipc	a0,0x3
    57b6:	d9e50513          	addi	a0,a0,-610 # 8550 <malloc+0x586>
    57ba:	00002097          	auipc	ra,0x2
    57be:	61e080e7          	jalr	1566(ra) # 7dd8 <printf>
    exit(1);
    57c2:	4505                	li	a0,1
    57c4:	00002097          	auipc	ra,0x2
    57c8:	0ec080e7          	jalr	236(ra) # 78b0 <exit>
  }
  if(pid == 0){
    57cc:	fdc42783          	lw	a5,-36(s0)
    57d0:	2781                	sext.w	a5,a5
    57d2:	e3c9                	bnez	a5,5854 <sbrkfail+0x244>
    // allocate a lot of memory.
    // this should produce a page fault,
    // and thus not complete.
    a = sbrk(0);
    57d4:	4501                	li	a0,0
    57d6:	00002097          	auipc	ra,0x2
    57da:	162080e7          	jalr	354(ra) # 7938 <sbrk>
    57de:	fca43823          	sd	a0,-48(s0)
    sbrk(10*BIG);
    57e2:	3e800537          	lui	a0,0x3e800
    57e6:	00002097          	auipc	ra,0x2
    57ea:	152080e7          	jalr	338(ra) # 7938 <sbrk>
    int n = 0;
    57ee:	fe042423          	sw	zero,-24(s0)
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    57f2:	fe042623          	sw	zero,-20(s0)
    57f6:	a02d                	j	5820 <sbrkfail+0x210>
      n += *(a+i);
    57f8:	fec42783          	lw	a5,-20(s0)
    57fc:	fd043703          	ld	a4,-48(s0)
    5800:	97ba                	add	a5,a5,a4
    5802:	0007c783          	lbu	a5,0(a5)
    5806:	2781                	sext.w	a5,a5
    5808:	fe842703          	lw	a4,-24(s0)
    580c:	9fb9                	addw	a5,a5,a4
    580e:	fef42423          	sw	a5,-24(s0)
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    5812:	fec42783          	lw	a5,-20(s0)
    5816:	873e                	mv	a4,a5
    5818:	6785                	lui	a5,0x1
    581a:	9fb9                	addw	a5,a5,a4
    581c:	fef42623          	sw	a5,-20(s0)
    5820:	fec42783          	lw	a5,-20(s0)
    5824:	0007871b          	sext.w	a4,a5
    5828:	3e8007b7          	lui	a5,0x3e800
    582c:	fcf746e3          	blt	a4,a5,57f8 <sbrkfail+0x1e8>
    }
    // print n so the compiler doesn't optimize away
    // the for loop.
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    5830:	fe842783          	lw	a5,-24(s0)
    5834:	863e                	mv	a2,a5
    5836:	f8843583          	ld	a1,-120(s0)
    583a:	00004517          	auipc	a0,0x4
    583e:	55650513          	addi	a0,a0,1366 # 9d90 <malloc+0x1dc6>
    5842:	00002097          	auipc	ra,0x2
    5846:	596080e7          	jalr	1430(ra) # 7dd8 <printf>
    exit(1);
    584a:	4505                	li	a0,1
    584c:	00002097          	auipc	ra,0x2
    5850:	064080e7          	jalr	100(ra) # 78b0 <exit>
  }
  wait(&xstatus);
    5854:	fcc40793          	addi	a5,s0,-52
    5858:	853e                	mv	a0,a5
    585a:	00002097          	auipc	ra,0x2
    585e:	05e080e7          	jalr	94(ra) # 78b8 <wait>
  if(xstatus != -1 && xstatus != 2)
    5862:	fcc42783          	lw	a5,-52(s0)
    5866:	873e                	mv	a4,a5
    5868:	57fd                	li	a5,-1
    586a:	00f70d63          	beq	a4,a5,5884 <sbrkfail+0x274>
    586e:	fcc42783          	lw	a5,-52(s0)
    5872:	873e                	mv	a4,a5
    5874:	4789                	li	a5,2
    5876:	00f70763          	beq	a4,a5,5884 <sbrkfail+0x274>
    exit(1);
    587a:	4505                	li	a0,1
    587c:	00002097          	auipc	ra,0x2
    5880:	034080e7          	jalr	52(ra) # 78b0 <exit>
}
    5884:	0001                	nop
    5886:	70e6                	ld	ra,120(sp)
    5888:	7446                	ld	s0,112(sp)
    588a:	6109                	addi	sp,sp,128
    588c:	8082                	ret

000000000000588e <sbrkarg>:

  
// test reads/writes from/to allocated memory
void
sbrkarg(char *s)
{
    588e:	7179                	addi	sp,sp,-48
    5890:	f406                	sd	ra,40(sp)
    5892:	f022                	sd	s0,32(sp)
    5894:	1800                	addi	s0,sp,48
    5896:	fca43c23          	sd	a0,-40(s0)
  char *a;
  int fd, n;

  a = sbrk(PGSIZE);
    589a:	6505                	lui	a0,0x1
    589c:	00002097          	auipc	ra,0x2
    58a0:	09c080e7          	jalr	156(ra) # 7938 <sbrk>
    58a4:	fea43423          	sd	a0,-24(s0)
  fd = open("sbrk", O_CREATE|O_WRONLY);
    58a8:	20100593          	li	a1,513
    58ac:	00004517          	auipc	a0,0x4
    58b0:	51450513          	addi	a0,a0,1300 # 9dc0 <malloc+0x1df6>
    58b4:	00002097          	auipc	ra,0x2
    58b8:	03c080e7          	jalr	60(ra) # 78f0 <open>
    58bc:	87aa                	mv	a5,a0
    58be:	fef42223          	sw	a5,-28(s0)
  unlink("sbrk");
    58c2:	00004517          	auipc	a0,0x4
    58c6:	4fe50513          	addi	a0,a0,1278 # 9dc0 <malloc+0x1df6>
    58ca:	00002097          	auipc	ra,0x2
    58ce:	036080e7          	jalr	54(ra) # 7900 <unlink>
  if(fd < 0)  {
    58d2:	fe442783          	lw	a5,-28(s0)
    58d6:	2781                	sext.w	a5,a5
    58d8:	0207d163          	bgez	a5,58fa <sbrkarg+0x6c>
    printf("%s: open sbrk failed\n", s);
    58dc:	fd843583          	ld	a1,-40(s0)
    58e0:	00004517          	auipc	a0,0x4
    58e4:	4e850513          	addi	a0,a0,1256 # 9dc8 <malloc+0x1dfe>
    58e8:	00002097          	auipc	ra,0x2
    58ec:	4f0080e7          	jalr	1264(ra) # 7dd8 <printf>
    exit(1);
    58f0:	4505                	li	a0,1
    58f2:	00002097          	auipc	ra,0x2
    58f6:	fbe080e7          	jalr	-66(ra) # 78b0 <exit>
  }
  if ((n = write(fd, a, PGSIZE)) < 0) {
    58fa:	fe442783          	lw	a5,-28(s0)
    58fe:	6605                	lui	a2,0x1
    5900:	fe843583          	ld	a1,-24(s0)
    5904:	853e                	mv	a0,a5
    5906:	00002097          	auipc	ra,0x2
    590a:	fca080e7          	jalr	-54(ra) # 78d0 <write>
    590e:	87aa                	mv	a5,a0
    5910:	fef42023          	sw	a5,-32(s0)
    5914:	fe042783          	lw	a5,-32(s0)
    5918:	2781                	sext.w	a5,a5
    591a:	0207d163          	bgez	a5,593c <sbrkarg+0xae>
    printf("%s: write sbrk failed\n", s);
    591e:	fd843583          	ld	a1,-40(s0)
    5922:	00004517          	auipc	a0,0x4
    5926:	4be50513          	addi	a0,a0,1214 # 9de0 <malloc+0x1e16>
    592a:	00002097          	auipc	ra,0x2
    592e:	4ae080e7          	jalr	1198(ra) # 7dd8 <printf>
    exit(1);
    5932:	4505                	li	a0,1
    5934:	00002097          	auipc	ra,0x2
    5938:	f7c080e7          	jalr	-132(ra) # 78b0 <exit>
  }
  close(fd);
    593c:	fe442783          	lw	a5,-28(s0)
    5940:	853e                	mv	a0,a5
    5942:	00002097          	auipc	ra,0x2
    5946:	f96080e7          	jalr	-106(ra) # 78d8 <close>

  // test writes to allocated memory
  a = sbrk(PGSIZE);
    594a:	6505                	lui	a0,0x1
    594c:	00002097          	auipc	ra,0x2
    5950:	fec080e7          	jalr	-20(ra) # 7938 <sbrk>
    5954:	fea43423          	sd	a0,-24(s0)
  if(pipe((int *) a) != 0){
    5958:	fe843503          	ld	a0,-24(s0)
    595c:	00002097          	auipc	ra,0x2
    5960:	f64080e7          	jalr	-156(ra) # 78c0 <pipe>
    5964:	87aa                	mv	a5,a0
    5966:	c385                	beqz	a5,5986 <sbrkarg+0xf8>
    printf("%s: pipe() failed\n", s);
    5968:	fd843583          	ld	a1,-40(s0)
    596c:	00003517          	auipc	a0,0x3
    5970:	07c50513          	addi	a0,a0,124 # 89e8 <malloc+0xa1e>
    5974:	00002097          	auipc	ra,0x2
    5978:	464080e7          	jalr	1124(ra) # 7dd8 <printf>
    exit(1);
    597c:	4505                	li	a0,1
    597e:	00002097          	auipc	ra,0x2
    5982:	f32080e7          	jalr	-206(ra) # 78b0 <exit>
  } 
}
    5986:	0001                	nop
    5988:	70a2                	ld	ra,40(sp)
    598a:	7402                	ld	s0,32(sp)
    598c:	6145                	addi	sp,sp,48
    598e:	8082                	ret

0000000000005990 <validatetest>:

void
validatetest(char *s)
{
    5990:	7179                	addi	sp,sp,-48
    5992:	f406                	sd	ra,40(sp)
    5994:	f022                	sd	s0,32(sp)
    5996:	1800                	addi	s0,sp,48
    5998:	fca43c23          	sd	a0,-40(s0)
  int hi;
  uint64 p;

  hi = 1100*1024;
    599c:	001137b7          	lui	a5,0x113
    59a0:	fef42223          	sw	a5,-28(s0)
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    59a4:	fe043423          	sd	zero,-24(s0)
    59a8:	a0b1                	j	59f4 <validatetest+0x64>
    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    59aa:	fe843783          	ld	a5,-24(s0)
    59ae:	85be                	mv	a1,a5
    59b0:	00004517          	auipc	a0,0x4
    59b4:	44850513          	addi	a0,a0,1096 # 9df8 <malloc+0x1e2e>
    59b8:	00002097          	auipc	ra,0x2
    59bc:	f58080e7          	jalr	-168(ra) # 7910 <link>
    59c0:	87aa                	mv	a5,a0
    59c2:	873e                	mv	a4,a5
    59c4:	57fd                	li	a5,-1
    59c6:	02f70163          	beq	a4,a5,59e8 <validatetest+0x58>
      printf("%s: link should not succeed\n", s);
    59ca:	fd843583          	ld	a1,-40(s0)
    59ce:	00004517          	auipc	a0,0x4
    59d2:	43a50513          	addi	a0,a0,1082 # 9e08 <malloc+0x1e3e>
    59d6:	00002097          	auipc	ra,0x2
    59da:	402080e7          	jalr	1026(ra) # 7dd8 <printf>
      exit(1);
    59de:	4505                	li	a0,1
    59e0:	00002097          	auipc	ra,0x2
    59e4:	ed0080e7          	jalr	-304(ra) # 78b0 <exit>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    59e8:	fe843703          	ld	a4,-24(s0)
    59ec:	6785                	lui	a5,0x1
    59ee:	97ba                	add	a5,a5,a4
    59f0:	fef43423          	sd	a5,-24(s0)
    59f4:	fe442783          	lw	a5,-28(s0)
    59f8:	1782                	slli	a5,a5,0x20
    59fa:	9381                	srli	a5,a5,0x20
    59fc:	fe843703          	ld	a4,-24(s0)
    5a00:	fae7f5e3          	bgeu	a5,a4,59aa <validatetest+0x1a>
    }
  }
}
    5a04:	0001                	nop
    5a06:	0001                	nop
    5a08:	70a2                	ld	ra,40(sp)
    5a0a:	7402                	ld	s0,32(sp)
    5a0c:	6145                	addi	sp,sp,48
    5a0e:	8082                	ret

0000000000005a10 <bsstest>:

// does uninitialized data start out zero?
char uninit[10000];
void
bsstest(char *s)
{
    5a10:	7179                	addi	sp,sp,-48
    5a12:	f406                	sd	ra,40(sp)
    5a14:	f022                	sd	s0,32(sp)
    5a16:	1800                	addi	s0,sp,48
    5a18:	fca43c23          	sd	a0,-40(s0)
  int i;

  for(i = 0; i < sizeof(uninit); i++){
    5a1c:	fe042623          	sw	zero,-20(s0)
    5a20:	a83d                	j	5a5e <bsstest+0x4e>
    if(uninit[i] != '\0'){
    5a22:	0000a717          	auipc	a4,0xa
    5a26:	8de70713          	addi	a4,a4,-1826 # f300 <uninit>
    5a2a:	fec42783          	lw	a5,-20(s0)
    5a2e:	97ba                	add	a5,a5,a4
    5a30:	0007c783          	lbu	a5,0(a5) # 1000 <truncate3+0x1b2>
    5a34:	c385                	beqz	a5,5a54 <bsstest+0x44>
      printf("%s: bss test failed\n", s);
    5a36:	fd843583          	ld	a1,-40(s0)
    5a3a:	00004517          	auipc	a0,0x4
    5a3e:	3ee50513          	addi	a0,a0,1006 # 9e28 <malloc+0x1e5e>
    5a42:	00002097          	auipc	ra,0x2
    5a46:	396080e7          	jalr	918(ra) # 7dd8 <printf>
      exit(1);
    5a4a:	4505                	li	a0,1
    5a4c:	00002097          	auipc	ra,0x2
    5a50:	e64080e7          	jalr	-412(ra) # 78b0 <exit>
  for(i = 0; i < sizeof(uninit); i++){
    5a54:	fec42783          	lw	a5,-20(s0)
    5a58:	2785                	addiw	a5,a5,1
    5a5a:	fef42623          	sw	a5,-20(s0)
    5a5e:	fec42783          	lw	a5,-20(s0)
    5a62:	873e                	mv	a4,a5
    5a64:	6789                	lui	a5,0x2
    5a66:	70f78793          	addi	a5,a5,1807 # 270f <reparent2+0x79>
    5a6a:	fae7fce3          	bgeu	a5,a4,5a22 <bsstest+0x12>
    }
  }
}
    5a6e:	0001                	nop
    5a70:	0001                	nop
    5a72:	70a2                	ld	ra,40(sp)
    5a74:	7402                	ld	s0,32(sp)
    5a76:	6145                	addi	sp,sp,48
    5a78:	8082                	ret

0000000000005a7a <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(char *s)
{
    5a7a:	7179                	addi	sp,sp,-48
    5a7c:	f406                	sd	ra,40(sp)
    5a7e:	f022                	sd	s0,32(sp)
    5a80:	1800                	addi	s0,sp,48
    5a82:	fca43c23          	sd	a0,-40(s0)
  int pid, fd, xstatus;

  unlink("bigarg-ok");
    5a86:	00004517          	auipc	a0,0x4
    5a8a:	3ba50513          	addi	a0,a0,954 # 9e40 <malloc+0x1e76>
    5a8e:	00002097          	auipc	ra,0x2
    5a92:	e72080e7          	jalr	-398(ra) # 7900 <unlink>
  pid = fork();
    5a96:	00002097          	auipc	ra,0x2
    5a9a:	e12080e7          	jalr	-494(ra) # 78a8 <fork>
    5a9e:	87aa                	mv	a5,a0
    5aa0:	fef42423          	sw	a5,-24(s0)
  if(pid == 0){
    5aa4:	fe842783          	lw	a5,-24(s0)
    5aa8:	2781                	sext.w	a5,a5
    5aaa:	ebc1                	bnez	a5,5b3a <bigargtest+0xc0>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    5aac:	fe042623          	sw	zero,-20(s0)
    5ab0:	a01d                	j	5ad6 <bigargtest+0x5c>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    5ab2:	0000d717          	auipc	a4,0xd
    5ab6:	f6670713          	addi	a4,a4,-154 # 12a18 <args.1>
    5aba:	fec42783          	lw	a5,-20(s0)
    5abe:	078e                	slli	a5,a5,0x3
    5ac0:	97ba                	add	a5,a5,a4
    5ac2:	00004717          	auipc	a4,0x4
    5ac6:	38e70713          	addi	a4,a4,910 # 9e50 <malloc+0x1e86>
    5aca:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    5acc:	fec42783          	lw	a5,-20(s0)
    5ad0:	2785                	addiw	a5,a5,1
    5ad2:	fef42623          	sw	a5,-20(s0)
    5ad6:	fec42783          	lw	a5,-20(s0)
    5ada:	0007871b          	sext.w	a4,a5
    5ade:	47f9                	li	a5,30
    5ae0:	fce7d9e3          	bge	a5,a4,5ab2 <bigargtest+0x38>
    args[MAXARG-1] = 0;
    5ae4:	0000d797          	auipc	a5,0xd
    5ae8:	f3478793          	addi	a5,a5,-204 # 12a18 <args.1>
    5aec:	0e07bc23          	sd	zero,248(a5)
    exec("echo", args);
    5af0:	0000d597          	auipc	a1,0xd
    5af4:	f2858593          	addi	a1,a1,-216 # 12a18 <args.1>
    5af8:	00003517          	auipc	a0,0x3
    5afc:	83850513          	addi	a0,a0,-1992 # 8330 <malloc+0x366>
    5b00:	00002097          	auipc	ra,0x2
    5b04:	de8080e7          	jalr	-536(ra) # 78e8 <exec>
    fd = open("bigarg-ok", O_CREATE);
    5b08:	20000593          	li	a1,512
    5b0c:	00004517          	auipc	a0,0x4
    5b10:	33450513          	addi	a0,a0,820 # 9e40 <malloc+0x1e76>
    5b14:	00002097          	auipc	ra,0x2
    5b18:	ddc080e7          	jalr	-548(ra) # 78f0 <open>
    5b1c:	87aa                	mv	a5,a0
    5b1e:	fef42223          	sw	a5,-28(s0)
    close(fd);
    5b22:	fe442783          	lw	a5,-28(s0)
    5b26:	853e                	mv	a0,a5
    5b28:	00002097          	auipc	ra,0x2
    5b2c:	db0080e7          	jalr	-592(ra) # 78d8 <close>
    exit(0);
    5b30:	4501                	li	a0,0
    5b32:	00002097          	auipc	ra,0x2
    5b36:	d7e080e7          	jalr	-642(ra) # 78b0 <exit>
  } else if(pid < 0){
    5b3a:	fe842783          	lw	a5,-24(s0)
    5b3e:	2781                	sext.w	a5,a5
    5b40:	0207d163          	bgez	a5,5b62 <bigargtest+0xe8>
    printf("%s: bigargtest: fork failed\n", s);
    5b44:	fd843583          	ld	a1,-40(s0)
    5b48:	00004517          	auipc	a0,0x4
    5b4c:	3e850513          	addi	a0,a0,1000 # 9f30 <malloc+0x1f66>
    5b50:	00002097          	auipc	ra,0x2
    5b54:	288080e7          	jalr	648(ra) # 7dd8 <printf>
    exit(1);
    5b58:	4505                	li	a0,1
    5b5a:	00002097          	auipc	ra,0x2
    5b5e:	d56080e7          	jalr	-682(ra) # 78b0 <exit>
  }
  
  wait(&xstatus);
    5b62:	fe040793          	addi	a5,s0,-32
    5b66:	853e                	mv	a0,a5
    5b68:	00002097          	auipc	ra,0x2
    5b6c:	d50080e7          	jalr	-688(ra) # 78b8 <wait>
  if(xstatus != 0)
    5b70:	fe042783          	lw	a5,-32(s0)
    5b74:	cb81                	beqz	a5,5b84 <bigargtest+0x10a>
    exit(xstatus);
    5b76:	fe042783          	lw	a5,-32(s0)
    5b7a:	853e                	mv	a0,a5
    5b7c:	00002097          	auipc	ra,0x2
    5b80:	d34080e7          	jalr	-716(ra) # 78b0 <exit>
  fd = open("bigarg-ok", 0);
    5b84:	4581                	li	a1,0
    5b86:	00004517          	auipc	a0,0x4
    5b8a:	2ba50513          	addi	a0,a0,698 # 9e40 <malloc+0x1e76>
    5b8e:	00002097          	auipc	ra,0x2
    5b92:	d62080e7          	jalr	-670(ra) # 78f0 <open>
    5b96:	87aa                	mv	a5,a0
    5b98:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    5b9c:	fe442783          	lw	a5,-28(s0)
    5ba0:	2781                	sext.w	a5,a5
    5ba2:	0207d163          	bgez	a5,5bc4 <bigargtest+0x14a>
    printf("%s: bigarg test failed!\n", s);
    5ba6:	fd843583          	ld	a1,-40(s0)
    5baa:	00004517          	auipc	a0,0x4
    5bae:	3a650513          	addi	a0,a0,934 # 9f50 <malloc+0x1f86>
    5bb2:	00002097          	auipc	ra,0x2
    5bb6:	226080e7          	jalr	550(ra) # 7dd8 <printf>
    exit(1);
    5bba:	4505                	li	a0,1
    5bbc:	00002097          	auipc	ra,0x2
    5bc0:	cf4080e7          	jalr	-780(ra) # 78b0 <exit>
  }
  close(fd);
    5bc4:	fe442783          	lw	a5,-28(s0)
    5bc8:	853e                	mv	a0,a5
    5bca:	00002097          	auipc	ra,0x2
    5bce:	d0e080e7          	jalr	-754(ra) # 78d8 <close>
}
    5bd2:	0001                	nop
    5bd4:	70a2                	ld	ra,40(sp)
    5bd6:	7402                	ld	s0,32(sp)
    5bd8:	6145                	addi	sp,sp,48
    5bda:	8082                	ret

0000000000005bdc <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    5bdc:	7159                	addi	sp,sp,-112
    5bde:	f486                	sd	ra,104(sp)
    5be0:	f0a2                	sd	s0,96(sp)
    5be2:	1880                	addi	s0,sp,112
  int nfiles;
  int fsblocks = 0;
    5be4:	fe042423          	sw	zero,-24(s0)

  printf("fsfull test\n");
    5be8:	00004517          	auipc	a0,0x4
    5bec:	38850513          	addi	a0,a0,904 # 9f70 <malloc+0x1fa6>
    5bf0:	00002097          	auipc	ra,0x2
    5bf4:	1e8080e7          	jalr	488(ra) # 7dd8 <printf>

  for(nfiles = 0; ; nfiles++){
    5bf8:	fe042623          	sw	zero,-20(s0)
    char name[64];
    name[0] = 'f';
    5bfc:	06600793          	li	a5,102
    5c00:	f8f40c23          	sb	a5,-104(s0)
    name[1] = '0' + nfiles / 1000;
    5c04:	fec42783          	lw	a5,-20(s0)
    5c08:	873e                	mv	a4,a5
    5c0a:	3e800793          	li	a5,1000
    5c0e:	02f747bb          	divw	a5,a4,a5
    5c12:	2781                	sext.w	a5,a5
    5c14:	0ff7f793          	zext.b	a5,a5
    5c18:	0307879b          	addiw	a5,a5,48
    5c1c:	0ff7f793          	zext.b	a5,a5
    5c20:	f8f40ca3          	sb	a5,-103(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5c24:	fec42783          	lw	a5,-20(s0)
    5c28:	873e                	mv	a4,a5
    5c2a:	3e800793          	li	a5,1000
    5c2e:	02f767bb          	remw	a5,a4,a5
    5c32:	2781                	sext.w	a5,a5
    5c34:	873e                	mv	a4,a5
    5c36:	06400793          	li	a5,100
    5c3a:	02f747bb          	divw	a5,a4,a5
    5c3e:	2781                	sext.w	a5,a5
    5c40:	0ff7f793          	zext.b	a5,a5
    5c44:	0307879b          	addiw	a5,a5,48
    5c48:	0ff7f793          	zext.b	a5,a5
    5c4c:	f8f40d23          	sb	a5,-102(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5c50:	fec42783          	lw	a5,-20(s0)
    5c54:	873e                	mv	a4,a5
    5c56:	06400793          	li	a5,100
    5c5a:	02f767bb          	remw	a5,a4,a5
    5c5e:	2781                	sext.w	a5,a5
    5c60:	873e                	mv	a4,a5
    5c62:	47a9                	li	a5,10
    5c64:	02f747bb          	divw	a5,a4,a5
    5c68:	2781                	sext.w	a5,a5
    5c6a:	0ff7f793          	zext.b	a5,a5
    5c6e:	0307879b          	addiw	a5,a5,48
    5c72:	0ff7f793          	zext.b	a5,a5
    5c76:	f8f40da3          	sb	a5,-101(s0)
    name[4] = '0' + (nfiles % 10);
    5c7a:	fec42783          	lw	a5,-20(s0)
    5c7e:	873e                	mv	a4,a5
    5c80:	47a9                	li	a5,10
    5c82:	02f767bb          	remw	a5,a4,a5
    5c86:	2781                	sext.w	a5,a5
    5c88:	0ff7f793          	zext.b	a5,a5
    5c8c:	0307879b          	addiw	a5,a5,48
    5c90:	0ff7f793          	zext.b	a5,a5
    5c94:	f8f40e23          	sb	a5,-100(s0)
    name[5] = '\0';
    5c98:	f8040ea3          	sb	zero,-99(s0)
    printf("writing %s\n", name);
    5c9c:	f9840793          	addi	a5,s0,-104
    5ca0:	85be                	mv	a1,a5
    5ca2:	00004517          	auipc	a0,0x4
    5ca6:	2de50513          	addi	a0,a0,734 # 9f80 <malloc+0x1fb6>
    5caa:	00002097          	auipc	ra,0x2
    5cae:	12e080e7          	jalr	302(ra) # 7dd8 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5cb2:	f9840793          	addi	a5,s0,-104
    5cb6:	20200593          	li	a1,514
    5cba:	853e                	mv	a0,a5
    5cbc:	00002097          	auipc	ra,0x2
    5cc0:	c34080e7          	jalr	-972(ra) # 78f0 <open>
    5cc4:	87aa                	mv	a5,a0
    5cc6:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
    5cca:	fe042783          	lw	a5,-32(s0)
    5cce:	2781                	sext.w	a5,a5
    5cd0:	0007de63          	bgez	a5,5cec <fsfull+0x110>
      printf("open %s failed\n", name);
    5cd4:	f9840793          	addi	a5,s0,-104
    5cd8:	85be                	mv	a1,a5
    5cda:	00004517          	auipc	a0,0x4
    5cde:	2b650513          	addi	a0,a0,694 # 9f90 <malloc+0x1fc6>
    5ce2:	00002097          	auipc	ra,0x2
    5ce6:	0f6080e7          	jalr	246(ra) # 7dd8 <printf>
      break;
    5cea:	a079                	j	5d78 <fsfull+0x19c>
    }
    int total = 0;
    5cec:	fe042223          	sw	zero,-28(s0)
    while(1){
      int cc = write(fd, buf, BSIZE);
    5cf0:	fe042783          	lw	a5,-32(s0)
    5cf4:	40000613          	li	a2,1024
    5cf8:	00006597          	auipc	a1,0x6
    5cfc:	60858593          	addi	a1,a1,1544 # c300 <buf>
    5d00:	853e                	mv	a0,a5
    5d02:	00002097          	auipc	ra,0x2
    5d06:	bce080e7          	jalr	-1074(ra) # 78d0 <write>
    5d0a:	87aa                	mv	a5,a0
    5d0c:	fcf42e23          	sw	a5,-36(s0)
      if(cc < BSIZE)
    5d10:	fdc42783          	lw	a5,-36(s0)
    5d14:	0007871b          	sext.w	a4,a5
    5d18:	3ff00793          	li	a5,1023
    5d1c:	02e7d063          	bge	a5,a4,5d3c <fsfull+0x160>
        break;
      total += cc;
    5d20:	fe442783          	lw	a5,-28(s0)
    5d24:	873e                	mv	a4,a5
    5d26:	fdc42783          	lw	a5,-36(s0)
    5d2a:	9fb9                	addw	a5,a5,a4
    5d2c:	fef42223          	sw	a5,-28(s0)
      fsblocks++;
    5d30:	fe842783          	lw	a5,-24(s0)
    5d34:	2785                	addiw	a5,a5,1
    5d36:	fef42423          	sw	a5,-24(s0)
    while(1){
    5d3a:	bf5d                	j	5cf0 <fsfull+0x114>
        break;
    5d3c:	0001                	nop
    }
    printf("wrote %d bytes\n", total);
    5d3e:	fe442783          	lw	a5,-28(s0)
    5d42:	85be                	mv	a1,a5
    5d44:	00004517          	auipc	a0,0x4
    5d48:	25c50513          	addi	a0,a0,604 # 9fa0 <malloc+0x1fd6>
    5d4c:	00002097          	auipc	ra,0x2
    5d50:	08c080e7          	jalr	140(ra) # 7dd8 <printf>
    close(fd);
    5d54:	fe042783          	lw	a5,-32(s0)
    5d58:	853e                	mv	a0,a5
    5d5a:	00002097          	auipc	ra,0x2
    5d5e:	b7e080e7          	jalr	-1154(ra) # 78d8 <close>
    if(total == 0)
    5d62:	fe442783          	lw	a5,-28(s0)
    5d66:	2781                	sext.w	a5,a5
    5d68:	c799                	beqz	a5,5d76 <fsfull+0x19a>
  for(nfiles = 0; ; nfiles++){
    5d6a:	fec42783          	lw	a5,-20(s0)
    5d6e:	2785                	addiw	a5,a5,1
    5d70:	fef42623          	sw	a5,-20(s0)
    5d74:	b561                	j	5bfc <fsfull+0x20>
      break;
    5d76:	0001                	nop
  }

  while(nfiles >= 0){
    5d78:	a86d                	j	5e32 <fsfull+0x256>
    char name[64];
    name[0] = 'f';
    5d7a:	06600793          	li	a5,102
    5d7e:	f8f40c23          	sb	a5,-104(s0)
    name[1] = '0' + nfiles / 1000;
    5d82:	fec42783          	lw	a5,-20(s0)
    5d86:	873e                	mv	a4,a5
    5d88:	3e800793          	li	a5,1000
    5d8c:	02f747bb          	divw	a5,a4,a5
    5d90:	2781                	sext.w	a5,a5
    5d92:	0ff7f793          	zext.b	a5,a5
    5d96:	0307879b          	addiw	a5,a5,48
    5d9a:	0ff7f793          	zext.b	a5,a5
    5d9e:	f8f40ca3          	sb	a5,-103(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5da2:	fec42783          	lw	a5,-20(s0)
    5da6:	873e                	mv	a4,a5
    5da8:	3e800793          	li	a5,1000
    5dac:	02f767bb          	remw	a5,a4,a5
    5db0:	2781                	sext.w	a5,a5
    5db2:	873e                	mv	a4,a5
    5db4:	06400793          	li	a5,100
    5db8:	02f747bb          	divw	a5,a4,a5
    5dbc:	2781                	sext.w	a5,a5
    5dbe:	0ff7f793          	zext.b	a5,a5
    5dc2:	0307879b          	addiw	a5,a5,48
    5dc6:	0ff7f793          	zext.b	a5,a5
    5dca:	f8f40d23          	sb	a5,-102(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5dce:	fec42783          	lw	a5,-20(s0)
    5dd2:	873e                	mv	a4,a5
    5dd4:	06400793          	li	a5,100
    5dd8:	02f767bb          	remw	a5,a4,a5
    5ddc:	2781                	sext.w	a5,a5
    5dde:	873e                	mv	a4,a5
    5de0:	47a9                	li	a5,10
    5de2:	02f747bb          	divw	a5,a4,a5
    5de6:	2781                	sext.w	a5,a5
    5de8:	0ff7f793          	zext.b	a5,a5
    5dec:	0307879b          	addiw	a5,a5,48
    5df0:	0ff7f793          	zext.b	a5,a5
    5df4:	f8f40da3          	sb	a5,-101(s0)
    name[4] = '0' + (nfiles % 10);
    5df8:	fec42783          	lw	a5,-20(s0)
    5dfc:	873e                	mv	a4,a5
    5dfe:	47a9                	li	a5,10
    5e00:	02f767bb          	remw	a5,a4,a5
    5e04:	2781                	sext.w	a5,a5
    5e06:	0ff7f793          	zext.b	a5,a5
    5e0a:	0307879b          	addiw	a5,a5,48
    5e0e:	0ff7f793          	zext.b	a5,a5
    5e12:	f8f40e23          	sb	a5,-100(s0)
    name[5] = '\0';
    5e16:	f8040ea3          	sb	zero,-99(s0)
    unlink(name);
    5e1a:	f9840793          	addi	a5,s0,-104
    5e1e:	853e                	mv	a0,a5
    5e20:	00002097          	auipc	ra,0x2
    5e24:	ae0080e7          	jalr	-1312(ra) # 7900 <unlink>
    nfiles--;
    5e28:	fec42783          	lw	a5,-20(s0)
    5e2c:	37fd                	addiw	a5,a5,-1
    5e2e:	fef42623          	sw	a5,-20(s0)
  while(nfiles >= 0){
    5e32:	fec42783          	lw	a5,-20(s0)
    5e36:	2781                	sext.w	a5,a5
    5e38:	f407d1e3          	bgez	a5,5d7a <fsfull+0x19e>
  }

  printf("fsfull test finished\n");
    5e3c:	00004517          	auipc	a0,0x4
    5e40:	17450513          	addi	a0,a0,372 # 9fb0 <malloc+0x1fe6>
    5e44:	00002097          	auipc	ra,0x2
    5e48:	f94080e7          	jalr	-108(ra) # 7dd8 <printf>
}
    5e4c:	0001                	nop
    5e4e:	70a6                	ld	ra,104(sp)
    5e50:	7406                	ld	s0,96(sp)
    5e52:	6165                	addi	sp,sp,112
    5e54:	8082                	ret

0000000000005e56 <argptest>:

void argptest(char *s)
{
    5e56:	7179                	addi	sp,sp,-48
    5e58:	f406                	sd	ra,40(sp)
    5e5a:	f022                	sd	s0,32(sp)
    5e5c:	1800                	addi	s0,sp,48
    5e5e:	fca43c23          	sd	a0,-40(s0)
  int fd;
  fd = open("init", O_RDONLY);
    5e62:	4581                	li	a1,0
    5e64:	00004517          	auipc	a0,0x4
    5e68:	16450513          	addi	a0,a0,356 # 9fc8 <malloc+0x1ffe>
    5e6c:	00002097          	auipc	ra,0x2
    5e70:	a84080e7          	jalr	-1404(ra) # 78f0 <open>
    5e74:	87aa                	mv	a5,a0
    5e76:	fef42623          	sw	a5,-20(s0)
  if (fd < 0) {
    5e7a:	fec42783          	lw	a5,-20(s0)
    5e7e:	2781                	sext.w	a5,a5
    5e80:	0207d163          	bgez	a5,5ea2 <argptest+0x4c>
    printf("%s: open failed\n", s);
    5e84:	fd843583          	ld	a1,-40(s0)
    5e88:	00002517          	auipc	a0,0x2
    5e8c:	6e050513          	addi	a0,a0,1760 # 8568 <malloc+0x59e>
    5e90:	00002097          	auipc	ra,0x2
    5e94:	f48080e7          	jalr	-184(ra) # 7dd8 <printf>
    exit(1);
    5e98:	4505                	li	a0,1
    5e9a:	00002097          	auipc	ra,0x2
    5e9e:	a16080e7          	jalr	-1514(ra) # 78b0 <exit>
  }
  read(fd, sbrk(0) - 1, -1);
    5ea2:	4501                	li	a0,0
    5ea4:	00002097          	auipc	ra,0x2
    5ea8:	a94080e7          	jalr	-1388(ra) # 7938 <sbrk>
    5eac:	87aa                	mv	a5,a0
    5eae:	fff78713          	addi	a4,a5,-1
    5eb2:	fec42783          	lw	a5,-20(s0)
    5eb6:	567d                	li	a2,-1
    5eb8:	85ba                	mv	a1,a4
    5eba:	853e                	mv	a0,a5
    5ebc:	00002097          	auipc	ra,0x2
    5ec0:	a0c080e7          	jalr	-1524(ra) # 78c8 <read>
  close(fd);
    5ec4:	fec42783          	lw	a5,-20(s0)
    5ec8:	853e                	mv	a0,a5
    5eca:	00002097          	auipc	ra,0x2
    5ece:	a0e080e7          	jalr	-1522(ra) # 78d8 <close>
}
    5ed2:	0001                	nop
    5ed4:	70a2                	ld	ra,40(sp)
    5ed6:	7402                	ld	s0,32(sp)
    5ed8:	6145                	addi	sp,sp,48
    5eda:	8082                	ret

0000000000005edc <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest(char *s)
{
    5edc:	7139                	addi	sp,sp,-64
    5ede:	fc06                	sd	ra,56(sp)
    5ee0:	f822                	sd	s0,48(sp)
    5ee2:	0080                	addi	s0,sp,64
    5ee4:	fca43423          	sd	a0,-56(s0)
  int pid;
  int xstatus;
  
  pid = fork();
    5ee8:	00002097          	auipc	ra,0x2
    5eec:	9c0080e7          	jalr	-1600(ra) # 78a8 <fork>
    5ef0:	87aa                	mv	a5,a0
    5ef2:	fef42623          	sw	a5,-20(s0)
  if(pid == 0) {
    5ef6:	fec42783          	lw	a5,-20(s0)
    5efa:	2781                	sext.w	a5,a5
    5efc:	e3b9                	bnez	a5,5f42 <stacktest+0x66>
    char *sp = (char *) r_sp();
    5efe:	ffffa097          	auipc	ra,0xffffa
    5f02:	102080e7          	jalr	258(ra) # 0 <r_sp>
    5f06:	87aa                	mv	a5,a0
    5f08:	fef43023          	sd	a5,-32(s0)
    sp -= PGSIZE;
    5f0c:	fe043703          	ld	a4,-32(s0)
    5f10:	77fd                	lui	a5,0xfffff
    5f12:	97ba                	add	a5,a5,a4
    5f14:	fef43023          	sd	a5,-32(s0)
    // the *sp should cause a trap.
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    5f18:	fe043783          	ld	a5,-32(s0)
    5f1c:	0007c783          	lbu	a5,0(a5) # fffffffffffff000 <freep+0xfffffffffffec4d8>
    5f20:	2781                	sext.w	a5,a5
    5f22:	863e                	mv	a2,a5
    5f24:	fc843583          	ld	a1,-56(s0)
    5f28:	00004517          	auipc	a0,0x4
    5f2c:	0a850513          	addi	a0,a0,168 # 9fd0 <malloc+0x2006>
    5f30:	00002097          	auipc	ra,0x2
    5f34:	ea8080e7          	jalr	-344(ra) # 7dd8 <printf>
    exit(1);
    5f38:	4505                	li	a0,1
    5f3a:	00002097          	auipc	ra,0x2
    5f3e:	976080e7          	jalr	-1674(ra) # 78b0 <exit>
  } else if(pid < 0){
    5f42:	fec42783          	lw	a5,-20(s0)
    5f46:	2781                	sext.w	a5,a5
    5f48:	0207d163          	bgez	a5,5f6a <stacktest+0x8e>
    printf("%s: fork failed\n", s);
    5f4c:	fc843583          	ld	a1,-56(s0)
    5f50:	00002517          	auipc	a0,0x2
    5f54:	60050513          	addi	a0,a0,1536 # 8550 <malloc+0x586>
    5f58:	00002097          	auipc	ra,0x2
    5f5c:	e80080e7          	jalr	-384(ra) # 7dd8 <printf>
    exit(1);
    5f60:	4505                	li	a0,1
    5f62:	00002097          	auipc	ra,0x2
    5f66:	94e080e7          	jalr	-1714(ra) # 78b0 <exit>
  }
  wait(&xstatus);
    5f6a:	fdc40793          	addi	a5,s0,-36
    5f6e:	853e                	mv	a0,a5
    5f70:	00002097          	auipc	ra,0x2
    5f74:	948080e7          	jalr	-1720(ra) # 78b8 <wait>
  if(xstatus == -1)  // kernel killed child?
    5f78:	fdc42783          	lw	a5,-36(s0)
    5f7c:	873e                	mv	a4,a5
    5f7e:	57fd                	li	a5,-1
    5f80:	00f71763          	bne	a4,a5,5f8e <stacktest+0xb2>
    exit(0);
    5f84:	4501                	li	a0,0
    5f86:	00002097          	auipc	ra,0x2
    5f8a:	92a080e7          	jalr	-1750(ra) # 78b0 <exit>
  else
    exit(xstatus);
    5f8e:	fdc42783          	lw	a5,-36(s0)
    5f92:	853e                	mv	a0,a5
    5f94:	00002097          	auipc	ra,0x2
    5f98:	91c080e7          	jalr	-1764(ra) # 78b0 <exit>

0000000000005f9c <textwrite>:
}

// check that writes to text segment fault
void
textwrite(char *s)
{
    5f9c:	7139                	addi	sp,sp,-64
    5f9e:	fc06                	sd	ra,56(sp)
    5fa0:	f822                	sd	s0,48(sp)
    5fa2:	0080                	addi	s0,sp,64
    5fa4:	fca43423          	sd	a0,-56(s0)
  int pid;
  int xstatus;
  
  pid = fork();
    5fa8:	00002097          	auipc	ra,0x2
    5fac:	900080e7          	jalr	-1792(ra) # 78a8 <fork>
    5fb0:	87aa                	mv	a5,a0
    5fb2:	fef42623          	sw	a5,-20(s0)
  if(pid == 0) {
    5fb6:	fec42783          	lw	a5,-20(s0)
    5fba:	2781                	sext.w	a5,a5
    5fbc:	ef81                	bnez	a5,5fd4 <textwrite+0x38>
    volatile int *addr = (int *) 0;
    5fbe:	fe043023          	sd	zero,-32(s0)
    *addr = 10;
    5fc2:	fe043783          	ld	a5,-32(s0)
    5fc6:	4729                	li	a4,10
    5fc8:	c398                	sw	a4,0(a5)
    exit(1);
    5fca:	4505                	li	a0,1
    5fcc:	00002097          	auipc	ra,0x2
    5fd0:	8e4080e7          	jalr	-1820(ra) # 78b0 <exit>
  } else if(pid < 0){
    5fd4:	fec42783          	lw	a5,-20(s0)
    5fd8:	2781                	sext.w	a5,a5
    5fda:	0207d163          	bgez	a5,5ffc <textwrite+0x60>
    printf("%s: fork failed\n", s);
    5fde:	fc843583          	ld	a1,-56(s0)
    5fe2:	00002517          	auipc	a0,0x2
    5fe6:	56e50513          	addi	a0,a0,1390 # 8550 <malloc+0x586>
    5fea:	00002097          	auipc	ra,0x2
    5fee:	dee080e7          	jalr	-530(ra) # 7dd8 <printf>
    exit(1);
    5ff2:	4505                	li	a0,1
    5ff4:	00002097          	auipc	ra,0x2
    5ff8:	8bc080e7          	jalr	-1860(ra) # 78b0 <exit>
  }
  wait(&xstatus);
    5ffc:	fdc40793          	addi	a5,s0,-36
    6000:	853e                	mv	a0,a5
    6002:	00002097          	auipc	ra,0x2
    6006:	8b6080e7          	jalr	-1866(ra) # 78b8 <wait>
  if(xstatus == -1)  // kernel killed child?
    600a:	fdc42783          	lw	a5,-36(s0)
    600e:	873e                	mv	a4,a5
    6010:	57fd                	li	a5,-1
    6012:	00f71763          	bne	a4,a5,6020 <textwrite+0x84>
    exit(0);
    6016:	4501                	li	a0,0
    6018:	00002097          	auipc	ra,0x2
    601c:	898080e7          	jalr	-1896(ra) # 78b0 <exit>
  else
    exit(xstatus);
    6020:	fdc42783          	lw	a5,-36(s0)
    6024:	853e                	mv	a0,a5
    6026:	00002097          	auipc	ra,0x2
    602a:	88a080e7          	jalr	-1910(ra) # 78b0 <exit>

000000000000602e <pgbug>:
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void *big = (void*) 0xeaeb0b5b00002f5e;
void
pgbug(char *s)
{
    602e:	7179                	addi	sp,sp,-48
    6030:	f406                	sd	ra,40(sp)
    6032:	f022                	sd	s0,32(sp)
    6034:	1800                	addi	s0,sp,48
    6036:	fca43c23          	sd	a0,-40(s0)
  char *argv[1];
  argv[0] = 0;
    603a:	fe043423          	sd	zero,-24(s0)
  exec(big, argv);
    603e:	00006797          	auipc	a5,0x6
    6042:	e5278793          	addi	a5,a5,-430 # be90 <big>
    6046:	639c                	ld	a5,0(a5)
    6048:	fe840713          	addi	a4,s0,-24
    604c:	85ba                	mv	a1,a4
    604e:	853e                	mv	a0,a5
    6050:	00002097          	auipc	ra,0x2
    6054:	898080e7          	jalr	-1896(ra) # 78e8 <exec>
  pipe(big);
    6058:	00006797          	auipc	a5,0x6
    605c:	e3878793          	addi	a5,a5,-456 # be90 <big>
    6060:	639c                	ld	a5,0(a5)
    6062:	853e                	mv	a0,a5
    6064:	00002097          	auipc	ra,0x2
    6068:	85c080e7          	jalr	-1956(ra) # 78c0 <pipe>

  exit(0);
    606c:	4501                	li	a0,0
    606e:	00002097          	auipc	ra,0x2
    6072:	842080e7          	jalr	-1982(ra) # 78b0 <exit>

0000000000006076 <sbrkbugs>:
// regression test. does the kernel panic if a process sbrk()s its
// size to be less than a page, or zero, or reduces the break by an
// amount too small to cause a page to be freed?
void
sbrkbugs(char *s)
{
    6076:	7179                	addi	sp,sp,-48
    6078:	f406                	sd	ra,40(sp)
    607a:	f022                	sd	s0,32(sp)
    607c:	1800                	addi	s0,sp,48
    607e:	fca43c23          	sd	a0,-40(s0)
  int pid = fork();
    6082:	00002097          	auipc	ra,0x2
    6086:	826080e7          	jalr	-2010(ra) # 78a8 <fork>
    608a:	87aa                	mv	a5,a0
    608c:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    6090:	fec42783          	lw	a5,-20(s0)
    6094:	2781                	sext.w	a5,a5
    6096:	0007df63          	bgez	a5,60b4 <sbrkbugs+0x3e>
    printf("fork failed\n");
    609a:	00002517          	auipc	a0,0x2
    609e:	28650513          	addi	a0,a0,646 # 8320 <malloc+0x356>
    60a2:	00002097          	auipc	ra,0x2
    60a6:	d36080e7          	jalr	-714(ra) # 7dd8 <printf>
    exit(1);
    60aa:	4505                	li	a0,1
    60ac:	00002097          	auipc	ra,0x2
    60b0:	804080e7          	jalr	-2044(ra) # 78b0 <exit>
  }
  if(pid == 0){
    60b4:	fec42783          	lw	a5,-20(s0)
    60b8:	2781                	sext.w	a5,a5
    60ba:	eb85                	bnez	a5,60ea <sbrkbugs+0x74>
    int sz = (uint64) sbrk(0);
    60bc:	4501                	li	a0,0
    60be:	00002097          	auipc	ra,0x2
    60c2:	87a080e7          	jalr	-1926(ra) # 7938 <sbrk>
    60c6:	87aa                	mv	a5,a0
    60c8:	fef42223          	sw	a5,-28(s0)
    // free all user memory; there used to be a bug that
    // would not adjust p->sz correctly in this case,
    // causing exit() to panic.
    sbrk(-sz);
    60cc:	fe442783          	lw	a5,-28(s0)
    60d0:	40f007bb          	negw	a5,a5
    60d4:	2781                	sext.w	a5,a5
    60d6:	853e                	mv	a0,a5
    60d8:	00002097          	auipc	ra,0x2
    60dc:	860080e7          	jalr	-1952(ra) # 7938 <sbrk>
    // user page fault here.
    exit(0);
    60e0:	4501                	li	a0,0
    60e2:	00001097          	auipc	ra,0x1
    60e6:	7ce080e7          	jalr	1998(ra) # 78b0 <exit>
  }
  wait(0);
    60ea:	4501                	li	a0,0
    60ec:	00001097          	auipc	ra,0x1
    60f0:	7cc080e7          	jalr	1996(ra) # 78b8 <wait>

  pid = fork();
    60f4:	00001097          	auipc	ra,0x1
    60f8:	7b4080e7          	jalr	1972(ra) # 78a8 <fork>
    60fc:	87aa                	mv	a5,a0
    60fe:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    6102:	fec42783          	lw	a5,-20(s0)
    6106:	2781                	sext.w	a5,a5
    6108:	0007df63          	bgez	a5,6126 <sbrkbugs+0xb0>
    printf("fork failed\n");
    610c:	00002517          	auipc	a0,0x2
    6110:	21450513          	addi	a0,a0,532 # 8320 <malloc+0x356>
    6114:	00002097          	auipc	ra,0x2
    6118:	cc4080e7          	jalr	-828(ra) # 7dd8 <printf>
    exit(1);
    611c:	4505                	li	a0,1
    611e:	00001097          	auipc	ra,0x1
    6122:	792080e7          	jalr	1938(ra) # 78b0 <exit>
  }
  if(pid == 0){
    6126:	fec42783          	lw	a5,-20(s0)
    612a:	2781                	sext.w	a5,a5
    612c:	eb95                	bnez	a5,6160 <sbrkbugs+0xea>
    int sz = (uint64) sbrk(0);
    612e:	4501                	li	a0,0
    6130:	00002097          	auipc	ra,0x2
    6134:	808080e7          	jalr	-2040(ra) # 7938 <sbrk>
    6138:	87aa                	mv	a5,a0
    613a:	fef42423          	sw	a5,-24(s0)
    // set the break to somewhere in the very first
    // page; there used to be a bug that would incorrectly
    // free the first page.
    sbrk(-(sz - 3500));
    613e:	6785                	lui	a5,0x1
    6140:	dac7879b          	addiw	a5,a5,-596 # dac <truncate2+0x4c>
    6144:	fe842703          	lw	a4,-24(s0)
    6148:	9f99                	subw	a5,a5,a4
    614a:	2781                	sext.w	a5,a5
    614c:	853e                	mv	a0,a5
    614e:	00001097          	auipc	ra,0x1
    6152:	7ea080e7          	jalr	2026(ra) # 7938 <sbrk>
    exit(0);
    6156:	4501                	li	a0,0
    6158:	00001097          	auipc	ra,0x1
    615c:	758080e7          	jalr	1880(ra) # 78b0 <exit>
  }
  wait(0);
    6160:	4501                	li	a0,0
    6162:	00001097          	auipc	ra,0x1
    6166:	756080e7          	jalr	1878(ra) # 78b8 <wait>

  pid = fork();
    616a:	00001097          	auipc	ra,0x1
    616e:	73e080e7          	jalr	1854(ra) # 78a8 <fork>
    6172:	87aa                	mv	a5,a0
    6174:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    6178:	fec42783          	lw	a5,-20(s0)
    617c:	2781                	sext.w	a5,a5
    617e:	0007df63          	bgez	a5,619c <sbrkbugs+0x126>
    printf("fork failed\n");
    6182:	00002517          	auipc	a0,0x2
    6186:	19e50513          	addi	a0,a0,414 # 8320 <malloc+0x356>
    618a:	00002097          	auipc	ra,0x2
    618e:	c4e080e7          	jalr	-946(ra) # 7dd8 <printf>
    exit(1);
    6192:	4505                	li	a0,1
    6194:	00001097          	auipc	ra,0x1
    6198:	71c080e7          	jalr	1820(ra) # 78b0 <exit>
  }
  if(pid == 0){
    619c:	fec42783          	lw	a5,-20(s0)
    61a0:	2781                	sext.w	a5,a5
    61a2:	ef95                	bnez	a5,61de <sbrkbugs+0x168>
    // set the break in the middle of a page.
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    61a4:	4501                	li	a0,0
    61a6:	00001097          	auipc	ra,0x1
    61aa:	792080e7          	jalr	1938(ra) # 7938 <sbrk>
    61ae:	87aa                	mv	a5,a0
    61b0:	2781                	sext.w	a5,a5
    61b2:	672d                	lui	a4,0xb
    61b4:	8007071b          	addiw	a4,a4,-2048 # a800 <malloc+0x2836>
    61b8:	40f707bb          	subw	a5,a4,a5
    61bc:	2781                	sext.w	a5,a5
    61be:	2781                	sext.w	a5,a5
    61c0:	853e                	mv	a0,a5
    61c2:	00001097          	auipc	ra,0x1
    61c6:	776080e7          	jalr	1910(ra) # 7938 <sbrk>

    // reduce the break a bit, but not enough to
    // cause a page to be freed. this used to cause
    // a panic.
    sbrk(-10);
    61ca:	5559                	li	a0,-10
    61cc:	00001097          	auipc	ra,0x1
    61d0:	76c080e7          	jalr	1900(ra) # 7938 <sbrk>

    exit(0);
    61d4:	4501                	li	a0,0
    61d6:	00001097          	auipc	ra,0x1
    61da:	6da080e7          	jalr	1754(ra) # 78b0 <exit>
  }
  wait(0);
    61de:	4501                	li	a0,0
    61e0:	00001097          	auipc	ra,0x1
    61e4:	6d8080e7          	jalr	1752(ra) # 78b8 <wait>

  exit(0);
    61e8:	4501                	li	a0,0
    61ea:	00001097          	auipc	ra,0x1
    61ee:	6c6080e7          	jalr	1734(ra) # 78b0 <exit>

00000000000061f2 <sbrklast>:
// if process size was somewhat more than a page boundary, and then
// shrunk to be somewhat less than that page boundary, can the kernel
// still copyin() from addresses in the last page?
void
sbrklast(char *s)
{
    61f2:	7139                	addi	sp,sp,-64
    61f4:	fc06                	sd	ra,56(sp)
    61f6:	f822                	sd	s0,48(sp)
    61f8:	0080                	addi	s0,sp,64
    61fa:	fca43423          	sd	a0,-56(s0)
  uint64 top = (uint64) sbrk(0);
    61fe:	4501                	li	a0,0
    6200:	00001097          	auipc	ra,0x1
    6204:	738080e7          	jalr	1848(ra) # 7938 <sbrk>
    6208:	87aa                	mv	a5,a0
    620a:	fef43423          	sd	a5,-24(s0)
  if((top % 4096) != 0)
    620e:	fe843703          	ld	a4,-24(s0)
    6212:	6785                	lui	a5,0x1
    6214:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    6216:	8ff9                	and	a5,a5,a4
    6218:	c39d                	beqz	a5,623e <sbrklast+0x4c>
    sbrk(4096 - (top % 4096));
    621a:	fe843783          	ld	a5,-24(s0)
    621e:	2781                	sext.w	a5,a5
    6220:	873e                	mv	a4,a5
    6222:	6785                	lui	a5,0x1
    6224:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    6226:	8ff9                	and	a5,a5,a4
    6228:	2781                	sext.w	a5,a5
    622a:	6705                	lui	a4,0x1
    622c:	40f707bb          	subw	a5,a4,a5
    6230:	2781                	sext.w	a5,a5
    6232:	2781                	sext.w	a5,a5
    6234:	853e                	mv	a0,a5
    6236:	00001097          	auipc	ra,0x1
    623a:	702080e7          	jalr	1794(ra) # 7938 <sbrk>
  sbrk(4096);
    623e:	6505                	lui	a0,0x1
    6240:	00001097          	auipc	ra,0x1
    6244:	6f8080e7          	jalr	1784(ra) # 7938 <sbrk>
  sbrk(10);
    6248:	4529                	li	a0,10
    624a:	00001097          	auipc	ra,0x1
    624e:	6ee080e7          	jalr	1774(ra) # 7938 <sbrk>
  sbrk(-20);
    6252:	5531                	li	a0,-20
    6254:	00001097          	auipc	ra,0x1
    6258:	6e4080e7          	jalr	1764(ra) # 7938 <sbrk>
  top = (uint64) sbrk(0);
    625c:	4501                	li	a0,0
    625e:	00001097          	auipc	ra,0x1
    6262:	6da080e7          	jalr	1754(ra) # 7938 <sbrk>
    6266:	87aa                	mv	a5,a0
    6268:	fef43423          	sd	a5,-24(s0)
  char *p = (char *) (top - 64);
    626c:	fe843783          	ld	a5,-24(s0)
    6270:	fc078793          	addi	a5,a5,-64
    6274:	fef43023          	sd	a5,-32(s0)
  p[0] = 'x';
    6278:	fe043783          	ld	a5,-32(s0)
    627c:	07800713          	li	a4,120
    6280:	00e78023          	sb	a4,0(a5)
  p[1] = '\0';
    6284:	fe043783          	ld	a5,-32(s0)
    6288:	0785                	addi	a5,a5,1
    628a:	00078023          	sb	zero,0(a5)
  int fd = open(p, O_RDWR|O_CREATE);
    628e:	20200593          	li	a1,514
    6292:	fe043503          	ld	a0,-32(s0)
    6296:	00001097          	auipc	ra,0x1
    629a:	65a080e7          	jalr	1626(ra) # 78f0 <open>
    629e:	87aa                	mv	a5,a0
    62a0:	fcf42e23          	sw	a5,-36(s0)
  write(fd, p, 1);
    62a4:	fdc42783          	lw	a5,-36(s0)
    62a8:	4605                	li	a2,1
    62aa:	fe043583          	ld	a1,-32(s0)
    62ae:	853e                	mv	a0,a5
    62b0:	00001097          	auipc	ra,0x1
    62b4:	620080e7          	jalr	1568(ra) # 78d0 <write>
  close(fd);
    62b8:	fdc42783          	lw	a5,-36(s0)
    62bc:	853e                	mv	a0,a5
    62be:	00001097          	auipc	ra,0x1
    62c2:	61a080e7          	jalr	1562(ra) # 78d8 <close>
  fd = open(p, O_RDWR);
    62c6:	4589                	li	a1,2
    62c8:	fe043503          	ld	a0,-32(s0)
    62cc:	00001097          	auipc	ra,0x1
    62d0:	624080e7          	jalr	1572(ra) # 78f0 <open>
    62d4:	87aa                	mv	a5,a0
    62d6:	fcf42e23          	sw	a5,-36(s0)
  p[0] = '\0';
    62da:	fe043783          	ld	a5,-32(s0)
    62de:	00078023          	sb	zero,0(a5)
  read(fd, p, 1);
    62e2:	fdc42783          	lw	a5,-36(s0)
    62e6:	4605                	li	a2,1
    62e8:	fe043583          	ld	a1,-32(s0)
    62ec:	853e                	mv	a0,a5
    62ee:	00001097          	auipc	ra,0x1
    62f2:	5da080e7          	jalr	1498(ra) # 78c8 <read>
  if(p[0] != 'x')
    62f6:	fe043783          	ld	a5,-32(s0)
    62fa:	0007c783          	lbu	a5,0(a5)
    62fe:	873e                	mv	a4,a5
    6300:	07800793          	li	a5,120
    6304:	00f70763          	beq	a4,a5,6312 <sbrklast+0x120>
    exit(1);
    6308:	4505                	li	a0,1
    630a:	00001097          	auipc	ra,0x1
    630e:	5a6080e7          	jalr	1446(ra) # 78b0 <exit>
}
    6312:	0001                	nop
    6314:	70e2                	ld	ra,56(sp)
    6316:	7442                	ld	s0,48(sp)
    6318:	6121                	addi	sp,sp,64
    631a:	8082                	ret

000000000000631c <sbrk8000>:

// does sbrk handle signed int32 wrap-around with
// negative arguments?
void
sbrk8000(char *s)
{
    631c:	7179                	addi	sp,sp,-48
    631e:	f406                	sd	ra,40(sp)
    6320:	f022                	sd	s0,32(sp)
    6322:	1800                	addi	s0,sp,48
    6324:	fca43c23          	sd	a0,-40(s0)
  sbrk(0x80000004);
    6328:	800007b7          	lui	a5,0x80000
    632c:	00478513          	addi	a0,a5,4 # ffffffff80000004 <freep+0xffffffff7ffed4dc>
    6330:	00001097          	auipc	ra,0x1
    6334:	608080e7          	jalr	1544(ra) # 7938 <sbrk>
  volatile char *top = sbrk(0);
    6338:	4501                	li	a0,0
    633a:	00001097          	auipc	ra,0x1
    633e:	5fe080e7          	jalr	1534(ra) # 7938 <sbrk>
    6342:	fea43423          	sd	a0,-24(s0)
  *(top-1) = *(top-1) + 1;
    6346:	fe843783          	ld	a5,-24(s0)
    634a:	17fd                	addi	a5,a5,-1
    634c:	0007c783          	lbu	a5,0(a5)
    6350:	0ff7f713          	zext.b	a4,a5
    6354:	fe843783          	ld	a5,-24(s0)
    6358:	17fd                	addi	a5,a5,-1
    635a:	2705                	addiw	a4,a4,1 # 1001 <truncate3+0x1b3>
    635c:	0ff77713          	zext.b	a4,a4
    6360:	00e78023          	sb	a4,0(a5)
}
    6364:	0001                	nop
    6366:	70a2                	ld	ra,40(sp)
    6368:	7402                	ld	s0,32(sp)
    636a:	6145                	addi	sp,sp,48
    636c:	8082                	ret

000000000000636e <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    636e:	7139                	addi	sp,sp,-64
    6370:	fc06                	sd	ra,56(sp)
    6372:	f822                	sd	s0,48(sp)
    6374:	0080                	addi	s0,sp,64
    6376:	fca43423          	sd	a0,-56(s0)
  for(int i = 0; i < 50000; i++){
    637a:	fe042623          	sw	zero,-20(s0)
    637e:	a03d                	j	63ac <badarg+0x3e>
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    6380:	57fd                	li	a5,-1
    6382:	9381                	srli	a5,a5,0x20
    6384:	fcf43c23          	sd	a5,-40(s0)
    argv[1] = 0;
    6388:	fe043023          	sd	zero,-32(s0)
    exec("echo", argv);
    638c:	fd840793          	addi	a5,s0,-40
    6390:	85be                	mv	a1,a5
    6392:	00002517          	auipc	a0,0x2
    6396:	f9e50513          	addi	a0,a0,-98 # 8330 <malloc+0x366>
    639a:	00001097          	auipc	ra,0x1
    639e:	54e080e7          	jalr	1358(ra) # 78e8 <exec>
  for(int i = 0; i < 50000; i++){
    63a2:	fec42783          	lw	a5,-20(s0)
    63a6:	2785                	addiw	a5,a5,1
    63a8:	fef42623          	sw	a5,-20(s0)
    63ac:	fec42783          	lw	a5,-20(s0)
    63b0:	0007871b          	sext.w	a4,a5
    63b4:	67b1                	lui	a5,0xc
    63b6:	34f78793          	addi	a5,a5,847 # c34f <buf+0x4f>
    63ba:	fce7d3e3          	bge	a5,a4,6380 <badarg+0x12>
  }
  
  exit(0);
    63be:	4501                	li	a0,0
    63c0:	00001097          	auipc	ra,0x1
    63c4:	4f0080e7          	jalr	1264(ra) # 78b0 <exit>

00000000000063c8 <bigdir>:
//

// directory that uses indirect blocks
void
bigdir(char *s)
{
    63c8:	7139                	addi	sp,sp,-64
    63ca:	fc06                	sd	ra,56(sp)
    63cc:	f822                	sd	s0,48(sp)
    63ce:	0080                	addi	s0,sp,64
    63d0:	fca43423          	sd	a0,-56(s0)
  enum { N = 500 };
  int i, fd;
  char name[10];

  unlink("bd");
    63d4:	00004517          	auipc	a0,0x4
    63d8:	f1450513          	addi	a0,a0,-236 # a2e8 <malloc+0x231e>
    63dc:	00001097          	auipc	ra,0x1
    63e0:	524080e7          	jalr	1316(ra) # 7900 <unlink>

  fd = open("bd", O_CREATE);
    63e4:	20000593          	li	a1,512
    63e8:	00004517          	auipc	a0,0x4
    63ec:	f0050513          	addi	a0,a0,-256 # a2e8 <malloc+0x231e>
    63f0:	00001097          	auipc	ra,0x1
    63f4:	500080e7          	jalr	1280(ra) # 78f0 <open>
    63f8:	87aa                	mv	a5,a0
    63fa:	fef42423          	sw	a5,-24(s0)
  if(fd < 0){
    63fe:	fe842783          	lw	a5,-24(s0)
    6402:	2781                	sext.w	a5,a5
    6404:	0207d163          	bgez	a5,6426 <bigdir+0x5e>
    printf("%s: bigdir create failed\n", s);
    6408:	fc843583          	ld	a1,-56(s0)
    640c:	00004517          	auipc	a0,0x4
    6410:	ee450513          	addi	a0,a0,-284 # a2f0 <malloc+0x2326>
    6414:	00002097          	auipc	ra,0x2
    6418:	9c4080e7          	jalr	-1596(ra) # 7dd8 <printf>
    exit(1);
    641c:	4505                	li	a0,1
    641e:	00001097          	auipc	ra,0x1
    6422:	492080e7          	jalr	1170(ra) # 78b0 <exit>
  }
  close(fd);
    6426:	fe842783          	lw	a5,-24(s0)
    642a:	853e                	mv	a0,a5
    642c:	00001097          	auipc	ra,0x1
    6430:	4ac080e7          	jalr	1196(ra) # 78d8 <close>

  for(i = 0; i < N; i++){
    6434:	fe042623          	sw	zero,-20(s0)
    6438:	a055                	j	64dc <bigdir+0x114>
    name[0] = 'x';
    643a:	07800793          	li	a5,120
    643e:	fcf40c23          	sb	a5,-40(s0)
    name[1] = '0' + (i / 64);
    6442:	fec42783          	lw	a5,-20(s0)
    6446:	41f7d71b          	sraiw	a4,a5,0x1f
    644a:	01a7571b          	srliw	a4,a4,0x1a
    644e:	9fb9                	addw	a5,a5,a4
    6450:	4067d79b          	sraiw	a5,a5,0x6
    6454:	2781                	sext.w	a5,a5
    6456:	0ff7f793          	zext.b	a5,a5
    645a:	0307879b          	addiw	a5,a5,48
    645e:	0ff7f793          	zext.b	a5,a5
    6462:	fcf40ca3          	sb	a5,-39(s0)
    name[2] = '0' + (i % 64);
    6466:	fec42783          	lw	a5,-20(s0)
    646a:	873e                	mv	a4,a5
    646c:	41f7579b          	sraiw	a5,a4,0x1f
    6470:	01a7d79b          	srliw	a5,a5,0x1a
    6474:	9f3d                	addw	a4,a4,a5
    6476:	03f77713          	andi	a4,a4,63
    647a:	40f707bb          	subw	a5,a4,a5
    647e:	2781                	sext.w	a5,a5
    6480:	0ff7f793          	zext.b	a5,a5
    6484:	0307879b          	addiw	a5,a5,48
    6488:	0ff7f793          	zext.b	a5,a5
    648c:	fcf40d23          	sb	a5,-38(s0)
    name[3] = '\0';
    6490:	fc040da3          	sb	zero,-37(s0)
    if(link("bd", name) != 0){
    6494:	fd840793          	addi	a5,s0,-40
    6498:	85be                	mv	a1,a5
    649a:	00004517          	auipc	a0,0x4
    649e:	e4e50513          	addi	a0,a0,-434 # a2e8 <malloc+0x231e>
    64a2:	00001097          	auipc	ra,0x1
    64a6:	46e080e7          	jalr	1134(ra) # 7910 <link>
    64aa:	87aa                	mv	a5,a0
    64ac:	c39d                	beqz	a5,64d2 <bigdir+0x10a>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    64ae:	fd840793          	addi	a5,s0,-40
    64b2:	863e                	mv	a2,a5
    64b4:	fc843583          	ld	a1,-56(s0)
    64b8:	00004517          	auipc	a0,0x4
    64bc:	e5850513          	addi	a0,a0,-424 # a310 <malloc+0x2346>
    64c0:	00002097          	auipc	ra,0x2
    64c4:	918080e7          	jalr	-1768(ra) # 7dd8 <printf>
      exit(1);
    64c8:	4505                	li	a0,1
    64ca:	00001097          	auipc	ra,0x1
    64ce:	3e6080e7          	jalr	998(ra) # 78b0 <exit>
  for(i = 0; i < N; i++){
    64d2:	fec42783          	lw	a5,-20(s0)
    64d6:	2785                	addiw	a5,a5,1
    64d8:	fef42623          	sw	a5,-20(s0)
    64dc:	fec42783          	lw	a5,-20(s0)
    64e0:	0007871b          	sext.w	a4,a5
    64e4:	1f300793          	li	a5,499
    64e8:	f4e7d9e3          	bge	a5,a4,643a <bigdir+0x72>
    }
  }

  unlink("bd");
    64ec:	00004517          	auipc	a0,0x4
    64f0:	dfc50513          	addi	a0,a0,-516 # a2e8 <malloc+0x231e>
    64f4:	00001097          	auipc	ra,0x1
    64f8:	40c080e7          	jalr	1036(ra) # 7900 <unlink>
  for(i = 0; i < N; i++){
    64fc:	fe042623          	sw	zero,-20(s0)
    6500:	a859                	j	6596 <bigdir+0x1ce>
    name[0] = 'x';
    6502:	07800793          	li	a5,120
    6506:	fcf40c23          	sb	a5,-40(s0)
    name[1] = '0' + (i / 64);
    650a:	fec42783          	lw	a5,-20(s0)
    650e:	41f7d71b          	sraiw	a4,a5,0x1f
    6512:	01a7571b          	srliw	a4,a4,0x1a
    6516:	9fb9                	addw	a5,a5,a4
    6518:	4067d79b          	sraiw	a5,a5,0x6
    651c:	2781                	sext.w	a5,a5
    651e:	0ff7f793          	zext.b	a5,a5
    6522:	0307879b          	addiw	a5,a5,48
    6526:	0ff7f793          	zext.b	a5,a5
    652a:	fcf40ca3          	sb	a5,-39(s0)
    name[2] = '0' + (i % 64);
    652e:	fec42783          	lw	a5,-20(s0)
    6532:	873e                	mv	a4,a5
    6534:	41f7579b          	sraiw	a5,a4,0x1f
    6538:	01a7d79b          	srliw	a5,a5,0x1a
    653c:	9f3d                	addw	a4,a4,a5
    653e:	03f77713          	andi	a4,a4,63
    6542:	40f707bb          	subw	a5,a4,a5
    6546:	2781                	sext.w	a5,a5
    6548:	0ff7f793          	zext.b	a5,a5
    654c:	0307879b          	addiw	a5,a5,48
    6550:	0ff7f793          	zext.b	a5,a5
    6554:	fcf40d23          	sb	a5,-38(s0)
    name[3] = '\0';
    6558:	fc040da3          	sb	zero,-37(s0)
    if(unlink(name) != 0){
    655c:	fd840793          	addi	a5,s0,-40
    6560:	853e                	mv	a0,a5
    6562:	00001097          	auipc	ra,0x1
    6566:	39e080e7          	jalr	926(ra) # 7900 <unlink>
    656a:	87aa                	mv	a5,a0
    656c:	c385                	beqz	a5,658c <bigdir+0x1c4>
      printf("%s: bigdir unlink failed", s);
    656e:	fc843583          	ld	a1,-56(s0)
    6572:	00004517          	auipc	a0,0x4
    6576:	dbe50513          	addi	a0,a0,-578 # a330 <malloc+0x2366>
    657a:	00002097          	auipc	ra,0x2
    657e:	85e080e7          	jalr	-1954(ra) # 7dd8 <printf>
      exit(1);
    6582:	4505                	li	a0,1
    6584:	00001097          	auipc	ra,0x1
    6588:	32c080e7          	jalr	812(ra) # 78b0 <exit>
  for(i = 0; i < N; i++){
    658c:	fec42783          	lw	a5,-20(s0)
    6590:	2785                	addiw	a5,a5,1
    6592:	fef42623          	sw	a5,-20(s0)
    6596:	fec42783          	lw	a5,-20(s0)
    659a:	0007871b          	sext.w	a4,a5
    659e:	1f300793          	li	a5,499
    65a2:	f6e7d0e3          	bge	a5,a4,6502 <bigdir+0x13a>
    }
  }
}
    65a6:	0001                	nop
    65a8:	0001                	nop
    65aa:	70e2                	ld	ra,56(sp)
    65ac:	7442                	ld	s0,48(sp)
    65ae:	6121                	addi	sp,sp,64
    65b0:	8082                	ret

00000000000065b2 <manywrites>:

// concurrent writes to try to provoke deadlock in the virtio disk
// driver.
void
manywrites(char *s)
{
    65b2:	711d                	addi	sp,sp,-96
    65b4:	ec86                	sd	ra,88(sp)
    65b6:	e8a2                	sd	s0,80(sp)
    65b8:	1080                	addi	s0,sp,96
    65ba:	faa43423          	sd	a0,-88(s0)
  int nchildren = 4;
    65be:	4791                	li	a5,4
    65c0:	fcf42e23          	sw	a5,-36(s0)
  int howmany = 30; // increase to look for deadlock
    65c4:	47f9                	li	a5,30
    65c6:	fcf42c23          	sw	a5,-40(s0)
  
  for(int ci = 0; ci < nchildren; ci++){
    65ca:	fe042623          	sw	zero,-20(s0)
    65ce:	aa61                	j	6766 <manywrites+0x1b4>
    int pid = fork();
    65d0:	00001097          	auipc	ra,0x1
    65d4:	2d8080e7          	jalr	728(ra) # 78a8 <fork>
    65d8:	87aa                	mv	a5,a0
    65da:	fcf42a23          	sw	a5,-44(s0)
    if(pid < 0){
    65de:	fd442783          	lw	a5,-44(s0)
    65e2:	2781                	sext.w	a5,a5
    65e4:	0007df63          	bgez	a5,6602 <manywrites+0x50>
      printf("fork failed\n");
    65e8:	00002517          	auipc	a0,0x2
    65ec:	d3850513          	addi	a0,a0,-712 # 8320 <malloc+0x356>
    65f0:	00001097          	auipc	ra,0x1
    65f4:	7e8080e7          	jalr	2024(ra) # 7dd8 <printf>
      exit(1);
    65f8:	4505                	li	a0,1
    65fa:	00001097          	auipc	ra,0x1
    65fe:	2b6080e7          	jalr	694(ra) # 78b0 <exit>
    }

    if(pid == 0){
    6602:	fd442783          	lw	a5,-44(s0)
    6606:	2781                	sext.w	a5,a5
    6608:	14079a63          	bnez	a5,675c <manywrites+0x1aa>
      char name[3];
      name[0] = 'b';
    660c:	06200793          	li	a5,98
    6610:	fcf40023          	sb	a5,-64(s0)
      name[1] = 'a' + ci;
    6614:	fec42783          	lw	a5,-20(s0)
    6618:	0ff7f793          	zext.b	a5,a5
    661c:	0617879b          	addiw	a5,a5,97
    6620:	0ff7f793          	zext.b	a5,a5
    6624:	fcf400a3          	sb	a5,-63(s0)
      name[2] = '\0';
    6628:	fc040123          	sb	zero,-62(s0)
      unlink(name);
    662c:	fc040793          	addi	a5,s0,-64
    6630:	853e                	mv	a0,a5
    6632:	00001097          	auipc	ra,0x1
    6636:	2ce080e7          	jalr	718(ra) # 7900 <unlink>
      
      for(int iters = 0; iters < howmany; iters++){
    663a:	fe042423          	sw	zero,-24(s0)
    663e:	a8d5                	j	6732 <manywrites+0x180>
        for(int i = 0; i < ci+1; i++){
    6640:	fe042223          	sw	zero,-28(s0)
    6644:	a0d1                	j	6708 <manywrites+0x156>
          int fd = open(name, O_CREATE | O_RDWR);
    6646:	fc040793          	addi	a5,s0,-64
    664a:	20200593          	li	a1,514
    664e:	853e                	mv	a0,a5
    6650:	00001097          	auipc	ra,0x1
    6654:	2a0080e7          	jalr	672(ra) # 78f0 <open>
    6658:	87aa                	mv	a5,a0
    665a:	fcf42823          	sw	a5,-48(s0)
          if(fd < 0){
    665e:	fd042783          	lw	a5,-48(s0)
    6662:	2781                	sext.w	a5,a5
    6664:	0207d463          	bgez	a5,668c <manywrites+0xda>
            printf("%s: cannot create %s\n", s, name);
    6668:	fc040793          	addi	a5,s0,-64
    666c:	863e                	mv	a2,a5
    666e:	fa843583          	ld	a1,-88(s0)
    6672:	00004517          	auipc	a0,0x4
    6676:	cde50513          	addi	a0,a0,-802 # a350 <malloc+0x2386>
    667a:	00001097          	auipc	ra,0x1
    667e:	75e080e7          	jalr	1886(ra) # 7dd8 <printf>
            exit(1);
    6682:	4505                	li	a0,1
    6684:	00001097          	auipc	ra,0x1
    6688:	22c080e7          	jalr	556(ra) # 78b0 <exit>
          }
          int sz = sizeof(buf);
    668c:	678d                	lui	a5,0x3
    668e:	fcf42623          	sw	a5,-52(s0)
          int cc = write(fd, buf, sz);
    6692:	fcc42703          	lw	a4,-52(s0)
    6696:	fd042783          	lw	a5,-48(s0)
    669a:	863a                	mv	a2,a4
    669c:	00006597          	auipc	a1,0x6
    66a0:	c6458593          	addi	a1,a1,-924 # c300 <buf>
    66a4:	853e                	mv	a0,a5
    66a6:	00001097          	auipc	ra,0x1
    66aa:	22a080e7          	jalr	554(ra) # 78d0 <write>
    66ae:	87aa                	mv	a5,a0
    66b0:	fcf42423          	sw	a5,-56(s0)
          if(cc != sz){
    66b4:	fc842783          	lw	a5,-56(s0)
    66b8:	873e                	mv	a4,a5
    66ba:	fcc42783          	lw	a5,-52(s0)
    66be:	2701                	sext.w	a4,a4
    66c0:	2781                	sext.w	a5,a5
    66c2:	02f70763          	beq	a4,a5,66f0 <manywrites+0x13e>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    66c6:	fc842703          	lw	a4,-56(s0)
    66ca:	fcc42783          	lw	a5,-52(s0)
    66ce:	86ba                	mv	a3,a4
    66d0:	863e                	mv	a2,a5
    66d2:	fa843583          	ld	a1,-88(s0)
    66d6:	00003517          	auipc	a0,0x3
    66da:	e8250513          	addi	a0,a0,-382 # 9558 <malloc+0x158e>
    66de:	00001097          	auipc	ra,0x1
    66e2:	6fa080e7          	jalr	1786(ra) # 7dd8 <printf>
            exit(1);
    66e6:	4505                	li	a0,1
    66e8:	00001097          	auipc	ra,0x1
    66ec:	1c8080e7          	jalr	456(ra) # 78b0 <exit>
          }
          close(fd);
    66f0:	fd042783          	lw	a5,-48(s0)
    66f4:	853e                	mv	a0,a5
    66f6:	00001097          	auipc	ra,0x1
    66fa:	1e2080e7          	jalr	482(ra) # 78d8 <close>
        for(int i = 0; i < ci+1; i++){
    66fe:	fe442783          	lw	a5,-28(s0)
    6702:	2785                	addiw	a5,a5,1 # 3001 <createdelete+0x281>
    6704:	fef42223          	sw	a5,-28(s0)
    6708:	fec42783          	lw	a5,-20(s0)
    670c:	873e                	mv	a4,a5
    670e:	fe442783          	lw	a5,-28(s0)
    6712:	2701                	sext.w	a4,a4
    6714:	2781                	sext.w	a5,a5
    6716:	f2f758e3          	bge	a4,a5,6646 <manywrites+0x94>
        }
        unlink(name);
    671a:	fc040793          	addi	a5,s0,-64
    671e:	853e                	mv	a0,a5
    6720:	00001097          	auipc	ra,0x1
    6724:	1e0080e7          	jalr	480(ra) # 7900 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    6728:	fe842783          	lw	a5,-24(s0)
    672c:	2785                	addiw	a5,a5,1
    672e:	fef42423          	sw	a5,-24(s0)
    6732:	fe842783          	lw	a5,-24(s0)
    6736:	873e                	mv	a4,a5
    6738:	fd842783          	lw	a5,-40(s0)
    673c:	2701                	sext.w	a4,a4
    673e:	2781                	sext.w	a5,a5
    6740:	f0f740e3          	blt	a4,a5,6640 <manywrites+0x8e>
      }

      unlink(name);
    6744:	fc040793          	addi	a5,s0,-64
    6748:	853e                	mv	a0,a5
    674a:	00001097          	auipc	ra,0x1
    674e:	1b6080e7          	jalr	438(ra) # 7900 <unlink>
      exit(0);
    6752:	4501                	li	a0,0
    6754:	00001097          	auipc	ra,0x1
    6758:	15c080e7          	jalr	348(ra) # 78b0 <exit>
  for(int ci = 0; ci < nchildren; ci++){
    675c:	fec42783          	lw	a5,-20(s0)
    6760:	2785                	addiw	a5,a5,1
    6762:	fef42623          	sw	a5,-20(s0)
    6766:	fec42783          	lw	a5,-20(s0)
    676a:	873e                	mv	a4,a5
    676c:	fdc42783          	lw	a5,-36(s0)
    6770:	2701                	sext.w	a4,a4
    6772:	2781                	sext.w	a5,a5
    6774:	e4f74ee3          	blt	a4,a5,65d0 <manywrites+0x1e>
    }
  }

  for(int ci = 0; ci < nchildren; ci++){
    6778:	fe042023          	sw	zero,-32(s0)
    677c:	a80d                	j	67ae <manywrites+0x1fc>
    int st = 0;
    677e:	fa042e23          	sw	zero,-68(s0)
    wait(&st);
    6782:	fbc40793          	addi	a5,s0,-68
    6786:	853e                	mv	a0,a5
    6788:	00001097          	auipc	ra,0x1
    678c:	130080e7          	jalr	304(ra) # 78b8 <wait>
    if(st != 0)
    6790:	fbc42783          	lw	a5,-68(s0)
    6794:	cb81                	beqz	a5,67a4 <manywrites+0x1f2>
      exit(st);
    6796:	fbc42783          	lw	a5,-68(s0)
    679a:	853e                	mv	a0,a5
    679c:	00001097          	auipc	ra,0x1
    67a0:	114080e7          	jalr	276(ra) # 78b0 <exit>
  for(int ci = 0; ci < nchildren; ci++){
    67a4:	fe042783          	lw	a5,-32(s0)
    67a8:	2785                	addiw	a5,a5,1
    67aa:	fef42023          	sw	a5,-32(s0)
    67ae:	fe042783          	lw	a5,-32(s0)
    67b2:	873e                	mv	a4,a5
    67b4:	fdc42783          	lw	a5,-36(s0)
    67b8:	2701                	sext.w	a4,a4
    67ba:	2781                	sext.w	a5,a5
    67bc:	fcf741e3          	blt	a4,a5,677e <manywrites+0x1cc>
  }
  exit(0);
    67c0:	4501                	li	a0,0
    67c2:	00001097          	auipc	ra,0x1
    67c6:	0ee080e7          	jalr	238(ra) # 78b0 <exit>

00000000000067ca <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
    67ca:	7179                	addi	sp,sp,-48
    67cc:	f406                	sd	ra,40(sp)
    67ce:	f022                	sd	s0,32(sp)
    67d0:	1800                	addi	s0,sp,48
    67d2:	fca43c23          	sd	a0,-40(s0)
  int assumed_free = 600;
    67d6:	25800793          	li	a5,600
    67da:	fef42423          	sw	a5,-24(s0)
  
  unlink("junk");
    67de:	00004517          	auipc	a0,0x4
    67e2:	b8a50513          	addi	a0,a0,-1142 # a368 <malloc+0x239e>
    67e6:	00001097          	auipc	ra,0x1
    67ea:	11a080e7          	jalr	282(ra) # 7900 <unlink>
  for(int i = 0; i < assumed_free; i++){
    67ee:	fe042623          	sw	zero,-20(s0)
    67f2:	a8bd                	j	6870 <badwrite+0xa6>
    int fd = open("junk", O_CREATE|O_WRONLY);
    67f4:	20100593          	li	a1,513
    67f8:	00004517          	auipc	a0,0x4
    67fc:	b7050513          	addi	a0,a0,-1168 # a368 <malloc+0x239e>
    6800:	00001097          	auipc	ra,0x1
    6804:	0f0080e7          	jalr	240(ra) # 78f0 <open>
    6808:	87aa                	mv	a5,a0
    680a:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
    680e:	fe042783          	lw	a5,-32(s0)
    6812:	2781                	sext.w	a5,a5
    6814:	0007df63          	bgez	a5,6832 <badwrite+0x68>
      printf("open junk failed\n");
    6818:	00004517          	auipc	a0,0x4
    681c:	b5850513          	addi	a0,a0,-1192 # a370 <malloc+0x23a6>
    6820:	00001097          	auipc	ra,0x1
    6824:	5b8080e7          	jalr	1464(ra) # 7dd8 <printf>
      exit(1);
    6828:	4505                	li	a0,1
    682a:	00001097          	auipc	ra,0x1
    682e:	086080e7          	jalr	134(ra) # 78b0 <exit>
    }
    write(fd, (char*)0xffffffffffL, 1);
    6832:	fe042703          	lw	a4,-32(s0)
    6836:	4605                	li	a2,1
    6838:	57fd                	li	a5,-1
    683a:	0187d593          	srli	a1,a5,0x18
    683e:	853a                	mv	a0,a4
    6840:	00001097          	auipc	ra,0x1
    6844:	090080e7          	jalr	144(ra) # 78d0 <write>
    close(fd);
    6848:	fe042783          	lw	a5,-32(s0)
    684c:	853e                	mv	a0,a5
    684e:	00001097          	auipc	ra,0x1
    6852:	08a080e7          	jalr	138(ra) # 78d8 <close>
    unlink("junk");
    6856:	00004517          	auipc	a0,0x4
    685a:	b1250513          	addi	a0,a0,-1262 # a368 <malloc+0x239e>
    685e:	00001097          	auipc	ra,0x1
    6862:	0a2080e7          	jalr	162(ra) # 7900 <unlink>
  for(int i = 0; i < assumed_free; i++){
    6866:	fec42783          	lw	a5,-20(s0)
    686a:	2785                	addiw	a5,a5,1
    686c:	fef42623          	sw	a5,-20(s0)
    6870:	fec42783          	lw	a5,-20(s0)
    6874:	873e                	mv	a4,a5
    6876:	fe842783          	lw	a5,-24(s0)
    687a:	2701                	sext.w	a4,a4
    687c:	2781                	sext.w	a5,a5
    687e:	f6f74be3          	blt	a4,a5,67f4 <badwrite+0x2a>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
    6882:	20100593          	li	a1,513
    6886:	00004517          	auipc	a0,0x4
    688a:	ae250513          	addi	a0,a0,-1310 # a368 <malloc+0x239e>
    688e:	00001097          	auipc	ra,0x1
    6892:	062080e7          	jalr	98(ra) # 78f0 <open>
    6896:	87aa                	mv	a5,a0
    6898:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    689c:	fe442783          	lw	a5,-28(s0)
    68a0:	2781                	sext.w	a5,a5
    68a2:	0007df63          	bgez	a5,68c0 <badwrite+0xf6>
    printf("open junk failed\n");
    68a6:	00004517          	auipc	a0,0x4
    68aa:	aca50513          	addi	a0,a0,-1334 # a370 <malloc+0x23a6>
    68ae:	00001097          	auipc	ra,0x1
    68b2:	52a080e7          	jalr	1322(ra) # 7dd8 <printf>
    exit(1);
    68b6:	4505                	li	a0,1
    68b8:	00001097          	auipc	ra,0x1
    68bc:	ff8080e7          	jalr	-8(ra) # 78b0 <exit>
  }
  if(write(fd, "x", 1) != 1){
    68c0:	fe442783          	lw	a5,-28(s0)
    68c4:	4605                	li	a2,1
    68c6:	00002597          	auipc	a1,0x2
    68ca:	95a58593          	addi	a1,a1,-1702 # 8220 <malloc+0x256>
    68ce:	853e                	mv	a0,a5
    68d0:	00001097          	auipc	ra,0x1
    68d4:	000080e7          	jalr	ra # 78d0 <write>
    68d8:	87aa                	mv	a5,a0
    68da:	873e                	mv	a4,a5
    68dc:	4785                	li	a5,1
    68de:	00f70f63          	beq	a4,a5,68fc <badwrite+0x132>
    printf("write failed\n");
    68e2:	00004517          	auipc	a0,0x4
    68e6:	aa650513          	addi	a0,a0,-1370 # a388 <malloc+0x23be>
    68ea:	00001097          	auipc	ra,0x1
    68ee:	4ee080e7          	jalr	1262(ra) # 7dd8 <printf>
    exit(1);
    68f2:	4505                	li	a0,1
    68f4:	00001097          	auipc	ra,0x1
    68f8:	fbc080e7          	jalr	-68(ra) # 78b0 <exit>
  }
  close(fd);
    68fc:	fe442783          	lw	a5,-28(s0)
    6900:	853e                	mv	a0,a5
    6902:	00001097          	auipc	ra,0x1
    6906:	fd6080e7          	jalr	-42(ra) # 78d8 <close>
  unlink("junk");
    690a:	00004517          	auipc	a0,0x4
    690e:	a5e50513          	addi	a0,a0,-1442 # a368 <malloc+0x239e>
    6912:	00001097          	auipc	ra,0x1
    6916:	fee080e7          	jalr	-18(ra) # 7900 <unlink>

  exit(0);
    691a:	4501                	li	a0,0
    691c:	00001097          	auipc	ra,0x1
    6920:	f94080e7          	jalr	-108(ra) # 78b0 <exit>

0000000000006924 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    6924:	715d                	addi	sp,sp,-80
    6926:	e486                	sd	ra,72(sp)
    6928:	e0a2                	sd	s0,64(sp)
    692a:	0880                	addi	s0,sp,80
    692c:	faa43c23          	sd	a0,-72(s0)
  for(int avail = 0; avail < 15; avail++){
    6930:	fe042623          	sw	zero,-20(s0)
    6934:	a8cd                	j	6a26 <execout+0x102>
    int pid = fork();
    6936:	00001097          	auipc	ra,0x1
    693a:	f72080e7          	jalr	-142(ra) # 78a8 <fork>
    693e:	87aa                	mv	a5,a0
    6940:	fef42223          	sw	a5,-28(s0)
    if(pid < 0){
    6944:	fe442783          	lw	a5,-28(s0)
    6948:	2781                	sext.w	a5,a5
    694a:	0007df63          	bgez	a5,6968 <execout+0x44>
      printf("fork failed\n");
    694e:	00002517          	auipc	a0,0x2
    6952:	9d250513          	addi	a0,a0,-1582 # 8320 <malloc+0x356>
    6956:	00001097          	auipc	ra,0x1
    695a:	482080e7          	jalr	1154(ra) # 7dd8 <printf>
      exit(1);
    695e:	4505                	li	a0,1
    6960:	00001097          	auipc	ra,0x1
    6964:	f50080e7          	jalr	-176(ra) # 78b0 <exit>
    } else if(pid == 0){
    6968:	fe442783          	lw	a5,-28(s0)
    696c:	2781                	sext.w	a5,a5
    696e:	e3d5                	bnez	a5,6a12 <execout+0xee>
      // allocate all of memory.
      while(1){
        uint64 a = (uint64) sbrk(4096);
    6970:	6505                	lui	a0,0x1
    6972:	00001097          	auipc	ra,0x1
    6976:	fc6080e7          	jalr	-58(ra) # 7938 <sbrk>
    697a:	87aa                	mv	a5,a0
    697c:	fcf43c23          	sd	a5,-40(s0)
        if(a == 0xffffffffffffffffLL)
    6980:	fd843703          	ld	a4,-40(s0)
    6984:	57fd                	li	a5,-1
    6986:	00f70c63          	beq	a4,a5,699e <execout+0x7a>
          break;
        *(char*)(a + 4096 - 1) = 1;
    698a:	fd843703          	ld	a4,-40(s0)
    698e:	6785                	lui	a5,0x1
    6990:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    6992:	97ba                	add	a5,a5,a4
    6994:	873e                	mv	a4,a5
    6996:	4785                	li	a5,1
    6998:	00f70023          	sb	a5,0(a4)
      while(1){
    699c:	bfd1                	j	6970 <execout+0x4c>
          break;
    699e:	0001                	nop
      }

      // free a few pages, in order to let exec() make some
      // progress.
      for(int i = 0; i < avail; i++)
    69a0:	fe042423          	sw	zero,-24(s0)
    69a4:	a819                	j	69ba <execout+0x96>
        sbrk(-4096);
    69a6:	757d                	lui	a0,0xfffff
    69a8:	00001097          	auipc	ra,0x1
    69ac:	f90080e7          	jalr	-112(ra) # 7938 <sbrk>
      for(int i = 0; i < avail; i++)
    69b0:	fe842783          	lw	a5,-24(s0)
    69b4:	2785                	addiw	a5,a5,1
    69b6:	fef42423          	sw	a5,-24(s0)
    69ba:	fe842783          	lw	a5,-24(s0)
    69be:	873e                	mv	a4,a5
    69c0:	fec42783          	lw	a5,-20(s0)
    69c4:	2701                	sext.w	a4,a4
    69c6:	2781                	sext.w	a5,a5
    69c8:	fcf74fe3          	blt	a4,a5,69a6 <execout+0x82>
      
      close(1);
    69cc:	4505                	li	a0,1
    69ce:	00001097          	auipc	ra,0x1
    69d2:	f0a080e7          	jalr	-246(ra) # 78d8 <close>
      char *args[] = { "echo", "x", 0 };
    69d6:	00002797          	auipc	a5,0x2
    69da:	95a78793          	addi	a5,a5,-1702 # 8330 <malloc+0x366>
    69de:	fcf43023          	sd	a5,-64(s0)
    69e2:	00002797          	auipc	a5,0x2
    69e6:	83e78793          	addi	a5,a5,-1986 # 8220 <malloc+0x256>
    69ea:	fcf43423          	sd	a5,-56(s0)
    69ee:	fc043823          	sd	zero,-48(s0)
      exec("echo", args);
    69f2:	fc040793          	addi	a5,s0,-64
    69f6:	85be                	mv	a1,a5
    69f8:	00002517          	auipc	a0,0x2
    69fc:	93850513          	addi	a0,a0,-1736 # 8330 <malloc+0x366>
    6a00:	00001097          	auipc	ra,0x1
    6a04:	ee8080e7          	jalr	-280(ra) # 78e8 <exec>
      exit(0);
    6a08:	4501                	li	a0,0
    6a0a:	00001097          	auipc	ra,0x1
    6a0e:	ea6080e7          	jalr	-346(ra) # 78b0 <exit>
    } else {
      wait((int*)0);
    6a12:	4501                	li	a0,0
    6a14:	00001097          	auipc	ra,0x1
    6a18:	ea4080e7          	jalr	-348(ra) # 78b8 <wait>
  for(int avail = 0; avail < 15; avail++){
    6a1c:	fec42783          	lw	a5,-20(s0)
    6a20:	2785                	addiw	a5,a5,1
    6a22:	fef42623          	sw	a5,-20(s0)
    6a26:	fec42783          	lw	a5,-20(s0)
    6a2a:	0007871b          	sext.w	a4,a5
    6a2e:	47b9                	li	a5,14
    6a30:	f0e7d3e3          	bge	a5,a4,6936 <execout+0x12>
    }
  }

  exit(0);
    6a34:	4501                	li	a0,0
    6a36:	00001097          	auipc	ra,0x1
    6a3a:	e7a080e7          	jalr	-390(ra) # 78b0 <exit>

0000000000006a3e <diskfull>:
}

// can the kernel tolerate running out of disk space?
void
diskfull(char *s)
{
    6a3e:	b9010113          	addi	sp,sp,-1136
    6a42:	46113423          	sd	ra,1128(sp)
    6a46:	46813023          	sd	s0,1120(sp)
    6a4a:	47010413          	addi	s0,sp,1136
    6a4e:	b8a43c23          	sd	a0,-1128(s0)
  int fi;
  int done = 0;
    6a52:	fe042423          	sw	zero,-24(s0)

  unlink("diskfulldir");
    6a56:	00004517          	auipc	a0,0x4
    6a5a:	94250513          	addi	a0,a0,-1726 # a398 <malloc+0x23ce>
    6a5e:	00001097          	auipc	ra,0x1
    6a62:	ea2080e7          	jalr	-350(ra) # 7900 <unlink>
  
  for(fi = 0; done == 0; fi++){
    6a66:	fe042623          	sw	zero,-20(s0)
    6a6a:	a8d5                	j	6b5e <diskfull+0x120>
    char name[32];
    name[0] = 'b';
    6a6c:	06200793          	li	a5,98
    6a70:	baf40423          	sb	a5,-1112(s0)
    name[1] = 'i';
    6a74:	06900793          	li	a5,105
    6a78:	baf404a3          	sb	a5,-1111(s0)
    name[2] = 'g';
    6a7c:	06700793          	li	a5,103
    6a80:	baf40523          	sb	a5,-1110(s0)
    name[3] = '0' + fi;
    6a84:	fec42783          	lw	a5,-20(s0)
    6a88:	0ff7f793          	zext.b	a5,a5
    6a8c:	0307879b          	addiw	a5,a5,48
    6a90:	0ff7f793          	zext.b	a5,a5
    6a94:	baf405a3          	sb	a5,-1109(s0)
    name[4] = '\0';
    6a98:	ba040623          	sb	zero,-1108(s0)
    unlink(name);
    6a9c:	ba840793          	addi	a5,s0,-1112
    6aa0:	853e                	mv	a0,a5
    6aa2:	00001097          	auipc	ra,0x1
    6aa6:	e5e080e7          	jalr	-418(ra) # 7900 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    6aaa:	ba840793          	addi	a5,s0,-1112
    6aae:	60200593          	li	a1,1538
    6ab2:	853e                	mv	a0,a5
    6ab4:	00001097          	auipc	ra,0x1
    6ab8:	e3c080e7          	jalr	-452(ra) # 78f0 <open>
    6abc:	87aa                	mv	a5,a0
    6abe:	fcf42a23          	sw	a5,-44(s0)
    if(fd < 0){
    6ac2:	fd442783          	lw	a5,-44(s0)
    6ac6:	2781                	sext.w	a5,a5
    6ac8:	0207d363          	bgez	a5,6aee <diskfull+0xb0>
      // oops, ran out of inodes before running out of blocks.
      printf("%s: could not create file %s\n", s, name);
    6acc:	ba840793          	addi	a5,s0,-1112
    6ad0:	863e                	mv	a2,a5
    6ad2:	b9843583          	ld	a1,-1128(s0)
    6ad6:	00004517          	auipc	a0,0x4
    6ada:	8d250513          	addi	a0,a0,-1838 # a3a8 <malloc+0x23de>
    6ade:	00001097          	auipc	ra,0x1
    6ae2:	2fa080e7          	jalr	762(ra) # 7dd8 <printf>
      done = 1;
    6ae6:	4785                	li	a5,1
    6ae8:	fef42423          	sw	a5,-24(s0)
    6aec:	a8ad                	j	6b66 <diskfull+0x128>
      break;
    }
    for(int i = 0; i < MAXFILE; i++){
    6aee:	fe042223          	sw	zero,-28(s0)
    6af2:	a099                	j	6b38 <diskfull+0xfa>
      char buf[BSIZE];
      if(write(fd, buf, BSIZE) != BSIZE){
    6af4:	bc840713          	addi	a4,s0,-1080
    6af8:	fd442783          	lw	a5,-44(s0)
    6afc:	40000613          	li	a2,1024
    6b00:	85ba                	mv	a1,a4
    6b02:	853e                	mv	a0,a5
    6b04:	00001097          	auipc	ra,0x1
    6b08:	dcc080e7          	jalr	-564(ra) # 78d0 <write>
    6b0c:	87aa                	mv	a5,a0
    6b0e:	873e                	mv	a4,a5
    6b10:	40000793          	li	a5,1024
    6b14:	00f70d63          	beq	a4,a5,6b2e <diskfull+0xf0>
        done = 1;
    6b18:	4785                	li	a5,1
    6b1a:	fef42423          	sw	a5,-24(s0)
        close(fd);
    6b1e:	fd442783          	lw	a5,-44(s0)
    6b22:	853e                	mv	a0,a5
    6b24:	00001097          	auipc	ra,0x1
    6b28:	db4080e7          	jalr	-588(ra) # 78d8 <close>
    6b2c:	a829                	j	6b46 <diskfull+0x108>
    for(int i = 0; i < MAXFILE; i++){
    6b2e:	fe442783          	lw	a5,-28(s0)
    6b32:	2785                	addiw	a5,a5,1
    6b34:	fef42223          	sw	a5,-28(s0)
    6b38:	fe442783          	lw	a5,-28(s0)
    6b3c:	873e                	mv	a4,a5
    6b3e:	10b00793          	li	a5,267
    6b42:	fae7f9e3          	bgeu	a5,a4,6af4 <diskfull+0xb6>
        break;
      }
    }
    close(fd);
    6b46:	fd442783          	lw	a5,-44(s0)
    6b4a:	853e                	mv	a0,a5
    6b4c:	00001097          	auipc	ra,0x1
    6b50:	d8c080e7          	jalr	-628(ra) # 78d8 <close>
  for(fi = 0; done == 0; fi++){
    6b54:	fec42783          	lw	a5,-20(s0)
    6b58:	2785                	addiw	a5,a5,1
    6b5a:	fef42623          	sw	a5,-20(s0)
    6b5e:	fe842783          	lw	a5,-24(s0)
    6b62:	2781                	sext.w	a5,a5
    6b64:	d781                	beqz	a5,6a6c <diskfull+0x2e>

  // now that there are no free blocks, test that dirlink()
  // merely fails (doesn't panic) if it can't extend
  // directory content. one of these file creations
  // is expected to fail.
  int nzz = 128;
    6b66:	08000793          	li	a5,128
    6b6a:	fcf42823          	sw	a5,-48(s0)
  for(int i = 0; i < nzz; i++){
    6b6e:	fe042023          	sw	zero,-32(s0)
    6b72:	a06d                	j	6c1c <diskfull+0x1de>
    char name[32];
    name[0] = 'z';
    6b74:	07a00793          	li	a5,122
    6b78:	bcf40423          	sb	a5,-1080(s0)
    name[1] = 'z';
    6b7c:	07a00793          	li	a5,122
    6b80:	bcf404a3          	sb	a5,-1079(s0)
    name[2] = '0' + (i / 32);
    6b84:	fe042783          	lw	a5,-32(s0)
    6b88:	41f7d71b          	sraiw	a4,a5,0x1f
    6b8c:	01b7571b          	srliw	a4,a4,0x1b
    6b90:	9fb9                	addw	a5,a5,a4
    6b92:	4057d79b          	sraiw	a5,a5,0x5
    6b96:	2781                	sext.w	a5,a5
    6b98:	0ff7f793          	zext.b	a5,a5
    6b9c:	0307879b          	addiw	a5,a5,48
    6ba0:	0ff7f793          	zext.b	a5,a5
    6ba4:	bcf40523          	sb	a5,-1078(s0)
    name[3] = '0' + (i % 32);
    6ba8:	fe042783          	lw	a5,-32(s0)
    6bac:	873e                	mv	a4,a5
    6bae:	41f7579b          	sraiw	a5,a4,0x1f
    6bb2:	01b7d79b          	srliw	a5,a5,0x1b
    6bb6:	9f3d                	addw	a4,a4,a5
    6bb8:	8b7d                	andi	a4,a4,31
    6bba:	40f707bb          	subw	a5,a4,a5
    6bbe:	2781                	sext.w	a5,a5
    6bc0:	0ff7f793          	zext.b	a5,a5
    6bc4:	0307879b          	addiw	a5,a5,48
    6bc8:	0ff7f793          	zext.b	a5,a5
    6bcc:	bcf405a3          	sb	a5,-1077(s0)
    name[4] = '\0';
    6bd0:	bc040623          	sb	zero,-1076(s0)
    unlink(name);
    6bd4:	bc840793          	addi	a5,s0,-1080
    6bd8:	853e                	mv	a0,a5
    6bda:	00001097          	auipc	ra,0x1
    6bde:	d26080e7          	jalr	-730(ra) # 7900 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    6be2:	bc840793          	addi	a5,s0,-1080
    6be6:	60200593          	li	a1,1538
    6bea:	853e                	mv	a0,a5
    6bec:	00001097          	auipc	ra,0x1
    6bf0:	d04080e7          	jalr	-764(ra) # 78f0 <open>
    6bf4:	87aa                	mv	a5,a0
    6bf6:	fcf42623          	sw	a5,-52(s0)
    if(fd < 0)
    6bfa:	fcc42783          	lw	a5,-52(s0)
    6bfe:	2781                	sext.w	a5,a5
    6c00:	0207c863          	bltz	a5,6c30 <diskfull+0x1f2>
      break;
    close(fd);
    6c04:	fcc42783          	lw	a5,-52(s0)
    6c08:	853e                	mv	a0,a5
    6c0a:	00001097          	auipc	ra,0x1
    6c0e:	cce080e7          	jalr	-818(ra) # 78d8 <close>
  for(int i = 0; i < nzz; i++){
    6c12:	fe042783          	lw	a5,-32(s0)
    6c16:	2785                	addiw	a5,a5,1
    6c18:	fef42023          	sw	a5,-32(s0)
    6c1c:	fe042783          	lw	a5,-32(s0)
    6c20:	873e                	mv	a4,a5
    6c22:	fd042783          	lw	a5,-48(s0)
    6c26:	2701                	sext.w	a4,a4
    6c28:	2781                	sext.w	a5,a5
    6c2a:	f4f745e3          	blt	a4,a5,6b74 <diskfull+0x136>
    6c2e:	a011                	j	6c32 <diskfull+0x1f4>
      break;
    6c30:	0001                	nop
  }

  // this mkdir() is expected to fail.
  if(mkdir("diskfulldir") == 0)
    6c32:	00003517          	auipc	a0,0x3
    6c36:	76650513          	addi	a0,a0,1894 # a398 <malloc+0x23ce>
    6c3a:	00001097          	auipc	ra,0x1
    6c3e:	cde080e7          	jalr	-802(ra) # 7918 <mkdir>
    6c42:	87aa                	mv	a5,a0
    6c44:	eb89                	bnez	a5,6c56 <diskfull+0x218>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    6c46:	00003517          	auipc	a0,0x3
    6c4a:	78250513          	addi	a0,a0,1922 # a3c8 <malloc+0x23fe>
    6c4e:	00001097          	auipc	ra,0x1
    6c52:	18a080e7          	jalr	394(ra) # 7dd8 <printf>

  unlink("diskfulldir");
    6c56:	00003517          	auipc	a0,0x3
    6c5a:	74250513          	addi	a0,a0,1858 # a398 <malloc+0x23ce>
    6c5e:	00001097          	auipc	ra,0x1
    6c62:	ca2080e7          	jalr	-862(ra) # 7900 <unlink>

  for(int i = 0; i < nzz; i++){
    6c66:	fc042e23          	sw	zero,-36(s0)
    6c6a:	a8ad                	j	6ce4 <diskfull+0x2a6>
    char name[32];
    name[0] = 'z';
    6c6c:	07a00793          	li	a5,122
    6c70:	bcf40423          	sb	a5,-1080(s0)
    name[1] = 'z';
    6c74:	07a00793          	li	a5,122
    6c78:	bcf404a3          	sb	a5,-1079(s0)
    name[2] = '0' + (i / 32);
    6c7c:	fdc42783          	lw	a5,-36(s0)
    6c80:	41f7d71b          	sraiw	a4,a5,0x1f
    6c84:	01b7571b          	srliw	a4,a4,0x1b
    6c88:	9fb9                	addw	a5,a5,a4
    6c8a:	4057d79b          	sraiw	a5,a5,0x5
    6c8e:	2781                	sext.w	a5,a5
    6c90:	0ff7f793          	zext.b	a5,a5
    6c94:	0307879b          	addiw	a5,a5,48
    6c98:	0ff7f793          	zext.b	a5,a5
    6c9c:	bcf40523          	sb	a5,-1078(s0)
    name[3] = '0' + (i % 32);
    6ca0:	fdc42783          	lw	a5,-36(s0)
    6ca4:	873e                	mv	a4,a5
    6ca6:	41f7579b          	sraiw	a5,a4,0x1f
    6caa:	01b7d79b          	srliw	a5,a5,0x1b
    6cae:	9f3d                	addw	a4,a4,a5
    6cb0:	8b7d                	andi	a4,a4,31
    6cb2:	40f707bb          	subw	a5,a4,a5
    6cb6:	2781                	sext.w	a5,a5
    6cb8:	0ff7f793          	zext.b	a5,a5
    6cbc:	0307879b          	addiw	a5,a5,48
    6cc0:	0ff7f793          	zext.b	a5,a5
    6cc4:	bcf405a3          	sb	a5,-1077(s0)
    name[4] = '\0';
    6cc8:	bc040623          	sb	zero,-1076(s0)
    unlink(name);
    6ccc:	bc840793          	addi	a5,s0,-1080
    6cd0:	853e                	mv	a0,a5
    6cd2:	00001097          	auipc	ra,0x1
    6cd6:	c2e080e7          	jalr	-978(ra) # 7900 <unlink>
  for(int i = 0; i < nzz; i++){
    6cda:	fdc42783          	lw	a5,-36(s0)
    6cde:	2785                	addiw	a5,a5,1
    6ce0:	fcf42e23          	sw	a5,-36(s0)
    6ce4:	fdc42783          	lw	a5,-36(s0)
    6ce8:	873e                	mv	a4,a5
    6cea:	fd042783          	lw	a5,-48(s0)
    6cee:	2701                	sext.w	a4,a4
    6cf0:	2781                	sext.w	a5,a5
    6cf2:	f6f74de3          	blt	a4,a5,6c6c <diskfull+0x22e>
  }

  for(int i = 0; i < fi; i++){
    6cf6:	fc042c23          	sw	zero,-40(s0)
    6cfa:	a0a9                	j	6d44 <diskfull+0x306>
    char name[32];
    name[0] = 'b';
    6cfc:	06200793          	li	a5,98
    6d00:	bcf40423          	sb	a5,-1080(s0)
    name[1] = 'i';
    6d04:	06900793          	li	a5,105
    6d08:	bcf404a3          	sb	a5,-1079(s0)
    name[2] = 'g';
    6d0c:	06700793          	li	a5,103
    6d10:	bcf40523          	sb	a5,-1078(s0)
    name[3] = '0' + i;
    6d14:	fd842783          	lw	a5,-40(s0)
    6d18:	0ff7f793          	zext.b	a5,a5
    6d1c:	0307879b          	addiw	a5,a5,48
    6d20:	0ff7f793          	zext.b	a5,a5
    6d24:	bcf405a3          	sb	a5,-1077(s0)
    name[4] = '\0';
    6d28:	bc040623          	sb	zero,-1076(s0)
    unlink(name);
    6d2c:	bc840793          	addi	a5,s0,-1080
    6d30:	853e                	mv	a0,a5
    6d32:	00001097          	auipc	ra,0x1
    6d36:	bce080e7          	jalr	-1074(ra) # 7900 <unlink>
  for(int i = 0; i < fi; i++){
    6d3a:	fd842783          	lw	a5,-40(s0)
    6d3e:	2785                	addiw	a5,a5,1
    6d40:	fcf42c23          	sw	a5,-40(s0)
    6d44:	fd842783          	lw	a5,-40(s0)
    6d48:	873e                	mv	a4,a5
    6d4a:	fec42783          	lw	a5,-20(s0)
    6d4e:	2701                	sext.w	a4,a4
    6d50:	2781                	sext.w	a5,a5
    6d52:	faf745e3          	blt	a4,a5,6cfc <diskfull+0x2be>
  }
}
    6d56:	0001                	nop
    6d58:	0001                	nop
    6d5a:	46813083          	ld	ra,1128(sp)
    6d5e:	46013403          	ld	s0,1120(sp)
    6d62:	47010113          	addi	sp,sp,1136
    6d66:	8082                	ret

0000000000006d68 <outofinodes>:

void
outofinodes(char *s)
{
    6d68:	715d                	addi	sp,sp,-80
    6d6a:	e486                	sd	ra,72(sp)
    6d6c:	e0a2                	sd	s0,64(sp)
    6d6e:	0880                	addi	s0,sp,80
    6d70:	faa43c23          	sd	a0,-72(s0)
  int nzz = 32*32;
    6d74:	40000793          	li	a5,1024
    6d78:	fef42223          	sw	a5,-28(s0)
  for(int i = 0; i < nzz; i++){
    6d7c:	fe042623          	sw	zero,-20(s0)
    6d80:	a06d                	j	6e2a <outofinodes+0xc2>
    char name[32];
    name[0] = 'z';
    6d82:	07a00793          	li	a5,122
    6d86:	fcf40023          	sb	a5,-64(s0)
    name[1] = 'z';
    6d8a:	07a00793          	li	a5,122
    6d8e:	fcf400a3          	sb	a5,-63(s0)
    name[2] = '0' + (i / 32);
    6d92:	fec42783          	lw	a5,-20(s0)
    6d96:	41f7d71b          	sraiw	a4,a5,0x1f
    6d9a:	01b7571b          	srliw	a4,a4,0x1b
    6d9e:	9fb9                	addw	a5,a5,a4
    6da0:	4057d79b          	sraiw	a5,a5,0x5
    6da4:	2781                	sext.w	a5,a5
    6da6:	0ff7f793          	zext.b	a5,a5
    6daa:	0307879b          	addiw	a5,a5,48
    6dae:	0ff7f793          	zext.b	a5,a5
    6db2:	fcf40123          	sb	a5,-62(s0)
    name[3] = '0' + (i % 32);
    6db6:	fec42783          	lw	a5,-20(s0)
    6dba:	873e                	mv	a4,a5
    6dbc:	41f7579b          	sraiw	a5,a4,0x1f
    6dc0:	01b7d79b          	srliw	a5,a5,0x1b
    6dc4:	9f3d                	addw	a4,a4,a5
    6dc6:	8b7d                	andi	a4,a4,31
    6dc8:	40f707bb          	subw	a5,a4,a5
    6dcc:	2781                	sext.w	a5,a5
    6dce:	0ff7f793          	zext.b	a5,a5
    6dd2:	0307879b          	addiw	a5,a5,48
    6dd6:	0ff7f793          	zext.b	a5,a5
    6dda:	fcf401a3          	sb	a5,-61(s0)
    name[4] = '\0';
    6dde:	fc040223          	sb	zero,-60(s0)
    unlink(name);
    6de2:	fc040793          	addi	a5,s0,-64
    6de6:	853e                	mv	a0,a5
    6de8:	00001097          	auipc	ra,0x1
    6dec:	b18080e7          	jalr	-1256(ra) # 7900 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    6df0:	fc040793          	addi	a5,s0,-64
    6df4:	60200593          	li	a1,1538
    6df8:	853e                	mv	a0,a5
    6dfa:	00001097          	auipc	ra,0x1
    6dfe:	af6080e7          	jalr	-1290(ra) # 78f0 <open>
    6e02:	87aa                	mv	a5,a0
    6e04:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
    6e08:	fe042783          	lw	a5,-32(s0)
    6e0c:	2781                	sext.w	a5,a5
    6e0e:	0207c863          	bltz	a5,6e3e <outofinodes+0xd6>
      // failure is eventually expected.
      break;
    }
    close(fd);
    6e12:	fe042783          	lw	a5,-32(s0)
    6e16:	853e                	mv	a0,a5
    6e18:	00001097          	auipc	ra,0x1
    6e1c:	ac0080e7          	jalr	-1344(ra) # 78d8 <close>
  for(int i = 0; i < nzz; i++){
    6e20:	fec42783          	lw	a5,-20(s0)
    6e24:	2785                	addiw	a5,a5,1
    6e26:	fef42623          	sw	a5,-20(s0)
    6e2a:	fec42783          	lw	a5,-20(s0)
    6e2e:	873e                	mv	a4,a5
    6e30:	fe442783          	lw	a5,-28(s0)
    6e34:	2701                	sext.w	a4,a4
    6e36:	2781                	sext.w	a5,a5
    6e38:	f4f745e3          	blt	a4,a5,6d82 <outofinodes+0x1a>
    6e3c:	a011                	j	6e40 <outofinodes+0xd8>
      break;
    6e3e:	0001                	nop
  }

  for(int i = 0; i < nzz; i++){
    6e40:	fe042423          	sw	zero,-24(s0)
    6e44:	a8ad                	j	6ebe <outofinodes+0x156>
    char name[32];
    name[0] = 'z';
    6e46:	07a00793          	li	a5,122
    6e4a:	fcf40023          	sb	a5,-64(s0)
    name[1] = 'z';
    6e4e:	07a00793          	li	a5,122
    6e52:	fcf400a3          	sb	a5,-63(s0)
    name[2] = '0' + (i / 32);
    6e56:	fe842783          	lw	a5,-24(s0)
    6e5a:	41f7d71b          	sraiw	a4,a5,0x1f
    6e5e:	01b7571b          	srliw	a4,a4,0x1b
    6e62:	9fb9                	addw	a5,a5,a4
    6e64:	4057d79b          	sraiw	a5,a5,0x5
    6e68:	2781                	sext.w	a5,a5
    6e6a:	0ff7f793          	zext.b	a5,a5
    6e6e:	0307879b          	addiw	a5,a5,48
    6e72:	0ff7f793          	zext.b	a5,a5
    6e76:	fcf40123          	sb	a5,-62(s0)
    name[3] = '0' + (i % 32);
    6e7a:	fe842783          	lw	a5,-24(s0)
    6e7e:	873e                	mv	a4,a5
    6e80:	41f7579b          	sraiw	a5,a4,0x1f
    6e84:	01b7d79b          	srliw	a5,a5,0x1b
    6e88:	9f3d                	addw	a4,a4,a5
    6e8a:	8b7d                	andi	a4,a4,31
    6e8c:	40f707bb          	subw	a5,a4,a5
    6e90:	2781                	sext.w	a5,a5
    6e92:	0ff7f793          	zext.b	a5,a5
    6e96:	0307879b          	addiw	a5,a5,48
    6e9a:	0ff7f793          	zext.b	a5,a5
    6e9e:	fcf401a3          	sb	a5,-61(s0)
    name[4] = '\0';
    6ea2:	fc040223          	sb	zero,-60(s0)
    unlink(name);
    6ea6:	fc040793          	addi	a5,s0,-64
    6eaa:	853e                	mv	a0,a5
    6eac:	00001097          	auipc	ra,0x1
    6eb0:	a54080e7          	jalr	-1452(ra) # 7900 <unlink>
  for(int i = 0; i < nzz; i++){
    6eb4:	fe842783          	lw	a5,-24(s0)
    6eb8:	2785                	addiw	a5,a5,1
    6eba:	fef42423          	sw	a5,-24(s0)
    6ebe:	fe842783          	lw	a5,-24(s0)
    6ec2:	873e                	mv	a4,a5
    6ec4:	fe442783          	lw	a5,-28(s0)
    6ec8:	2701                	sext.w	a4,a4
    6eca:	2781                	sext.w	a5,a5
    6ecc:	f6f74de3          	blt	a4,a5,6e46 <outofinodes+0xde>
  }
}
    6ed0:	0001                	nop
    6ed2:	0001                	nop
    6ed4:	60a6                	ld	ra,72(sp)
    6ed6:	6406                	ld	s0,64(sp)
    6ed8:	6161                	addi	sp,sp,80
    6eda:	8082                	ret

0000000000006edc <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    6edc:	7179                	addi	sp,sp,-48
    6ede:	f406                	sd	ra,40(sp)
    6ee0:	f022                	sd	s0,32(sp)
    6ee2:	1800                	addi	s0,sp,48
    6ee4:	fca43c23          	sd	a0,-40(s0)
    6ee8:	fcb43823          	sd	a1,-48(s0)
  int pid;
  int xstatus;

  printf("test %s: ", s);
    6eec:	fd043583          	ld	a1,-48(s0)
    6ef0:	00003517          	auipc	a0,0x3
    6ef4:	55850513          	addi	a0,a0,1368 # a448 <malloc+0x247e>
    6ef8:	00001097          	auipc	ra,0x1
    6efc:	ee0080e7          	jalr	-288(ra) # 7dd8 <printf>
  if((pid = fork()) < 0) {
    6f00:	00001097          	auipc	ra,0x1
    6f04:	9a8080e7          	jalr	-1624(ra) # 78a8 <fork>
    6f08:	87aa                	mv	a5,a0
    6f0a:	fef42623          	sw	a5,-20(s0)
    6f0e:	fec42783          	lw	a5,-20(s0)
    6f12:	2781                	sext.w	a5,a5
    6f14:	0007df63          	bgez	a5,6f32 <run+0x56>
    printf("runtest: fork error\n");
    6f18:	00003517          	auipc	a0,0x3
    6f1c:	54050513          	addi	a0,a0,1344 # a458 <malloc+0x248e>
    6f20:	00001097          	auipc	ra,0x1
    6f24:	eb8080e7          	jalr	-328(ra) # 7dd8 <printf>
    exit(1);
    6f28:	4505                	li	a0,1
    6f2a:	00001097          	auipc	ra,0x1
    6f2e:	986080e7          	jalr	-1658(ra) # 78b0 <exit>
  }
  if(pid == 0) {
    6f32:	fec42783          	lw	a5,-20(s0)
    6f36:	2781                	sext.w	a5,a5
    6f38:	eb99                	bnez	a5,6f4e <run+0x72>
    f(s);
    6f3a:	fd843783          	ld	a5,-40(s0)
    6f3e:	fd043503          	ld	a0,-48(s0)
    6f42:	9782                	jalr	a5
    exit(0);
    6f44:	4501                	li	a0,0
    6f46:	00001097          	auipc	ra,0x1
    6f4a:	96a080e7          	jalr	-1686(ra) # 78b0 <exit>
  } else {
    wait(&xstatus);
    6f4e:	fe840793          	addi	a5,s0,-24
    6f52:	853e                	mv	a0,a5
    6f54:	00001097          	auipc	ra,0x1
    6f58:	964080e7          	jalr	-1692(ra) # 78b8 <wait>
    if(xstatus != 0) 
    6f5c:	fe842783          	lw	a5,-24(s0)
    6f60:	cb91                	beqz	a5,6f74 <run+0x98>
      printf("FAILED\n");
    6f62:	00003517          	auipc	a0,0x3
    6f66:	50e50513          	addi	a0,a0,1294 # a470 <malloc+0x24a6>
    6f6a:	00001097          	auipc	ra,0x1
    6f6e:	e6e080e7          	jalr	-402(ra) # 7dd8 <printf>
    6f72:	a809                	j	6f84 <run+0xa8>
    else
      printf("OK\n");
    6f74:	00003517          	auipc	a0,0x3
    6f78:	50450513          	addi	a0,a0,1284 # a478 <malloc+0x24ae>
    6f7c:	00001097          	auipc	ra,0x1
    6f80:	e5c080e7          	jalr	-420(ra) # 7dd8 <printf>
    return xstatus == 0;
    6f84:	fe842783          	lw	a5,-24(s0)
    6f88:	0017b793          	seqz	a5,a5
    6f8c:	0ff7f793          	zext.b	a5,a5
    6f90:	2781                	sext.w	a5,a5
  }
}
    6f92:	853e                	mv	a0,a5
    6f94:	70a2                	ld	ra,40(sp)
    6f96:	7402                	ld	s0,32(sp)
    6f98:	6145                	addi	sp,sp,48
    6f9a:	8082                	ret

0000000000006f9c <runtests>:

int
runtests(struct test *tests, char *justone) {
    6f9c:	7179                	addi	sp,sp,-48
    6f9e:	f406                	sd	ra,40(sp)
    6fa0:	f022                	sd	s0,32(sp)
    6fa2:	1800                	addi	s0,sp,48
    6fa4:	fca43c23          	sd	a0,-40(s0)
    6fa8:	fcb43823          	sd	a1,-48(s0)
  for (struct test *t = tests; t->s != 0; t++) {
    6fac:	fd843783          	ld	a5,-40(s0)
    6fb0:	fef43423          	sd	a5,-24(s0)
    6fb4:	a8a9                	j	700e <runtests+0x72>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    6fb6:	fd043783          	ld	a5,-48(s0)
    6fba:	cf89                	beqz	a5,6fd4 <runtests+0x38>
    6fbc:	fe843783          	ld	a5,-24(s0)
    6fc0:	679c                	ld	a5,8(a5)
    6fc2:	fd043583          	ld	a1,-48(s0)
    6fc6:	853e                	mv	a0,a5
    6fc8:	00000097          	auipc	ra,0x0
    6fcc:	4a0080e7          	jalr	1184(ra) # 7468 <strcmp>
    6fd0:	87aa                	mv	a5,a0
    6fd2:	eb8d                	bnez	a5,7004 <runtests+0x68>
      if(!run(t->f, t->s)){
    6fd4:	fe843783          	ld	a5,-24(s0)
    6fd8:	6398                	ld	a4,0(a5)
    6fda:	fe843783          	ld	a5,-24(s0)
    6fde:	679c                	ld	a5,8(a5)
    6fe0:	85be                	mv	a1,a5
    6fe2:	853a                	mv	a0,a4
    6fe4:	00000097          	auipc	ra,0x0
    6fe8:	ef8080e7          	jalr	-264(ra) # 6edc <run>
    6fec:	87aa                	mv	a5,a0
    6fee:	eb99                	bnez	a5,7004 <runtests+0x68>
        printf("SOME TESTS FAILED\n");
    6ff0:	00003517          	auipc	a0,0x3
    6ff4:	49050513          	addi	a0,a0,1168 # a480 <malloc+0x24b6>
    6ff8:	00001097          	auipc	ra,0x1
    6ffc:	de0080e7          	jalr	-544(ra) # 7dd8 <printf>
        return 1;
    7000:	4785                	li	a5,1
    7002:	a819                	j	7018 <runtests+0x7c>
  for (struct test *t = tests; t->s != 0; t++) {
    7004:	fe843783          	ld	a5,-24(s0)
    7008:	07c1                	addi	a5,a5,16
    700a:	fef43423          	sd	a5,-24(s0)
    700e:	fe843783          	ld	a5,-24(s0)
    7012:	679c                	ld	a5,8(a5)
    7014:	f3cd                	bnez	a5,6fb6 <runtests+0x1a>
      }
    }
  }
  return 0;
    7016:	4781                	li	a5,0
}
    7018:	853e                	mv	a0,a5
    701a:	70a2                	ld	ra,40(sp)
    701c:	7402                	ld	s0,32(sp)
    701e:	6145                	addi	sp,sp,48
    7020:	8082                	ret

0000000000007022 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    7022:	7139                	addi	sp,sp,-64
    7024:	fc06                	sd	ra,56(sp)
    7026:	f822                	sd	s0,48(sp)
    7028:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    702a:	fd040793          	addi	a5,s0,-48
    702e:	853e                	mv	a0,a5
    7030:	00001097          	auipc	ra,0x1
    7034:	890080e7          	jalr	-1904(ra) # 78c0 <pipe>
    7038:	87aa                	mv	a5,a0
    703a:	0007df63          	bgez	a5,7058 <countfree+0x36>
    printf("pipe() failed in countfree()\n");
    703e:	00003517          	auipc	a0,0x3
    7042:	45a50513          	addi	a0,a0,1114 # a498 <malloc+0x24ce>
    7046:	00001097          	auipc	ra,0x1
    704a:	d92080e7          	jalr	-622(ra) # 7dd8 <printf>
    exit(1);
    704e:	4505                	li	a0,1
    7050:	00001097          	auipc	ra,0x1
    7054:	860080e7          	jalr	-1952(ra) # 78b0 <exit>
  }
  
  int pid = fork();
    7058:	00001097          	auipc	ra,0x1
    705c:	850080e7          	jalr	-1968(ra) # 78a8 <fork>
    7060:	87aa                	mv	a5,a0
    7062:	fef42423          	sw	a5,-24(s0)

  if(pid < 0){
    7066:	fe842783          	lw	a5,-24(s0)
    706a:	2781                	sext.w	a5,a5
    706c:	0007df63          	bgez	a5,708a <countfree+0x68>
    printf("fork failed in countfree()\n");
    7070:	00003517          	auipc	a0,0x3
    7074:	44850513          	addi	a0,a0,1096 # a4b8 <malloc+0x24ee>
    7078:	00001097          	auipc	ra,0x1
    707c:	d60080e7          	jalr	-672(ra) # 7dd8 <printf>
    exit(1);
    7080:	4505                	li	a0,1
    7082:	00001097          	auipc	ra,0x1
    7086:	82e080e7          	jalr	-2002(ra) # 78b0 <exit>
  }

  if(pid == 0){
    708a:	fe842783          	lw	a5,-24(s0)
    708e:	2781                	sext.w	a5,a5
    7090:	e3d1                	bnez	a5,7114 <countfree+0xf2>
    close(fds[0]);
    7092:	fd042783          	lw	a5,-48(s0)
    7096:	853e                	mv	a0,a5
    7098:	00001097          	auipc	ra,0x1
    709c:	840080e7          	jalr	-1984(ra) # 78d8 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
    70a0:	6505                	lui	a0,0x1
    70a2:	00001097          	auipc	ra,0x1
    70a6:	896080e7          	jalr	-1898(ra) # 7938 <sbrk>
    70aa:	87aa                	mv	a5,a0
    70ac:	fcf43c23          	sd	a5,-40(s0)
      if(a == 0xffffffffffffffff){
    70b0:	fd843703          	ld	a4,-40(s0)
    70b4:	57fd                	li	a5,-1
    70b6:	04f70963          	beq	a4,a5,7108 <countfree+0xe6>
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    70ba:	fd843703          	ld	a4,-40(s0)
    70be:	6785                	lui	a5,0x1
    70c0:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    70c2:	97ba                	add	a5,a5,a4
    70c4:	873e                	mv	a4,a5
    70c6:	4785                	li	a5,1
    70c8:	00f70023          	sb	a5,0(a4)

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    70cc:	fd442783          	lw	a5,-44(s0)
    70d0:	4605                	li	a2,1
    70d2:	00001597          	auipc	a1,0x1
    70d6:	14e58593          	addi	a1,a1,334 # 8220 <malloc+0x256>
    70da:	853e                	mv	a0,a5
    70dc:	00000097          	auipc	ra,0x0
    70e0:	7f4080e7          	jalr	2036(ra) # 78d0 <write>
    70e4:	87aa                	mv	a5,a0
    70e6:	873e                	mv	a4,a5
    70e8:	4785                	li	a5,1
    70ea:	faf70be3          	beq	a4,a5,70a0 <countfree+0x7e>
        printf("write() failed in countfree()\n");
    70ee:	00003517          	auipc	a0,0x3
    70f2:	3ea50513          	addi	a0,a0,1002 # a4d8 <malloc+0x250e>
    70f6:	00001097          	auipc	ra,0x1
    70fa:	ce2080e7          	jalr	-798(ra) # 7dd8 <printf>
        exit(1);
    70fe:	4505                	li	a0,1
    7100:	00000097          	auipc	ra,0x0
    7104:	7b0080e7          	jalr	1968(ra) # 78b0 <exit>
        break;
    7108:	0001                	nop
      }
    }

    exit(0);
    710a:	4501                	li	a0,0
    710c:	00000097          	auipc	ra,0x0
    7110:	7a4080e7          	jalr	1956(ra) # 78b0 <exit>
  }

  close(fds[1]);
    7114:	fd442783          	lw	a5,-44(s0)
    7118:	853e                	mv	a0,a5
    711a:	00000097          	auipc	ra,0x0
    711e:	7be080e7          	jalr	1982(ra) # 78d8 <close>

  int n = 0;
    7122:	fe042623          	sw	zero,-20(s0)
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    7126:	fd042783          	lw	a5,-48(s0)
    712a:	fcf40713          	addi	a4,s0,-49
    712e:	4605                	li	a2,1
    7130:	85ba                	mv	a1,a4
    7132:	853e                	mv	a0,a5
    7134:	00000097          	auipc	ra,0x0
    7138:	794080e7          	jalr	1940(ra) # 78c8 <read>
    713c:	87aa                	mv	a5,a0
    713e:	fef42223          	sw	a5,-28(s0)
    if(cc < 0){
    7142:	fe442783          	lw	a5,-28(s0)
    7146:	2781                	sext.w	a5,a5
    7148:	0007df63          	bgez	a5,7166 <countfree+0x144>
      printf("read() failed in countfree()\n");
    714c:	00003517          	auipc	a0,0x3
    7150:	3ac50513          	addi	a0,a0,940 # a4f8 <malloc+0x252e>
    7154:	00001097          	auipc	ra,0x1
    7158:	c84080e7          	jalr	-892(ra) # 7dd8 <printf>
      exit(1);
    715c:	4505                	li	a0,1
    715e:	00000097          	auipc	ra,0x0
    7162:	752080e7          	jalr	1874(ra) # 78b0 <exit>
    }
    if(cc == 0)
    7166:	fe442783          	lw	a5,-28(s0)
    716a:	2781                	sext.w	a5,a5
    716c:	e385                	bnez	a5,718c <countfree+0x16a>
      break;
    n += 1;
  }

  close(fds[0]);
    716e:	fd042783          	lw	a5,-48(s0)
    7172:	853e                	mv	a0,a5
    7174:	00000097          	auipc	ra,0x0
    7178:	764080e7          	jalr	1892(ra) # 78d8 <close>
  wait((int*)0);
    717c:	4501                	li	a0,0
    717e:	00000097          	auipc	ra,0x0
    7182:	73a080e7          	jalr	1850(ra) # 78b8 <wait>
  
  return n;
    7186:	fec42783          	lw	a5,-20(s0)
    718a:	a039                	j	7198 <countfree+0x176>
    n += 1;
    718c:	fec42783          	lw	a5,-20(s0)
    7190:	2785                	addiw	a5,a5,1
    7192:	fef42623          	sw	a5,-20(s0)
  while(1){
    7196:	bf41                	j	7126 <countfree+0x104>
}
    7198:	853e                	mv	a0,a5
    719a:	70e2                	ld	ra,56(sp)
    719c:	7442                	ld	s0,48(sp)
    719e:	6121                	addi	sp,sp,64
    71a0:	8082                	ret

00000000000071a2 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    71a2:	7179                	addi	sp,sp,-48
    71a4:	f406                	sd	ra,40(sp)
    71a6:	f022                	sd	s0,32(sp)
    71a8:	1800                	addi	s0,sp,48
    71aa:	87aa                	mv	a5,a0
    71ac:	872e                	mv	a4,a1
    71ae:	fcc43823          	sd	a2,-48(s0)
    71b2:	fcf42e23          	sw	a5,-36(s0)
    71b6:	87ba                	mv	a5,a4
    71b8:	fcf42c23          	sw	a5,-40(s0)
  do {
    printf("usertests starting\n");
    71bc:	00003517          	auipc	a0,0x3
    71c0:	35c50513          	addi	a0,a0,860 # a518 <malloc+0x254e>
    71c4:	00001097          	auipc	ra,0x1
    71c8:	c14080e7          	jalr	-1004(ra) # 7dd8 <printf>
    int free0 = countfree();
    71cc:	00000097          	auipc	ra,0x0
    71d0:	e56080e7          	jalr	-426(ra) # 7022 <countfree>
    71d4:	87aa                	mv	a5,a0
    71d6:	fef42623          	sw	a5,-20(s0)
    int free1 = 0;
    71da:	fe042423          	sw	zero,-24(s0)
    if (runtests(quicktests, justone)) {
    71de:	fd043583          	ld	a1,-48(s0)
    71e2:	00005517          	auipc	a0,0x5
    71e6:	cbe50513          	addi	a0,a0,-834 # bea0 <quicktests>
    71ea:	00000097          	auipc	ra,0x0
    71ee:	db2080e7          	jalr	-590(ra) # 6f9c <runtests>
    71f2:	87aa                	mv	a5,a0
    71f4:	cb91                	beqz	a5,7208 <drivetests+0x66>
      if(continuous != 2) {
    71f6:	fd842783          	lw	a5,-40(s0)
    71fa:	0007871b          	sext.w	a4,a5
    71fe:	4789                	li	a5,2
    7200:	00f70463          	beq	a4,a5,7208 <drivetests+0x66>
        return 1;
    7204:	4785                	li	a5,1
    7206:	a04d                	j	72a8 <drivetests+0x106>
      }
    }
    if(!quick) {
    7208:	fdc42783          	lw	a5,-36(s0)
    720c:	2781                	sext.w	a5,a5
    720e:	e3a9                	bnez	a5,7250 <drivetests+0xae>
      if (justone == 0)
    7210:	fd043783          	ld	a5,-48(s0)
    7214:	eb89                	bnez	a5,7226 <drivetests+0x84>
        printf("usertests slow tests starting\n");
    7216:	00003517          	auipc	a0,0x3
    721a:	31a50513          	addi	a0,a0,794 # a530 <malloc+0x2566>
    721e:	00001097          	auipc	ra,0x1
    7222:	bba080e7          	jalr	-1094(ra) # 7dd8 <printf>
      if (runtests(slowtests, justone)) {
    7226:	fd043583          	ld	a1,-48(s0)
    722a:	00005517          	auipc	a0,0x5
    722e:	04650513          	addi	a0,a0,70 # c270 <slowtests>
    7232:	00000097          	auipc	ra,0x0
    7236:	d6a080e7          	jalr	-662(ra) # 6f9c <runtests>
    723a:	87aa                	mv	a5,a0
    723c:	cb91                	beqz	a5,7250 <drivetests+0xae>
        if(continuous != 2) {
    723e:	fd842783          	lw	a5,-40(s0)
    7242:	0007871b          	sext.w	a4,a5
    7246:	4789                	li	a5,2
    7248:	00f70463          	beq	a4,a5,7250 <drivetests+0xae>
          return 1;
    724c:	4785                	li	a5,1
    724e:	a8a9                	j	72a8 <drivetests+0x106>
        }
      }
    }
    if((free1 = countfree()) < free0) {
    7250:	00000097          	auipc	ra,0x0
    7254:	dd2080e7          	jalr	-558(ra) # 7022 <countfree>
    7258:	87aa                	mv	a5,a0
    725a:	fef42423          	sw	a5,-24(s0)
    725e:	fe842783          	lw	a5,-24(s0)
    7262:	873e                	mv	a4,a5
    7264:	fec42783          	lw	a5,-20(s0)
    7268:	2701                	sext.w	a4,a4
    726a:	2781                	sext.w	a5,a5
    726c:	02f75963          	bge	a4,a5,729e <drivetests+0xfc>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    7270:	fec42703          	lw	a4,-20(s0)
    7274:	fe842783          	lw	a5,-24(s0)
    7278:	863a                	mv	a2,a4
    727a:	85be                	mv	a1,a5
    727c:	00003517          	auipc	a0,0x3
    7280:	2d450513          	addi	a0,a0,724 # a550 <malloc+0x2586>
    7284:	00001097          	auipc	ra,0x1
    7288:	b54080e7          	jalr	-1196(ra) # 7dd8 <printf>
      if(continuous != 2) {
    728c:	fd842783          	lw	a5,-40(s0)
    7290:	0007871b          	sext.w	a4,a5
    7294:	4789                	li	a5,2
    7296:	00f70463          	beq	a4,a5,729e <drivetests+0xfc>
        return 1;
    729a:	4785                	li	a5,1
    729c:	a031                	j	72a8 <drivetests+0x106>
      }
    }
  } while(continuous);
    729e:	fd842783          	lw	a5,-40(s0)
    72a2:	2781                	sext.w	a5,a5
    72a4:	ff81                	bnez	a5,71bc <drivetests+0x1a>
  return 0;
    72a6:	4781                	li	a5,0
}
    72a8:	853e                	mv	a0,a5
    72aa:	70a2                	ld	ra,40(sp)
    72ac:	7402                	ld	s0,32(sp)
    72ae:	6145                	addi	sp,sp,48
    72b0:	8082                	ret

00000000000072b2 <main>:

int
main(int argc, char *argv[])
{
    72b2:	7179                	addi	sp,sp,-48
    72b4:	f406                	sd	ra,40(sp)
    72b6:	f022                	sd	s0,32(sp)
    72b8:	1800                	addi	s0,sp,48
    72ba:	87aa                	mv	a5,a0
    72bc:	fcb43823          	sd	a1,-48(s0)
    72c0:	fcf42e23          	sw	a5,-36(s0)
  int continuous = 0;
    72c4:	fe042623          	sw	zero,-20(s0)
  int quick = 0;
    72c8:	fe042423          	sw	zero,-24(s0)
  char *justone = 0;
    72cc:	fe043023          	sd	zero,-32(s0)

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    72d0:	fdc42783          	lw	a5,-36(s0)
    72d4:	0007871b          	sext.w	a4,a5
    72d8:	4789                	li	a5,2
    72da:	02f71563          	bne	a4,a5,7304 <main+0x52>
    72de:	fd043783          	ld	a5,-48(s0)
    72e2:	07a1                	addi	a5,a5,8
    72e4:	639c                	ld	a5,0(a5)
    72e6:	00003597          	auipc	a1,0x3
    72ea:	29a58593          	addi	a1,a1,666 # a580 <malloc+0x25b6>
    72ee:	853e                	mv	a0,a5
    72f0:	00000097          	auipc	ra,0x0
    72f4:	178080e7          	jalr	376(ra) # 7468 <strcmp>
    72f8:	87aa                	mv	a5,a0
    72fa:	e789                	bnez	a5,7304 <main+0x52>
    quick = 1;
    72fc:	4785                	li	a5,1
    72fe:	fef42423          	sw	a5,-24(s0)
    7302:	a0c9                	j	73c4 <main+0x112>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    7304:	fdc42783          	lw	a5,-36(s0)
    7308:	0007871b          	sext.w	a4,a5
    730c:	4789                	li	a5,2
    730e:	02f71563          	bne	a4,a5,7338 <main+0x86>
    7312:	fd043783          	ld	a5,-48(s0)
    7316:	07a1                	addi	a5,a5,8
    7318:	639c                	ld	a5,0(a5)
    731a:	00003597          	auipc	a1,0x3
    731e:	26e58593          	addi	a1,a1,622 # a588 <malloc+0x25be>
    7322:	853e                	mv	a0,a5
    7324:	00000097          	auipc	ra,0x0
    7328:	144080e7          	jalr	324(ra) # 7468 <strcmp>
    732c:	87aa                	mv	a5,a0
    732e:	e789                	bnez	a5,7338 <main+0x86>
    continuous = 1;
    7330:	4785                	li	a5,1
    7332:	fef42623          	sw	a5,-20(s0)
    7336:	a079                	j	73c4 <main+0x112>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    7338:	fdc42783          	lw	a5,-36(s0)
    733c:	0007871b          	sext.w	a4,a5
    7340:	4789                	li	a5,2
    7342:	02f71563          	bne	a4,a5,736c <main+0xba>
    7346:	fd043783          	ld	a5,-48(s0)
    734a:	07a1                	addi	a5,a5,8
    734c:	639c                	ld	a5,0(a5)
    734e:	00003597          	auipc	a1,0x3
    7352:	24258593          	addi	a1,a1,578 # a590 <malloc+0x25c6>
    7356:	853e                	mv	a0,a5
    7358:	00000097          	auipc	ra,0x0
    735c:	110080e7          	jalr	272(ra) # 7468 <strcmp>
    7360:	87aa                	mv	a5,a0
    7362:	e789                	bnez	a5,736c <main+0xba>
    continuous = 2;
    7364:	4789                	li	a5,2
    7366:	fef42623          	sw	a5,-20(s0)
    736a:	a8a9                	j	73c4 <main+0x112>
  } else if(argc == 2 && argv[1][0] != '-'){
    736c:	fdc42783          	lw	a5,-36(s0)
    7370:	0007871b          	sext.w	a4,a5
    7374:	4789                	li	a5,2
    7376:	02f71363          	bne	a4,a5,739c <main+0xea>
    737a:	fd043783          	ld	a5,-48(s0)
    737e:	07a1                	addi	a5,a5,8
    7380:	639c                	ld	a5,0(a5)
    7382:	0007c783          	lbu	a5,0(a5)
    7386:	873e                	mv	a4,a5
    7388:	02d00793          	li	a5,45
    738c:	00f70863          	beq	a4,a5,739c <main+0xea>
    justone = argv[1];
    7390:	fd043783          	ld	a5,-48(s0)
    7394:	679c                	ld	a5,8(a5)
    7396:	fef43023          	sd	a5,-32(s0)
    739a:	a02d                	j	73c4 <main+0x112>
  } else if(argc > 1){
    739c:	fdc42783          	lw	a5,-36(s0)
    73a0:	0007871b          	sext.w	a4,a5
    73a4:	4785                	li	a5,1
    73a6:	00e7df63          	bge	a5,a4,73c4 <main+0x112>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    73aa:	00003517          	auipc	a0,0x3
    73ae:	1ee50513          	addi	a0,a0,494 # a598 <malloc+0x25ce>
    73b2:	00001097          	auipc	ra,0x1
    73b6:	a26080e7          	jalr	-1498(ra) # 7dd8 <printf>
    exit(1);
    73ba:	4505                	li	a0,1
    73bc:	00000097          	auipc	ra,0x0
    73c0:	4f4080e7          	jalr	1268(ra) # 78b0 <exit>
  }
  if (drivetests(quick, continuous, justone)) {
    73c4:	fec42703          	lw	a4,-20(s0)
    73c8:	fe842783          	lw	a5,-24(s0)
    73cc:	fe043603          	ld	a2,-32(s0)
    73d0:	85ba                	mv	a1,a4
    73d2:	853e                	mv	a0,a5
    73d4:	00000097          	auipc	ra,0x0
    73d8:	dce080e7          	jalr	-562(ra) # 71a2 <drivetests>
    73dc:	87aa                	mv	a5,a0
    73de:	c791                	beqz	a5,73ea <main+0x138>
    exit(1);
    73e0:	4505                	li	a0,1
    73e2:	00000097          	auipc	ra,0x0
    73e6:	4ce080e7          	jalr	1230(ra) # 78b0 <exit>
  }
  printf("ALL TESTS PASSED\n");
    73ea:	00003517          	auipc	a0,0x3
    73ee:	1de50513          	addi	a0,a0,478 # a5c8 <malloc+0x25fe>
    73f2:	00001097          	auipc	ra,0x1
    73f6:	9e6080e7          	jalr	-1562(ra) # 7dd8 <printf>
  exit(0);
    73fa:	4501                	li	a0,0
    73fc:	00000097          	auipc	ra,0x0
    7400:	4b4080e7          	jalr	1204(ra) # 78b0 <exit>

0000000000007404 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    7404:	1141                	addi	sp,sp,-16
    7406:	e406                	sd	ra,8(sp)
    7408:	e022                	sd	s0,0(sp)
    740a:	0800                	addi	s0,sp,16
  extern int main();
  main();
    740c:	00000097          	auipc	ra,0x0
    7410:	ea6080e7          	jalr	-346(ra) # 72b2 <main>
  exit(0);
    7414:	4501                	li	a0,0
    7416:	00000097          	auipc	ra,0x0
    741a:	49a080e7          	jalr	1178(ra) # 78b0 <exit>

000000000000741e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    741e:	7179                	addi	sp,sp,-48
    7420:	f422                	sd	s0,40(sp)
    7422:	1800                	addi	s0,sp,48
    7424:	fca43c23          	sd	a0,-40(s0)
    7428:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
    742c:	fd843783          	ld	a5,-40(s0)
    7430:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
    7434:	0001                	nop
    7436:	fd043703          	ld	a4,-48(s0)
    743a:	00170793          	addi	a5,a4,1
    743e:	fcf43823          	sd	a5,-48(s0)
    7442:	fd843783          	ld	a5,-40(s0)
    7446:	00178693          	addi	a3,a5,1
    744a:	fcd43c23          	sd	a3,-40(s0)
    744e:	00074703          	lbu	a4,0(a4)
    7452:	00e78023          	sb	a4,0(a5)
    7456:	0007c783          	lbu	a5,0(a5)
    745a:	fff1                	bnez	a5,7436 <strcpy+0x18>
    ;
  return os;
    745c:	fe843783          	ld	a5,-24(s0)
}
    7460:	853e                	mv	a0,a5
    7462:	7422                	ld	s0,40(sp)
    7464:	6145                	addi	sp,sp,48
    7466:	8082                	ret

0000000000007468 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    7468:	1101                	addi	sp,sp,-32
    746a:	ec22                	sd	s0,24(sp)
    746c:	1000                	addi	s0,sp,32
    746e:	fea43423          	sd	a0,-24(s0)
    7472:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
    7476:	a819                	j	748c <strcmp+0x24>
    p++, q++;
    7478:	fe843783          	ld	a5,-24(s0)
    747c:	0785                	addi	a5,a5,1
    747e:	fef43423          	sd	a5,-24(s0)
    7482:	fe043783          	ld	a5,-32(s0)
    7486:	0785                	addi	a5,a5,1
    7488:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
    748c:	fe843783          	ld	a5,-24(s0)
    7490:	0007c783          	lbu	a5,0(a5)
    7494:	cb99                	beqz	a5,74aa <strcmp+0x42>
    7496:	fe843783          	ld	a5,-24(s0)
    749a:	0007c703          	lbu	a4,0(a5)
    749e:	fe043783          	ld	a5,-32(s0)
    74a2:	0007c783          	lbu	a5,0(a5)
    74a6:	fcf709e3          	beq	a4,a5,7478 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
    74aa:	fe843783          	ld	a5,-24(s0)
    74ae:	0007c783          	lbu	a5,0(a5)
    74b2:	0007871b          	sext.w	a4,a5
    74b6:	fe043783          	ld	a5,-32(s0)
    74ba:	0007c783          	lbu	a5,0(a5)
    74be:	2781                	sext.w	a5,a5
    74c0:	40f707bb          	subw	a5,a4,a5
    74c4:	2781                	sext.w	a5,a5
}
    74c6:	853e                	mv	a0,a5
    74c8:	6462                	ld	s0,24(sp)
    74ca:	6105                	addi	sp,sp,32
    74cc:	8082                	ret

00000000000074ce <strlen>:

uint
strlen(const char *s)
{
    74ce:	7179                	addi	sp,sp,-48
    74d0:	f422                	sd	s0,40(sp)
    74d2:	1800                	addi	s0,sp,48
    74d4:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    74d8:	fe042623          	sw	zero,-20(s0)
    74dc:	a031                	j	74e8 <strlen+0x1a>
    74de:	fec42783          	lw	a5,-20(s0)
    74e2:	2785                	addiw	a5,a5,1
    74e4:	fef42623          	sw	a5,-20(s0)
    74e8:	fec42783          	lw	a5,-20(s0)
    74ec:	fd843703          	ld	a4,-40(s0)
    74f0:	97ba                	add	a5,a5,a4
    74f2:	0007c783          	lbu	a5,0(a5)
    74f6:	f7e5                	bnez	a5,74de <strlen+0x10>
    ;
  return n;
    74f8:	fec42783          	lw	a5,-20(s0)
}
    74fc:	853e                	mv	a0,a5
    74fe:	7422                	ld	s0,40(sp)
    7500:	6145                	addi	sp,sp,48
    7502:	8082                	ret

0000000000007504 <memset>:

void*
memset(void *dst, int c, uint n)
{
    7504:	7179                	addi	sp,sp,-48
    7506:	f422                	sd	s0,40(sp)
    7508:	1800                	addi	s0,sp,48
    750a:	fca43c23          	sd	a0,-40(s0)
    750e:	87ae                	mv	a5,a1
    7510:	8732                	mv	a4,a2
    7512:	fcf42a23          	sw	a5,-44(s0)
    7516:	87ba                	mv	a5,a4
    7518:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    751c:	fd843783          	ld	a5,-40(s0)
    7520:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    7524:	fe042623          	sw	zero,-20(s0)
    7528:	a00d                	j	754a <memset+0x46>
    cdst[i] = c;
    752a:	fec42783          	lw	a5,-20(s0)
    752e:	fe043703          	ld	a4,-32(s0)
    7532:	97ba                	add	a5,a5,a4
    7534:	fd442703          	lw	a4,-44(s0)
    7538:	0ff77713          	zext.b	a4,a4
    753c:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    7540:	fec42783          	lw	a5,-20(s0)
    7544:	2785                	addiw	a5,a5,1
    7546:	fef42623          	sw	a5,-20(s0)
    754a:	fec42703          	lw	a4,-20(s0)
    754e:	fd042783          	lw	a5,-48(s0)
    7552:	2781                	sext.w	a5,a5
    7554:	fcf76be3          	bltu	a4,a5,752a <memset+0x26>
  }
  return dst;
    7558:	fd843783          	ld	a5,-40(s0)
}
    755c:	853e                	mv	a0,a5
    755e:	7422                	ld	s0,40(sp)
    7560:	6145                	addi	sp,sp,48
    7562:	8082                	ret

0000000000007564 <strchr>:

char*
strchr(const char *s, char c)
{
    7564:	1101                	addi	sp,sp,-32
    7566:	ec22                	sd	s0,24(sp)
    7568:	1000                	addi	s0,sp,32
    756a:	fea43423          	sd	a0,-24(s0)
    756e:	87ae                	mv	a5,a1
    7570:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
    7574:	a01d                	j	759a <strchr+0x36>
    if(*s == c)
    7576:	fe843783          	ld	a5,-24(s0)
    757a:	0007c703          	lbu	a4,0(a5)
    757e:	fe744783          	lbu	a5,-25(s0)
    7582:	0ff7f793          	zext.b	a5,a5
    7586:	00e79563          	bne	a5,a4,7590 <strchr+0x2c>
      return (char*)s;
    758a:	fe843783          	ld	a5,-24(s0)
    758e:	a821                	j	75a6 <strchr+0x42>
  for(; *s; s++)
    7590:	fe843783          	ld	a5,-24(s0)
    7594:	0785                	addi	a5,a5,1
    7596:	fef43423          	sd	a5,-24(s0)
    759a:	fe843783          	ld	a5,-24(s0)
    759e:	0007c783          	lbu	a5,0(a5)
    75a2:	fbf1                	bnez	a5,7576 <strchr+0x12>
  return 0;
    75a4:	4781                	li	a5,0
}
    75a6:	853e                	mv	a0,a5
    75a8:	6462                	ld	s0,24(sp)
    75aa:	6105                	addi	sp,sp,32
    75ac:	8082                	ret

00000000000075ae <gets>:

char*
gets(char *buf, int max)
{
    75ae:	7179                	addi	sp,sp,-48
    75b0:	f406                	sd	ra,40(sp)
    75b2:	f022                	sd	s0,32(sp)
    75b4:	1800                	addi	s0,sp,48
    75b6:	fca43c23          	sd	a0,-40(s0)
    75ba:	87ae                	mv	a5,a1
    75bc:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    75c0:	fe042623          	sw	zero,-20(s0)
    75c4:	a8a1                	j	761c <gets+0x6e>
    cc = read(0, &c, 1);
    75c6:	fe740793          	addi	a5,s0,-25
    75ca:	4605                	li	a2,1
    75cc:	85be                	mv	a1,a5
    75ce:	4501                	li	a0,0
    75d0:	00000097          	auipc	ra,0x0
    75d4:	2f8080e7          	jalr	760(ra) # 78c8 <read>
    75d8:	87aa                	mv	a5,a0
    75da:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
    75de:	fe842783          	lw	a5,-24(s0)
    75e2:	2781                	sext.w	a5,a5
    75e4:	04f05763          	blez	a5,7632 <gets+0x84>
      break;
    buf[i++] = c;
    75e8:	fec42783          	lw	a5,-20(s0)
    75ec:	0017871b          	addiw	a4,a5,1
    75f0:	fee42623          	sw	a4,-20(s0)
    75f4:	873e                	mv	a4,a5
    75f6:	fd843783          	ld	a5,-40(s0)
    75fa:	97ba                	add	a5,a5,a4
    75fc:	fe744703          	lbu	a4,-25(s0)
    7600:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
    7604:	fe744783          	lbu	a5,-25(s0)
    7608:	873e                	mv	a4,a5
    760a:	47a9                	li	a5,10
    760c:	02f70463          	beq	a4,a5,7634 <gets+0x86>
    7610:	fe744783          	lbu	a5,-25(s0)
    7614:	873e                	mv	a4,a5
    7616:	47b5                	li	a5,13
    7618:	00f70e63          	beq	a4,a5,7634 <gets+0x86>
  for(i=0; i+1 < max; ){
    761c:	fec42783          	lw	a5,-20(s0)
    7620:	2785                	addiw	a5,a5,1
    7622:	0007871b          	sext.w	a4,a5
    7626:	fd442783          	lw	a5,-44(s0)
    762a:	2781                	sext.w	a5,a5
    762c:	f8f74de3          	blt	a4,a5,75c6 <gets+0x18>
    7630:	a011                	j	7634 <gets+0x86>
      break;
    7632:	0001                	nop
      break;
  }
  buf[i] = '\0';
    7634:	fec42783          	lw	a5,-20(s0)
    7638:	fd843703          	ld	a4,-40(s0)
    763c:	97ba                	add	a5,a5,a4
    763e:	00078023          	sb	zero,0(a5)
  return buf;
    7642:	fd843783          	ld	a5,-40(s0)
}
    7646:	853e                	mv	a0,a5
    7648:	70a2                	ld	ra,40(sp)
    764a:	7402                	ld	s0,32(sp)
    764c:	6145                	addi	sp,sp,48
    764e:	8082                	ret

0000000000007650 <stat>:

int
stat(const char *n, struct stat *st)
{
    7650:	7179                	addi	sp,sp,-48
    7652:	f406                	sd	ra,40(sp)
    7654:	f022                	sd	s0,32(sp)
    7656:	1800                	addi	s0,sp,48
    7658:	fca43c23          	sd	a0,-40(s0)
    765c:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    7660:	4581                	li	a1,0
    7662:	fd843503          	ld	a0,-40(s0)
    7666:	00000097          	auipc	ra,0x0
    766a:	28a080e7          	jalr	650(ra) # 78f0 <open>
    766e:	87aa                	mv	a5,a0
    7670:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
    7674:	fec42783          	lw	a5,-20(s0)
    7678:	2781                	sext.w	a5,a5
    767a:	0007d463          	bgez	a5,7682 <stat+0x32>
    return -1;
    767e:	57fd                	li	a5,-1
    7680:	a035                	j	76ac <stat+0x5c>
  r = fstat(fd, st);
    7682:	fec42783          	lw	a5,-20(s0)
    7686:	fd043583          	ld	a1,-48(s0)
    768a:	853e                	mv	a0,a5
    768c:	00000097          	auipc	ra,0x0
    7690:	27c080e7          	jalr	636(ra) # 7908 <fstat>
    7694:	87aa                	mv	a5,a0
    7696:	fef42423          	sw	a5,-24(s0)
  close(fd);
    769a:	fec42783          	lw	a5,-20(s0)
    769e:	853e                	mv	a0,a5
    76a0:	00000097          	auipc	ra,0x0
    76a4:	238080e7          	jalr	568(ra) # 78d8 <close>
  return r;
    76a8:	fe842783          	lw	a5,-24(s0)
}
    76ac:	853e                	mv	a0,a5
    76ae:	70a2                	ld	ra,40(sp)
    76b0:	7402                	ld	s0,32(sp)
    76b2:	6145                	addi	sp,sp,48
    76b4:	8082                	ret

00000000000076b6 <atoi>:

int
atoi(const char *s)
{
    76b6:	7179                	addi	sp,sp,-48
    76b8:	f422                	sd	s0,40(sp)
    76ba:	1800                	addi	s0,sp,48
    76bc:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
    76c0:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
    76c4:	a81d                	j	76fa <atoi+0x44>
    n = n*10 + *s++ - '0';
    76c6:	fec42783          	lw	a5,-20(s0)
    76ca:	873e                	mv	a4,a5
    76cc:	87ba                	mv	a5,a4
    76ce:	0027979b          	slliw	a5,a5,0x2
    76d2:	9fb9                	addw	a5,a5,a4
    76d4:	0017979b          	slliw	a5,a5,0x1
    76d8:	0007871b          	sext.w	a4,a5
    76dc:	fd843783          	ld	a5,-40(s0)
    76e0:	00178693          	addi	a3,a5,1
    76e4:	fcd43c23          	sd	a3,-40(s0)
    76e8:	0007c783          	lbu	a5,0(a5)
    76ec:	2781                	sext.w	a5,a5
    76ee:	9fb9                	addw	a5,a5,a4
    76f0:	2781                	sext.w	a5,a5
    76f2:	fd07879b          	addiw	a5,a5,-48
    76f6:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
    76fa:	fd843783          	ld	a5,-40(s0)
    76fe:	0007c783          	lbu	a5,0(a5)
    7702:	873e                	mv	a4,a5
    7704:	02f00793          	li	a5,47
    7708:	00e7fb63          	bgeu	a5,a4,771e <atoi+0x68>
    770c:	fd843783          	ld	a5,-40(s0)
    7710:	0007c783          	lbu	a5,0(a5)
    7714:	873e                	mv	a4,a5
    7716:	03900793          	li	a5,57
    771a:	fae7f6e3          	bgeu	a5,a4,76c6 <atoi+0x10>
  return n;
    771e:	fec42783          	lw	a5,-20(s0)
}
    7722:	853e                	mv	a0,a5
    7724:	7422                	ld	s0,40(sp)
    7726:	6145                	addi	sp,sp,48
    7728:	8082                	ret

000000000000772a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    772a:	7139                	addi	sp,sp,-64
    772c:	fc22                	sd	s0,56(sp)
    772e:	0080                	addi	s0,sp,64
    7730:	fca43c23          	sd	a0,-40(s0)
    7734:	fcb43823          	sd	a1,-48(s0)
    7738:	87b2                	mv	a5,a2
    773a:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
    773e:	fd843783          	ld	a5,-40(s0)
    7742:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
    7746:	fd043783          	ld	a5,-48(s0)
    774a:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
    774e:	fe043703          	ld	a4,-32(s0)
    7752:	fe843783          	ld	a5,-24(s0)
    7756:	02e7fc63          	bgeu	a5,a4,778e <memmove+0x64>
    while(n-- > 0)
    775a:	a00d                	j	777c <memmove+0x52>
      *dst++ = *src++;
    775c:	fe043703          	ld	a4,-32(s0)
    7760:	00170793          	addi	a5,a4,1
    7764:	fef43023          	sd	a5,-32(s0)
    7768:	fe843783          	ld	a5,-24(s0)
    776c:	00178693          	addi	a3,a5,1
    7770:	fed43423          	sd	a3,-24(s0)
    7774:	00074703          	lbu	a4,0(a4)
    7778:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    777c:	fcc42783          	lw	a5,-52(s0)
    7780:	fff7871b          	addiw	a4,a5,-1
    7784:	fce42623          	sw	a4,-52(s0)
    7788:	fcf04ae3          	bgtz	a5,775c <memmove+0x32>
    778c:	a891                	j	77e0 <memmove+0xb6>
  } else {
    dst += n;
    778e:	fcc42783          	lw	a5,-52(s0)
    7792:	fe843703          	ld	a4,-24(s0)
    7796:	97ba                	add	a5,a5,a4
    7798:	fef43423          	sd	a5,-24(s0)
    src += n;
    779c:	fcc42783          	lw	a5,-52(s0)
    77a0:	fe043703          	ld	a4,-32(s0)
    77a4:	97ba                	add	a5,a5,a4
    77a6:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    77aa:	a01d                	j	77d0 <memmove+0xa6>
      *--dst = *--src;
    77ac:	fe043783          	ld	a5,-32(s0)
    77b0:	17fd                	addi	a5,a5,-1
    77b2:	fef43023          	sd	a5,-32(s0)
    77b6:	fe843783          	ld	a5,-24(s0)
    77ba:	17fd                	addi	a5,a5,-1
    77bc:	fef43423          	sd	a5,-24(s0)
    77c0:	fe043783          	ld	a5,-32(s0)
    77c4:	0007c703          	lbu	a4,0(a5)
    77c8:	fe843783          	ld	a5,-24(s0)
    77cc:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    77d0:	fcc42783          	lw	a5,-52(s0)
    77d4:	fff7871b          	addiw	a4,a5,-1
    77d8:	fce42623          	sw	a4,-52(s0)
    77dc:	fcf048e3          	bgtz	a5,77ac <memmove+0x82>
  }
  return vdst;
    77e0:	fd843783          	ld	a5,-40(s0)
}
    77e4:	853e                	mv	a0,a5
    77e6:	7462                	ld	s0,56(sp)
    77e8:	6121                	addi	sp,sp,64
    77ea:	8082                	ret

00000000000077ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    77ec:	7139                	addi	sp,sp,-64
    77ee:	fc22                	sd	s0,56(sp)
    77f0:	0080                	addi	s0,sp,64
    77f2:	fca43c23          	sd	a0,-40(s0)
    77f6:	fcb43823          	sd	a1,-48(s0)
    77fa:	87b2                	mv	a5,a2
    77fc:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
    7800:	fd843783          	ld	a5,-40(s0)
    7804:	fef43423          	sd	a5,-24(s0)
    7808:	fd043783          	ld	a5,-48(s0)
    780c:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
    7810:	a0a1                	j	7858 <memcmp+0x6c>
    if (*p1 != *p2) {
    7812:	fe843783          	ld	a5,-24(s0)
    7816:	0007c703          	lbu	a4,0(a5)
    781a:	fe043783          	ld	a5,-32(s0)
    781e:	0007c783          	lbu	a5,0(a5)
    7822:	02f70163          	beq	a4,a5,7844 <memcmp+0x58>
      return *p1 - *p2;
    7826:	fe843783          	ld	a5,-24(s0)
    782a:	0007c783          	lbu	a5,0(a5)
    782e:	0007871b          	sext.w	a4,a5
    7832:	fe043783          	ld	a5,-32(s0)
    7836:	0007c783          	lbu	a5,0(a5)
    783a:	2781                	sext.w	a5,a5
    783c:	40f707bb          	subw	a5,a4,a5
    7840:	2781                	sext.w	a5,a5
    7842:	a01d                	j	7868 <memcmp+0x7c>
    }
    p1++;
    7844:	fe843783          	ld	a5,-24(s0)
    7848:	0785                	addi	a5,a5,1
    784a:	fef43423          	sd	a5,-24(s0)
    p2++;
    784e:	fe043783          	ld	a5,-32(s0)
    7852:	0785                	addi	a5,a5,1
    7854:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
    7858:	fcc42783          	lw	a5,-52(s0)
    785c:	fff7871b          	addiw	a4,a5,-1
    7860:	fce42623          	sw	a4,-52(s0)
    7864:	f7dd                	bnez	a5,7812 <memcmp+0x26>
  }
  return 0;
    7866:	4781                	li	a5,0
}
    7868:	853e                	mv	a0,a5
    786a:	7462                	ld	s0,56(sp)
    786c:	6121                	addi	sp,sp,64
    786e:	8082                	ret

0000000000007870 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    7870:	7179                	addi	sp,sp,-48
    7872:	f406                	sd	ra,40(sp)
    7874:	f022                	sd	s0,32(sp)
    7876:	1800                	addi	s0,sp,48
    7878:	fea43423          	sd	a0,-24(s0)
    787c:	feb43023          	sd	a1,-32(s0)
    7880:	87b2                	mv	a5,a2
    7882:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    7886:	fdc42783          	lw	a5,-36(s0)
    788a:	863e                	mv	a2,a5
    788c:	fe043583          	ld	a1,-32(s0)
    7890:	fe843503          	ld	a0,-24(s0)
    7894:	00000097          	auipc	ra,0x0
    7898:	e96080e7          	jalr	-362(ra) # 772a <memmove>
    789c:	87aa                	mv	a5,a0
}
    789e:	853e                	mv	a0,a5
    78a0:	70a2                	ld	ra,40(sp)
    78a2:	7402                	ld	s0,32(sp)
    78a4:	6145                	addi	sp,sp,48
    78a6:	8082                	ret

00000000000078a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    78a8:	4885                	li	a7,1
 ecall
    78aa:	00000073          	ecall
 ret
    78ae:	8082                	ret

00000000000078b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
    78b0:	4889                	li	a7,2
 ecall
    78b2:	00000073          	ecall
 ret
    78b6:	8082                	ret

00000000000078b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
    78b8:	488d                	li	a7,3
 ecall
    78ba:	00000073          	ecall
 ret
    78be:	8082                	ret

00000000000078c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    78c0:	4891                	li	a7,4
 ecall
    78c2:	00000073          	ecall
 ret
    78c6:	8082                	ret

00000000000078c8 <read>:
.global read
read:
 li a7, SYS_read
    78c8:	4895                	li	a7,5
 ecall
    78ca:	00000073          	ecall
 ret
    78ce:	8082                	ret

00000000000078d0 <write>:
.global write
write:
 li a7, SYS_write
    78d0:	48c1                	li	a7,16
 ecall
    78d2:	00000073          	ecall
 ret
    78d6:	8082                	ret

00000000000078d8 <close>:
.global close
close:
 li a7, SYS_close
    78d8:	48d5                	li	a7,21
 ecall
    78da:	00000073          	ecall
 ret
    78de:	8082                	ret

00000000000078e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
    78e0:	4899                	li	a7,6
 ecall
    78e2:	00000073          	ecall
 ret
    78e6:	8082                	ret

00000000000078e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
    78e8:	489d                	li	a7,7
 ecall
    78ea:	00000073          	ecall
 ret
    78ee:	8082                	ret

00000000000078f0 <open>:
.global open
open:
 li a7, SYS_open
    78f0:	48bd                	li	a7,15
 ecall
    78f2:	00000073          	ecall
 ret
    78f6:	8082                	ret

00000000000078f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    78f8:	48c5                	li	a7,17
 ecall
    78fa:	00000073          	ecall
 ret
    78fe:	8082                	ret

0000000000007900 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    7900:	48c9                	li	a7,18
 ecall
    7902:	00000073          	ecall
 ret
    7906:	8082                	ret

0000000000007908 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    7908:	48a1                	li	a7,8
 ecall
    790a:	00000073          	ecall
 ret
    790e:	8082                	ret

0000000000007910 <link>:
.global link
link:
 li a7, SYS_link
    7910:	48cd                	li	a7,19
 ecall
    7912:	00000073          	ecall
 ret
    7916:	8082                	ret

0000000000007918 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    7918:	48d1                	li	a7,20
 ecall
    791a:	00000073          	ecall
 ret
    791e:	8082                	ret

0000000000007920 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    7920:	48a5                	li	a7,9
 ecall
    7922:	00000073          	ecall
 ret
    7926:	8082                	ret

0000000000007928 <dup>:
.global dup
dup:
 li a7, SYS_dup
    7928:	48a9                	li	a7,10
 ecall
    792a:	00000073          	ecall
 ret
    792e:	8082                	ret

0000000000007930 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    7930:	48ad                	li	a7,11
 ecall
    7932:	00000073          	ecall
 ret
    7936:	8082                	ret

0000000000007938 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    7938:	48b1                	li	a7,12
 ecall
    793a:	00000073          	ecall
 ret
    793e:	8082                	ret

0000000000007940 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    7940:	48b5                	li	a7,13
 ecall
    7942:	00000073          	ecall
 ret
    7946:	8082                	ret

0000000000007948 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    7948:	48b9                	li	a7,14
 ecall
    794a:	00000073          	ecall
 ret
    794e:	8082                	ret

0000000000007950 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    7950:	1101                	addi	sp,sp,-32
    7952:	ec06                	sd	ra,24(sp)
    7954:	e822                	sd	s0,16(sp)
    7956:	1000                	addi	s0,sp,32
    7958:	87aa                	mv	a5,a0
    795a:	872e                	mv	a4,a1
    795c:	fef42623          	sw	a5,-20(s0)
    7960:	87ba                	mv	a5,a4
    7962:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
    7966:	feb40713          	addi	a4,s0,-21
    796a:	fec42783          	lw	a5,-20(s0)
    796e:	4605                	li	a2,1
    7970:	85ba                	mv	a1,a4
    7972:	853e                	mv	a0,a5
    7974:	00000097          	auipc	ra,0x0
    7978:	f5c080e7          	jalr	-164(ra) # 78d0 <write>
}
    797c:	0001                	nop
    797e:	60e2                	ld	ra,24(sp)
    7980:	6442                	ld	s0,16(sp)
    7982:	6105                	addi	sp,sp,32
    7984:	8082                	ret

0000000000007986 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    7986:	7139                	addi	sp,sp,-64
    7988:	fc06                	sd	ra,56(sp)
    798a:	f822                	sd	s0,48(sp)
    798c:	0080                	addi	s0,sp,64
    798e:	87aa                	mv	a5,a0
    7990:	8736                	mv	a4,a3
    7992:	fcf42623          	sw	a5,-52(s0)
    7996:	87ae                	mv	a5,a1
    7998:	fcf42423          	sw	a5,-56(s0)
    799c:	87b2                	mv	a5,a2
    799e:	fcf42223          	sw	a5,-60(s0)
    79a2:	87ba                	mv	a5,a4
    79a4:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    79a8:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
    79ac:	fc042783          	lw	a5,-64(s0)
    79b0:	2781                	sext.w	a5,a5
    79b2:	c38d                	beqz	a5,79d4 <printint+0x4e>
    79b4:	fc842783          	lw	a5,-56(s0)
    79b8:	2781                	sext.w	a5,a5
    79ba:	0007dd63          	bgez	a5,79d4 <printint+0x4e>
    neg = 1;
    79be:	4785                	li	a5,1
    79c0:	fef42423          	sw	a5,-24(s0)
    x = -xx;
    79c4:	fc842783          	lw	a5,-56(s0)
    79c8:	40f007bb          	negw	a5,a5
    79cc:	2781                	sext.w	a5,a5
    79ce:	fef42223          	sw	a5,-28(s0)
    79d2:	a029                	j	79dc <printint+0x56>
  } else {
    x = xx;
    79d4:	fc842783          	lw	a5,-56(s0)
    79d8:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
    79dc:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
    79e0:	fc442783          	lw	a5,-60(s0)
    79e4:	fe442703          	lw	a4,-28(s0)
    79e8:	02f777bb          	remuw	a5,a4,a5
    79ec:	0007861b          	sext.w	a2,a5
    79f0:	fec42783          	lw	a5,-20(s0)
    79f4:	0017871b          	addiw	a4,a5,1
    79f8:	fee42623          	sw	a4,-20(s0)
    79fc:	00005697          	auipc	a3,0x5
    7a00:	8e468693          	addi	a3,a3,-1820 # c2e0 <digits>
    7a04:	02061713          	slli	a4,a2,0x20
    7a08:	9301                	srli	a4,a4,0x20
    7a0a:	9736                	add	a4,a4,a3
    7a0c:	00074703          	lbu	a4,0(a4)
    7a10:	17c1                	addi	a5,a5,-16
    7a12:	97a2                	add	a5,a5,s0
    7a14:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
    7a18:	fc442783          	lw	a5,-60(s0)
    7a1c:	fe442703          	lw	a4,-28(s0)
    7a20:	02f757bb          	divuw	a5,a4,a5
    7a24:	fef42223          	sw	a5,-28(s0)
    7a28:	fe442783          	lw	a5,-28(s0)
    7a2c:	2781                	sext.w	a5,a5
    7a2e:	fbcd                	bnez	a5,79e0 <printint+0x5a>
  if(neg)
    7a30:	fe842783          	lw	a5,-24(s0)
    7a34:	2781                	sext.w	a5,a5
    7a36:	cf85                	beqz	a5,7a6e <printint+0xe8>
    buf[i++] = '-';
    7a38:	fec42783          	lw	a5,-20(s0)
    7a3c:	0017871b          	addiw	a4,a5,1
    7a40:	fee42623          	sw	a4,-20(s0)
    7a44:	17c1                	addi	a5,a5,-16
    7a46:	97a2                	add	a5,a5,s0
    7a48:	02d00713          	li	a4,45
    7a4c:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
    7a50:	a839                	j	7a6e <printint+0xe8>
    putc(fd, buf[i]);
    7a52:	fec42783          	lw	a5,-20(s0)
    7a56:	17c1                	addi	a5,a5,-16
    7a58:	97a2                	add	a5,a5,s0
    7a5a:	fe07c703          	lbu	a4,-32(a5)
    7a5e:	fcc42783          	lw	a5,-52(s0)
    7a62:	85ba                	mv	a1,a4
    7a64:	853e                	mv	a0,a5
    7a66:	00000097          	auipc	ra,0x0
    7a6a:	eea080e7          	jalr	-278(ra) # 7950 <putc>
  while(--i >= 0)
    7a6e:	fec42783          	lw	a5,-20(s0)
    7a72:	37fd                	addiw	a5,a5,-1
    7a74:	fef42623          	sw	a5,-20(s0)
    7a78:	fec42783          	lw	a5,-20(s0)
    7a7c:	2781                	sext.w	a5,a5
    7a7e:	fc07dae3          	bgez	a5,7a52 <printint+0xcc>
}
    7a82:	0001                	nop
    7a84:	0001                	nop
    7a86:	70e2                	ld	ra,56(sp)
    7a88:	7442                	ld	s0,48(sp)
    7a8a:	6121                	addi	sp,sp,64
    7a8c:	8082                	ret

0000000000007a8e <printptr>:

static void
printptr(int fd, uint64 x) {
    7a8e:	7179                	addi	sp,sp,-48
    7a90:	f406                	sd	ra,40(sp)
    7a92:	f022                	sd	s0,32(sp)
    7a94:	1800                	addi	s0,sp,48
    7a96:	87aa                	mv	a5,a0
    7a98:	fcb43823          	sd	a1,-48(s0)
    7a9c:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
    7aa0:	fdc42783          	lw	a5,-36(s0)
    7aa4:	03000593          	li	a1,48
    7aa8:	853e                	mv	a0,a5
    7aaa:	00000097          	auipc	ra,0x0
    7aae:	ea6080e7          	jalr	-346(ra) # 7950 <putc>
  putc(fd, 'x');
    7ab2:	fdc42783          	lw	a5,-36(s0)
    7ab6:	07800593          	li	a1,120
    7aba:	853e                	mv	a0,a5
    7abc:	00000097          	auipc	ra,0x0
    7ac0:	e94080e7          	jalr	-364(ra) # 7950 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    7ac4:	fe042623          	sw	zero,-20(s0)
    7ac8:	a82d                	j	7b02 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    7aca:	fd043783          	ld	a5,-48(s0)
    7ace:	93f1                	srli	a5,a5,0x3c
    7ad0:	00005717          	auipc	a4,0x5
    7ad4:	81070713          	addi	a4,a4,-2032 # c2e0 <digits>
    7ad8:	97ba                	add	a5,a5,a4
    7ada:	0007c703          	lbu	a4,0(a5)
    7ade:	fdc42783          	lw	a5,-36(s0)
    7ae2:	85ba                	mv	a1,a4
    7ae4:	853e                	mv	a0,a5
    7ae6:	00000097          	auipc	ra,0x0
    7aea:	e6a080e7          	jalr	-406(ra) # 7950 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    7aee:	fec42783          	lw	a5,-20(s0)
    7af2:	2785                	addiw	a5,a5,1
    7af4:	fef42623          	sw	a5,-20(s0)
    7af8:	fd043783          	ld	a5,-48(s0)
    7afc:	0792                	slli	a5,a5,0x4
    7afe:	fcf43823          	sd	a5,-48(s0)
    7b02:	fec42783          	lw	a5,-20(s0)
    7b06:	873e                	mv	a4,a5
    7b08:	47bd                	li	a5,15
    7b0a:	fce7f0e3          	bgeu	a5,a4,7aca <printptr+0x3c>
}
    7b0e:	0001                	nop
    7b10:	0001                	nop
    7b12:	70a2                	ld	ra,40(sp)
    7b14:	7402                	ld	s0,32(sp)
    7b16:	6145                	addi	sp,sp,48
    7b18:	8082                	ret

0000000000007b1a <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    7b1a:	715d                	addi	sp,sp,-80
    7b1c:	e486                	sd	ra,72(sp)
    7b1e:	e0a2                	sd	s0,64(sp)
    7b20:	0880                	addi	s0,sp,80
    7b22:	87aa                	mv	a5,a0
    7b24:	fcb43023          	sd	a1,-64(s0)
    7b28:	fac43c23          	sd	a2,-72(s0)
    7b2c:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
    7b30:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    7b34:	fe042223          	sw	zero,-28(s0)
    7b38:	a42d                	j	7d62 <vprintf+0x248>
    c = fmt[i] & 0xff;
    7b3a:	fe442783          	lw	a5,-28(s0)
    7b3e:	fc043703          	ld	a4,-64(s0)
    7b42:	97ba                	add	a5,a5,a4
    7b44:	0007c783          	lbu	a5,0(a5)
    7b48:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
    7b4c:	fe042783          	lw	a5,-32(s0)
    7b50:	2781                	sext.w	a5,a5
    7b52:	eb9d                	bnez	a5,7b88 <vprintf+0x6e>
      if(c == '%'){
    7b54:	fdc42783          	lw	a5,-36(s0)
    7b58:	0007871b          	sext.w	a4,a5
    7b5c:	02500793          	li	a5,37
    7b60:	00f71763          	bne	a4,a5,7b6e <vprintf+0x54>
        state = '%';
    7b64:	02500793          	li	a5,37
    7b68:	fef42023          	sw	a5,-32(s0)
    7b6c:	a2f5                	j	7d58 <vprintf+0x23e>
      } else {
        putc(fd, c);
    7b6e:	fdc42783          	lw	a5,-36(s0)
    7b72:	0ff7f713          	zext.b	a4,a5
    7b76:	fcc42783          	lw	a5,-52(s0)
    7b7a:	85ba                	mv	a1,a4
    7b7c:	853e                	mv	a0,a5
    7b7e:	00000097          	auipc	ra,0x0
    7b82:	dd2080e7          	jalr	-558(ra) # 7950 <putc>
    7b86:	aac9                	j	7d58 <vprintf+0x23e>
      }
    } else if(state == '%'){
    7b88:	fe042783          	lw	a5,-32(s0)
    7b8c:	0007871b          	sext.w	a4,a5
    7b90:	02500793          	li	a5,37
    7b94:	1cf71263          	bne	a4,a5,7d58 <vprintf+0x23e>
      if(c == 'd'){
    7b98:	fdc42783          	lw	a5,-36(s0)
    7b9c:	0007871b          	sext.w	a4,a5
    7ba0:	06400793          	li	a5,100
    7ba4:	02f71463          	bne	a4,a5,7bcc <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
    7ba8:	fb843783          	ld	a5,-72(s0)
    7bac:	00878713          	addi	a4,a5,8
    7bb0:	fae43c23          	sd	a4,-72(s0)
    7bb4:	4398                	lw	a4,0(a5)
    7bb6:	fcc42783          	lw	a5,-52(s0)
    7bba:	4685                	li	a3,1
    7bbc:	4629                	li	a2,10
    7bbe:	85ba                	mv	a1,a4
    7bc0:	853e                	mv	a0,a5
    7bc2:	00000097          	auipc	ra,0x0
    7bc6:	dc4080e7          	jalr	-572(ra) # 7986 <printint>
    7bca:	a269                	j	7d54 <vprintf+0x23a>
      } else if(c == 'l') {
    7bcc:	fdc42783          	lw	a5,-36(s0)
    7bd0:	0007871b          	sext.w	a4,a5
    7bd4:	06c00793          	li	a5,108
    7bd8:	02f71663          	bne	a4,a5,7c04 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
    7bdc:	fb843783          	ld	a5,-72(s0)
    7be0:	00878713          	addi	a4,a5,8
    7be4:	fae43c23          	sd	a4,-72(s0)
    7be8:	639c                	ld	a5,0(a5)
    7bea:	0007871b          	sext.w	a4,a5
    7bee:	fcc42783          	lw	a5,-52(s0)
    7bf2:	4681                	li	a3,0
    7bf4:	4629                	li	a2,10
    7bf6:	85ba                	mv	a1,a4
    7bf8:	853e                	mv	a0,a5
    7bfa:	00000097          	auipc	ra,0x0
    7bfe:	d8c080e7          	jalr	-628(ra) # 7986 <printint>
    7c02:	aa89                	j	7d54 <vprintf+0x23a>
      } else if(c == 'x') {
    7c04:	fdc42783          	lw	a5,-36(s0)
    7c08:	0007871b          	sext.w	a4,a5
    7c0c:	07800793          	li	a5,120
    7c10:	02f71463          	bne	a4,a5,7c38 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
    7c14:	fb843783          	ld	a5,-72(s0)
    7c18:	00878713          	addi	a4,a5,8
    7c1c:	fae43c23          	sd	a4,-72(s0)
    7c20:	4398                	lw	a4,0(a5)
    7c22:	fcc42783          	lw	a5,-52(s0)
    7c26:	4681                	li	a3,0
    7c28:	4641                	li	a2,16
    7c2a:	85ba                	mv	a1,a4
    7c2c:	853e                	mv	a0,a5
    7c2e:	00000097          	auipc	ra,0x0
    7c32:	d58080e7          	jalr	-680(ra) # 7986 <printint>
    7c36:	aa39                	j	7d54 <vprintf+0x23a>
      } else if(c == 'p') {
    7c38:	fdc42783          	lw	a5,-36(s0)
    7c3c:	0007871b          	sext.w	a4,a5
    7c40:	07000793          	li	a5,112
    7c44:	02f71263          	bne	a4,a5,7c68 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
    7c48:	fb843783          	ld	a5,-72(s0)
    7c4c:	00878713          	addi	a4,a5,8
    7c50:	fae43c23          	sd	a4,-72(s0)
    7c54:	6398                	ld	a4,0(a5)
    7c56:	fcc42783          	lw	a5,-52(s0)
    7c5a:	85ba                	mv	a1,a4
    7c5c:	853e                	mv	a0,a5
    7c5e:	00000097          	auipc	ra,0x0
    7c62:	e30080e7          	jalr	-464(ra) # 7a8e <printptr>
    7c66:	a0fd                	j	7d54 <vprintf+0x23a>
      } else if(c == 's'){
    7c68:	fdc42783          	lw	a5,-36(s0)
    7c6c:	0007871b          	sext.w	a4,a5
    7c70:	07300793          	li	a5,115
    7c74:	04f71c63          	bne	a4,a5,7ccc <vprintf+0x1b2>
        s = va_arg(ap, char*);
    7c78:	fb843783          	ld	a5,-72(s0)
    7c7c:	00878713          	addi	a4,a5,8
    7c80:	fae43c23          	sd	a4,-72(s0)
    7c84:	639c                	ld	a5,0(a5)
    7c86:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
    7c8a:	fe843783          	ld	a5,-24(s0)
    7c8e:	eb8d                	bnez	a5,7cc0 <vprintf+0x1a6>
          s = "(null)";
    7c90:	00003797          	auipc	a5,0x3
    7c94:	95078793          	addi	a5,a5,-1712 # a5e0 <malloc+0x2616>
    7c98:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    7c9c:	a015                	j	7cc0 <vprintf+0x1a6>
          putc(fd, *s);
    7c9e:	fe843783          	ld	a5,-24(s0)
    7ca2:	0007c703          	lbu	a4,0(a5)
    7ca6:	fcc42783          	lw	a5,-52(s0)
    7caa:	85ba                	mv	a1,a4
    7cac:	853e                	mv	a0,a5
    7cae:	00000097          	auipc	ra,0x0
    7cb2:	ca2080e7          	jalr	-862(ra) # 7950 <putc>
          s++;
    7cb6:	fe843783          	ld	a5,-24(s0)
    7cba:	0785                	addi	a5,a5,1
    7cbc:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    7cc0:	fe843783          	ld	a5,-24(s0)
    7cc4:	0007c783          	lbu	a5,0(a5)
    7cc8:	fbf9                	bnez	a5,7c9e <vprintf+0x184>
    7cca:	a069                	j	7d54 <vprintf+0x23a>
        }
      } else if(c == 'c'){
    7ccc:	fdc42783          	lw	a5,-36(s0)
    7cd0:	0007871b          	sext.w	a4,a5
    7cd4:	06300793          	li	a5,99
    7cd8:	02f71463          	bne	a4,a5,7d00 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
    7cdc:	fb843783          	ld	a5,-72(s0)
    7ce0:	00878713          	addi	a4,a5,8
    7ce4:	fae43c23          	sd	a4,-72(s0)
    7ce8:	439c                	lw	a5,0(a5)
    7cea:	0ff7f713          	zext.b	a4,a5
    7cee:	fcc42783          	lw	a5,-52(s0)
    7cf2:	85ba                	mv	a1,a4
    7cf4:	853e                	mv	a0,a5
    7cf6:	00000097          	auipc	ra,0x0
    7cfa:	c5a080e7          	jalr	-934(ra) # 7950 <putc>
    7cfe:	a899                	j	7d54 <vprintf+0x23a>
      } else if(c == '%'){
    7d00:	fdc42783          	lw	a5,-36(s0)
    7d04:	0007871b          	sext.w	a4,a5
    7d08:	02500793          	li	a5,37
    7d0c:	00f71f63          	bne	a4,a5,7d2a <vprintf+0x210>
        putc(fd, c);
    7d10:	fdc42783          	lw	a5,-36(s0)
    7d14:	0ff7f713          	zext.b	a4,a5
    7d18:	fcc42783          	lw	a5,-52(s0)
    7d1c:	85ba                	mv	a1,a4
    7d1e:	853e                	mv	a0,a5
    7d20:	00000097          	auipc	ra,0x0
    7d24:	c30080e7          	jalr	-976(ra) # 7950 <putc>
    7d28:	a035                	j	7d54 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    7d2a:	fcc42783          	lw	a5,-52(s0)
    7d2e:	02500593          	li	a1,37
    7d32:	853e                	mv	a0,a5
    7d34:	00000097          	auipc	ra,0x0
    7d38:	c1c080e7          	jalr	-996(ra) # 7950 <putc>
        putc(fd, c);
    7d3c:	fdc42783          	lw	a5,-36(s0)
    7d40:	0ff7f713          	zext.b	a4,a5
    7d44:	fcc42783          	lw	a5,-52(s0)
    7d48:	85ba                	mv	a1,a4
    7d4a:	853e                	mv	a0,a5
    7d4c:	00000097          	auipc	ra,0x0
    7d50:	c04080e7          	jalr	-1020(ra) # 7950 <putc>
      }
      state = 0;
    7d54:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    7d58:	fe442783          	lw	a5,-28(s0)
    7d5c:	2785                	addiw	a5,a5,1
    7d5e:	fef42223          	sw	a5,-28(s0)
    7d62:	fe442783          	lw	a5,-28(s0)
    7d66:	fc043703          	ld	a4,-64(s0)
    7d6a:	97ba                	add	a5,a5,a4
    7d6c:	0007c783          	lbu	a5,0(a5)
    7d70:	dc0795e3          	bnez	a5,7b3a <vprintf+0x20>
    }
  }
}
    7d74:	0001                	nop
    7d76:	0001                	nop
    7d78:	60a6                	ld	ra,72(sp)
    7d7a:	6406                	ld	s0,64(sp)
    7d7c:	6161                	addi	sp,sp,80
    7d7e:	8082                	ret

0000000000007d80 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    7d80:	7159                	addi	sp,sp,-112
    7d82:	fc06                	sd	ra,56(sp)
    7d84:	f822                	sd	s0,48(sp)
    7d86:	0080                	addi	s0,sp,64
    7d88:	fcb43823          	sd	a1,-48(s0)
    7d8c:	e010                	sd	a2,0(s0)
    7d8e:	e414                	sd	a3,8(s0)
    7d90:	e818                	sd	a4,16(s0)
    7d92:	ec1c                	sd	a5,24(s0)
    7d94:	03043023          	sd	a6,32(s0)
    7d98:	03143423          	sd	a7,40(s0)
    7d9c:	87aa                	mv	a5,a0
    7d9e:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
    7da2:	03040793          	addi	a5,s0,48
    7da6:	fcf43423          	sd	a5,-56(s0)
    7daa:	fc843783          	ld	a5,-56(s0)
    7dae:	fd078793          	addi	a5,a5,-48
    7db2:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
    7db6:	fe843703          	ld	a4,-24(s0)
    7dba:	fdc42783          	lw	a5,-36(s0)
    7dbe:	863a                	mv	a2,a4
    7dc0:	fd043583          	ld	a1,-48(s0)
    7dc4:	853e                	mv	a0,a5
    7dc6:	00000097          	auipc	ra,0x0
    7dca:	d54080e7          	jalr	-684(ra) # 7b1a <vprintf>
}
    7dce:	0001                	nop
    7dd0:	70e2                	ld	ra,56(sp)
    7dd2:	7442                	ld	s0,48(sp)
    7dd4:	6165                	addi	sp,sp,112
    7dd6:	8082                	ret

0000000000007dd8 <printf>:

void
printf(const char *fmt, ...)
{
    7dd8:	7159                	addi	sp,sp,-112
    7dda:	f406                	sd	ra,40(sp)
    7ddc:	f022                	sd	s0,32(sp)
    7dde:	1800                	addi	s0,sp,48
    7de0:	fca43c23          	sd	a0,-40(s0)
    7de4:	e40c                	sd	a1,8(s0)
    7de6:	e810                	sd	a2,16(s0)
    7de8:	ec14                	sd	a3,24(s0)
    7dea:	f018                	sd	a4,32(s0)
    7dec:	f41c                	sd	a5,40(s0)
    7dee:	03043823          	sd	a6,48(s0)
    7df2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    7df6:	04040793          	addi	a5,s0,64
    7dfa:	fcf43823          	sd	a5,-48(s0)
    7dfe:	fd043783          	ld	a5,-48(s0)
    7e02:	fc878793          	addi	a5,a5,-56
    7e06:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
    7e0a:	fe843783          	ld	a5,-24(s0)
    7e0e:	863e                	mv	a2,a5
    7e10:	fd843583          	ld	a1,-40(s0)
    7e14:	4505                	li	a0,1
    7e16:	00000097          	auipc	ra,0x0
    7e1a:	d04080e7          	jalr	-764(ra) # 7b1a <vprintf>
}
    7e1e:	0001                	nop
    7e20:	70a2                	ld	ra,40(sp)
    7e22:	7402                	ld	s0,32(sp)
    7e24:	6165                	addi	sp,sp,112
    7e26:	8082                	ret

0000000000007e28 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    7e28:	7179                	addi	sp,sp,-48
    7e2a:	f422                	sd	s0,40(sp)
    7e2c:	1800                	addi	s0,sp,48
    7e2e:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    7e32:	fd843783          	ld	a5,-40(s0)
    7e36:	17c1                	addi	a5,a5,-16
    7e38:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    7e3c:	0000b797          	auipc	a5,0xb
    7e40:	cec78793          	addi	a5,a5,-788 # 12b28 <freep>
    7e44:	639c                	ld	a5,0(a5)
    7e46:	fef43423          	sd	a5,-24(s0)
    7e4a:	a815                	j	7e7e <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    7e4c:	fe843783          	ld	a5,-24(s0)
    7e50:	639c                	ld	a5,0(a5)
    7e52:	fe843703          	ld	a4,-24(s0)
    7e56:	00f76f63          	bltu	a4,a5,7e74 <free+0x4c>
    7e5a:	fe043703          	ld	a4,-32(s0)
    7e5e:	fe843783          	ld	a5,-24(s0)
    7e62:	02e7eb63          	bltu	a5,a4,7e98 <free+0x70>
    7e66:	fe843783          	ld	a5,-24(s0)
    7e6a:	639c                	ld	a5,0(a5)
    7e6c:	fe043703          	ld	a4,-32(s0)
    7e70:	02f76463          	bltu	a4,a5,7e98 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    7e74:	fe843783          	ld	a5,-24(s0)
    7e78:	639c                	ld	a5,0(a5)
    7e7a:	fef43423          	sd	a5,-24(s0)
    7e7e:	fe043703          	ld	a4,-32(s0)
    7e82:	fe843783          	ld	a5,-24(s0)
    7e86:	fce7f3e3          	bgeu	a5,a4,7e4c <free+0x24>
    7e8a:	fe843783          	ld	a5,-24(s0)
    7e8e:	639c                	ld	a5,0(a5)
    7e90:	fe043703          	ld	a4,-32(s0)
    7e94:	faf77ce3          	bgeu	a4,a5,7e4c <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
    7e98:	fe043783          	ld	a5,-32(s0)
    7e9c:	479c                	lw	a5,8(a5)
    7e9e:	1782                	slli	a5,a5,0x20
    7ea0:	9381                	srli	a5,a5,0x20
    7ea2:	0792                	slli	a5,a5,0x4
    7ea4:	fe043703          	ld	a4,-32(s0)
    7ea8:	973e                	add	a4,a4,a5
    7eaa:	fe843783          	ld	a5,-24(s0)
    7eae:	639c                	ld	a5,0(a5)
    7eb0:	02f71763          	bne	a4,a5,7ede <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
    7eb4:	fe043783          	ld	a5,-32(s0)
    7eb8:	4798                	lw	a4,8(a5)
    7eba:	fe843783          	ld	a5,-24(s0)
    7ebe:	639c                	ld	a5,0(a5)
    7ec0:	479c                	lw	a5,8(a5)
    7ec2:	9fb9                	addw	a5,a5,a4
    7ec4:	0007871b          	sext.w	a4,a5
    7ec8:	fe043783          	ld	a5,-32(s0)
    7ecc:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
    7ece:	fe843783          	ld	a5,-24(s0)
    7ed2:	639c                	ld	a5,0(a5)
    7ed4:	6398                	ld	a4,0(a5)
    7ed6:	fe043783          	ld	a5,-32(s0)
    7eda:	e398                	sd	a4,0(a5)
    7edc:	a039                	j	7eea <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
    7ede:	fe843783          	ld	a5,-24(s0)
    7ee2:	6398                	ld	a4,0(a5)
    7ee4:	fe043783          	ld	a5,-32(s0)
    7ee8:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
    7eea:	fe843783          	ld	a5,-24(s0)
    7eee:	479c                	lw	a5,8(a5)
    7ef0:	1782                	slli	a5,a5,0x20
    7ef2:	9381                	srli	a5,a5,0x20
    7ef4:	0792                	slli	a5,a5,0x4
    7ef6:	fe843703          	ld	a4,-24(s0)
    7efa:	97ba                	add	a5,a5,a4
    7efc:	fe043703          	ld	a4,-32(s0)
    7f00:	02f71563          	bne	a4,a5,7f2a <free+0x102>
    p->s.size += bp->s.size;
    7f04:	fe843783          	ld	a5,-24(s0)
    7f08:	4798                	lw	a4,8(a5)
    7f0a:	fe043783          	ld	a5,-32(s0)
    7f0e:	479c                	lw	a5,8(a5)
    7f10:	9fb9                	addw	a5,a5,a4
    7f12:	0007871b          	sext.w	a4,a5
    7f16:	fe843783          	ld	a5,-24(s0)
    7f1a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    7f1c:	fe043783          	ld	a5,-32(s0)
    7f20:	6398                	ld	a4,0(a5)
    7f22:	fe843783          	ld	a5,-24(s0)
    7f26:	e398                	sd	a4,0(a5)
    7f28:	a031                	j	7f34 <free+0x10c>
  } else
    p->s.ptr = bp;
    7f2a:	fe843783          	ld	a5,-24(s0)
    7f2e:	fe043703          	ld	a4,-32(s0)
    7f32:	e398                	sd	a4,0(a5)
  freep = p;
    7f34:	0000b797          	auipc	a5,0xb
    7f38:	bf478793          	addi	a5,a5,-1036 # 12b28 <freep>
    7f3c:	fe843703          	ld	a4,-24(s0)
    7f40:	e398                	sd	a4,0(a5)
}
    7f42:	0001                	nop
    7f44:	7422                	ld	s0,40(sp)
    7f46:	6145                	addi	sp,sp,48
    7f48:	8082                	ret

0000000000007f4a <morecore>:

static Header*
morecore(uint nu)
{
    7f4a:	7179                	addi	sp,sp,-48
    7f4c:	f406                	sd	ra,40(sp)
    7f4e:	f022                	sd	s0,32(sp)
    7f50:	1800                	addi	s0,sp,48
    7f52:	87aa                	mv	a5,a0
    7f54:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
    7f58:	fdc42783          	lw	a5,-36(s0)
    7f5c:	0007871b          	sext.w	a4,a5
    7f60:	6785                	lui	a5,0x1
    7f62:	00f77563          	bgeu	a4,a5,7f6c <morecore+0x22>
    nu = 4096;
    7f66:	6785                	lui	a5,0x1
    7f68:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
    7f6c:	fdc42783          	lw	a5,-36(s0)
    7f70:	0047979b          	slliw	a5,a5,0x4
    7f74:	2781                	sext.w	a5,a5
    7f76:	2781                	sext.w	a5,a5
    7f78:	853e                	mv	a0,a5
    7f7a:	00000097          	auipc	ra,0x0
    7f7e:	9be080e7          	jalr	-1602(ra) # 7938 <sbrk>
    7f82:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
    7f86:	fe843703          	ld	a4,-24(s0)
    7f8a:	57fd                	li	a5,-1
    7f8c:	00f71463          	bne	a4,a5,7f94 <morecore+0x4a>
    return 0;
    7f90:	4781                	li	a5,0
    7f92:	a03d                	j	7fc0 <morecore+0x76>
  hp = (Header*)p;
    7f94:	fe843783          	ld	a5,-24(s0)
    7f98:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
    7f9c:	fe043783          	ld	a5,-32(s0)
    7fa0:	fdc42703          	lw	a4,-36(s0)
    7fa4:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
    7fa6:	fe043783          	ld	a5,-32(s0)
    7faa:	07c1                	addi	a5,a5,16 # 1010 <truncate3+0x1c2>
    7fac:	853e                	mv	a0,a5
    7fae:	00000097          	auipc	ra,0x0
    7fb2:	e7a080e7          	jalr	-390(ra) # 7e28 <free>
  return freep;
    7fb6:	0000b797          	auipc	a5,0xb
    7fba:	b7278793          	addi	a5,a5,-1166 # 12b28 <freep>
    7fbe:	639c                	ld	a5,0(a5)
}
    7fc0:	853e                	mv	a0,a5
    7fc2:	70a2                	ld	ra,40(sp)
    7fc4:	7402                	ld	s0,32(sp)
    7fc6:	6145                	addi	sp,sp,48
    7fc8:	8082                	ret

0000000000007fca <malloc>:

void*
malloc(uint nbytes)
{
    7fca:	7139                	addi	sp,sp,-64
    7fcc:	fc06                	sd	ra,56(sp)
    7fce:	f822                	sd	s0,48(sp)
    7fd0:	0080                	addi	s0,sp,64
    7fd2:	87aa                	mv	a5,a0
    7fd4:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    7fd8:	fcc46783          	lwu	a5,-52(s0)
    7fdc:	07bd                	addi	a5,a5,15
    7fde:	8391                	srli	a5,a5,0x4
    7fe0:	2781                	sext.w	a5,a5
    7fe2:	2785                	addiw	a5,a5,1
    7fe4:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
    7fe8:	0000b797          	auipc	a5,0xb
    7fec:	b4078793          	addi	a5,a5,-1216 # 12b28 <freep>
    7ff0:	639c                	ld	a5,0(a5)
    7ff2:	fef43023          	sd	a5,-32(s0)
    7ff6:	fe043783          	ld	a5,-32(s0)
    7ffa:	ef95                	bnez	a5,8036 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
    7ffc:	0000b797          	auipc	a5,0xb
    8000:	b1c78793          	addi	a5,a5,-1252 # 12b18 <base>
    8004:	fef43023          	sd	a5,-32(s0)
    8008:	0000b797          	auipc	a5,0xb
    800c:	b2078793          	addi	a5,a5,-1248 # 12b28 <freep>
    8010:	fe043703          	ld	a4,-32(s0)
    8014:	e398                	sd	a4,0(a5)
    8016:	0000b797          	auipc	a5,0xb
    801a:	b1278793          	addi	a5,a5,-1262 # 12b28 <freep>
    801e:	6398                	ld	a4,0(a5)
    8020:	0000b797          	auipc	a5,0xb
    8024:	af878793          	addi	a5,a5,-1288 # 12b18 <base>
    8028:	e398                	sd	a4,0(a5)
    base.s.size = 0;
    802a:	0000b797          	auipc	a5,0xb
    802e:	aee78793          	addi	a5,a5,-1298 # 12b18 <base>
    8032:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    8036:	fe043783          	ld	a5,-32(s0)
    803a:	639c                	ld	a5,0(a5)
    803c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    8040:	fe843783          	ld	a5,-24(s0)
    8044:	4798                	lw	a4,8(a5)
    8046:	fdc42783          	lw	a5,-36(s0)
    804a:	2781                	sext.w	a5,a5
    804c:	06f76763          	bltu	a4,a5,80ba <malloc+0xf0>
      if(p->s.size == nunits)
    8050:	fe843783          	ld	a5,-24(s0)
    8054:	4798                	lw	a4,8(a5)
    8056:	fdc42783          	lw	a5,-36(s0)
    805a:	2781                	sext.w	a5,a5
    805c:	00e79963          	bne	a5,a4,806e <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    8060:	fe843783          	ld	a5,-24(s0)
    8064:	6398                	ld	a4,0(a5)
    8066:	fe043783          	ld	a5,-32(s0)
    806a:	e398                	sd	a4,0(a5)
    806c:	a825                	j	80a4 <malloc+0xda>
      else {
        p->s.size -= nunits;
    806e:	fe843783          	ld	a5,-24(s0)
    8072:	479c                	lw	a5,8(a5)
    8074:	fdc42703          	lw	a4,-36(s0)
    8078:	9f99                	subw	a5,a5,a4
    807a:	0007871b          	sext.w	a4,a5
    807e:	fe843783          	ld	a5,-24(s0)
    8082:	c798                	sw	a4,8(a5)
        p += p->s.size;
    8084:	fe843783          	ld	a5,-24(s0)
    8088:	479c                	lw	a5,8(a5)
    808a:	1782                	slli	a5,a5,0x20
    808c:	9381                	srli	a5,a5,0x20
    808e:	0792                	slli	a5,a5,0x4
    8090:	fe843703          	ld	a4,-24(s0)
    8094:	97ba                	add	a5,a5,a4
    8096:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    809a:	fe843783          	ld	a5,-24(s0)
    809e:	fdc42703          	lw	a4,-36(s0)
    80a2:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    80a4:	0000b797          	auipc	a5,0xb
    80a8:	a8478793          	addi	a5,a5,-1404 # 12b28 <freep>
    80ac:	fe043703          	ld	a4,-32(s0)
    80b0:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    80b2:	fe843783          	ld	a5,-24(s0)
    80b6:	07c1                	addi	a5,a5,16
    80b8:	a091                	j	80fc <malloc+0x132>
    }
    if(p == freep)
    80ba:	0000b797          	auipc	a5,0xb
    80be:	a6e78793          	addi	a5,a5,-1426 # 12b28 <freep>
    80c2:	639c                	ld	a5,0(a5)
    80c4:	fe843703          	ld	a4,-24(s0)
    80c8:	02f71063          	bne	a4,a5,80e8 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    80cc:	fdc42783          	lw	a5,-36(s0)
    80d0:	853e                	mv	a0,a5
    80d2:	00000097          	auipc	ra,0x0
    80d6:	e78080e7          	jalr	-392(ra) # 7f4a <morecore>
    80da:	fea43423          	sd	a0,-24(s0)
    80de:	fe843783          	ld	a5,-24(s0)
    80e2:	e399                	bnez	a5,80e8 <malloc+0x11e>
        return 0;
    80e4:	4781                	li	a5,0
    80e6:	a819                	j	80fc <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    80e8:	fe843783          	ld	a5,-24(s0)
    80ec:	fef43023          	sd	a5,-32(s0)
    80f0:	fe843783          	ld	a5,-24(s0)
    80f4:	639c                	ld	a5,0(a5)
    80f6:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    80fa:	b799                	j	8040 <malloc+0x76>
  }
}
    80fc:	853e                	mv	a0,a5
    80fe:	70e2                	ld	ra,56(sp)
    8100:	7442                	ld	s0,48(sp)
    8102:	6121                	addi	sp,sp,64
    8104:	8082                	ret
