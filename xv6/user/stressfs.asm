
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
  1c:	eb878793          	addi	a5,a5,-328 # ed0 <malloc+0x178>
  20:	6398                	ld	a4,0(a5)
  22:	fce43c23          	sd	a4,-40(s0)
  26:	0087d783          	lhu	a5,8(a5)
  2a:	fef41023          	sh	a5,-32(s0)
  char data[512];

  printf("stressfs starting\n");
  2e:	00001517          	auipc	a0,0x1
  32:	e7250513          	addi	a0,a0,-398 # ea0 <malloc+0x148>
  36:	00001097          	auipc	ra,0x1
  3a:	b30080e7          	jalr	-1232(ra) # b66 <printf>
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
  8e:	e2e50513          	addi	a0,a0,-466 # eb8 <malloc+0x160>
  92:	00001097          	auipc	ra,0x1
  96:	ad4080e7          	jalr	-1324(ra) # b66 <printf>

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
 110:	dbc50513          	addi	a0,a0,-580 # ec8 <malloc+0x170>
 114:	00001097          	auipc	ra,0x1
 118:	a52080e7          	jalr	-1454(ra) # b66 <printf>

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

00000000000006d6 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 6d6:	48d9                	li	a7,22
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6de:	1101                	addi	sp,sp,-32
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	addi	s0,sp,32
 6e6:	87aa                	mv	a5,a0
 6e8:	872e                	mv	a4,a1
 6ea:	fef42623          	sw	a5,-20(s0)
 6ee:	87ba                	mv	a5,a4
 6f0:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 6f4:	feb40713          	addi	a4,s0,-21
 6f8:	fec42783          	lw	a5,-20(s0)
 6fc:	4605                	li	a2,1
 6fe:	85ba                	mv	a1,a4
 700:	853e                	mv	a0,a5
 702:	00000097          	auipc	ra,0x0
 706:	f54080e7          	jalr	-172(ra) # 656 <write>
}
 70a:	0001                	nop
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6105                	addi	sp,sp,32
 712:	8082                	ret

0000000000000714 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 714:	7139                	addi	sp,sp,-64
 716:	fc06                	sd	ra,56(sp)
 718:	f822                	sd	s0,48(sp)
 71a:	0080                	addi	s0,sp,64
 71c:	87aa                	mv	a5,a0
 71e:	8736                	mv	a4,a3
 720:	fcf42623          	sw	a5,-52(s0)
 724:	87ae                	mv	a5,a1
 726:	fcf42423          	sw	a5,-56(s0)
 72a:	87b2                	mv	a5,a2
 72c:	fcf42223          	sw	a5,-60(s0)
 730:	87ba                	mv	a5,a4
 732:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 736:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 73a:	fc042783          	lw	a5,-64(s0)
 73e:	2781                	sext.w	a5,a5
 740:	c38d                	beqz	a5,762 <printint+0x4e>
 742:	fc842783          	lw	a5,-56(s0)
 746:	2781                	sext.w	a5,a5
 748:	0007dd63          	bgez	a5,762 <printint+0x4e>
    neg = 1;
 74c:	4785                	li	a5,1
 74e:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 752:	fc842783          	lw	a5,-56(s0)
 756:	40f007bb          	negw	a5,a5
 75a:	2781                	sext.w	a5,a5
 75c:	fef42223          	sw	a5,-28(s0)
 760:	a029                	j	76a <printint+0x56>
  } else {
    x = xx;
 762:	fc842783          	lw	a5,-56(s0)
 766:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 76a:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 76e:	fc442783          	lw	a5,-60(s0)
 772:	fe442703          	lw	a4,-28(s0)
 776:	02f777bb          	remuw	a5,a4,a5
 77a:	0007861b          	sext.w	a2,a5
 77e:	fec42783          	lw	a5,-20(s0)
 782:	0017871b          	addiw	a4,a5,1
 786:	fee42623          	sw	a4,-20(s0)
 78a:	00001697          	auipc	a3,0x1
 78e:	be668693          	addi	a3,a3,-1050 # 1370 <digits>
 792:	02061713          	slli	a4,a2,0x20
 796:	9301                	srli	a4,a4,0x20
 798:	9736                	add	a4,a4,a3
 79a:	00074703          	lbu	a4,0(a4)
 79e:	17c1                	addi	a5,a5,-16
 7a0:	97a2                	add	a5,a5,s0
 7a2:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 7a6:	fc442783          	lw	a5,-60(s0)
 7aa:	fe442703          	lw	a4,-28(s0)
 7ae:	02f757bb          	divuw	a5,a4,a5
 7b2:	fef42223          	sw	a5,-28(s0)
 7b6:	fe442783          	lw	a5,-28(s0)
 7ba:	2781                	sext.w	a5,a5
 7bc:	fbcd                	bnez	a5,76e <printint+0x5a>
  if(neg)
 7be:	fe842783          	lw	a5,-24(s0)
 7c2:	2781                	sext.w	a5,a5
 7c4:	cf85                	beqz	a5,7fc <printint+0xe8>
    buf[i++] = '-';
 7c6:	fec42783          	lw	a5,-20(s0)
 7ca:	0017871b          	addiw	a4,a5,1
 7ce:	fee42623          	sw	a4,-20(s0)
 7d2:	17c1                	addi	a5,a5,-16
 7d4:	97a2                	add	a5,a5,s0
 7d6:	02d00713          	li	a4,45
 7da:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 7de:	a839                	j	7fc <printint+0xe8>
    putc(fd, buf[i]);
 7e0:	fec42783          	lw	a5,-20(s0)
 7e4:	17c1                	addi	a5,a5,-16
 7e6:	97a2                	add	a5,a5,s0
 7e8:	fe07c703          	lbu	a4,-32(a5)
 7ec:	fcc42783          	lw	a5,-52(s0)
 7f0:	85ba                	mv	a1,a4
 7f2:	853e                	mv	a0,a5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	eea080e7          	jalr	-278(ra) # 6de <putc>
  while(--i >= 0)
 7fc:	fec42783          	lw	a5,-20(s0)
 800:	37fd                	addiw	a5,a5,-1
 802:	fef42623          	sw	a5,-20(s0)
 806:	fec42783          	lw	a5,-20(s0)
 80a:	2781                	sext.w	a5,a5
 80c:	fc07dae3          	bgez	a5,7e0 <printint+0xcc>
}
 810:	0001                	nop
 812:	0001                	nop
 814:	70e2                	ld	ra,56(sp)
 816:	7442                	ld	s0,48(sp)
 818:	6121                	addi	sp,sp,64
 81a:	8082                	ret

000000000000081c <printptr>:

static void
printptr(int fd, uint64 x) {
 81c:	7179                	addi	sp,sp,-48
 81e:	f406                	sd	ra,40(sp)
 820:	f022                	sd	s0,32(sp)
 822:	1800                	addi	s0,sp,48
 824:	87aa                	mv	a5,a0
 826:	fcb43823          	sd	a1,-48(s0)
 82a:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 82e:	fdc42783          	lw	a5,-36(s0)
 832:	03000593          	li	a1,48
 836:	853e                	mv	a0,a5
 838:	00000097          	auipc	ra,0x0
 83c:	ea6080e7          	jalr	-346(ra) # 6de <putc>
  putc(fd, 'x');
 840:	fdc42783          	lw	a5,-36(s0)
 844:	07800593          	li	a1,120
 848:	853e                	mv	a0,a5
 84a:	00000097          	auipc	ra,0x0
 84e:	e94080e7          	jalr	-364(ra) # 6de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 852:	fe042623          	sw	zero,-20(s0)
 856:	a82d                	j	890 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 858:	fd043783          	ld	a5,-48(s0)
 85c:	93f1                	srli	a5,a5,0x3c
 85e:	00001717          	auipc	a4,0x1
 862:	b1270713          	addi	a4,a4,-1262 # 1370 <digits>
 866:	97ba                	add	a5,a5,a4
 868:	0007c703          	lbu	a4,0(a5)
 86c:	fdc42783          	lw	a5,-36(s0)
 870:	85ba                	mv	a1,a4
 872:	853e                	mv	a0,a5
 874:	00000097          	auipc	ra,0x0
 878:	e6a080e7          	jalr	-406(ra) # 6de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 87c:	fec42783          	lw	a5,-20(s0)
 880:	2785                	addiw	a5,a5,1
 882:	fef42623          	sw	a5,-20(s0)
 886:	fd043783          	ld	a5,-48(s0)
 88a:	0792                	slli	a5,a5,0x4
 88c:	fcf43823          	sd	a5,-48(s0)
 890:	fec42783          	lw	a5,-20(s0)
 894:	873e                	mv	a4,a5
 896:	47bd                	li	a5,15
 898:	fce7f0e3          	bgeu	a5,a4,858 <printptr+0x3c>
}
 89c:	0001                	nop
 89e:	0001                	nop
 8a0:	70a2                	ld	ra,40(sp)
 8a2:	7402                	ld	s0,32(sp)
 8a4:	6145                	addi	sp,sp,48
 8a6:	8082                	ret

00000000000008a8 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8a8:	715d                	addi	sp,sp,-80
 8aa:	e486                	sd	ra,72(sp)
 8ac:	e0a2                	sd	s0,64(sp)
 8ae:	0880                	addi	s0,sp,80
 8b0:	87aa                	mv	a5,a0
 8b2:	fcb43023          	sd	a1,-64(s0)
 8b6:	fac43c23          	sd	a2,-72(s0)
 8ba:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 8be:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 8c2:	fe042223          	sw	zero,-28(s0)
 8c6:	a42d                	j	af0 <vprintf+0x248>
    c = fmt[i] & 0xff;
 8c8:	fe442783          	lw	a5,-28(s0)
 8cc:	fc043703          	ld	a4,-64(s0)
 8d0:	97ba                	add	a5,a5,a4
 8d2:	0007c783          	lbu	a5,0(a5)
 8d6:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 8da:	fe042783          	lw	a5,-32(s0)
 8de:	2781                	sext.w	a5,a5
 8e0:	eb9d                	bnez	a5,916 <vprintf+0x6e>
      if(c == '%'){
 8e2:	fdc42783          	lw	a5,-36(s0)
 8e6:	0007871b          	sext.w	a4,a5
 8ea:	02500793          	li	a5,37
 8ee:	00f71763          	bne	a4,a5,8fc <vprintf+0x54>
        state = '%';
 8f2:	02500793          	li	a5,37
 8f6:	fef42023          	sw	a5,-32(s0)
 8fa:	a2f5                	j	ae6 <vprintf+0x23e>
      } else {
        putc(fd, c);
 8fc:	fdc42783          	lw	a5,-36(s0)
 900:	0ff7f713          	zext.b	a4,a5
 904:	fcc42783          	lw	a5,-52(s0)
 908:	85ba                	mv	a1,a4
 90a:	853e                	mv	a0,a5
 90c:	00000097          	auipc	ra,0x0
 910:	dd2080e7          	jalr	-558(ra) # 6de <putc>
 914:	aac9                	j	ae6 <vprintf+0x23e>
      }
    } else if(state == '%'){
 916:	fe042783          	lw	a5,-32(s0)
 91a:	0007871b          	sext.w	a4,a5
 91e:	02500793          	li	a5,37
 922:	1cf71263          	bne	a4,a5,ae6 <vprintf+0x23e>
      if(c == 'd'){
 926:	fdc42783          	lw	a5,-36(s0)
 92a:	0007871b          	sext.w	a4,a5
 92e:	06400793          	li	a5,100
 932:	02f71463          	bne	a4,a5,95a <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 936:	fb843783          	ld	a5,-72(s0)
 93a:	00878713          	addi	a4,a5,8
 93e:	fae43c23          	sd	a4,-72(s0)
 942:	4398                	lw	a4,0(a5)
 944:	fcc42783          	lw	a5,-52(s0)
 948:	4685                	li	a3,1
 94a:	4629                	li	a2,10
 94c:	85ba                	mv	a1,a4
 94e:	853e                	mv	a0,a5
 950:	00000097          	auipc	ra,0x0
 954:	dc4080e7          	jalr	-572(ra) # 714 <printint>
 958:	a269                	j	ae2 <vprintf+0x23a>
      } else if(c == 'l') {
 95a:	fdc42783          	lw	a5,-36(s0)
 95e:	0007871b          	sext.w	a4,a5
 962:	06c00793          	li	a5,108
 966:	02f71663          	bne	a4,a5,992 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 96a:	fb843783          	ld	a5,-72(s0)
 96e:	00878713          	addi	a4,a5,8
 972:	fae43c23          	sd	a4,-72(s0)
 976:	639c                	ld	a5,0(a5)
 978:	0007871b          	sext.w	a4,a5
 97c:	fcc42783          	lw	a5,-52(s0)
 980:	4681                	li	a3,0
 982:	4629                	li	a2,10
 984:	85ba                	mv	a1,a4
 986:	853e                	mv	a0,a5
 988:	00000097          	auipc	ra,0x0
 98c:	d8c080e7          	jalr	-628(ra) # 714 <printint>
 990:	aa89                	j	ae2 <vprintf+0x23a>
      } else if(c == 'x') {
 992:	fdc42783          	lw	a5,-36(s0)
 996:	0007871b          	sext.w	a4,a5
 99a:	07800793          	li	a5,120
 99e:	02f71463          	bne	a4,a5,9c6 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 9a2:	fb843783          	ld	a5,-72(s0)
 9a6:	00878713          	addi	a4,a5,8
 9aa:	fae43c23          	sd	a4,-72(s0)
 9ae:	4398                	lw	a4,0(a5)
 9b0:	fcc42783          	lw	a5,-52(s0)
 9b4:	4681                	li	a3,0
 9b6:	4641                	li	a2,16
 9b8:	85ba                	mv	a1,a4
 9ba:	853e                	mv	a0,a5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	d58080e7          	jalr	-680(ra) # 714 <printint>
 9c4:	aa39                	j	ae2 <vprintf+0x23a>
      } else if(c == 'p') {
 9c6:	fdc42783          	lw	a5,-36(s0)
 9ca:	0007871b          	sext.w	a4,a5
 9ce:	07000793          	li	a5,112
 9d2:	02f71263          	bne	a4,a5,9f6 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 9d6:	fb843783          	ld	a5,-72(s0)
 9da:	00878713          	addi	a4,a5,8
 9de:	fae43c23          	sd	a4,-72(s0)
 9e2:	6398                	ld	a4,0(a5)
 9e4:	fcc42783          	lw	a5,-52(s0)
 9e8:	85ba                	mv	a1,a4
 9ea:	853e                	mv	a0,a5
 9ec:	00000097          	auipc	ra,0x0
 9f0:	e30080e7          	jalr	-464(ra) # 81c <printptr>
 9f4:	a0fd                	j	ae2 <vprintf+0x23a>
      } else if(c == 's'){
 9f6:	fdc42783          	lw	a5,-36(s0)
 9fa:	0007871b          	sext.w	a4,a5
 9fe:	07300793          	li	a5,115
 a02:	04f71c63          	bne	a4,a5,a5a <vprintf+0x1b2>
        s = va_arg(ap, char*);
 a06:	fb843783          	ld	a5,-72(s0)
 a0a:	00878713          	addi	a4,a5,8
 a0e:	fae43c23          	sd	a4,-72(s0)
 a12:	639c                	ld	a5,0(a5)
 a14:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 a18:	fe843783          	ld	a5,-24(s0)
 a1c:	eb8d                	bnez	a5,a4e <vprintf+0x1a6>
          s = "(null)";
 a1e:	00000797          	auipc	a5,0x0
 a22:	4c278793          	addi	a5,a5,1218 # ee0 <malloc+0x188>
 a26:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a2a:	a015                	j	a4e <vprintf+0x1a6>
          putc(fd, *s);
 a2c:	fe843783          	ld	a5,-24(s0)
 a30:	0007c703          	lbu	a4,0(a5)
 a34:	fcc42783          	lw	a5,-52(s0)
 a38:	85ba                	mv	a1,a4
 a3a:	853e                	mv	a0,a5
 a3c:	00000097          	auipc	ra,0x0
 a40:	ca2080e7          	jalr	-862(ra) # 6de <putc>
          s++;
 a44:	fe843783          	ld	a5,-24(s0)
 a48:	0785                	addi	a5,a5,1
 a4a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a4e:	fe843783          	ld	a5,-24(s0)
 a52:	0007c783          	lbu	a5,0(a5)
 a56:	fbf9                	bnez	a5,a2c <vprintf+0x184>
 a58:	a069                	j	ae2 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a5a:	fdc42783          	lw	a5,-36(s0)
 a5e:	0007871b          	sext.w	a4,a5
 a62:	06300793          	li	a5,99
 a66:	02f71463          	bne	a4,a5,a8e <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a6a:	fb843783          	ld	a5,-72(s0)
 a6e:	00878713          	addi	a4,a5,8
 a72:	fae43c23          	sd	a4,-72(s0)
 a76:	439c                	lw	a5,0(a5)
 a78:	0ff7f713          	zext.b	a4,a5
 a7c:	fcc42783          	lw	a5,-52(s0)
 a80:	85ba                	mv	a1,a4
 a82:	853e                	mv	a0,a5
 a84:	00000097          	auipc	ra,0x0
 a88:	c5a080e7          	jalr	-934(ra) # 6de <putc>
 a8c:	a899                	j	ae2 <vprintf+0x23a>
      } else if(c == '%'){
 a8e:	fdc42783          	lw	a5,-36(s0)
 a92:	0007871b          	sext.w	a4,a5
 a96:	02500793          	li	a5,37
 a9a:	00f71f63          	bne	a4,a5,ab8 <vprintf+0x210>
        putc(fd, c);
 a9e:	fdc42783          	lw	a5,-36(s0)
 aa2:	0ff7f713          	zext.b	a4,a5
 aa6:	fcc42783          	lw	a5,-52(s0)
 aaa:	85ba                	mv	a1,a4
 aac:	853e                	mv	a0,a5
 aae:	00000097          	auipc	ra,0x0
 ab2:	c30080e7          	jalr	-976(ra) # 6de <putc>
 ab6:	a035                	j	ae2 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ab8:	fcc42783          	lw	a5,-52(s0)
 abc:	02500593          	li	a1,37
 ac0:	853e                	mv	a0,a5
 ac2:	00000097          	auipc	ra,0x0
 ac6:	c1c080e7          	jalr	-996(ra) # 6de <putc>
        putc(fd, c);
 aca:	fdc42783          	lw	a5,-36(s0)
 ace:	0ff7f713          	zext.b	a4,a5
 ad2:	fcc42783          	lw	a5,-52(s0)
 ad6:	85ba                	mv	a1,a4
 ad8:	853e                	mv	a0,a5
 ada:	00000097          	auipc	ra,0x0
 ade:	c04080e7          	jalr	-1020(ra) # 6de <putc>
      }
      state = 0;
 ae2:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 ae6:	fe442783          	lw	a5,-28(s0)
 aea:	2785                	addiw	a5,a5,1
 aec:	fef42223          	sw	a5,-28(s0)
 af0:	fe442783          	lw	a5,-28(s0)
 af4:	fc043703          	ld	a4,-64(s0)
 af8:	97ba                	add	a5,a5,a4
 afa:	0007c783          	lbu	a5,0(a5)
 afe:	dc0795e3          	bnez	a5,8c8 <vprintf+0x20>
    }
  }
}
 b02:	0001                	nop
 b04:	0001                	nop
 b06:	60a6                	ld	ra,72(sp)
 b08:	6406                	ld	s0,64(sp)
 b0a:	6161                	addi	sp,sp,80
 b0c:	8082                	ret

0000000000000b0e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b0e:	7159                	addi	sp,sp,-112
 b10:	fc06                	sd	ra,56(sp)
 b12:	f822                	sd	s0,48(sp)
 b14:	0080                	addi	s0,sp,64
 b16:	fcb43823          	sd	a1,-48(s0)
 b1a:	e010                	sd	a2,0(s0)
 b1c:	e414                	sd	a3,8(s0)
 b1e:	e818                	sd	a4,16(s0)
 b20:	ec1c                	sd	a5,24(s0)
 b22:	03043023          	sd	a6,32(s0)
 b26:	03143423          	sd	a7,40(s0)
 b2a:	87aa                	mv	a5,a0
 b2c:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 b30:	03040793          	addi	a5,s0,48
 b34:	fcf43423          	sd	a5,-56(s0)
 b38:	fc843783          	ld	a5,-56(s0)
 b3c:	fd078793          	addi	a5,a5,-48
 b40:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 b44:	fe843703          	ld	a4,-24(s0)
 b48:	fdc42783          	lw	a5,-36(s0)
 b4c:	863a                	mv	a2,a4
 b4e:	fd043583          	ld	a1,-48(s0)
 b52:	853e                	mv	a0,a5
 b54:	00000097          	auipc	ra,0x0
 b58:	d54080e7          	jalr	-684(ra) # 8a8 <vprintf>
}
 b5c:	0001                	nop
 b5e:	70e2                	ld	ra,56(sp)
 b60:	7442                	ld	s0,48(sp)
 b62:	6165                	addi	sp,sp,112
 b64:	8082                	ret

0000000000000b66 <printf>:

void
printf(const char *fmt, ...)
{
 b66:	7159                	addi	sp,sp,-112
 b68:	f406                	sd	ra,40(sp)
 b6a:	f022                	sd	s0,32(sp)
 b6c:	1800                	addi	s0,sp,48
 b6e:	fca43c23          	sd	a0,-40(s0)
 b72:	e40c                	sd	a1,8(s0)
 b74:	e810                	sd	a2,16(s0)
 b76:	ec14                	sd	a3,24(s0)
 b78:	f018                	sd	a4,32(s0)
 b7a:	f41c                	sd	a5,40(s0)
 b7c:	03043823          	sd	a6,48(s0)
 b80:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b84:	04040793          	addi	a5,s0,64
 b88:	fcf43823          	sd	a5,-48(s0)
 b8c:	fd043783          	ld	a5,-48(s0)
 b90:	fc878793          	addi	a5,a5,-56
 b94:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 b98:	fe843783          	ld	a5,-24(s0)
 b9c:	863e                	mv	a2,a5
 b9e:	fd843583          	ld	a1,-40(s0)
 ba2:	4505                	li	a0,1
 ba4:	00000097          	auipc	ra,0x0
 ba8:	d04080e7          	jalr	-764(ra) # 8a8 <vprintf>
}
 bac:	0001                	nop
 bae:	70a2                	ld	ra,40(sp)
 bb0:	7402                	ld	s0,32(sp)
 bb2:	6165                	addi	sp,sp,112
 bb4:	8082                	ret

0000000000000bb6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bb6:	7179                	addi	sp,sp,-48
 bb8:	f422                	sd	s0,40(sp)
 bba:	1800                	addi	s0,sp,48
 bbc:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bc0:	fd843783          	ld	a5,-40(s0)
 bc4:	17c1                	addi	a5,a5,-16
 bc6:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bca:	00000797          	auipc	a5,0x0
 bce:	7d678793          	addi	a5,a5,2006 # 13a0 <freep>
 bd2:	639c                	ld	a5,0(a5)
 bd4:	fef43423          	sd	a5,-24(s0)
 bd8:	a815                	j	c0c <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bda:	fe843783          	ld	a5,-24(s0)
 bde:	639c                	ld	a5,0(a5)
 be0:	fe843703          	ld	a4,-24(s0)
 be4:	00f76f63          	bltu	a4,a5,c02 <free+0x4c>
 be8:	fe043703          	ld	a4,-32(s0)
 bec:	fe843783          	ld	a5,-24(s0)
 bf0:	02e7eb63          	bltu	a5,a4,c26 <free+0x70>
 bf4:	fe843783          	ld	a5,-24(s0)
 bf8:	639c                	ld	a5,0(a5)
 bfa:	fe043703          	ld	a4,-32(s0)
 bfe:	02f76463          	bltu	a4,a5,c26 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c02:	fe843783          	ld	a5,-24(s0)
 c06:	639c                	ld	a5,0(a5)
 c08:	fef43423          	sd	a5,-24(s0)
 c0c:	fe043703          	ld	a4,-32(s0)
 c10:	fe843783          	ld	a5,-24(s0)
 c14:	fce7f3e3          	bgeu	a5,a4,bda <free+0x24>
 c18:	fe843783          	ld	a5,-24(s0)
 c1c:	639c                	ld	a5,0(a5)
 c1e:	fe043703          	ld	a4,-32(s0)
 c22:	faf77ce3          	bgeu	a4,a5,bda <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c26:	fe043783          	ld	a5,-32(s0)
 c2a:	479c                	lw	a5,8(a5)
 c2c:	1782                	slli	a5,a5,0x20
 c2e:	9381                	srli	a5,a5,0x20
 c30:	0792                	slli	a5,a5,0x4
 c32:	fe043703          	ld	a4,-32(s0)
 c36:	973e                	add	a4,a4,a5
 c38:	fe843783          	ld	a5,-24(s0)
 c3c:	639c                	ld	a5,0(a5)
 c3e:	02f71763          	bne	a4,a5,c6c <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 c42:	fe043783          	ld	a5,-32(s0)
 c46:	4798                	lw	a4,8(a5)
 c48:	fe843783          	ld	a5,-24(s0)
 c4c:	639c                	ld	a5,0(a5)
 c4e:	479c                	lw	a5,8(a5)
 c50:	9fb9                	addw	a5,a5,a4
 c52:	0007871b          	sext.w	a4,a5
 c56:	fe043783          	ld	a5,-32(s0)
 c5a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c5c:	fe843783          	ld	a5,-24(s0)
 c60:	639c                	ld	a5,0(a5)
 c62:	6398                	ld	a4,0(a5)
 c64:	fe043783          	ld	a5,-32(s0)
 c68:	e398                	sd	a4,0(a5)
 c6a:	a039                	j	c78 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 c6c:	fe843783          	ld	a5,-24(s0)
 c70:	6398                	ld	a4,0(a5)
 c72:	fe043783          	ld	a5,-32(s0)
 c76:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c78:	fe843783          	ld	a5,-24(s0)
 c7c:	479c                	lw	a5,8(a5)
 c7e:	1782                	slli	a5,a5,0x20
 c80:	9381                	srli	a5,a5,0x20
 c82:	0792                	slli	a5,a5,0x4
 c84:	fe843703          	ld	a4,-24(s0)
 c88:	97ba                	add	a5,a5,a4
 c8a:	fe043703          	ld	a4,-32(s0)
 c8e:	02f71563          	bne	a4,a5,cb8 <free+0x102>
    p->s.size += bp->s.size;
 c92:	fe843783          	ld	a5,-24(s0)
 c96:	4798                	lw	a4,8(a5)
 c98:	fe043783          	ld	a5,-32(s0)
 c9c:	479c                	lw	a5,8(a5)
 c9e:	9fb9                	addw	a5,a5,a4
 ca0:	0007871b          	sext.w	a4,a5
 ca4:	fe843783          	ld	a5,-24(s0)
 ca8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 caa:	fe043783          	ld	a5,-32(s0)
 cae:	6398                	ld	a4,0(a5)
 cb0:	fe843783          	ld	a5,-24(s0)
 cb4:	e398                	sd	a4,0(a5)
 cb6:	a031                	j	cc2 <free+0x10c>
  } else
    p->s.ptr = bp;
 cb8:	fe843783          	ld	a5,-24(s0)
 cbc:	fe043703          	ld	a4,-32(s0)
 cc0:	e398                	sd	a4,0(a5)
  freep = p;
 cc2:	00000797          	auipc	a5,0x0
 cc6:	6de78793          	addi	a5,a5,1758 # 13a0 <freep>
 cca:	fe843703          	ld	a4,-24(s0)
 cce:	e398                	sd	a4,0(a5)
}
 cd0:	0001                	nop
 cd2:	7422                	ld	s0,40(sp)
 cd4:	6145                	addi	sp,sp,48
 cd6:	8082                	ret

0000000000000cd8 <morecore>:

static Header*
morecore(uint nu)
{
 cd8:	7179                	addi	sp,sp,-48
 cda:	f406                	sd	ra,40(sp)
 cdc:	f022                	sd	s0,32(sp)
 cde:	1800                	addi	s0,sp,48
 ce0:	87aa                	mv	a5,a0
 ce2:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 ce6:	fdc42783          	lw	a5,-36(s0)
 cea:	0007871b          	sext.w	a4,a5
 cee:	6785                	lui	a5,0x1
 cf0:	00f77563          	bgeu	a4,a5,cfa <morecore+0x22>
    nu = 4096;
 cf4:	6785                	lui	a5,0x1
 cf6:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 cfa:	fdc42783          	lw	a5,-36(s0)
 cfe:	0047979b          	slliw	a5,a5,0x4
 d02:	2781                	sext.w	a5,a5
 d04:	2781                	sext.w	a5,a5
 d06:	853e                	mv	a0,a5
 d08:	00000097          	auipc	ra,0x0
 d0c:	9b6080e7          	jalr	-1610(ra) # 6be <sbrk>
 d10:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 d14:	fe843703          	ld	a4,-24(s0)
 d18:	57fd                	li	a5,-1
 d1a:	00f71463          	bne	a4,a5,d22 <morecore+0x4a>
    return 0;
 d1e:	4781                	li	a5,0
 d20:	a03d                	j	d4e <morecore+0x76>
  hp = (Header*)p;
 d22:	fe843783          	ld	a5,-24(s0)
 d26:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 d2a:	fe043783          	ld	a5,-32(s0)
 d2e:	fdc42703          	lw	a4,-36(s0)
 d32:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 d34:	fe043783          	ld	a5,-32(s0)
 d38:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x2b8>
 d3a:	853e                	mv	a0,a5
 d3c:	00000097          	auipc	ra,0x0
 d40:	e7a080e7          	jalr	-390(ra) # bb6 <free>
  return freep;
 d44:	00000797          	auipc	a5,0x0
 d48:	65c78793          	addi	a5,a5,1628 # 13a0 <freep>
 d4c:	639c                	ld	a5,0(a5)
}
 d4e:	853e                	mv	a0,a5
 d50:	70a2                	ld	ra,40(sp)
 d52:	7402                	ld	s0,32(sp)
 d54:	6145                	addi	sp,sp,48
 d56:	8082                	ret

0000000000000d58 <malloc>:

void*
malloc(uint nbytes)
{
 d58:	7139                	addi	sp,sp,-64
 d5a:	fc06                	sd	ra,56(sp)
 d5c:	f822                	sd	s0,48(sp)
 d5e:	0080                	addi	s0,sp,64
 d60:	87aa                	mv	a5,a0
 d62:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d66:	fcc46783          	lwu	a5,-52(s0)
 d6a:	07bd                	addi	a5,a5,15
 d6c:	8391                	srli	a5,a5,0x4
 d6e:	2781                	sext.w	a5,a5
 d70:	2785                	addiw	a5,a5,1
 d72:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d76:	00000797          	auipc	a5,0x0
 d7a:	62a78793          	addi	a5,a5,1578 # 13a0 <freep>
 d7e:	639c                	ld	a5,0(a5)
 d80:	fef43023          	sd	a5,-32(s0)
 d84:	fe043783          	ld	a5,-32(s0)
 d88:	ef95                	bnez	a5,dc4 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d8a:	00000797          	auipc	a5,0x0
 d8e:	60678793          	addi	a5,a5,1542 # 1390 <base>
 d92:	fef43023          	sd	a5,-32(s0)
 d96:	00000797          	auipc	a5,0x0
 d9a:	60a78793          	addi	a5,a5,1546 # 13a0 <freep>
 d9e:	fe043703          	ld	a4,-32(s0)
 da2:	e398                	sd	a4,0(a5)
 da4:	00000797          	auipc	a5,0x0
 da8:	5fc78793          	addi	a5,a5,1532 # 13a0 <freep>
 dac:	6398                	ld	a4,0(a5)
 dae:	00000797          	auipc	a5,0x0
 db2:	5e278793          	addi	a5,a5,1506 # 1390 <base>
 db6:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 db8:	00000797          	auipc	a5,0x0
 dbc:	5d878793          	addi	a5,a5,1496 # 1390 <base>
 dc0:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dc4:	fe043783          	ld	a5,-32(s0)
 dc8:	639c                	ld	a5,0(a5)
 dca:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dce:	fe843783          	ld	a5,-24(s0)
 dd2:	4798                	lw	a4,8(a5)
 dd4:	fdc42783          	lw	a5,-36(s0)
 dd8:	2781                	sext.w	a5,a5
 dda:	06f76763          	bltu	a4,a5,e48 <malloc+0xf0>
      if(p->s.size == nunits)
 dde:	fe843783          	ld	a5,-24(s0)
 de2:	4798                	lw	a4,8(a5)
 de4:	fdc42783          	lw	a5,-36(s0)
 de8:	2781                	sext.w	a5,a5
 dea:	00e79963          	bne	a5,a4,dfc <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 dee:	fe843783          	ld	a5,-24(s0)
 df2:	6398                	ld	a4,0(a5)
 df4:	fe043783          	ld	a5,-32(s0)
 df8:	e398                	sd	a4,0(a5)
 dfa:	a825                	j	e32 <malloc+0xda>
      else {
        p->s.size -= nunits;
 dfc:	fe843783          	ld	a5,-24(s0)
 e00:	479c                	lw	a5,8(a5)
 e02:	fdc42703          	lw	a4,-36(s0)
 e06:	9f99                	subw	a5,a5,a4
 e08:	0007871b          	sext.w	a4,a5
 e0c:	fe843783          	ld	a5,-24(s0)
 e10:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e12:	fe843783          	ld	a5,-24(s0)
 e16:	479c                	lw	a5,8(a5)
 e18:	1782                	slli	a5,a5,0x20
 e1a:	9381                	srli	a5,a5,0x20
 e1c:	0792                	slli	a5,a5,0x4
 e1e:	fe843703          	ld	a4,-24(s0)
 e22:	97ba                	add	a5,a5,a4
 e24:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 e28:	fe843783          	ld	a5,-24(s0)
 e2c:	fdc42703          	lw	a4,-36(s0)
 e30:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 e32:	00000797          	auipc	a5,0x0
 e36:	56e78793          	addi	a5,a5,1390 # 13a0 <freep>
 e3a:	fe043703          	ld	a4,-32(s0)
 e3e:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 e40:	fe843783          	ld	a5,-24(s0)
 e44:	07c1                	addi	a5,a5,16
 e46:	a091                	j	e8a <malloc+0x132>
    }
    if(p == freep)
 e48:	00000797          	auipc	a5,0x0
 e4c:	55878793          	addi	a5,a5,1368 # 13a0 <freep>
 e50:	639c                	ld	a5,0(a5)
 e52:	fe843703          	ld	a4,-24(s0)
 e56:	02f71063          	bne	a4,a5,e76 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e5a:	fdc42783          	lw	a5,-36(s0)
 e5e:	853e                	mv	a0,a5
 e60:	00000097          	auipc	ra,0x0
 e64:	e78080e7          	jalr	-392(ra) # cd8 <morecore>
 e68:	fea43423          	sd	a0,-24(s0)
 e6c:	fe843783          	ld	a5,-24(s0)
 e70:	e399                	bnez	a5,e76 <malloc+0x11e>
        return 0;
 e72:	4781                	li	a5,0
 e74:	a819                	j	e8a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e76:	fe843783          	ld	a5,-24(s0)
 e7a:	fef43023          	sd	a5,-32(s0)
 e7e:	fe843783          	ld	a5,-24(s0)
 e82:	639c                	ld	a5,0(a5)
 e84:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e88:	b799                	j	dce <malloc+0x76>
  }
}
 e8a:	853e                	mv	a0,a5
 e8c:	70e2                	ld	ra,56(sp)
 e8e:	7442                	ld	s0,48(sp)
 e90:	6121                	addi	sp,sp,64
 e92:	8082                	ret
