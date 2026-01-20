
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	0480                	addi	s0,sp,576
   e:	87aa                	mv	a5,a0
  10:	dcb43023          	sd	a1,-576(s0)
  14:	dcf42623          	sw	a5,-564(s0)
  int fd, i;
  char path[] = "stressfs0";
  18:	00001797          	auipc	a5,0x1
  1c:	ea878793          	addi	a5,a5,-344 # ec0 <malloc+0x170>
  20:	6398                	ld	a4,0(a5)
  22:	fce43c23          	sd	a4,-40(s0)
  26:	0087d783          	lhu	a5,8(a5)
  2a:	fef41023          	sh	a5,-32(s0)
  char data[512];

  printf("stressfs starting\n");
  2e:	00001517          	auipc	a0,0x1
  32:	e6250513          	addi	a0,a0,-414 # e90 <malloc+0x140>
  36:	00001097          	auipc	ra,0x1
  3a:	b28080e7          	jalr	-1240(ra) # b5e <printf>
  memset(data, 'a', sizeof(data));
  3e:	dd840793          	addi	a5,s0,-552
  42:	20000613          	li	a2,512
  46:	06100593          	li	a1,97
  4a:	853e                	mv	a0,a5
  4c:	00000097          	auipc	ra,0x0
  50:	23e080e7          	jalr	574(ra) # 28a <memset>

  for(i = 0; i < 4; i++)
  54:	fe042623          	sw	zero,-20(s0)
  58:	a829                	j	72 <main+0x72>
    if(fork() > 0)
  5a:	00000097          	auipc	ra,0x0
  5e:	5d4080e7          	jalr	1492(ra) # 62e <fork>
  62:	87aa                	mv	a5,a0
  64:	00f04f63          	bgtz	a5,82 <main+0x82>
  for(i = 0; i < 4; i++)
  68:	fec42783          	lw	a5,-20(s0)
  6c:	2785                	addiw	a5,a5,1
  6e:	fef42623          	sw	a5,-20(s0)
  72:	fec42783          	lw	a5,-20(s0)
  76:	0007871b          	sext.w	a4,a5
  7a:	478d                	li	a5,3
  7c:	fce7dfe3          	bge	a5,a4,5a <main+0x5a>
  80:	a011                	j	84 <main+0x84>
      break;
  82:	0001                	nop

  printf("write %d\n", i);
  84:	fec42783          	lw	a5,-20(s0)
  88:	85be                	mv	a1,a5
  8a:	00001517          	auipc	a0,0x1
  8e:	e1e50513          	addi	a0,a0,-482 # ea8 <malloc+0x158>
  92:	00001097          	auipc	ra,0x1
  96:	acc080e7          	jalr	-1332(ra) # b5e <printf>

  path[8] += i;
  9a:	fe044703          	lbu	a4,-32(s0)
  9e:	fec42783          	lw	a5,-20(s0)
  a2:	0ff7f793          	zext.b	a5,a5
  a6:	9fb9                	addw	a5,a5,a4
  a8:	0ff7f793          	zext.b	a5,a5
  ac:	fef40023          	sb	a5,-32(s0)
  fd = open(path, O_CREATE | O_RDWR);
  b0:	fd840793          	addi	a5,s0,-40
  b4:	20200593          	li	a1,514
  b8:	853e                	mv	a0,a5
  ba:	00000097          	auipc	ra,0x0
  be:	5bc080e7          	jalr	1468(ra) # 676 <open>
  c2:	87aa                	mv	a5,a0
  c4:	fef42423          	sw	a5,-24(s0)
  for(i = 0; i < 20; i++)
  c8:	fe042623          	sw	zero,-20(s0)
  cc:	a015                	j	f0 <main+0xf0>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ce:	dd840713          	addi	a4,s0,-552
  d2:	fe842783          	lw	a5,-24(s0)
  d6:	20000613          	li	a2,512
  da:	85ba                	mv	a1,a4
  dc:	853e                	mv	a0,a5
  de:	00000097          	auipc	ra,0x0
  e2:	578080e7          	jalr	1400(ra) # 656 <write>
  for(i = 0; i < 20; i++)
  e6:	fec42783          	lw	a5,-20(s0)
  ea:	2785                	addiw	a5,a5,1
  ec:	fef42623          	sw	a5,-20(s0)
  f0:	fec42783          	lw	a5,-20(s0)
  f4:	0007871b          	sext.w	a4,a5
  f8:	47cd                	li	a5,19
  fa:	fce7dae3          	bge	a5,a4,ce <main+0xce>
  close(fd);
  fe:	fe842783          	lw	a5,-24(s0)
 102:	853e                	mv	a0,a5
 104:	00000097          	auipc	ra,0x0
 108:	55a080e7          	jalr	1370(ra) # 65e <close>

  printf("read\n");
 10c:	00001517          	auipc	a0,0x1
 110:	dac50513          	addi	a0,a0,-596 # eb8 <malloc+0x168>
 114:	00001097          	auipc	ra,0x1
 118:	a4a080e7          	jalr	-1462(ra) # b5e <printf>

  fd = open(path, O_RDONLY);
 11c:	fd840793          	addi	a5,s0,-40
 120:	4581                	li	a1,0
 122:	853e                	mv	a0,a5
 124:	00000097          	auipc	ra,0x0
 128:	552080e7          	jalr	1362(ra) # 676 <open>
 12c:	87aa                	mv	a5,a0
 12e:	fef42423          	sw	a5,-24(s0)
  for (i = 0; i < 20; i++)
 132:	fe042623          	sw	zero,-20(s0)
 136:	a015                	j	15a <main+0x15a>
    read(fd, data, sizeof(data));
 138:	dd840713          	addi	a4,s0,-552
 13c:	fe842783          	lw	a5,-24(s0)
 140:	20000613          	li	a2,512
 144:	85ba                	mv	a1,a4
 146:	853e                	mv	a0,a5
 148:	00000097          	auipc	ra,0x0
 14c:	506080e7          	jalr	1286(ra) # 64e <read>
  for (i = 0; i < 20; i++)
 150:	fec42783          	lw	a5,-20(s0)
 154:	2785                	addiw	a5,a5,1
 156:	fef42623          	sw	a5,-20(s0)
 15a:	fec42783          	lw	a5,-20(s0)
 15e:	0007871b          	sext.w	a4,a5
 162:	47cd                	li	a5,19
 164:	fce7dae3          	bge	a5,a4,138 <main+0x138>
  close(fd);
 168:	fe842783          	lw	a5,-24(s0)
 16c:	853e                	mv	a0,a5
 16e:	00000097          	auipc	ra,0x0
 172:	4f0080e7          	jalr	1264(ra) # 65e <close>

  wait(0);
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	4c6080e7          	jalr	1222(ra) # 63e <wait>

  exit(0);
 180:	4501                	li	a0,0
 182:	00000097          	auipc	ra,0x0
 186:	4b4080e7          	jalr	1204(ra) # 636 <exit>

000000000000018a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
  extern int main();
  main();
 192:	00000097          	auipc	ra,0x0
 196:	e6e080e7          	jalr	-402(ra) # 0 <main>
  exit(0);
 19a:	4501                	li	a0,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	49a080e7          	jalr	1178(ra) # 636 <exit>

00000000000001a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1a4:	7179                	addi	sp,sp,-48
 1a6:	f422                	sd	s0,40(sp)
 1a8:	1800                	addi	s0,sp,48
 1aa:	fca43c23          	sd	a0,-40(s0)
 1ae:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 1b2:	fd843783          	ld	a5,-40(s0)
 1b6:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 1ba:	0001                	nop
 1bc:	fd043703          	ld	a4,-48(s0)
 1c0:	00170793          	addi	a5,a4,1
 1c4:	fcf43823          	sd	a5,-48(s0)
 1c8:	fd843783          	ld	a5,-40(s0)
 1cc:	00178693          	addi	a3,a5,1
 1d0:	fcd43c23          	sd	a3,-40(s0)
 1d4:	00074703          	lbu	a4,0(a4)
 1d8:	00e78023          	sb	a4,0(a5)
 1dc:	0007c783          	lbu	a5,0(a5)
 1e0:	fff1                	bnez	a5,1bc <strcpy+0x18>
    ;
  return os;
 1e2:	fe843783          	ld	a5,-24(s0)
}
 1e6:	853e                	mv	a0,a5
 1e8:	7422                	ld	s0,40(sp)
 1ea:	6145                	addi	sp,sp,48
 1ec:	8082                	ret

00000000000001ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ee:	1101                	addi	sp,sp,-32
 1f0:	ec22                	sd	s0,24(sp)
 1f2:	1000                	addi	s0,sp,32
 1f4:	fea43423          	sd	a0,-24(s0)
 1f8:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 1fc:	a819                	j	212 <strcmp+0x24>
    p++, q++;
 1fe:	fe843783          	ld	a5,-24(s0)
 202:	0785                	addi	a5,a5,1
 204:	fef43423          	sd	a5,-24(s0)
 208:	fe043783          	ld	a5,-32(s0)
 20c:	0785                	addi	a5,a5,1
 20e:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 212:	fe843783          	ld	a5,-24(s0)
 216:	0007c783          	lbu	a5,0(a5)
 21a:	cb99                	beqz	a5,230 <strcmp+0x42>
 21c:	fe843783          	ld	a5,-24(s0)
 220:	0007c703          	lbu	a4,0(a5)
 224:	fe043783          	ld	a5,-32(s0)
 228:	0007c783          	lbu	a5,0(a5)
 22c:	fcf709e3          	beq	a4,a5,1fe <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 230:	fe843783          	ld	a5,-24(s0)
 234:	0007c783          	lbu	a5,0(a5)
 238:	0007871b          	sext.w	a4,a5
 23c:	fe043783          	ld	a5,-32(s0)
 240:	0007c783          	lbu	a5,0(a5)
 244:	2781                	sext.w	a5,a5
 246:	40f707bb          	subw	a5,a4,a5
 24a:	2781                	sext.w	a5,a5
}
 24c:	853e                	mv	a0,a5
 24e:	6462                	ld	s0,24(sp)
 250:	6105                	addi	sp,sp,32
 252:	8082                	ret

0000000000000254 <strlen>:

uint
strlen(const char *s)
{
 254:	7179                	addi	sp,sp,-48
 256:	f422                	sd	s0,40(sp)
 258:	1800                	addi	s0,sp,48
 25a:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 25e:	fe042623          	sw	zero,-20(s0)
 262:	a031                	j	26e <strlen+0x1a>
 264:	fec42783          	lw	a5,-20(s0)
 268:	2785                	addiw	a5,a5,1
 26a:	fef42623          	sw	a5,-20(s0)
 26e:	fec42783          	lw	a5,-20(s0)
 272:	fd843703          	ld	a4,-40(s0)
 276:	97ba                	add	a5,a5,a4
 278:	0007c783          	lbu	a5,0(a5)
 27c:	f7e5                	bnez	a5,264 <strlen+0x10>
    ;
  return n;
 27e:	fec42783          	lw	a5,-20(s0)
}
 282:	853e                	mv	a0,a5
 284:	7422                	ld	s0,40(sp)
 286:	6145                	addi	sp,sp,48
 288:	8082                	ret

000000000000028a <memset>:

void*
memset(void *dst, int c, uint n)
{
 28a:	7179                	addi	sp,sp,-48
 28c:	f422                	sd	s0,40(sp)
 28e:	1800                	addi	s0,sp,48
 290:	fca43c23          	sd	a0,-40(s0)
 294:	87ae                	mv	a5,a1
 296:	8732                	mv	a4,a2
 298:	fcf42a23          	sw	a5,-44(s0)
 29c:	87ba                	mv	a5,a4
 29e:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 2a2:	fd843783          	ld	a5,-40(s0)
 2a6:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 2aa:	fe042623          	sw	zero,-20(s0)
 2ae:	a00d                	j	2d0 <memset+0x46>
    cdst[i] = c;
 2b0:	fec42783          	lw	a5,-20(s0)
 2b4:	fe043703          	ld	a4,-32(s0)
 2b8:	97ba                	add	a5,a5,a4
 2ba:	fd442703          	lw	a4,-44(s0)
 2be:	0ff77713          	zext.b	a4,a4
 2c2:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 2c6:	fec42783          	lw	a5,-20(s0)
 2ca:	2785                	addiw	a5,a5,1
 2cc:	fef42623          	sw	a5,-20(s0)
 2d0:	fec42703          	lw	a4,-20(s0)
 2d4:	fd042783          	lw	a5,-48(s0)
 2d8:	2781                	sext.w	a5,a5
 2da:	fcf76be3          	bltu	a4,a5,2b0 <memset+0x26>
  }
  return dst;
 2de:	fd843783          	ld	a5,-40(s0)
}
 2e2:	853e                	mv	a0,a5
 2e4:	7422                	ld	s0,40(sp)
 2e6:	6145                	addi	sp,sp,48
 2e8:	8082                	ret

00000000000002ea <strchr>:

char*
strchr(const char *s, char c)
{
 2ea:	1101                	addi	sp,sp,-32
 2ec:	ec22                	sd	s0,24(sp)
 2ee:	1000                	addi	s0,sp,32
 2f0:	fea43423          	sd	a0,-24(s0)
 2f4:	87ae                	mv	a5,a1
 2f6:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 2fa:	a01d                	j	320 <strchr+0x36>
    if(*s == c)
 2fc:	fe843783          	ld	a5,-24(s0)
 300:	0007c703          	lbu	a4,0(a5)
 304:	fe744783          	lbu	a5,-25(s0)
 308:	0ff7f793          	zext.b	a5,a5
 30c:	00e79563          	bne	a5,a4,316 <strchr+0x2c>
      return (char*)s;
 310:	fe843783          	ld	a5,-24(s0)
 314:	a821                	j	32c <strchr+0x42>
  for(; *s; s++)
 316:	fe843783          	ld	a5,-24(s0)
 31a:	0785                	addi	a5,a5,1
 31c:	fef43423          	sd	a5,-24(s0)
 320:	fe843783          	ld	a5,-24(s0)
 324:	0007c783          	lbu	a5,0(a5)
 328:	fbf1                	bnez	a5,2fc <strchr+0x12>
  return 0;
 32a:	4781                	li	a5,0
}
 32c:	853e                	mv	a0,a5
 32e:	6462                	ld	s0,24(sp)
 330:	6105                	addi	sp,sp,32
 332:	8082                	ret

0000000000000334 <gets>:

char*
gets(char *buf, int max)
{
 334:	7179                	addi	sp,sp,-48
 336:	f406                	sd	ra,40(sp)
 338:	f022                	sd	s0,32(sp)
 33a:	1800                	addi	s0,sp,48
 33c:	fca43c23          	sd	a0,-40(s0)
 340:	87ae                	mv	a5,a1
 342:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 346:	fe042623          	sw	zero,-20(s0)
 34a:	a8a1                	j	3a2 <gets+0x6e>
    cc = read(0, &c, 1);
 34c:	fe740793          	addi	a5,s0,-25
 350:	4605                	li	a2,1
 352:	85be                	mv	a1,a5
 354:	4501                	li	a0,0
 356:	00000097          	auipc	ra,0x0
 35a:	2f8080e7          	jalr	760(ra) # 64e <read>
 35e:	87aa                	mv	a5,a0
 360:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 364:	fe842783          	lw	a5,-24(s0)
 368:	2781                	sext.w	a5,a5
 36a:	04f05763          	blez	a5,3b8 <gets+0x84>
      break;
    buf[i++] = c;
 36e:	fec42783          	lw	a5,-20(s0)
 372:	0017871b          	addiw	a4,a5,1
 376:	fee42623          	sw	a4,-20(s0)
 37a:	873e                	mv	a4,a5
 37c:	fd843783          	ld	a5,-40(s0)
 380:	97ba                	add	a5,a5,a4
 382:	fe744703          	lbu	a4,-25(s0)
 386:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 38a:	fe744783          	lbu	a5,-25(s0)
 38e:	873e                	mv	a4,a5
 390:	47a9                	li	a5,10
 392:	02f70463          	beq	a4,a5,3ba <gets+0x86>
 396:	fe744783          	lbu	a5,-25(s0)
 39a:	873e                	mv	a4,a5
 39c:	47b5                	li	a5,13
 39e:	00f70e63          	beq	a4,a5,3ba <gets+0x86>
  for(i=0; i+1 < max; ){
 3a2:	fec42783          	lw	a5,-20(s0)
 3a6:	2785                	addiw	a5,a5,1
 3a8:	0007871b          	sext.w	a4,a5
 3ac:	fd442783          	lw	a5,-44(s0)
 3b0:	2781                	sext.w	a5,a5
 3b2:	f8f74de3          	blt	a4,a5,34c <gets+0x18>
 3b6:	a011                	j	3ba <gets+0x86>
      break;
 3b8:	0001                	nop
      break;
  }
  buf[i] = '\0';
 3ba:	fec42783          	lw	a5,-20(s0)
 3be:	fd843703          	ld	a4,-40(s0)
 3c2:	97ba                	add	a5,a5,a4
 3c4:	00078023          	sb	zero,0(a5)
  return buf;
 3c8:	fd843783          	ld	a5,-40(s0)
}
 3cc:	853e                	mv	a0,a5
 3ce:	70a2                	ld	ra,40(sp)
 3d0:	7402                	ld	s0,32(sp)
 3d2:	6145                	addi	sp,sp,48
 3d4:	8082                	ret

00000000000003d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d6:	7179                	addi	sp,sp,-48
 3d8:	f406                	sd	ra,40(sp)
 3da:	f022                	sd	s0,32(sp)
 3dc:	1800                	addi	s0,sp,48
 3de:	fca43c23          	sd	a0,-40(s0)
 3e2:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e6:	4581                	li	a1,0
 3e8:	fd843503          	ld	a0,-40(s0)
 3ec:	00000097          	auipc	ra,0x0
 3f0:	28a080e7          	jalr	650(ra) # 676 <open>
 3f4:	87aa                	mv	a5,a0
 3f6:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 3fa:	fec42783          	lw	a5,-20(s0)
 3fe:	2781                	sext.w	a5,a5
 400:	0007d463          	bgez	a5,408 <stat+0x32>
    return -1;
 404:	57fd                	li	a5,-1
 406:	a035                	j	432 <stat+0x5c>
  r = fstat(fd, st);
 408:	fec42783          	lw	a5,-20(s0)
 40c:	fd043583          	ld	a1,-48(s0)
 410:	853e                	mv	a0,a5
 412:	00000097          	auipc	ra,0x0
 416:	27c080e7          	jalr	636(ra) # 68e <fstat>
 41a:	87aa                	mv	a5,a0
 41c:	fef42423          	sw	a5,-24(s0)
  close(fd);
 420:	fec42783          	lw	a5,-20(s0)
 424:	853e                	mv	a0,a5
 426:	00000097          	auipc	ra,0x0
 42a:	238080e7          	jalr	568(ra) # 65e <close>
  return r;
 42e:	fe842783          	lw	a5,-24(s0)
}
 432:	853e                	mv	a0,a5
 434:	70a2                	ld	ra,40(sp)
 436:	7402                	ld	s0,32(sp)
 438:	6145                	addi	sp,sp,48
 43a:	8082                	ret

000000000000043c <atoi>:

int
atoi(const char *s)
{
 43c:	7179                	addi	sp,sp,-48
 43e:	f422                	sd	s0,40(sp)
 440:	1800                	addi	s0,sp,48
 442:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 446:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 44a:	a81d                	j	480 <atoi+0x44>
    n = n*10 + *s++ - '0';
 44c:	fec42783          	lw	a5,-20(s0)
 450:	873e                	mv	a4,a5
 452:	87ba                	mv	a5,a4
 454:	0027979b          	slliw	a5,a5,0x2
 458:	9fb9                	addw	a5,a5,a4
 45a:	0017979b          	slliw	a5,a5,0x1
 45e:	0007871b          	sext.w	a4,a5
 462:	fd843783          	ld	a5,-40(s0)
 466:	00178693          	addi	a3,a5,1
 46a:	fcd43c23          	sd	a3,-40(s0)
 46e:	0007c783          	lbu	a5,0(a5)
 472:	2781                	sext.w	a5,a5
 474:	9fb9                	addw	a5,a5,a4
 476:	2781                	sext.w	a5,a5
 478:	fd07879b          	addiw	a5,a5,-48
 47c:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 480:	fd843783          	ld	a5,-40(s0)
 484:	0007c783          	lbu	a5,0(a5)
 488:	873e                	mv	a4,a5
 48a:	02f00793          	li	a5,47
 48e:	00e7fb63          	bgeu	a5,a4,4a4 <atoi+0x68>
 492:	fd843783          	ld	a5,-40(s0)
 496:	0007c783          	lbu	a5,0(a5)
 49a:	873e                	mv	a4,a5
 49c:	03900793          	li	a5,57
 4a0:	fae7f6e3          	bgeu	a5,a4,44c <atoi+0x10>
  return n;
 4a4:	fec42783          	lw	a5,-20(s0)
}
 4a8:	853e                	mv	a0,a5
 4aa:	7422                	ld	s0,40(sp)
 4ac:	6145                	addi	sp,sp,48
 4ae:	8082                	ret

00000000000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	7139                	addi	sp,sp,-64
 4b2:	fc22                	sd	s0,56(sp)
 4b4:	0080                	addi	s0,sp,64
 4b6:	fca43c23          	sd	a0,-40(s0)
 4ba:	fcb43823          	sd	a1,-48(s0)
 4be:	87b2                	mv	a5,a2
 4c0:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 4c4:	fd843783          	ld	a5,-40(s0)
 4c8:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 4cc:	fd043783          	ld	a5,-48(s0)
 4d0:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 4d4:	fe043703          	ld	a4,-32(s0)
 4d8:	fe843783          	ld	a5,-24(s0)
 4dc:	02e7fc63          	bgeu	a5,a4,514 <memmove+0x64>
    while(n-- > 0)
 4e0:	a00d                	j	502 <memmove+0x52>
      *dst++ = *src++;
 4e2:	fe043703          	ld	a4,-32(s0)
 4e6:	00170793          	addi	a5,a4,1
 4ea:	fef43023          	sd	a5,-32(s0)
 4ee:	fe843783          	ld	a5,-24(s0)
 4f2:	00178693          	addi	a3,a5,1
 4f6:	fed43423          	sd	a3,-24(s0)
 4fa:	00074703          	lbu	a4,0(a4)
 4fe:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 502:	fcc42783          	lw	a5,-52(s0)
 506:	fff7871b          	addiw	a4,a5,-1
 50a:	fce42623          	sw	a4,-52(s0)
 50e:	fcf04ae3          	bgtz	a5,4e2 <memmove+0x32>
 512:	a891                	j	566 <memmove+0xb6>
  } else {
    dst += n;
 514:	fcc42783          	lw	a5,-52(s0)
 518:	fe843703          	ld	a4,-24(s0)
 51c:	97ba                	add	a5,a5,a4
 51e:	fef43423          	sd	a5,-24(s0)
    src += n;
 522:	fcc42783          	lw	a5,-52(s0)
 526:	fe043703          	ld	a4,-32(s0)
 52a:	97ba                	add	a5,a5,a4
 52c:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 530:	a01d                	j	556 <memmove+0xa6>
      *--dst = *--src;
 532:	fe043783          	ld	a5,-32(s0)
 536:	17fd                	addi	a5,a5,-1
 538:	fef43023          	sd	a5,-32(s0)
 53c:	fe843783          	ld	a5,-24(s0)
 540:	17fd                	addi	a5,a5,-1
 542:	fef43423          	sd	a5,-24(s0)
 546:	fe043783          	ld	a5,-32(s0)
 54a:	0007c703          	lbu	a4,0(a5)
 54e:	fe843783          	ld	a5,-24(s0)
 552:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 556:	fcc42783          	lw	a5,-52(s0)
 55a:	fff7871b          	addiw	a4,a5,-1
 55e:	fce42623          	sw	a4,-52(s0)
 562:	fcf048e3          	bgtz	a5,532 <memmove+0x82>
  }
  return vdst;
 566:	fd843783          	ld	a5,-40(s0)
}
 56a:	853e                	mv	a0,a5
 56c:	7462                	ld	s0,56(sp)
 56e:	6121                	addi	sp,sp,64
 570:	8082                	ret

0000000000000572 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 572:	7139                	addi	sp,sp,-64
 574:	fc22                	sd	s0,56(sp)
 576:	0080                	addi	s0,sp,64
 578:	fca43c23          	sd	a0,-40(s0)
 57c:	fcb43823          	sd	a1,-48(s0)
 580:	87b2                	mv	a5,a2
 582:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 586:	fd843783          	ld	a5,-40(s0)
 58a:	fef43423          	sd	a5,-24(s0)
 58e:	fd043783          	ld	a5,-48(s0)
 592:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 596:	a0a1                	j	5de <memcmp+0x6c>
    if (*p1 != *p2) {
 598:	fe843783          	ld	a5,-24(s0)
 59c:	0007c703          	lbu	a4,0(a5)
 5a0:	fe043783          	ld	a5,-32(s0)
 5a4:	0007c783          	lbu	a5,0(a5)
 5a8:	02f70163          	beq	a4,a5,5ca <memcmp+0x58>
      return *p1 - *p2;
 5ac:	fe843783          	ld	a5,-24(s0)
 5b0:	0007c783          	lbu	a5,0(a5)
 5b4:	0007871b          	sext.w	a4,a5
 5b8:	fe043783          	ld	a5,-32(s0)
 5bc:	0007c783          	lbu	a5,0(a5)
 5c0:	2781                	sext.w	a5,a5
 5c2:	40f707bb          	subw	a5,a4,a5
 5c6:	2781                	sext.w	a5,a5
 5c8:	a01d                	j	5ee <memcmp+0x7c>
    }
    p1++;
 5ca:	fe843783          	ld	a5,-24(s0)
 5ce:	0785                	addi	a5,a5,1
 5d0:	fef43423          	sd	a5,-24(s0)
    p2++;
 5d4:	fe043783          	ld	a5,-32(s0)
 5d8:	0785                	addi	a5,a5,1
 5da:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 5de:	fcc42783          	lw	a5,-52(s0)
 5e2:	fff7871b          	addiw	a4,a5,-1
 5e6:	fce42623          	sw	a4,-52(s0)
 5ea:	f7dd                	bnez	a5,598 <memcmp+0x26>
  }
  return 0;
 5ec:	4781                	li	a5,0
}
 5ee:	853e                	mv	a0,a5
 5f0:	7462                	ld	s0,56(sp)
 5f2:	6121                	addi	sp,sp,64
 5f4:	8082                	ret

00000000000005f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5f6:	7179                	addi	sp,sp,-48
 5f8:	f406                	sd	ra,40(sp)
 5fa:	f022                	sd	s0,32(sp)
 5fc:	1800                	addi	s0,sp,48
 5fe:	fea43423          	sd	a0,-24(s0)
 602:	feb43023          	sd	a1,-32(s0)
 606:	87b2                	mv	a5,a2
 608:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 60c:	fdc42783          	lw	a5,-36(s0)
 610:	863e                	mv	a2,a5
 612:	fe043583          	ld	a1,-32(s0)
 616:	fe843503          	ld	a0,-24(s0)
 61a:	00000097          	auipc	ra,0x0
 61e:	e96080e7          	jalr	-362(ra) # 4b0 <memmove>
 622:	87aa                	mv	a5,a0
}
 624:	853e                	mv	a0,a5
 626:	70a2                	ld	ra,40(sp)
 628:	7402                	ld	s0,32(sp)
 62a:	6145                	addi	sp,sp,48
 62c:	8082                	ret

000000000000062e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 62e:	4885                	li	a7,1
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <exit>:
.global exit
exit:
 li a7, SYS_exit
 636:	4889                	li	a7,2
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <wait>:
.global wait
wait:
 li a7, SYS_wait
 63e:	488d                	li	a7,3
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 646:	4891                	li	a7,4
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <read>:
.global read
read:
 li a7, SYS_read
 64e:	4895                	li	a7,5
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <write>:
.global write
write:
 li a7, SYS_write
 656:	48c1                	li	a7,16
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <close>:
.global close
close:
 li a7, SYS_close
 65e:	48d5                	li	a7,21
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <kill>:
.global kill
kill:
 li a7, SYS_kill
 666:	4899                	li	a7,6
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <exec>:
.global exec
exec:
 li a7, SYS_exec
 66e:	489d                	li	a7,7
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <open>:
.global open
open:
 li a7, SYS_open
 676:	48bd                	li	a7,15
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 67e:	48c5                	li	a7,17
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 686:	48c9                	li	a7,18
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 68e:	48a1                	li	a7,8
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <link>:
.global link
link:
 li a7, SYS_link
 696:	48cd                	li	a7,19
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 69e:	48d1                	li	a7,20
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6a6:	48a5                	li	a7,9
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 6ae:	48a9                	li	a7,10
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6b6:	48ad                	li	a7,11
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6be:	48b1                	li	a7,12
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6c6:	48b5                	li	a7,13
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6ce:	48b9                	li	a7,14
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6d6:	1101                	addi	sp,sp,-32
 6d8:	ec06                	sd	ra,24(sp)
 6da:	e822                	sd	s0,16(sp)
 6dc:	1000                	addi	s0,sp,32
 6de:	87aa                	mv	a5,a0
 6e0:	872e                	mv	a4,a1
 6e2:	fef42623          	sw	a5,-20(s0)
 6e6:	87ba                	mv	a5,a4
 6e8:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 6ec:	feb40713          	addi	a4,s0,-21
 6f0:	fec42783          	lw	a5,-20(s0)
 6f4:	4605                	li	a2,1
 6f6:	85ba                	mv	a1,a4
 6f8:	853e                	mv	a0,a5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	f5c080e7          	jalr	-164(ra) # 656 <write>
}
 702:	0001                	nop
 704:	60e2                	ld	ra,24(sp)
 706:	6442                	ld	s0,16(sp)
 708:	6105                	addi	sp,sp,32
 70a:	8082                	ret

000000000000070c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 70c:	7139                	addi	sp,sp,-64
 70e:	fc06                	sd	ra,56(sp)
 710:	f822                	sd	s0,48(sp)
 712:	0080                	addi	s0,sp,64
 714:	87aa                	mv	a5,a0
 716:	8736                	mv	a4,a3
 718:	fcf42623          	sw	a5,-52(s0)
 71c:	87ae                	mv	a5,a1
 71e:	fcf42423          	sw	a5,-56(s0)
 722:	87b2                	mv	a5,a2
 724:	fcf42223          	sw	a5,-60(s0)
 728:	87ba                	mv	a5,a4
 72a:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 72e:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 732:	fc042783          	lw	a5,-64(s0)
 736:	2781                	sext.w	a5,a5
 738:	c38d                	beqz	a5,75a <printint+0x4e>
 73a:	fc842783          	lw	a5,-56(s0)
 73e:	2781                	sext.w	a5,a5
 740:	0007dd63          	bgez	a5,75a <printint+0x4e>
    neg = 1;
 744:	4785                	li	a5,1
 746:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 74a:	fc842783          	lw	a5,-56(s0)
 74e:	40f007bb          	negw	a5,a5
 752:	2781                	sext.w	a5,a5
 754:	fef42223          	sw	a5,-28(s0)
 758:	a029                	j	762 <printint+0x56>
  } else {
    x = xx;
 75a:	fc842783          	lw	a5,-56(s0)
 75e:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 762:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 766:	fc442783          	lw	a5,-60(s0)
 76a:	fe442703          	lw	a4,-28(s0)
 76e:	02f777bb          	remuw	a5,a4,a5
 772:	0007861b          	sext.w	a2,a5
 776:	fec42783          	lw	a5,-20(s0)
 77a:	0017871b          	addiw	a4,a5,1
 77e:	fee42623          	sw	a4,-20(s0)
 782:	00001697          	auipc	a3,0x1
 786:	bee68693          	addi	a3,a3,-1042 # 1370 <digits>
 78a:	02061713          	slli	a4,a2,0x20
 78e:	9301                	srli	a4,a4,0x20
 790:	9736                	add	a4,a4,a3
 792:	00074703          	lbu	a4,0(a4)
 796:	17c1                	addi	a5,a5,-16
 798:	97a2                	add	a5,a5,s0
 79a:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 79e:	fc442783          	lw	a5,-60(s0)
 7a2:	fe442703          	lw	a4,-28(s0)
 7a6:	02f757bb          	divuw	a5,a4,a5
 7aa:	fef42223          	sw	a5,-28(s0)
 7ae:	fe442783          	lw	a5,-28(s0)
 7b2:	2781                	sext.w	a5,a5
 7b4:	fbcd                	bnez	a5,766 <printint+0x5a>
  if(neg)
 7b6:	fe842783          	lw	a5,-24(s0)
 7ba:	2781                	sext.w	a5,a5
 7bc:	cf85                	beqz	a5,7f4 <printint+0xe8>
    buf[i++] = '-';
 7be:	fec42783          	lw	a5,-20(s0)
 7c2:	0017871b          	addiw	a4,a5,1
 7c6:	fee42623          	sw	a4,-20(s0)
 7ca:	17c1                	addi	a5,a5,-16
 7cc:	97a2                	add	a5,a5,s0
 7ce:	02d00713          	li	a4,45
 7d2:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 7d6:	a839                	j	7f4 <printint+0xe8>
    putc(fd, buf[i]);
 7d8:	fec42783          	lw	a5,-20(s0)
 7dc:	17c1                	addi	a5,a5,-16
 7de:	97a2                	add	a5,a5,s0
 7e0:	fe07c703          	lbu	a4,-32(a5)
 7e4:	fcc42783          	lw	a5,-52(s0)
 7e8:	85ba                	mv	a1,a4
 7ea:	853e                	mv	a0,a5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	eea080e7          	jalr	-278(ra) # 6d6 <putc>
  while(--i >= 0)
 7f4:	fec42783          	lw	a5,-20(s0)
 7f8:	37fd                	addiw	a5,a5,-1
 7fa:	fef42623          	sw	a5,-20(s0)
 7fe:	fec42783          	lw	a5,-20(s0)
 802:	2781                	sext.w	a5,a5
 804:	fc07dae3          	bgez	a5,7d8 <printint+0xcc>
}
 808:	0001                	nop
 80a:	0001                	nop
 80c:	70e2                	ld	ra,56(sp)
 80e:	7442                	ld	s0,48(sp)
 810:	6121                	addi	sp,sp,64
 812:	8082                	ret

0000000000000814 <printptr>:

static void
printptr(int fd, uint64 x) {
 814:	7179                	addi	sp,sp,-48
 816:	f406                	sd	ra,40(sp)
 818:	f022                	sd	s0,32(sp)
 81a:	1800                	addi	s0,sp,48
 81c:	87aa                	mv	a5,a0
 81e:	fcb43823          	sd	a1,-48(s0)
 822:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 826:	fdc42783          	lw	a5,-36(s0)
 82a:	03000593          	li	a1,48
 82e:	853e                	mv	a0,a5
 830:	00000097          	auipc	ra,0x0
 834:	ea6080e7          	jalr	-346(ra) # 6d6 <putc>
  putc(fd, 'x');
 838:	fdc42783          	lw	a5,-36(s0)
 83c:	07800593          	li	a1,120
 840:	853e                	mv	a0,a5
 842:	00000097          	auipc	ra,0x0
 846:	e94080e7          	jalr	-364(ra) # 6d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 84a:	fe042623          	sw	zero,-20(s0)
 84e:	a82d                	j	888 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 850:	fd043783          	ld	a5,-48(s0)
 854:	93f1                	srli	a5,a5,0x3c
 856:	00001717          	auipc	a4,0x1
 85a:	b1a70713          	addi	a4,a4,-1254 # 1370 <digits>
 85e:	97ba                	add	a5,a5,a4
 860:	0007c703          	lbu	a4,0(a5)
 864:	fdc42783          	lw	a5,-36(s0)
 868:	85ba                	mv	a1,a4
 86a:	853e                	mv	a0,a5
 86c:	00000097          	auipc	ra,0x0
 870:	e6a080e7          	jalr	-406(ra) # 6d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 874:	fec42783          	lw	a5,-20(s0)
 878:	2785                	addiw	a5,a5,1
 87a:	fef42623          	sw	a5,-20(s0)
 87e:	fd043783          	ld	a5,-48(s0)
 882:	0792                	slli	a5,a5,0x4
 884:	fcf43823          	sd	a5,-48(s0)
 888:	fec42783          	lw	a5,-20(s0)
 88c:	873e                	mv	a4,a5
 88e:	47bd                	li	a5,15
 890:	fce7f0e3          	bgeu	a5,a4,850 <printptr+0x3c>
}
 894:	0001                	nop
 896:	0001                	nop
 898:	70a2                	ld	ra,40(sp)
 89a:	7402                	ld	s0,32(sp)
 89c:	6145                	addi	sp,sp,48
 89e:	8082                	ret

00000000000008a0 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8a0:	715d                	addi	sp,sp,-80
 8a2:	e486                	sd	ra,72(sp)
 8a4:	e0a2                	sd	s0,64(sp)
 8a6:	0880                	addi	s0,sp,80
 8a8:	87aa                	mv	a5,a0
 8aa:	fcb43023          	sd	a1,-64(s0)
 8ae:	fac43c23          	sd	a2,-72(s0)
 8b2:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 8b6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 8ba:	fe042223          	sw	zero,-28(s0)
 8be:	a42d                	j	ae8 <vprintf+0x248>
    c = fmt[i] & 0xff;
 8c0:	fe442783          	lw	a5,-28(s0)
 8c4:	fc043703          	ld	a4,-64(s0)
 8c8:	97ba                	add	a5,a5,a4
 8ca:	0007c783          	lbu	a5,0(a5)
 8ce:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 8d2:	fe042783          	lw	a5,-32(s0)
 8d6:	2781                	sext.w	a5,a5
 8d8:	eb9d                	bnez	a5,90e <vprintf+0x6e>
      if(c == '%'){
 8da:	fdc42783          	lw	a5,-36(s0)
 8de:	0007871b          	sext.w	a4,a5
 8e2:	02500793          	li	a5,37
 8e6:	00f71763          	bne	a4,a5,8f4 <vprintf+0x54>
        state = '%';
 8ea:	02500793          	li	a5,37
 8ee:	fef42023          	sw	a5,-32(s0)
 8f2:	a2f5                	j	ade <vprintf+0x23e>
      } else {
        putc(fd, c);
 8f4:	fdc42783          	lw	a5,-36(s0)
 8f8:	0ff7f713          	zext.b	a4,a5
 8fc:	fcc42783          	lw	a5,-52(s0)
 900:	85ba                	mv	a1,a4
 902:	853e                	mv	a0,a5
 904:	00000097          	auipc	ra,0x0
 908:	dd2080e7          	jalr	-558(ra) # 6d6 <putc>
 90c:	aac9                	j	ade <vprintf+0x23e>
      }
    } else if(state == '%'){
 90e:	fe042783          	lw	a5,-32(s0)
 912:	0007871b          	sext.w	a4,a5
 916:	02500793          	li	a5,37
 91a:	1cf71263          	bne	a4,a5,ade <vprintf+0x23e>
      if(c == 'd'){
 91e:	fdc42783          	lw	a5,-36(s0)
 922:	0007871b          	sext.w	a4,a5
 926:	06400793          	li	a5,100
 92a:	02f71463          	bne	a4,a5,952 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 92e:	fb843783          	ld	a5,-72(s0)
 932:	00878713          	addi	a4,a5,8
 936:	fae43c23          	sd	a4,-72(s0)
 93a:	4398                	lw	a4,0(a5)
 93c:	fcc42783          	lw	a5,-52(s0)
 940:	4685                	li	a3,1
 942:	4629                	li	a2,10
 944:	85ba                	mv	a1,a4
 946:	853e                	mv	a0,a5
 948:	00000097          	auipc	ra,0x0
 94c:	dc4080e7          	jalr	-572(ra) # 70c <printint>
 950:	a269                	j	ada <vprintf+0x23a>
      } else if(c == 'l') {
 952:	fdc42783          	lw	a5,-36(s0)
 956:	0007871b          	sext.w	a4,a5
 95a:	06c00793          	li	a5,108
 95e:	02f71663          	bne	a4,a5,98a <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 962:	fb843783          	ld	a5,-72(s0)
 966:	00878713          	addi	a4,a5,8
 96a:	fae43c23          	sd	a4,-72(s0)
 96e:	639c                	ld	a5,0(a5)
 970:	0007871b          	sext.w	a4,a5
 974:	fcc42783          	lw	a5,-52(s0)
 978:	4681                	li	a3,0
 97a:	4629                	li	a2,10
 97c:	85ba                	mv	a1,a4
 97e:	853e                	mv	a0,a5
 980:	00000097          	auipc	ra,0x0
 984:	d8c080e7          	jalr	-628(ra) # 70c <printint>
 988:	aa89                	j	ada <vprintf+0x23a>
      } else if(c == 'x') {
 98a:	fdc42783          	lw	a5,-36(s0)
 98e:	0007871b          	sext.w	a4,a5
 992:	07800793          	li	a5,120
 996:	02f71463          	bne	a4,a5,9be <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 99a:	fb843783          	ld	a5,-72(s0)
 99e:	00878713          	addi	a4,a5,8
 9a2:	fae43c23          	sd	a4,-72(s0)
 9a6:	4398                	lw	a4,0(a5)
 9a8:	fcc42783          	lw	a5,-52(s0)
 9ac:	4681                	li	a3,0
 9ae:	4641                	li	a2,16
 9b0:	85ba                	mv	a1,a4
 9b2:	853e                	mv	a0,a5
 9b4:	00000097          	auipc	ra,0x0
 9b8:	d58080e7          	jalr	-680(ra) # 70c <printint>
 9bc:	aa39                	j	ada <vprintf+0x23a>
      } else if(c == 'p') {
 9be:	fdc42783          	lw	a5,-36(s0)
 9c2:	0007871b          	sext.w	a4,a5
 9c6:	07000793          	li	a5,112
 9ca:	02f71263          	bne	a4,a5,9ee <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 9ce:	fb843783          	ld	a5,-72(s0)
 9d2:	00878713          	addi	a4,a5,8
 9d6:	fae43c23          	sd	a4,-72(s0)
 9da:	6398                	ld	a4,0(a5)
 9dc:	fcc42783          	lw	a5,-52(s0)
 9e0:	85ba                	mv	a1,a4
 9e2:	853e                	mv	a0,a5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	e30080e7          	jalr	-464(ra) # 814 <printptr>
 9ec:	a0fd                	j	ada <vprintf+0x23a>
      } else if(c == 's'){
 9ee:	fdc42783          	lw	a5,-36(s0)
 9f2:	0007871b          	sext.w	a4,a5
 9f6:	07300793          	li	a5,115
 9fa:	04f71c63          	bne	a4,a5,a52 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 9fe:	fb843783          	ld	a5,-72(s0)
 a02:	00878713          	addi	a4,a5,8
 a06:	fae43c23          	sd	a4,-72(s0)
 a0a:	639c                	ld	a5,0(a5)
 a0c:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 a10:	fe843783          	ld	a5,-24(s0)
 a14:	eb8d                	bnez	a5,a46 <vprintf+0x1a6>
          s = "(null)";
 a16:	00000797          	auipc	a5,0x0
 a1a:	4ba78793          	addi	a5,a5,1210 # ed0 <malloc+0x180>
 a1e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a22:	a015                	j	a46 <vprintf+0x1a6>
          putc(fd, *s);
 a24:	fe843783          	ld	a5,-24(s0)
 a28:	0007c703          	lbu	a4,0(a5)
 a2c:	fcc42783          	lw	a5,-52(s0)
 a30:	85ba                	mv	a1,a4
 a32:	853e                	mv	a0,a5
 a34:	00000097          	auipc	ra,0x0
 a38:	ca2080e7          	jalr	-862(ra) # 6d6 <putc>
          s++;
 a3c:	fe843783          	ld	a5,-24(s0)
 a40:	0785                	addi	a5,a5,1
 a42:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a46:	fe843783          	ld	a5,-24(s0)
 a4a:	0007c783          	lbu	a5,0(a5)
 a4e:	fbf9                	bnez	a5,a24 <vprintf+0x184>
 a50:	a069                	j	ada <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a52:	fdc42783          	lw	a5,-36(s0)
 a56:	0007871b          	sext.w	a4,a5
 a5a:	06300793          	li	a5,99
 a5e:	02f71463          	bne	a4,a5,a86 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a62:	fb843783          	ld	a5,-72(s0)
 a66:	00878713          	addi	a4,a5,8
 a6a:	fae43c23          	sd	a4,-72(s0)
 a6e:	439c                	lw	a5,0(a5)
 a70:	0ff7f713          	zext.b	a4,a5
 a74:	fcc42783          	lw	a5,-52(s0)
 a78:	85ba                	mv	a1,a4
 a7a:	853e                	mv	a0,a5
 a7c:	00000097          	auipc	ra,0x0
 a80:	c5a080e7          	jalr	-934(ra) # 6d6 <putc>
 a84:	a899                	j	ada <vprintf+0x23a>
      } else if(c == '%'){
 a86:	fdc42783          	lw	a5,-36(s0)
 a8a:	0007871b          	sext.w	a4,a5
 a8e:	02500793          	li	a5,37
 a92:	00f71f63          	bne	a4,a5,ab0 <vprintf+0x210>
        putc(fd, c);
 a96:	fdc42783          	lw	a5,-36(s0)
 a9a:	0ff7f713          	zext.b	a4,a5
 a9e:	fcc42783          	lw	a5,-52(s0)
 aa2:	85ba                	mv	a1,a4
 aa4:	853e                	mv	a0,a5
 aa6:	00000097          	auipc	ra,0x0
 aaa:	c30080e7          	jalr	-976(ra) # 6d6 <putc>
 aae:	a035                	j	ada <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ab0:	fcc42783          	lw	a5,-52(s0)
 ab4:	02500593          	li	a1,37
 ab8:	853e                	mv	a0,a5
 aba:	00000097          	auipc	ra,0x0
 abe:	c1c080e7          	jalr	-996(ra) # 6d6 <putc>
        putc(fd, c);
 ac2:	fdc42783          	lw	a5,-36(s0)
 ac6:	0ff7f713          	zext.b	a4,a5
 aca:	fcc42783          	lw	a5,-52(s0)
 ace:	85ba                	mv	a1,a4
 ad0:	853e                	mv	a0,a5
 ad2:	00000097          	auipc	ra,0x0
 ad6:	c04080e7          	jalr	-1020(ra) # 6d6 <putc>
      }
      state = 0;
 ada:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 ade:	fe442783          	lw	a5,-28(s0)
 ae2:	2785                	addiw	a5,a5,1
 ae4:	fef42223          	sw	a5,-28(s0)
 ae8:	fe442783          	lw	a5,-28(s0)
 aec:	fc043703          	ld	a4,-64(s0)
 af0:	97ba                	add	a5,a5,a4
 af2:	0007c783          	lbu	a5,0(a5)
 af6:	dc0795e3          	bnez	a5,8c0 <vprintf+0x20>
    }
  }
}
 afa:	0001                	nop
 afc:	0001                	nop
 afe:	60a6                	ld	ra,72(sp)
 b00:	6406                	ld	s0,64(sp)
 b02:	6161                	addi	sp,sp,80
 b04:	8082                	ret

0000000000000b06 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b06:	7159                	addi	sp,sp,-112
 b08:	fc06                	sd	ra,56(sp)
 b0a:	f822                	sd	s0,48(sp)
 b0c:	0080                	addi	s0,sp,64
 b0e:	fcb43823          	sd	a1,-48(s0)
 b12:	e010                	sd	a2,0(s0)
 b14:	e414                	sd	a3,8(s0)
 b16:	e818                	sd	a4,16(s0)
 b18:	ec1c                	sd	a5,24(s0)
 b1a:	03043023          	sd	a6,32(s0)
 b1e:	03143423          	sd	a7,40(s0)
 b22:	87aa                	mv	a5,a0
 b24:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 b28:	03040793          	addi	a5,s0,48
 b2c:	fcf43423          	sd	a5,-56(s0)
 b30:	fc843783          	ld	a5,-56(s0)
 b34:	fd078793          	addi	a5,a5,-48
 b38:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 b3c:	fe843703          	ld	a4,-24(s0)
 b40:	fdc42783          	lw	a5,-36(s0)
 b44:	863a                	mv	a2,a4
 b46:	fd043583          	ld	a1,-48(s0)
 b4a:	853e                	mv	a0,a5
 b4c:	00000097          	auipc	ra,0x0
 b50:	d54080e7          	jalr	-684(ra) # 8a0 <vprintf>
}
 b54:	0001                	nop
 b56:	70e2                	ld	ra,56(sp)
 b58:	7442                	ld	s0,48(sp)
 b5a:	6165                	addi	sp,sp,112
 b5c:	8082                	ret

0000000000000b5e <printf>:

void
printf(const char *fmt, ...)
{
 b5e:	7159                	addi	sp,sp,-112
 b60:	f406                	sd	ra,40(sp)
 b62:	f022                	sd	s0,32(sp)
 b64:	1800                	addi	s0,sp,48
 b66:	fca43c23          	sd	a0,-40(s0)
 b6a:	e40c                	sd	a1,8(s0)
 b6c:	e810                	sd	a2,16(s0)
 b6e:	ec14                	sd	a3,24(s0)
 b70:	f018                	sd	a4,32(s0)
 b72:	f41c                	sd	a5,40(s0)
 b74:	03043823          	sd	a6,48(s0)
 b78:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b7c:	04040793          	addi	a5,s0,64
 b80:	fcf43823          	sd	a5,-48(s0)
 b84:	fd043783          	ld	a5,-48(s0)
 b88:	fc878793          	addi	a5,a5,-56
 b8c:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 b90:	fe843783          	ld	a5,-24(s0)
 b94:	863e                	mv	a2,a5
 b96:	fd843583          	ld	a1,-40(s0)
 b9a:	4505                	li	a0,1
 b9c:	00000097          	auipc	ra,0x0
 ba0:	d04080e7          	jalr	-764(ra) # 8a0 <vprintf>
}
 ba4:	0001                	nop
 ba6:	70a2                	ld	ra,40(sp)
 ba8:	7402                	ld	s0,32(sp)
 baa:	6165                	addi	sp,sp,112
 bac:	8082                	ret

0000000000000bae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bae:	7179                	addi	sp,sp,-48
 bb0:	f422                	sd	s0,40(sp)
 bb2:	1800                	addi	s0,sp,48
 bb4:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bb8:	fd843783          	ld	a5,-40(s0)
 bbc:	17c1                	addi	a5,a5,-16
 bbe:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc2:	00000797          	auipc	a5,0x0
 bc6:	7de78793          	addi	a5,a5,2014 # 13a0 <freep>
 bca:	639c                	ld	a5,0(a5)
 bcc:	fef43423          	sd	a5,-24(s0)
 bd0:	a815                	j	c04 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bd2:	fe843783          	ld	a5,-24(s0)
 bd6:	639c                	ld	a5,0(a5)
 bd8:	fe843703          	ld	a4,-24(s0)
 bdc:	00f76f63          	bltu	a4,a5,bfa <free+0x4c>
 be0:	fe043703          	ld	a4,-32(s0)
 be4:	fe843783          	ld	a5,-24(s0)
 be8:	02e7eb63          	bltu	a5,a4,c1e <free+0x70>
 bec:	fe843783          	ld	a5,-24(s0)
 bf0:	639c                	ld	a5,0(a5)
 bf2:	fe043703          	ld	a4,-32(s0)
 bf6:	02f76463          	bltu	a4,a5,c1e <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfa:	fe843783          	ld	a5,-24(s0)
 bfe:	639c                	ld	a5,0(a5)
 c00:	fef43423          	sd	a5,-24(s0)
 c04:	fe043703          	ld	a4,-32(s0)
 c08:	fe843783          	ld	a5,-24(s0)
 c0c:	fce7f3e3          	bgeu	a5,a4,bd2 <free+0x24>
 c10:	fe843783          	ld	a5,-24(s0)
 c14:	639c                	ld	a5,0(a5)
 c16:	fe043703          	ld	a4,-32(s0)
 c1a:	faf77ce3          	bgeu	a4,a5,bd2 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c1e:	fe043783          	ld	a5,-32(s0)
 c22:	479c                	lw	a5,8(a5)
 c24:	1782                	slli	a5,a5,0x20
 c26:	9381                	srli	a5,a5,0x20
 c28:	0792                	slli	a5,a5,0x4
 c2a:	fe043703          	ld	a4,-32(s0)
 c2e:	973e                	add	a4,a4,a5
 c30:	fe843783          	ld	a5,-24(s0)
 c34:	639c                	ld	a5,0(a5)
 c36:	02f71763          	bne	a4,a5,c64 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 c3a:	fe043783          	ld	a5,-32(s0)
 c3e:	4798                	lw	a4,8(a5)
 c40:	fe843783          	ld	a5,-24(s0)
 c44:	639c                	ld	a5,0(a5)
 c46:	479c                	lw	a5,8(a5)
 c48:	9fb9                	addw	a5,a5,a4
 c4a:	0007871b          	sext.w	a4,a5
 c4e:	fe043783          	ld	a5,-32(s0)
 c52:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c54:	fe843783          	ld	a5,-24(s0)
 c58:	639c                	ld	a5,0(a5)
 c5a:	6398                	ld	a4,0(a5)
 c5c:	fe043783          	ld	a5,-32(s0)
 c60:	e398                	sd	a4,0(a5)
 c62:	a039                	j	c70 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 c64:	fe843783          	ld	a5,-24(s0)
 c68:	6398                	ld	a4,0(a5)
 c6a:	fe043783          	ld	a5,-32(s0)
 c6e:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c70:	fe843783          	ld	a5,-24(s0)
 c74:	479c                	lw	a5,8(a5)
 c76:	1782                	slli	a5,a5,0x20
 c78:	9381                	srli	a5,a5,0x20
 c7a:	0792                	slli	a5,a5,0x4
 c7c:	fe843703          	ld	a4,-24(s0)
 c80:	97ba                	add	a5,a5,a4
 c82:	fe043703          	ld	a4,-32(s0)
 c86:	02f71563          	bne	a4,a5,cb0 <free+0x102>
    p->s.size += bp->s.size;
 c8a:	fe843783          	ld	a5,-24(s0)
 c8e:	4798                	lw	a4,8(a5)
 c90:	fe043783          	ld	a5,-32(s0)
 c94:	479c                	lw	a5,8(a5)
 c96:	9fb9                	addw	a5,a5,a4
 c98:	0007871b          	sext.w	a4,a5
 c9c:	fe843783          	ld	a5,-24(s0)
 ca0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ca2:	fe043783          	ld	a5,-32(s0)
 ca6:	6398                	ld	a4,0(a5)
 ca8:	fe843783          	ld	a5,-24(s0)
 cac:	e398                	sd	a4,0(a5)
 cae:	a031                	j	cba <free+0x10c>
  } else
    p->s.ptr = bp;
 cb0:	fe843783          	ld	a5,-24(s0)
 cb4:	fe043703          	ld	a4,-32(s0)
 cb8:	e398                	sd	a4,0(a5)
  freep = p;
 cba:	00000797          	auipc	a5,0x0
 cbe:	6e678793          	addi	a5,a5,1766 # 13a0 <freep>
 cc2:	fe843703          	ld	a4,-24(s0)
 cc6:	e398                	sd	a4,0(a5)
}
 cc8:	0001                	nop
 cca:	7422                	ld	s0,40(sp)
 ccc:	6145                	addi	sp,sp,48
 cce:	8082                	ret

0000000000000cd0 <morecore>:

static Header*
morecore(uint nu)
{
 cd0:	7179                	addi	sp,sp,-48
 cd2:	f406                	sd	ra,40(sp)
 cd4:	f022                	sd	s0,32(sp)
 cd6:	1800                	addi	s0,sp,48
 cd8:	87aa                	mv	a5,a0
 cda:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 cde:	fdc42783          	lw	a5,-36(s0)
 ce2:	0007871b          	sext.w	a4,a5
 ce6:	6785                	lui	a5,0x1
 ce8:	00f77563          	bgeu	a4,a5,cf2 <morecore+0x22>
    nu = 4096;
 cec:	6785                	lui	a5,0x1
 cee:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 cf2:	fdc42783          	lw	a5,-36(s0)
 cf6:	0047979b          	slliw	a5,a5,0x4
 cfa:	2781                	sext.w	a5,a5
 cfc:	2781                	sext.w	a5,a5
 cfe:	853e                	mv	a0,a5
 d00:	00000097          	auipc	ra,0x0
 d04:	9be080e7          	jalr	-1602(ra) # 6be <sbrk>
 d08:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 d0c:	fe843703          	ld	a4,-24(s0)
 d10:	57fd                	li	a5,-1
 d12:	00f71463          	bne	a4,a5,d1a <morecore+0x4a>
    return 0;
 d16:	4781                	li	a5,0
 d18:	a03d                	j	d46 <morecore+0x76>
  hp = (Header*)p;
 d1a:	fe843783          	ld	a5,-24(s0)
 d1e:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 d22:	fe043783          	ld	a5,-32(s0)
 d26:	fdc42703          	lw	a4,-36(s0)
 d2a:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 d2c:	fe043783          	ld	a5,-32(s0)
 d30:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x2c0>
 d32:	853e                	mv	a0,a5
 d34:	00000097          	auipc	ra,0x0
 d38:	e7a080e7          	jalr	-390(ra) # bae <free>
  return freep;
 d3c:	00000797          	auipc	a5,0x0
 d40:	66478793          	addi	a5,a5,1636 # 13a0 <freep>
 d44:	639c                	ld	a5,0(a5)
}
 d46:	853e                	mv	a0,a5
 d48:	70a2                	ld	ra,40(sp)
 d4a:	7402                	ld	s0,32(sp)
 d4c:	6145                	addi	sp,sp,48
 d4e:	8082                	ret

0000000000000d50 <malloc>:

void*
malloc(uint nbytes)
{
 d50:	7139                	addi	sp,sp,-64
 d52:	fc06                	sd	ra,56(sp)
 d54:	f822                	sd	s0,48(sp)
 d56:	0080                	addi	s0,sp,64
 d58:	87aa                	mv	a5,a0
 d5a:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d5e:	fcc46783          	lwu	a5,-52(s0)
 d62:	07bd                	addi	a5,a5,15
 d64:	8391                	srli	a5,a5,0x4
 d66:	2781                	sext.w	a5,a5
 d68:	2785                	addiw	a5,a5,1
 d6a:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d6e:	00000797          	auipc	a5,0x0
 d72:	63278793          	addi	a5,a5,1586 # 13a0 <freep>
 d76:	639c                	ld	a5,0(a5)
 d78:	fef43023          	sd	a5,-32(s0)
 d7c:	fe043783          	ld	a5,-32(s0)
 d80:	ef95                	bnez	a5,dbc <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d82:	00000797          	auipc	a5,0x0
 d86:	60e78793          	addi	a5,a5,1550 # 1390 <base>
 d8a:	fef43023          	sd	a5,-32(s0)
 d8e:	00000797          	auipc	a5,0x0
 d92:	61278793          	addi	a5,a5,1554 # 13a0 <freep>
 d96:	fe043703          	ld	a4,-32(s0)
 d9a:	e398                	sd	a4,0(a5)
 d9c:	00000797          	auipc	a5,0x0
 da0:	60478793          	addi	a5,a5,1540 # 13a0 <freep>
 da4:	6398                	ld	a4,0(a5)
 da6:	00000797          	auipc	a5,0x0
 daa:	5ea78793          	addi	a5,a5,1514 # 1390 <base>
 dae:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 db0:	00000797          	auipc	a5,0x0
 db4:	5e078793          	addi	a5,a5,1504 # 1390 <base>
 db8:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dbc:	fe043783          	ld	a5,-32(s0)
 dc0:	639c                	ld	a5,0(a5)
 dc2:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dc6:	fe843783          	ld	a5,-24(s0)
 dca:	4798                	lw	a4,8(a5)
 dcc:	fdc42783          	lw	a5,-36(s0)
 dd0:	2781                	sext.w	a5,a5
 dd2:	06f76763          	bltu	a4,a5,e40 <malloc+0xf0>
      if(p->s.size == nunits)
 dd6:	fe843783          	ld	a5,-24(s0)
 dda:	4798                	lw	a4,8(a5)
 ddc:	fdc42783          	lw	a5,-36(s0)
 de0:	2781                	sext.w	a5,a5
 de2:	00e79963          	bne	a5,a4,df4 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 de6:	fe843783          	ld	a5,-24(s0)
 dea:	6398                	ld	a4,0(a5)
 dec:	fe043783          	ld	a5,-32(s0)
 df0:	e398                	sd	a4,0(a5)
 df2:	a825                	j	e2a <malloc+0xda>
      else {
        p->s.size -= nunits;
 df4:	fe843783          	ld	a5,-24(s0)
 df8:	479c                	lw	a5,8(a5)
 dfa:	fdc42703          	lw	a4,-36(s0)
 dfe:	9f99                	subw	a5,a5,a4
 e00:	0007871b          	sext.w	a4,a5
 e04:	fe843783          	ld	a5,-24(s0)
 e08:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e0a:	fe843783          	ld	a5,-24(s0)
 e0e:	479c                	lw	a5,8(a5)
 e10:	1782                	slli	a5,a5,0x20
 e12:	9381                	srli	a5,a5,0x20
 e14:	0792                	slli	a5,a5,0x4
 e16:	fe843703          	ld	a4,-24(s0)
 e1a:	97ba                	add	a5,a5,a4
 e1c:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 e20:	fe843783          	ld	a5,-24(s0)
 e24:	fdc42703          	lw	a4,-36(s0)
 e28:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 e2a:	00000797          	auipc	a5,0x0
 e2e:	57678793          	addi	a5,a5,1398 # 13a0 <freep>
 e32:	fe043703          	ld	a4,-32(s0)
 e36:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 e38:	fe843783          	ld	a5,-24(s0)
 e3c:	07c1                	addi	a5,a5,16
 e3e:	a091                	j	e82 <malloc+0x132>
    }
    if(p == freep)
 e40:	00000797          	auipc	a5,0x0
 e44:	56078793          	addi	a5,a5,1376 # 13a0 <freep>
 e48:	639c                	ld	a5,0(a5)
 e4a:	fe843703          	ld	a4,-24(s0)
 e4e:	02f71063          	bne	a4,a5,e6e <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e52:	fdc42783          	lw	a5,-36(s0)
 e56:	853e                	mv	a0,a5
 e58:	00000097          	auipc	ra,0x0
 e5c:	e78080e7          	jalr	-392(ra) # cd0 <morecore>
 e60:	fea43423          	sd	a0,-24(s0)
 e64:	fe843783          	ld	a5,-24(s0)
 e68:	e399                	bnez	a5,e6e <malloc+0x11e>
        return 0;
 e6a:	4781                	li	a5,0
 e6c:	a819                	j	e82 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e6e:	fe843783          	ld	a5,-24(s0)
 e72:	fef43023          	sd	a5,-32(s0)
 e76:	fe843783          	ld	a5,-24(s0)
 e7a:	639c                	ld	a5,0(a5)
 e7c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e80:	b799                	j	dc6 <malloc+0x76>
  }
}
 e82:	853e                	mv	a0,a5
 e84:	70e2                	ld	ra,56(sp)
 e86:	7442                	ld	s0,48(sp)
 e88:	6121                	addi	sp,sp,64
 e8a:	8082                	ret
