
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
   8:	87aa                	mv	a5,a0
   a:	fcb43823          	sd	a1,-48(s0)
   e:	fcf42e23          	sw	a5,-36(s0)
  int i;

  if(argc < 2){
  12:	fdc42783          	lw	a5,-36(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	4785                	li	a5,1
  1c:	02e7c063          	blt	a5,a4,3c <main+0x3c>
    fprintf(2, "usage: kill pid...\n");
  20:	00001597          	auipc	a1,0x1
  24:	d7058593          	addi	a1,a1,-656 # d90 <malloc+0x13c>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	9e0080e7          	jalr	-1568(ra) # a0a <fprintf>
    exit(1);
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	506080e7          	jalr	1286(ra) # 53a <exit>
  }
  for(i=1; i<argc; i++)
  3c:	4785                	li	a5,1
  3e:	fef42623          	sw	a5,-20(s0)
  42:	a805                	j	72 <main+0x72>
    kill(atoi(argv[i]));
  44:	fec42783          	lw	a5,-20(s0)
  48:	078e                	slli	a5,a5,0x3
  4a:	fd043703          	ld	a4,-48(s0)
  4e:	97ba                	add	a5,a5,a4
  50:	639c                	ld	a5,0(a5)
  52:	853e                	mv	a0,a5
  54:	00000097          	auipc	ra,0x0
  58:	2ec080e7          	jalr	748(ra) # 340 <atoi>
  5c:	87aa                	mv	a5,a0
  5e:	853e                	mv	a0,a5
  60:	00000097          	auipc	ra,0x0
  64:	50a080e7          	jalr	1290(ra) # 56a <kill>
  for(i=1; i<argc; i++)
  68:	fec42783          	lw	a5,-20(s0)
  6c:	2785                	addiw	a5,a5,1
  6e:	fef42623          	sw	a5,-20(s0)
  72:	fec42783          	lw	a5,-20(s0)
  76:	873e                	mv	a4,a5
  78:	fdc42783          	lw	a5,-36(s0)
  7c:	2701                	sext.w	a4,a4
  7e:	2781                	sext.w	a5,a5
  80:	fcf742e3          	blt	a4,a5,44 <main+0x44>
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	4b4080e7          	jalr	1204(ra) # 53a <exit>

000000000000008e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  extern int main();
  main();
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <main>
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	49a080e7          	jalr	1178(ra) # 53a <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	7179                	addi	sp,sp,-48
  aa:	f422                	sd	s0,40(sp)
  ac:	1800                	addi	s0,sp,48
  ae:	fca43c23          	sd	a0,-40(s0)
  b2:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  b6:	fd843783          	ld	a5,-40(s0)
  ba:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  be:	0001                	nop
  c0:	fd043703          	ld	a4,-48(s0)
  c4:	00170793          	addi	a5,a4,1
  c8:	fcf43823          	sd	a5,-48(s0)
  cc:	fd843783          	ld	a5,-40(s0)
  d0:	00178693          	addi	a3,a5,1
  d4:	fcd43c23          	sd	a3,-40(s0)
  d8:	00074703          	lbu	a4,0(a4)
  dc:	00e78023          	sb	a4,0(a5)
  e0:	0007c783          	lbu	a5,0(a5)
  e4:	fff1                	bnez	a5,c0 <strcpy+0x18>
    ;
  return os;
  e6:	fe843783          	ld	a5,-24(s0)
}
  ea:	853e                	mv	a0,a5
  ec:	7422                	ld	s0,40(sp)
  ee:	6145                	addi	sp,sp,48
  f0:	8082                	ret

00000000000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	1101                	addi	sp,sp,-32
  f4:	ec22                	sd	s0,24(sp)
  f6:	1000                	addi	s0,sp,32
  f8:	fea43423          	sd	a0,-24(s0)
  fc:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 100:	a819                	j	116 <strcmp+0x24>
    p++, q++;
 102:	fe843783          	ld	a5,-24(s0)
 106:	0785                	addi	a5,a5,1
 108:	fef43423          	sd	a5,-24(s0)
 10c:	fe043783          	ld	a5,-32(s0)
 110:	0785                	addi	a5,a5,1
 112:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 116:	fe843783          	ld	a5,-24(s0)
 11a:	0007c783          	lbu	a5,0(a5)
 11e:	cb99                	beqz	a5,134 <strcmp+0x42>
 120:	fe843783          	ld	a5,-24(s0)
 124:	0007c703          	lbu	a4,0(a5)
 128:	fe043783          	ld	a5,-32(s0)
 12c:	0007c783          	lbu	a5,0(a5)
 130:	fcf709e3          	beq	a4,a5,102 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 134:	fe843783          	ld	a5,-24(s0)
 138:	0007c783          	lbu	a5,0(a5)
 13c:	0007871b          	sext.w	a4,a5
 140:	fe043783          	ld	a5,-32(s0)
 144:	0007c783          	lbu	a5,0(a5)
 148:	2781                	sext.w	a5,a5
 14a:	40f707bb          	subw	a5,a4,a5
 14e:	2781                	sext.w	a5,a5
}
 150:	853e                	mv	a0,a5
 152:	6462                	ld	s0,24(sp)
 154:	6105                	addi	sp,sp,32
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	7179                	addi	sp,sp,-48
 15a:	f422                	sd	s0,40(sp)
 15c:	1800                	addi	s0,sp,48
 15e:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 162:	fe042623          	sw	zero,-20(s0)
 166:	a031                	j	172 <strlen+0x1a>
 168:	fec42783          	lw	a5,-20(s0)
 16c:	2785                	addiw	a5,a5,1
 16e:	fef42623          	sw	a5,-20(s0)
 172:	fec42783          	lw	a5,-20(s0)
 176:	fd843703          	ld	a4,-40(s0)
 17a:	97ba                	add	a5,a5,a4
 17c:	0007c783          	lbu	a5,0(a5)
 180:	f7e5                	bnez	a5,168 <strlen+0x10>
    ;
  return n;
 182:	fec42783          	lw	a5,-20(s0)
}
 186:	853e                	mv	a0,a5
 188:	7422                	ld	s0,40(sp)
 18a:	6145                	addi	sp,sp,48
 18c:	8082                	ret

000000000000018e <memset>:

void*
memset(void *dst, int c, uint n)
{
 18e:	7179                	addi	sp,sp,-48
 190:	f422                	sd	s0,40(sp)
 192:	1800                	addi	s0,sp,48
 194:	fca43c23          	sd	a0,-40(s0)
 198:	87ae                	mv	a5,a1
 19a:	8732                	mv	a4,a2
 19c:	fcf42a23          	sw	a5,-44(s0)
 1a0:	87ba                	mv	a5,a4
 1a2:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1a6:	fd843783          	ld	a5,-40(s0)
 1aa:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1ae:	fe042623          	sw	zero,-20(s0)
 1b2:	a00d                	j	1d4 <memset+0x46>
    cdst[i] = c;
 1b4:	fec42783          	lw	a5,-20(s0)
 1b8:	fe043703          	ld	a4,-32(s0)
 1bc:	97ba                	add	a5,a5,a4
 1be:	fd442703          	lw	a4,-44(s0)
 1c2:	0ff77713          	zext.b	a4,a4
 1c6:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1ca:	fec42783          	lw	a5,-20(s0)
 1ce:	2785                	addiw	a5,a5,1
 1d0:	fef42623          	sw	a5,-20(s0)
 1d4:	fec42703          	lw	a4,-20(s0)
 1d8:	fd042783          	lw	a5,-48(s0)
 1dc:	2781                	sext.w	a5,a5
 1de:	fcf76be3          	bltu	a4,a5,1b4 <memset+0x26>
  }
  return dst;
 1e2:	fd843783          	ld	a5,-40(s0)
}
 1e6:	853e                	mv	a0,a5
 1e8:	7422                	ld	s0,40(sp)
 1ea:	6145                	addi	sp,sp,48
 1ec:	8082                	ret

00000000000001ee <strchr>:

char*
strchr(const char *s, char c)
{
 1ee:	1101                	addi	sp,sp,-32
 1f0:	ec22                	sd	s0,24(sp)
 1f2:	1000                	addi	s0,sp,32
 1f4:	fea43423          	sd	a0,-24(s0)
 1f8:	87ae                	mv	a5,a1
 1fa:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 1fe:	a01d                	j	224 <strchr+0x36>
    if(*s == c)
 200:	fe843783          	ld	a5,-24(s0)
 204:	0007c703          	lbu	a4,0(a5)
 208:	fe744783          	lbu	a5,-25(s0)
 20c:	0ff7f793          	zext.b	a5,a5
 210:	00e79563          	bne	a5,a4,21a <strchr+0x2c>
      return (char*)s;
 214:	fe843783          	ld	a5,-24(s0)
 218:	a821                	j	230 <strchr+0x42>
  for(; *s; s++)
 21a:	fe843783          	ld	a5,-24(s0)
 21e:	0785                	addi	a5,a5,1
 220:	fef43423          	sd	a5,-24(s0)
 224:	fe843783          	ld	a5,-24(s0)
 228:	0007c783          	lbu	a5,0(a5)
 22c:	fbf1                	bnez	a5,200 <strchr+0x12>
  return 0;
 22e:	4781                	li	a5,0
}
 230:	853e                	mv	a0,a5
 232:	6462                	ld	s0,24(sp)
 234:	6105                	addi	sp,sp,32
 236:	8082                	ret

0000000000000238 <gets>:

char*
gets(char *buf, int max)
{
 238:	7179                	addi	sp,sp,-48
 23a:	f406                	sd	ra,40(sp)
 23c:	f022                	sd	s0,32(sp)
 23e:	1800                	addi	s0,sp,48
 240:	fca43c23          	sd	a0,-40(s0)
 244:	87ae                	mv	a5,a1
 246:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24a:	fe042623          	sw	zero,-20(s0)
 24e:	a8a1                	j	2a6 <gets+0x6e>
    cc = read(0, &c, 1);
 250:	fe740793          	addi	a5,s0,-25
 254:	4605                	li	a2,1
 256:	85be                	mv	a1,a5
 258:	4501                	li	a0,0
 25a:	00000097          	auipc	ra,0x0
 25e:	2f8080e7          	jalr	760(ra) # 552 <read>
 262:	87aa                	mv	a5,a0
 264:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 268:	fe842783          	lw	a5,-24(s0)
 26c:	2781                	sext.w	a5,a5
 26e:	04f05763          	blez	a5,2bc <gets+0x84>
      break;
    buf[i++] = c;
 272:	fec42783          	lw	a5,-20(s0)
 276:	0017871b          	addiw	a4,a5,1
 27a:	fee42623          	sw	a4,-20(s0)
 27e:	873e                	mv	a4,a5
 280:	fd843783          	ld	a5,-40(s0)
 284:	97ba                	add	a5,a5,a4
 286:	fe744703          	lbu	a4,-25(s0)
 28a:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 28e:	fe744783          	lbu	a5,-25(s0)
 292:	873e                	mv	a4,a5
 294:	47a9                	li	a5,10
 296:	02f70463          	beq	a4,a5,2be <gets+0x86>
 29a:	fe744783          	lbu	a5,-25(s0)
 29e:	873e                	mv	a4,a5
 2a0:	47b5                	li	a5,13
 2a2:	00f70e63          	beq	a4,a5,2be <gets+0x86>
  for(i=0; i+1 < max; ){
 2a6:	fec42783          	lw	a5,-20(s0)
 2aa:	2785                	addiw	a5,a5,1
 2ac:	0007871b          	sext.w	a4,a5
 2b0:	fd442783          	lw	a5,-44(s0)
 2b4:	2781                	sext.w	a5,a5
 2b6:	f8f74de3          	blt	a4,a5,250 <gets+0x18>
 2ba:	a011                	j	2be <gets+0x86>
      break;
 2bc:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2be:	fec42783          	lw	a5,-20(s0)
 2c2:	fd843703          	ld	a4,-40(s0)
 2c6:	97ba                	add	a5,a5,a4
 2c8:	00078023          	sb	zero,0(a5)
  return buf;
 2cc:	fd843783          	ld	a5,-40(s0)
}
 2d0:	853e                	mv	a0,a5
 2d2:	70a2                	ld	ra,40(sp)
 2d4:	7402                	ld	s0,32(sp)
 2d6:	6145                	addi	sp,sp,48
 2d8:	8082                	ret

00000000000002da <stat>:

int
stat(const char *n, struct stat *st)
{
 2da:	7179                	addi	sp,sp,-48
 2dc:	f406                	sd	ra,40(sp)
 2de:	f022                	sd	s0,32(sp)
 2e0:	1800                	addi	s0,sp,48
 2e2:	fca43c23          	sd	a0,-40(s0)
 2e6:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ea:	4581                	li	a1,0
 2ec:	fd843503          	ld	a0,-40(s0)
 2f0:	00000097          	auipc	ra,0x0
 2f4:	28a080e7          	jalr	650(ra) # 57a <open>
 2f8:	87aa                	mv	a5,a0
 2fa:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 2fe:	fec42783          	lw	a5,-20(s0)
 302:	2781                	sext.w	a5,a5
 304:	0007d463          	bgez	a5,30c <stat+0x32>
    return -1;
 308:	57fd                	li	a5,-1
 30a:	a035                	j	336 <stat+0x5c>
  r = fstat(fd, st);
 30c:	fec42783          	lw	a5,-20(s0)
 310:	fd043583          	ld	a1,-48(s0)
 314:	853e                	mv	a0,a5
 316:	00000097          	auipc	ra,0x0
 31a:	27c080e7          	jalr	636(ra) # 592 <fstat>
 31e:	87aa                	mv	a5,a0
 320:	fef42423          	sw	a5,-24(s0)
  close(fd);
 324:	fec42783          	lw	a5,-20(s0)
 328:	853e                	mv	a0,a5
 32a:	00000097          	auipc	ra,0x0
 32e:	238080e7          	jalr	568(ra) # 562 <close>
  return r;
 332:	fe842783          	lw	a5,-24(s0)
}
 336:	853e                	mv	a0,a5
 338:	70a2                	ld	ra,40(sp)
 33a:	7402                	ld	s0,32(sp)
 33c:	6145                	addi	sp,sp,48
 33e:	8082                	ret

0000000000000340 <atoi>:

int
atoi(const char *s)
{
 340:	7179                	addi	sp,sp,-48
 342:	f422                	sd	s0,40(sp)
 344:	1800                	addi	s0,sp,48
 346:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 34a:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 34e:	a81d                	j	384 <atoi+0x44>
    n = n*10 + *s++ - '0';
 350:	fec42783          	lw	a5,-20(s0)
 354:	873e                	mv	a4,a5
 356:	87ba                	mv	a5,a4
 358:	0027979b          	slliw	a5,a5,0x2
 35c:	9fb9                	addw	a5,a5,a4
 35e:	0017979b          	slliw	a5,a5,0x1
 362:	0007871b          	sext.w	a4,a5
 366:	fd843783          	ld	a5,-40(s0)
 36a:	00178693          	addi	a3,a5,1
 36e:	fcd43c23          	sd	a3,-40(s0)
 372:	0007c783          	lbu	a5,0(a5)
 376:	2781                	sext.w	a5,a5
 378:	9fb9                	addw	a5,a5,a4
 37a:	2781                	sext.w	a5,a5
 37c:	fd07879b          	addiw	a5,a5,-48
 380:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 384:	fd843783          	ld	a5,-40(s0)
 388:	0007c783          	lbu	a5,0(a5)
 38c:	873e                	mv	a4,a5
 38e:	02f00793          	li	a5,47
 392:	00e7fb63          	bgeu	a5,a4,3a8 <atoi+0x68>
 396:	fd843783          	ld	a5,-40(s0)
 39a:	0007c783          	lbu	a5,0(a5)
 39e:	873e                	mv	a4,a5
 3a0:	03900793          	li	a5,57
 3a4:	fae7f6e3          	bgeu	a5,a4,350 <atoi+0x10>
  return n;
 3a8:	fec42783          	lw	a5,-20(s0)
}
 3ac:	853e                	mv	a0,a5
 3ae:	7422                	ld	s0,40(sp)
 3b0:	6145                	addi	sp,sp,48
 3b2:	8082                	ret

00000000000003b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b4:	7139                	addi	sp,sp,-64
 3b6:	fc22                	sd	s0,56(sp)
 3b8:	0080                	addi	s0,sp,64
 3ba:	fca43c23          	sd	a0,-40(s0)
 3be:	fcb43823          	sd	a1,-48(s0)
 3c2:	87b2                	mv	a5,a2
 3c4:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3c8:	fd843783          	ld	a5,-40(s0)
 3cc:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3d0:	fd043783          	ld	a5,-48(s0)
 3d4:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3d8:	fe043703          	ld	a4,-32(s0)
 3dc:	fe843783          	ld	a5,-24(s0)
 3e0:	02e7fc63          	bgeu	a5,a4,418 <memmove+0x64>
    while(n-- > 0)
 3e4:	a00d                	j	406 <memmove+0x52>
      *dst++ = *src++;
 3e6:	fe043703          	ld	a4,-32(s0)
 3ea:	00170793          	addi	a5,a4,1
 3ee:	fef43023          	sd	a5,-32(s0)
 3f2:	fe843783          	ld	a5,-24(s0)
 3f6:	00178693          	addi	a3,a5,1
 3fa:	fed43423          	sd	a3,-24(s0)
 3fe:	00074703          	lbu	a4,0(a4)
 402:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 406:	fcc42783          	lw	a5,-52(s0)
 40a:	fff7871b          	addiw	a4,a5,-1
 40e:	fce42623          	sw	a4,-52(s0)
 412:	fcf04ae3          	bgtz	a5,3e6 <memmove+0x32>
 416:	a891                	j	46a <memmove+0xb6>
  } else {
    dst += n;
 418:	fcc42783          	lw	a5,-52(s0)
 41c:	fe843703          	ld	a4,-24(s0)
 420:	97ba                	add	a5,a5,a4
 422:	fef43423          	sd	a5,-24(s0)
    src += n;
 426:	fcc42783          	lw	a5,-52(s0)
 42a:	fe043703          	ld	a4,-32(s0)
 42e:	97ba                	add	a5,a5,a4
 430:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 434:	a01d                	j	45a <memmove+0xa6>
      *--dst = *--src;
 436:	fe043783          	ld	a5,-32(s0)
 43a:	17fd                	addi	a5,a5,-1
 43c:	fef43023          	sd	a5,-32(s0)
 440:	fe843783          	ld	a5,-24(s0)
 444:	17fd                	addi	a5,a5,-1
 446:	fef43423          	sd	a5,-24(s0)
 44a:	fe043783          	ld	a5,-32(s0)
 44e:	0007c703          	lbu	a4,0(a5)
 452:	fe843783          	ld	a5,-24(s0)
 456:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 45a:	fcc42783          	lw	a5,-52(s0)
 45e:	fff7871b          	addiw	a4,a5,-1
 462:	fce42623          	sw	a4,-52(s0)
 466:	fcf048e3          	bgtz	a5,436 <memmove+0x82>
  }
  return vdst;
 46a:	fd843783          	ld	a5,-40(s0)
}
 46e:	853e                	mv	a0,a5
 470:	7462                	ld	s0,56(sp)
 472:	6121                	addi	sp,sp,64
 474:	8082                	ret

0000000000000476 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 476:	7139                	addi	sp,sp,-64
 478:	fc22                	sd	s0,56(sp)
 47a:	0080                	addi	s0,sp,64
 47c:	fca43c23          	sd	a0,-40(s0)
 480:	fcb43823          	sd	a1,-48(s0)
 484:	87b2                	mv	a5,a2
 486:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 48a:	fd843783          	ld	a5,-40(s0)
 48e:	fef43423          	sd	a5,-24(s0)
 492:	fd043783          	ld	a5,-48(s0)
 496:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 49a:	a0a1                	j	4e2 <memcmp+0x6c>
    if (*p1 != *p2) {
 49c:	fe843783          	ld	a5,-24(s0)
 4a0:	0007c703          	lbu	a4,0(a5)
 4a4:	fe043783          	ld	a5,-32(s0)
 4a8:	0007c783          	lbu	a5,0(a5)
 4ac:	02f70163          	beq	a4,a5,4ce <memcmp+0x58>
      return *p1 - *p2;
 4b0:	fe843783          	ld	a5,-24(s0)
 4b4:	0007c783          	lbu	a5,0(a5)
 4b8:	0007871b          	sext.w	a4,a5
 4bc:	fe043783          	ld	a5,-32(s0)
 4c0:	0007c783          	lbu	a5,0(a5)
 4c4:	2781                	sext.w	a5,a5
 4c6:	40f707bb          	subw	a5,a4,a5
 4ca:	2781                	sext.w	a5,a5
 4cc:	a01d                	j	4f2 <memcmp+0x7c>
    }
    p1++;
 4ce:	fe843783          	ld	a5,-24(s0)
 4d2:	0785                	addi	a5,a5,1
 4d4:	fef43423          	sd	a5,-24(s0)
    p2++;
 4d8:	fe043783          	ld	a5,-32(s0)
 4dc:	0785                	addi	a5,a5,1
 4de:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4e2:	fcc42783          	lw	a5,-52(s0)
 4e6:	fff7871b          	addiw	a4,a5,-1
 4ea:	fce42623          	sw	a4,-52(s0)
 4ee:	f7dd                	bnez	a5,49c <memcmp+0x26>
  }
  return 0;
 4f0:	4781                	li	a5,0
}
 4f2:	853e                	mv	a0,a5
 4f4:	7462                	ld	s0,56(sp)
 4f6:	6121                	addi	sp,sp,64
 4f8:	8082                	ret

00000000000004fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4fa:	7179                	addi	sp,sp,-48
 4fc:	f406                	sd	ra,40(sp)
 4fe:	f022                	sd	s0,32(sp)
 500:	1800                	addi	s0,sp,48
 502:	fea43423          	sd	a0,-24(s0)
 506:	feb43023          	sd	a1,-32(s0)
 50a:	87b2                	mv	a5,a2
 50c:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 510:	fdc42783          	lw	a5,-36(s0)
 514:	863e                	mv	a2,a5
 516:	fe043583          	ld	a1,-32(s0)
 51a:	fe843503          	ld	a0,-24(s0)
 51e:	00000097          	auipc	ra,0x0
 522:	e96080e7          	jalr	-362(ra) # 3b4 <memmove>
 526:	87aa                	mv	a5,a0
}
 528:	853e                	mv	a0,a5
 52a:	70a2                	ld	ra,40(sp)
 52c:	7402                	ld	s0,32(sp)
 52e:	6145                	addi	sp,sp,48
 530:	8082                	ret

0000000000000532 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 532:	4885                	li	a7,1
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <exit>:
.global exit
exit:
 li a7, SYS_exit
 53a:	4889                	li	a7,2
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <wait>:
.global wait
wait:
 li a7, SYS_wait
 542:	488d                	li	a7,3
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 54a:	4891                	li	a7,4
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <read>:
.global read
read:
 li a7, SYS_read
 552:	4895                	li	a7,5
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <write>:
.global write
write:
 li a7, SYS_write
 55a:	48c1                	li	a7,16
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <close>:
.global close
close:
 li a7, SYS_close
 562:	48d5                	li	a7,21
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <kill>:
.global kill
kill:
 li a7, SYS_kill
 56a:	4899                	li	a7,6
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <exec>:
.global exec
exec:
 li a7, SYS_exec
 572:	489d                	li	a7,7
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <open>:
.global open
open:
 li a7, SYS_open
 57a:	48bd                	li	a7,15
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 582:	48c5                	li	a7,17
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 58a:	48c9                	li	a7,18
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 592:	48a1                	li	a7,8
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <link>:
.global link
link:
 li a7, SYS_link
 59a:	48cd                	li	a7,19
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a2:	48d1                	li	a7,20
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5aa:	48a5                	li	a7,9
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b2:	48a9                	li	a7,10
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ba:	48ad                	li	a7,11
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c2:	48b1                	li	a7,12
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ca:	48b5                	li	a7,13
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d2:	48b9                	li	a7,14
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5da:	1101                	addi	sp,sp,-32
 5dc:	ec06                	sd	ra,24(sp)
 5de:	e822                	sd	s0,16(sp)
 5e0:	1000                	addi	s0,sp,32
 5e2:	87aa                	mv	a5,a0
 5e4:	872e                	mv	a4,a1
 5e6:	fef42623          	sw	a5,-20(s0)
 5ea:	87ba                	mv	a5,a4
 5ec:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5f0:	feb40713          	addi	a4,s0,-21
 5f4:	fec42783          	lw	a5,-20(s0)
 5f8:	4605                	li	a2,1
 5fa:	85ba                	mv	a1,a4
 5fc:	853e                	mv	a0,a5
 5fe:	00000097          	auipc	ra,0x0
 602:	f5c080e7          	jalr	-164(ra) # 55a <write>
}
 606:	0001                	nop
 608:	60e2                	ld	ra,24(sp)
 60a:	6442                	ld	s0,16(sp)
 60c:	6105                	addi	sp,sp,32
 60e:	8082                	ret

0000000000000610 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 610:	7139                	addi	sp,sp,-64
 612:	fc06                	sd	ra,56(sp)
 614:	f822                	sd	s0,48(sp)
 616:	0080                	addi	s0,sp,64
 618:	87aa                	mv	a5,a0
 61a:	8736                	mv	a4,a3
 61c:	fcf42623          	sw	a5,-52(s0)
 620:	87ae                	mv	a5,a1
 622:	fcf42423          	sw	a5,-56(s0)
 626:	87b2                	mv	a5,a2
 628:	fcf42223          	sw	a5,-60(s0)
 62c:	87ba                	mv	a5,a4
 62e:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 632:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 636:	fc042783          	lw	a5,-64(s0)
 63a:	2781                	sext.w	a5,a5
 63c:	c38d                	beqz	a5,65e <printint+0x4e>
 63e:	fc842783          	lw	a5,-56(s0)
 642:	2781                	sext.w	a5,a5
 644:	0007dd63          	bgez	a5,65e <printint+0x4e>
    neg = 1;
 648:	4785                	li	a5,1
 64a:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 64e:	fc842783          	lw	a5,-56(s0)
 652:	40f007bb          	negw	a5,a5
 656:	2781                	sext.w	a5,a5
 658:	fef42223          	sw	a5,-28(s0)
 65c:	a029                	j	666 <printint+0x56>
  } else {
    x = xx;
 65e:	fc842783          	lw	a5,-56(s0)
 662:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 666:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 66a:	fc442783          	lw	a5,-60(s0)
 66e:	fe442703          	lw	a4,-28(s0)
 672:	02f777bb          	remuw	a5,a4,a5
 676:	0007861b          	sext.w	a2,a5
 67a:	fec42783          	lw	a5,-20(s0)
 67e:	0017871b          	addiw	a4,a5,1
 682:	fee42623          	sw	a4,-20(s0)
 686:	00001697          	auipc	a3,0x1
 68a:	cea68693          	addi	a3,a3,-790 # 1370 <digits>
 68e:	02061713          	slli	a4,a2,0x20
 692:	9301                	srli	a4,a4,0x20
 694:	9736                	add	a4,a4,a3
 696:	00074703          	lbu	a4,0(a4)
 69a:	17c1                	addi	a5,a5,-16
 69c:	97a2                	add	a5,a5,s0
 69e:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6a2:	fc442783          	lw	a5,-60(s0)
 6a6:	fe442703          	lw	a4,-28(s0)
 6aa:	02f757bb          	divuw	a5,a4,a5
 6ae:	fef42223          	sw	a5,-28(s0)
 6b2:	fe442783          	lw	a5,-28(s0)
 6b6:	2781                	sext.w	a5,a5
 6b8:	fbcd                	bnez	a5,66a <printint+0x5a>
  if(neg)
 6ba:	fe842783          	lw	a5,-24(s0)
 6be:	2781                	sext.w	a5,a5
 6c0:	cf85                	beqz	a5,6f8 <printint+0xe8>
    buf[i++] = '-';
 6c2:	fec42783          	lw	a5,-20(s0)
 6c6:	0017871b          	addiw	a4,a5,1
 6ca:	fee42623          	sw	a4,-20(s0)
 6ce:	17c1                	addi	a5,a5,-16
 6d0:	97a2                	add	a5,a5,s0
 6d2:	02d00713          	li	a4,45
 6d6:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6da:	a839                	j	6f8 <printint+0xe8>
    putc(fd, buf[i]);
 6dc:	fec42783          	lw	a5,-20(s0)
 6e0:	17c1                	addi	a5,a5,-16
 6e2:	97a2                	add	a5,a5,s0
 6e4:	fe07c703          	lbu	a4,-32(a5)
 6e8:	fcc42783          	lw	a5,-52(s0)
 6ec:	85ba                	mv	a1,a4
 6ee:	853e                	mv	a0,a5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	eea080e7          	jalr	-278(ra) # 5da <putc>
  while(--i >= 0)
 6f8:	fec42783          	lw	a5,-20(s0)
 6fc:	37fd                	addiw	a5,a5,-1
 6fe:	fef42623          	sw	a5,-20(s0)
 702:	fec42783          	lw	a5,-20(s0)
 706:	2781                	sext.w	a5,a5
 708:	fc07dae3          	bgez	a5,6dc <printint+0xcc>
}
 70c:	0001                	nop
 70e:	0001                	nop
 710:	70e2                	ld	ra,56(sp)
 712:	7442                	ld	s0,48(sp)
 714:	6121                	addi	sp,sp,64
 716:	8082                	ret

0000000000000718 <printptr>:

static void
printptr(int fd, uint64 x) {
 718:	7179                	addi	sp,sp,-48
 71a:	f406                	sd	ra,40(sp)
 71c:	f022                	sd	s0,32(sp)
 71e:	1800                	addi	s0,sp,48
 720:	87aa                	mv	a5,a0
 722:	fcb43823          	sd	a1,-48(s0)
 726:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 72a:	fdc42783          	lw	a5,-36(s0)
 72e:	03000593          	li	a1,48
 732:	853e                	mv	a0,a5
 734:	00000097          	auipc	ra,0x0
 738:	ea6080e7          	jalr	-346(ra) # 5da <putc>
  putc(fd, 'x');
 73c:	fdc42783          	lw	a5,-36(s0)
 740:	07800593          	li	a1,120
 744:	853e                	mv	a0,a5
 746:	00000097          	auipc	ra,0x0
 74a:	e94080e7          	jalr	-364(ra) # 5da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74e:	fe042623          	sw	zero,-20(s0)
 752:	a82d                	j	78c <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 754:	fd043783          	ld	a5,-48(s0)
 758:	93f1                	srli	a5,a5,0x3c
 75a:	00001717          	auipc	a4,0x1
 75e:	c1670713          	addi	a4,a4,-1002 # 1370 <digits>
 762:	97ba                	add	a5,a5,a4
 764:	0007c703          	lbu	a4,0(a5)
 768:	fdc42783          	lw	a5,-36(s0)
 76c:	85ba                	mv	a1,a4
 76e:	853e                	mv	a0,a5
 770:	00000097          	auipc	ra,0x0
 774:	e6a080e7          	jalr	-406(ra) # 5da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 778:	fec42783          	lw	a5,-20(s0)
 77c:	2785                	addiw	a5,a5,1
 77e:	fef42623          	sw	a5,-20(s0)
 782:	fd043783          	ld	a5,-48(s0)
 786:	0792                	slli	a5,a5,0x4
 788:	fcf43823          	sd	a5,-48(s0)
 78c:	fec42783          	lw	a5,-20(s0)
 790:	873e                	mv	a4,a5
 792:	47bd                	li	a5,15
 794:	fce7f0e3          	bgeu	a5,a4,754 <printptr+0x3c>
}
 798:	0001                	nop
 79a:	0001                	nop
 79c:	70a2                	ld	ra,40(sp)
 79e:	7402                	ld	s0,32(sp)
 7a0:	6145                	addi	sp,sp,48
 7a2:	8082                	ret

00000000000007a4 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7a4:	715d                	addi	sp,sp,-80
 7a6:	e486                	sd	ra,72(sp)
 7a8:	e0a2                	sd	s0,64(sp)
 7aa:	0880                	addi	s0,sp,80
 7ac:	87aa                	mv	a5,a0
 7ae:	fcb43023          	sd	a1,-64(s0)
 7b2:	fac43c23          	sd	a2,-72(s0)
 7b6:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7ba:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7be:	fe042223          	sw	zero,-28(s0)
 7c2:	a42d                	j	9ec <vprintf+0x248>
    c = fmt[i] & 0xff;
 7c4:	fe442783          	lw	a5,-28(s0)
 7c8:	fc043703          	ld	a4,-64(s0)
 7cc:	97ba                	add	a5,a5,a4
 7ce:	0007c783          	lbu	a5,0(a5)
 7d2:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7d6:	fe042783          	lw	a5,-32(s0)
 7da:	2781                	sext.w	a5,a5
 7dc:	eb9d                	bnez	a5,812 <vprintf+0x6e>
      if(c == '%'){
 7de:	fdc42783          	lw	a5,-36(s0)
 7e2:	0007871b          	sext.w	a4,a5
 7e6:	02500793          	li	a5,37
 7ea:	00f71763          	bne	a4,a5,7f8 <vprintf+0x54>
        state = '%';
 7ee:	02500793          	li	a5,37
 7f2:	fef42023          	sw	a5,-32(s0)
 7f6:	a2f5                	j	9e2 <vprintf+0x23e>
      } else {
        putc(fd, c);
 7f8:	fdc42783          	lw	a5,-36(s0)
 7fc:	0ff7f713          	zext.b	a4,a5
 800:	fcc42783          	lw	a5,-52(s0)
 804:	85ba                	mv	a1,a4
 806:	853e                	mv	a0,a5
 808:	00000097          	auipc	ra,0x0
 80c:	dd2080e7          	jalr	-558(ra) # 5da <putc>
 810:	aac9                	j	9e2 <vprintf+0x23e>
      }
    } else if(state == '%'){
 812:	fe042783          	lw	a5,-32(s0)
 816:	0007871b          	sext.w	a4,a5
 81a:	02500793          	li	a5,37
 81e:	1cf71263          	bne	a4,a5,9e2 <vprintf+0x23e>
      if(c == 'd'){
 822:	fdc42783          	lw	a5,-36(s0)
 826:	0007871b          	sext.w	a4,a5
 82a:	06400793          	li	a5,100
 82e:	02f71463          	bne	a4,a5,856 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 832:	fb843783          	ld	a5,-72(s0)
 836:	00878713          	addi	a4,a5,8
 83a:	fae43c23          	sd	a4,-72(s0)
 83e:	4398                	lw	a4,0(a5)
 840:	fcc42783          	lw	a5,-52(s0)
 844:	4685                	li	a3,1
 846:	4629                	li	a2,10
 848:	85ba                	mv	a1,a4
 84a:	853e                	mv	a0,a5
 84c:	00000097          	auipc	ra,0x0
 850:	dc4080e7          	jalr	-572(ra) # 610 <printint>
 854:	a269                	j	9de <vprintf+0x23a>
      } else if(c == 'l') {
 856:	fdc42783          	lw	a5,-36(s0)
 85a:	0007871b          	sext.w	a4,a5
 85e:	06c00793          	li	a5,108
 862:	02f71663          	bne	a4,a5,88e <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 866:	fb843783          	ld	a5,-72(s0)
 86a:	00878713          	addi	a4,a5,8
 86e:	fae43c23          	sd	a4,-72(s0)
 872:	639c                	ld	a5,0(a5)
 874:	0007871b          	sext.w	a4,a5
 878:	fcc42783          	lw	a5,-52(s0)
 87c:	4681                	li	a3,0
 87e:	4629                	li	a2,10
 880:	85ba                	mv	a1,a4
 882:	853e                	mv	a0,a5
 884:	00000097          	auipc	ra,0x0
 888:	d8c080e7          	jalr	-628(ra) # 610 <printint>
 88c:	aa89                	j	9de <vprintf+0x23a>
      } else if(c == 'x') {
 88e:	fdc42783          	lw	a5,-36(s0)
 892:	0007871b          	sext.w	a4,a5
 896:	07800793          	li	a5,120
 89a:	02f71463          	bne	a4,a5,8c2 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 89e:	fb843783          	ld	a5,-72(s0)
 8a2:	00878713          	addi	a4,a5,8
 8a6:	fae43c23          	sd	a4,-72(s0)
 8aa:	4398                	lw	a4,0(a5)
 8ac:	fcc42783          	lw	a5,-52(s0)
 8b0:	4681                	li	a3,0
 8b2:	4641                	li	a2,16
 8b4:	85ba                	mv	a1,a4
 8b6:	853e                	mv	a0,a5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	d58080e7          	jalr	-680(ra) # 610 <printint>
 8c0:	aa39                	j	9de <vprintf+0x23a>
      } else if(c == 'p') {
 8c2:	fdc42783          	lw	a5,-36(s0)
 8c6:	0007871b          	sext.w	a4,a5
 8ca:	07000793          	li	a5,112
 8ce:	02f71263          	bne	a4,a5,8f2 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8d2:	fb843783          	ld	a5,-72(s0)
 8d6:	00878713          	addi	a4,a5,8
 8da:	fae43c23          	sd	a4,-72(s0)
 8de:	6398                	ld	a4,0(a5)
 8e0:	fcc42783          	lw	a5,-52(s0)
 8e4:	85ba                	mv	a1,a4
 8e6:	853e                	mv	a0,a5
 8e8:	00000097          	auipc	ra,0x0
 8ec:	e30080e7          	jalr	-464(ra) # 718 <printptr>
 8f0:	a0fd                	j	9de <vprintf+0x23a>
      } else if(c == 's'){
 8f2:	fdc42783          	lw	a5,-36(s0)
 8f6:	0007871b          	sext.w	a4,a5
 8fa:	07300793          	li	a5,115
 8fe:	04f71c63          	bne	a4,a5,956 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 902:	fb843783          	ld	a5,-72(s0)
 906:	00878713          	addi	a4,a5,8
 90a:	fae43c23          	sd	a4,-72(s0)
 90e:	639c                	ld	a5,0(a5)
 910:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 914:	fe843783          	ld	a5,-24(s0)
 918:	eb8d                	bnez	a5,94a <vprintf+0x1a6>
          s = "(null)";
 91a:	00000797          	auipc	a5,0x0
 91e:	48e78793          	addi	a5,a5,1166 # da8 <malloc+0x154>
 922:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 926:	a015                	j	94a <vprintf+0x1a6>
          putc(fd, *s);
 928:	fe843783          	ld	a5,-24(s0)
 92c:	0007c703          	lbu	a4,0(a5)
 930:	fcc42783          	lw	a5,-52(s0)
 934:	85ba                	mv	a1,a4
 936:	853e                	mv	a0,a5
 938:	00000097          	auipc	ra,0x0
 93c:	ca2080e7          	jalr	-862(ra) # 5da <putc>
          s++;
 940:	fe843783          	ld	a5,-24(s0)
 944:	0785                	addi	a5,a5,1
 946:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 94a:	fe843783          	ld	a5,-24(s0)
 94e:	0007c783          	lbu	a5,0(a5)
 952:	fbf9                	bnez	a5,928 <vprintf+0x184>
 954:	a069                	j	9de <vprintf+0x23a>
        }
      } else if(c == 'c'){
 956:	fdc42783          	lw	a5,-36(s0)
 95a:	0007871b          	sext.w	a4,a5
 95e:	06300793          	li	a5,99
 962:	02f71463          	bne	a4,a5,98a <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 966:	fb843783          	ld	a5,-72(s0)
 96a:	00878713          	addi	a4,a5,8
 96e:	fae43c23          	sd	a4,-72(s0)
 972:	439c                	lw	a5,0(a5)
 974:	0ff7f713          	zext.b	a4,a5
 978:	fcc42783          	lw	a5,-52(s0)
 97c:	85ba                	mv	a1,a4
 97e:	853e                	mv	a0,a5
 980:	00000097          	auipc	ra,0x0
 984:	c5a080e7          	jalr	-934(ra) # 5da <putc>
 988:	a899                	j	9de <vprintf+0x23a>
      } else if(c == '%'){
 98a:	fdc42783          	lw	a5,-36(s0)
 98e:	0007871b          	sext.w	a4,a5
 992:	02500793          	li	a5,37
 996:	00f71f63          	bne	a4,a5,9b4 <vprintf+0x210>
        putc(fd, c);
 99a:	fdc42783          	lw	a5,-36(s0)
 99e:	0ff7f713          	zext.b	a4,a5
 9a2:	fcc42783          	lw	a5,-52(s0)
 9a6:	85ba                	mv	a1,a4
 9a8:	853e                	mv	a0,a5
 9aa:	00000097          	auipc	ra,0x0
 9ae:	c30080e7          	jalr	-976(ra) # 5da <putc>
 9b2:	a035                	j	9de <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9b4:	fcc42783          	lw	a5,-52(s0)
 9b8:	02500593          	li	a1,37
 9bc:	853e                	mv	a0,a5
 9be:	00000097          	auipc	ra,0x0
 9c2:	c1c080e7          	jalr	-996(ra) # 5da <putc>
        putc(fd, c);
 9c6:	fdc42783          	lw	a5,-36(s0)
 9ca:	0ff7f713          	zext.b	a4,a5
 9ce:	fcc42783          	lw	a5,-52(s0)
 9d2:	85ba                	mv	a1,a4
 9d4:	853e                	mv	a0,a5
 9d6:	00000097          	auipc	ra,0x0
 9da:	c04080e7          	jalr	-1020(ra) # 5da <putc>
      }
      state = 0;
 9de:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9e2:	fe442783          	lw	a5,-28(s0)
 9e6:	2785                	addiw	a5,a5,1
 9e8:	fef42223          	sw	a5,-28(s0)
 9ec:	fe442783          	lw	a5,-28(s0)
 9f0:	fc043703          	ld	a4,-64(s0)
 9f4:	97ba                	add	a5,a5,a4
 9f6:	0007c783          	lbu	a5,0(a5)
 9fa:	dc0795e3          	bnez	a5,7c4 <vprintf+0x20>
    }
  }
}
 9fe:	0001                	nop
 a00:	0001                	nop
 a02:	60a6                	ld	ra,72(sp)
 a04:	6406                	ld	s0,64(sp)
 a06:	6161                	addi	sp,sp,80
 a08:	8082                	ret

0000000000000a0a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a0a:	7159                	addi	sp,sp,-112
 a0c:	fc06                	sd	ra,56(sp)
 a0e:	f822                	sd	s0,48(sp)
 a10:	0080                	addi	s0,sp,64
 a12:	fcb43823          	sd	a1,-48(s0)
 a16:	e010                	sd	a2,0(s0)
 a18:	e414                	sd	a3,8(s0)
 a1a:	e818                	sd	a4,16(s0)
 a1c:	ec1c                	sd	a5,24(s0)
 a1e:	03043023          	sd	a6,32(s0)
 a22:	03143423          	sd	a7,40(s0)
 a26:	87aa                	mv	a5,a0
 a28:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a2c:	03040793          	addi	a5,s0,48
 a30:	fcf43423          	sd	a5,-56(s0)
 a34:	fc843783          	ld	a5,-56(s0)
 a38:	fd078793          	addi	a5,a5,-48
 a3c:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a40:	fe843703          	ld	a4,-24(s0)
 a44:	fdc42783          	lw	a5,-36(s0)
 a48:	863a                	mv	a2,a4
 a4a:	fd043583          	ld	a1,-48(s0)
 a4e:	853e                	mv	a0,a5
 a50:	00000097          	auipc	ra,0x0
 a54:	d54080e7          	jalr	-684(ra) # 7a4 <vprintf>
}
 a58:	0001                	nop
 a5a:	70e2                	ld	ra,56(sp)
 a5c:	7442                	ld	s0,48(sp)
 a5e:	6165                	addi	sp,sp,112
 a60:	8082                	ret

0000000000000a62 <printf>:

void
printf(const char *fmt, ...)
{
 a62:	7159                	addi	sp,sp,-112
 a64:	f406                	sd	ra,40(sp)
 a66:	f022                	sd	s0,32(sp)
 a68:	1800                	addi	s0,sp,48
 a6a:	fca43c23          	sd	a0,-40(s0)
 a6e:	e40c                	sd	a1,8(s0)
 a70:	e810                	sd	a2,16(s0)
 a72:	ec14                	sd	a3,24(s0)
 a74:	f018                	sd	a4,32(s0)
 a76:	f41c                	sd	a5,40(s0)
 a78:	03043823          	sd	a6,48(s0)
 a7c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a80:	04040793          	addi	a5,s0,64
 a84:	fcf43823          	sd	a5,-48(s0)
 a88:	fd043783          	ld	a5,-48(s0)
 a8c:	fc878793          	addi	a5,a5,-56
 a90:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a94:	fe843783          	ld	a5,-24(s0)
 a98:	863e                	mv	a2,a5
 a9a:	fd843583          	ld	a1,-40(s0)
 a9e:	4505                	li	a0,1
 aa0:	00000097          	auipc	ra,0x0
 aa4:	d04080e7          	jalr	-764(ra) # 7a4 <vprintf>
}
 aa8:	0001                	nop
 aaa:	70a2                	ld	ra,40(sp)
 aac:	7402                	ld	s0,32(sp)
 aae:	6165                	addi	sp,sp,112
 ab0:	8082                	ret

0000000000000ab2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab2:	7179                	addi	sp,sp,-48
 ab4:	f422                	sd	s0,40(sp)
 ab6:	1800                	addi	s0,sp,48
 ab8:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 abc:	fd843783          	ld	a5,-40(s0)
 ac0:	17c1                	addi	a5,a5,-16
 ac2:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac6:	00001797          	auipc	a5,0x1
 aca:	8da78793          	addi	a5,a5,-1830 # 13a0 <freep>
 ace:	639c                	ld	a5,0(a5)
 ad0:	fef43423          	sd	a5,-24(s0)
 ad4:	a815                	j	b08 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad6:	fe843783          	ld	a5,-24(s0)
 ada:	639c                	ld	a5,0(a5)
 adc:	fe843703          	ld	a4,-24(s0)
 ae0:	00f76f63          	bltu	a4,a5,afe <free+0x4c>
 ae4:	fe043703          	ld	a4,-32(s0)
 ae8:	fe843783          	ld	a5,-24(s0)
 aec:	02e7eb63          	bltu	a5,a4,b22 <free+0x70>
 af0:	fe843783          	ld	a5,-24(s0)
 af4:	639c                	ld	a5,0(a5)
 af6:	fe043703          	ld	a4,-32(s0)
 afa:	02f76463          	bltu	a4,a5,b22 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afe:	fe843783          	ld	a5,-24(s0)
 b02:	639c                	ld	a5,0(a5)
 b04:	fef43423          	sd	a5,-24(s0)
 b08:	fe043703          	ld	a4,-32(s0)
 b0c:	fe843783          	ld	a5,-24(s0)
 b10:	fce7f3e3          	bgeu	a5,a4,ad6 <free+0x24>
 b14:	fe843783          	ld	a5,-24(s0)
 b18:	639c                	ld	a5,0(a5)
 b1a:	fe043703          	ld	a4,-32(s0)
 b1e:	faf77ce3          	bgeu	a4,a5,ad6 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b22:	fe043783          	ld	a5,-32(s0)
 b26:	479c                	lw	a5,8(a5)
 b28:	1782                	slli	a5,a5,0x20
 b2a:	9381                	srli	a5,a5,0x20
 b2c:	0792                	slli	a5,a5,0x4
 b2e:	fe043703          	ld	a4,-32(s0)
 b32:	973e                	add	a4,a4,a5
 b34:	fe843783          	ld	a5,-24(s0)
 b38:	639c                	ld	a5,0(a5)
 b3a:	02f71763          	bne	a4,a5,b68 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b3e:	fe043783          	ld	a5,-32(s0)
 b42:	4798                	lw	a4,8(a5)
 b44:	fe843783          	ld	a5,-24(s0)
 b48:	639c                	ld	a5,0(a5)
 b4a:	479c                	lw	a5,8(a5)
 b4c:	9fb9                	addw	a5,a5,a4
 b4e:	0007871b          	sext.w	a4,a5
 b52:	fe043783          	ld	a5,-32(s0)
 b56:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b58:	fe843783          	ld	a5,-24(s0)
 b5c:	639c                	ld	a5,0(a5)
 b5e:	6398                	ld	a4,0(a5)
 b60:	fe043783          	ld	a5,-32(s0)
 b64:	e398                	sd	a4,0(a5)
 b66:	a039                	j	b74 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b68:	fe843783          	ld	a5,-24(s0)
 b6c:	6398                	ld	a4,0(a5)
 b6e:	fe043783          	ld	a5,-32(s0)
 b72:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b74:	fe843783          	ld	a5,-24(s0)
 b78:	479c                	lw	a5,8(a5)
 b7a:	1782                	slli	a5,a5,0x20
 b7c:	9381                	srli	a5,a5,0x20
 b7e:	0792                	slli	a5,a5,0x4
 b80:	fe843703          	ld	a4,-24(s0)
 b84:	97ba                	add	a5,a5,a4
 b86:	fe043703          	ld	a4,-32(s0)
 b8a:	02f71563          	bne	a4,a5,bb4 <free+0x102>
    p->s.size += bp->s.size;
 b8e:	fe843783          	ld	a5,-24(s0)
 b92:	4798                	lw	a4,8(a5)
 b94:	fe043783          	ld	a5,-32(s0)
 b98:	479c                	lw	a5,8(a5)
 b9a:	9fb9                	addw	a5,a5,a4
 b9c:	0007871b          	sext.w	a4,a5
 ba0:	fe843783          	ld	a5,-24(s0)
 ba4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ba6:	fe043783          	ld	a5,-32(s0)
 baa:	6398                	ld	a4,0(a5)
 bac:	fe843783          	ld	a5,-24(s0)
 bb0:	e398                	sd	a4,0(a5)
 bb2:	a031                	j	bbe <free+0x10c>
  } else
    p->s.ptr = bp;
 bb4:	fe843783          	ld	a5,-24(s0)
 bb8:	fe043703          	ld	a4,-32(s0)
 bbc:	e398                	sd	a4,0(a5)
  freep = p;
 bbe:	00000797          	auipc	a5,0x0
 bc2:	7e278793          	addi	a5,a5,2018 # 13a0 <freep>
 bc6:	fe843703          	ld	a4,-24(s0)
 bca:	e398                	sd	a4,0(a5)
}
 bcc:	0001                	nop
 bce:	7422                	ld	s0,40(sp)
 bd0:	6145                	addi	sp,sp,48
 bd2:	8082                	ret

0000000000000bd4 <morecore>:

static Header*
morecore(uint nu)
{
 bd4:	7179                	addi	sp,sp,-48
 bd6:	f406                	sd	ra,40(sp)
 bd8:	f022                	sd	s0,32(sp)
 bda:	1800                	addi	s0,sp,48
 bdc:	87aa                	mv	a5,a0
 bde:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 be2:	fdc42783          	lw	a5,-36(s0)
 be6:	0007871b          	sext.w	a4,a5
 bea:	6785                	lui	a5,0x1
 bec:	00f77563          	bgeu	a4,a5,bf6 <morecore+0x22>
    nu = 4096;
 bf0:	6785                	lui	a5,0x1
 bf2:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bf6:	fdc42783          	lw	a5,-36(s0)
 bfa:	0047979b          	slliw	a5,a5,0x4
 bfe:	2781                	sext.w	a5,a5
 c00:	2781                	sext.w	a5,a5
 c02:	853e                	mv	a0,a5
 c04:	00000097          	auipc	ra,0x0
 c08:	9be080e7          	jalr	-1602(ra) # 5c2 <sbrk>
 c0c:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c10:	fe843703          	ld	a4,-24(s0)
 c14:	57fd                	li	a5,-1
 c16:	00f71463          	bne	a4,a5,c1e <morecore+0x4a>
    return 0;
 c1a:	4781                	li	a5,0
 c1c:	a03d                	j	c4a <morecore+0x76>
  hp = (Header*)p;
 c1e:	fe843783          	ld	a5,-24(s0)
 c22:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c26:	fe043783          	ld	a5,-32(s0)
 c2a:	fdc42703          	lw	a4,-36(s0)
 c2e:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c30:	fe043783          	ld	a5,-32(s0)
 c34:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3bc>
 c36:	853e                	mv	a0,a5
 c38:	00000097          	auipc	ra,0x0
 c3c:	e7a080e7          	jalr	-390(ra) # ab2 <free>
  return freep;
 c40:	00000797          	auipc	a5,0x0
 c44:	76078793          	addi	a5,a5,1888 # 13a0 <freep>
 c48:	639c                	ld	a5,0(a5)
}
 c4a:	853e                	mv	a0,a5
 c4c:	70a2                	ld	ra,40(sp)
 c4e:	7402                	ld	s0,32(sp)
 c50:	6145                	addi	sp,sp,48
 c52:	8082                	ret

0000000000000c54 <malloc>:

void*
malloc(uint nbytes)
{
 c54:	7139                	addi	sp,sp,-64
 c56:	fc06                	sd	ra,56(sp)
 c58:	f822                	sd	s0,48(sp)
 c5a:	0080                	addi	s0,sp,64
 c5c:	87aa                	mv	a5,a0
 c5e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c62:	fcc46783          	lwu	a5,-52(s0)
 c66:	07bd                	addi	a5,a5,15
 c68:	8391                	srli	a5,a5,0x4
 c6a:	2781                	sext.w	a5,a5
 c6c:	2785                	addiw	a5,a5,1
 c6e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c72:	00000797          	auipc	a5,0x0
 c76:	72e78793          	addi	a5,a5,1838 # 13a0 <freep>
 c7a:	639c                	ld	a5,0(a5)
 c7c:	fef43023          	sd	a5,-32(s0)
 c80:	fe043783          	ld	a5,-32(s0)
 c84:	ef95                	bnez	a5,cc0 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c86:	00000797          	auipc	a5,0x0
 c8a:	70a78793          	addi	a5,a5,1802 # 1390 <base>
 c8e:	fef43023          	sd	a5,-32(s0)
 c92:	00000797          	auipc	a5,0x0
 c96:	70e78793          	addi	a5,a5,1806 # 13a0 <freep>
 c9a:	fe043703          	ld	a4,-32(s0)
 c9e:	e398                	sd	a4,0(a5)
 ca0:	00000797          	auipc	a5,0x0
 ca4:	70078793          	addi	a5,a5,1792 # 13a0 <freep>
 ca8:	6398                	ld	a4,0(a5)
 caa:	00000797          	auipc	a5,0x0
 cae:	6e678793          	addi	a5,a5,1766 # 1390 <base>
 cb2:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cb4:	00000797          	auipc	a5,0x0
 cb8:	6dc78793          	addi	a5,a5,1756 # 1390 <base>
 cbc:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc0:	fe043783          	ld	a5,-32(s0)
 cc4:	639c                	ld	a5,0(a5)
 cc6:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 cca:	fe843783          	ld	a5,-24(s0)
 cce:	4798                	lw	a4,8(a5)
 cd0:	fdc42783          	lw	a5,-36(s0)
 cd4:	2781                	sext.w	a5,a5
 cd6:	06f76763          	bltu	a4,a5,d44 <malloc+0xf0>
      if(p->s.size == nunits)
 cda:	fe843783          	ld	a5,-24(s0)
 cde:	4798                	lw	a4,8(a5)
 ce0:	fdc42783          	lw	a5,-36(s0)
 ce4:	2781                	sext.w	a5,a5
 ce6:	00e79963          	bne	a5,a4,cf8 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cea:	fe843783          	ld	a5,-24(s0)
 cee:	6398                	ld	a4,0(a5)
 cf0:	fe043783          	ld	a5,-32(s0)
 cf4:	e398                	sd	a4,0(a5)
 cf6:	a825                	j	d2e <malloc+0xda>
      else {
        p->s.size -= nunits;
 cf8:	fe843783          	ld	a5,-24(s0)
 cfc:	479c                	lw	a5,8(a5)
 cfe:	fdc42703          	lw	a4,-36(s0)
 d02:	9f99                	subw	a5,a5,a4
 d04:	0007871b          	sext.w	a4,a5
 d08:	fe843783          	ld	a5,-24(s0)
 d0c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d0e:	fe843783          	ld	a5,-24(s0)
 d12:	479c                	lw	a5,8(a5)
 d14:	1782                	slli	a5,a5,0x20
 d16:	9381                	srli	a5,a5,0x20
 d18:	0792                	slli	a5,a5,0x4
 d1a:	fe843703          	ld	a4,-24(s0)
 d1e:	97ba                	add	a5,a5,a4
 d20:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d24:	fe843783          	ld	a5,-24(s0)
 d28:	fdc42703          	lw	a4,-36(s0)
 d2c:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d2e:	00000797          	auipc	a5,0x0
 d32:	67278793          	addi	a5,a5,1650 # 13a0 <freep>
 d36:	fe043703          	ld	a4,-32(s0)
 d3a:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d3c:	fe843783          	ld	a5,-24(s0)
 d40:	07c1                	addi	a5,a5,16
 d42:	a091                	j	d86 <malloc+0x132>
    }
    if(p == freep)
 d44:	00000797          	auipc	a5,0x0
 d48:	65c78793          	addi	a5,a5,1628 # 13a0 <freep>
 d4c:	639c                	ld	a5,0(a5)
 d4e:	fe843703          	ld	a4,-24(s0)
 d52:	02f71063          	bne	a4,a5,d72 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d56:	fdc42783          	lw	a5,-36(s0)
 d5a:	853e                	mv	a0,a5
 d5c:	00000097          	auipc	ra,0x0
 d60:	e78080e7          	jalr	-392(ra) # bd4 <morecore>
 d64:	fea43423          	sd	a0,-24(s0)
 d68:	fe843783          	ld	a5,-24(s0)
 d6c:	e399                	bnez	a5,d72 <malloc+0x11e>
        return 0;
 d6e:	4781                	li	a5,0
 d70:	a819                	j	d86 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d72:	fe843783          	ld	a5,-24(s0)
 d76:	fef43023          	sd	a5,-32(s0)
 d7a:	fe843783          	ld	a5,-24(s0)
 d7e:	639c                	ld	a5,0(a5)
 d80:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d84:	b799                	j	cca <malloc+0x76>
  }
}
 d86:	853e                	mv	a0,a5
 d88:	70e2                	ld	ra,56(sp)
 d8a:	7442                	ld	s0,48(sp)
 d8c:	6121                	addi	sp,sp,64
 d8e:	8082                	ret
