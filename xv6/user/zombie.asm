
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	4c6080e7          	jalr	1222(ra) # 4ce <fork>
  10:	87aa                	mv	a5,a0
  12:	00f05763          	blez	a5,20 <main+0x20>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	00000097          	auipc	ra,0x0
  1c:	54e080e7          	jalr	1358(ra) # 566 <sleep>
  exit(0);
  20:	4501                	li	a0,0
  22:	00000097          	auipc	ra,0x0
  26:	4b4080e7          	jalr	1204(ra) # 4d6 <exit>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	49a080e7          	jalr	1178(ra) # 4d6 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	7179                	addi	sp,sp,-48
  46:	f422                	sd	s0,40(sp)
  48:	1800                	addi	s0,sp,48
  4a:	fca43c23          	sd	a0,-40(s0)
  4e:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  52:	fd843783          	ld	a5,-40(s0)
  56:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  5a:	0001                	nop
  5c:	fd043703          	ld	a4,-48(s0)
  60:	00170793          	addi	a5,a4,1
  64:	fcf43823          	sd	a5,-48(s0)
  68:	fd843783          	ld	a5,-40(s0)
  6c:	00178693          	addi	a3,a5,1
  70:	fcd43c23          	sd	a3,-40(s0)
  74:	00074703          	lbu	a4,0(a4)
  78:	00e78023          	sb	a4,0(a5)
  7c:	0007c783          	lbu	a5,0(a5)
  80:	fff1                	bnez	a5,5c <strcpy+0x18>
    ;
  return os;
  82:	fe843783          	ld	a5,-24(s0)
}
  86:	853e                	mv	a0,a5
  88:	7422                	ld	s0,40(sp)
  8a:	6145                	addi	sp,sp,48
  8c:	8082                	ret

000000000000008e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8e:	1101                	addi	sp,sp,-32
  90:	ec22                	sd	s0,24(sp)
  92:	1000                	addi	s0,sp,32
  94:	fea43423          	sd	a0,-24(s0)
  98:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
  9c:	a819                	j	b2 <strcmp+0x24>
    p++, q++;
  9e:	fe843783          	ld	a5,-24(s0)
  a2:	0785                	addi	a5,a5,1
  a4:	fef43423          	sd	a5,-24(s0)
  a8:	fe043783          	ld	a5,-32(s0)
  ac:	0785                	addi	a5,a5,1
  ae:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
  b2:	fe843783          	ld	a5,-24(s0)
  b6:	0007c783          	lbu	a5,0(a5)
  ba:	cb99                	beqz	a5,d0 <strcmp+0x42>
  bc:	fe843783          	ld	a5,-24(s0)
  c0:	0007c703          	lbu	a4,0(a5)
  c4:	fe043783          	ld	a5,-32(s0)
  c8:	0007c783          	lbu	a5,0(a5)
  cc:	fcf709e3          	beq	a4,a5,9e <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  d0:	fe843783          	ld	a5,-24(s0)
  d4:	0007c783          	lbu	a5,0(a5)
  d8:	0007871b          	sext.w	a4,a5
  dc:	fe043783          	ld	a5,-32(s0)
  e0:	0007c783          	lbu	a5,0(a5)
  e4:	2781                	sext.w	a5,a5
  e6:	40f707bb          	subw	a5,a4,a5
  ea:	2781                	sext.w	a5,a5
}
  ec:	853e                	mv	a0,a5
  ee:	6462                	ld	s0,24(sp)
  f0:	6105                	addi	sp,sp,32
  f2:	8082                	ret

00000000000000f4 <strlen>:

uint
strlen(const char *s)
{
  f4:	7179                	addi	sp,sp,-48
  f6:	f422                	sd	s0,40(sp)
  f8:	1800                	addi	s0,sp,48
  fa:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
  fe:	fe042623          	sw	zero,-20(s0)
 102:	a031                	j	10e <strlen+0x1a>
 104:	fec42783          	lw	a5,-20(s0)
 108:	2785                	addiw	a5,a5,1
 10a:	fef42623          	sw	a5,-20(s0)
 10e:	fec42783          	lw	a5,-20(s0)
 112:	fd843703          	ld	a4,-40(s0)
 116:	97ba                	add	a5,a5,a4
 118:	0007c783          	lbu	a5,0(a5)
 11c:	f7e5                	bnez	a5,104 <strlen+0x10>
    ;
  return n;
 11e:	fec42783          	lw	a5,-20(s0)
}
 122:	853e                	mv	a0,a5
 124:	7422                	ld	s0,40(sp)
 126:	6145                	addi	sp,sp,48
 128:	8082                	ret

000000000000012a <memset>:

void*
memset(void *dst, int c, uint n)
{
 12a:	7179                	addi	sp,sp,-48
 12c:	f422                	sd	s0,40(sp)
 12e:	1800                	addi	s0,sp,48
 130:	fca43c23          	sd	a0,-40(s0)
 134:	87ae                	mv	a5,a1
 136:	8732                	mv	a4,a2
 138:	fcf42a23          	sw	a5,-44(s0)
 13c:	87ba                	mv	a5,a4
 13e:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 142:	fd843783          	ld	a5,-40(s0)
 146:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 14a:	fe042623          	sw	zero,-20(s0)
 14e:	a00d                	j	170 <memset+0x46>
    cdst[i] = c;
 150:	fec42783          	lw	a5,-20(s0)
 154:	fe043703          	ld	a4,-32(s0)
 158:	97ba                	add	a5,a5,a4
 15a:	fd442703          	lw	a4,-44(s0)
 15e:	0ff77713          	zext.b	a4,a4
 162:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 166:	fec42783          	lw	a5,-20(s0)
 16a:	2785                	addiw	a5,a5,1
 16c:	fef42623          	sw	a5,-20(s0)
 170:	fec42703          	lw	a4,-20(s0)
 174:	fd042783          	lw	a5,-48(s0)
 178:	2781                	sext.w	a5,a5
 17a:	fcf76be3          	bltu	a4,a5,150 <memset+0x26>
  }
  return dst;
 17e:	fd843783          	ld	a5,-40(s0)
}
 182:	853e                	mv	a0,a5
 184:	7422                	ld	s0,40(sp)
 186:	6145                	addi	sp,sp,48
 188:	8082                	ret

000000000000018a <strchr>:

char*
strchr(const char *s, char c)
{
 18a:	1101                	addi	sp,sp,-32
 18c:	ec22                	sd	s0,24(sp)
 18e:	1000                	addi	s0,sp,32
 190:	fea43423          	sd	a0,-24(s0)
 194:	87ae                	mv	a5,a1
 196:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 19a:	a01d                	j	1c0 <strchr+0x36>
    if(*s == c)
 19c:	fe843783          	ld	a5,-24(s0)
 1a0:	0007c703          	lbu	a4,0(a5)
 1a4:	fe744783          	lbu	a5,-25(s0)
 1a8:	0ff7f793          	zext.b	a5,a5
 1ac:	00e79563          	bne	a5,a4,1b6 <strchr+0x2c>
      return (char*)s;
 1b0:	fe843783          	ld	a5,-24(s0)
 1b4:	a821                	j	1cc <strchr+0x42>
  for(; *s; s++)
 1b6:	fe843783          	ld	a5,-24(s0)
 1ba:	0785                	addi	a5,a5,1
 1bc:	fef43423          	sd	a5,-24(s0)
 1c0:	fe843783          	ld	a5,-24(s0)
 1c4:	0007c783          	lbu	a5,0(a5)
 1c8:	fbf1                	bnez	a5,19c <strchr+0x12>
  return 0;
 1ca:	4781                	li	a5,0
}
 1cc:	853e                	mv	a0,a5
 1ce:	6462                	ld	s0,24(sp)
 1d0:	6105                	addi	sp,sp,32
 1d2:	8082                	ret

00000000000001d4 <gets>:

char*
gets(char *buf, int max)
{
 1d4:	7179                	addi	sp,sp,-48
 1d6:	f406                	sd	ra,40(sp)
 1d8:	f022                	sd	s0,32(sp)
 1da:	1800                	addi	s0,sp,48
 1dc:	fca43c23          	sd	a0,-40(s0)
 1e0:	87ae                	mv	a5,a1
 1e2:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	fe042623          	sw	zero,-20(s0)
 1ea:	a8a1                	j	242 <gets+0x6e>
    cc = read(0, &c, 1);
 1ec:	fe740793          	addi	a5,s0,-25
 1f0:	4605                	li	a2,1
 1f2:	85be                	mv	a1,a5
 1f4:	4501                	li	a0,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	2f8080e7          	jalr	760(ra) # 4ee <read>
 1fe:	87aa                	mv	a5,a0
 200:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 204:	fe842783          	lw	a5,-24(s0)
 208:	2781                	sext.w	a5,a5
 20a:	04f05763          	blez	a5,258 <gets+0x84>
      break;
    buf[i++] = c;
 20e:	fec42783          	lw	a5,-20(s0)
 212:	0017871b          	addiw	a4,a5,1
 216:	fee42623          	sw	a4,-20(s0)
 21a:	873e                	mv	a4,a5
 21c:	fd843783          	ld	a5,-40(s0)
 220:	97ba                	add	a5,a5,a4
 222:	fe744703          	lbu	a4,-25(s0)
 226:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 22a:	fe744783          	lbu	a5,-25(s0)
 22e:	873e                	mv	a4,a5
 230:	47a9                	li	a5,10
 232:	02f70463          	beq	a4,a5,25a <gets+0x86>
 236:	fe744783          	lbu	a5,-25(s0)
 23a:	873e                	mv	a4,a5
 23c:	47b5                	li	a5,13
 23e:	00f70e63          	beq	a4,a5,25a <gets+0x86>
  for(i=0; i+1 < max; ){
 242:	fec42783          	lw	a5,-20(s0)
 246:	2785                	addiw	a5,a5,1
 248:	0007871b          	sext.w	a4,a5
 24c:	fd442783          	lw	a5,-44(s0)
 250:	2781                	sext.w	a5,a5
 252:	f8f74de3          	blt	a4,a5,1ec <gets+0x18>
 256:	a011                	j	25a <gets+0x86>
      break;
 258:	0001                	nop
      break;
  }
  buf[i] = '\0';
 25a:	fec42783          	lw	a5,-20(s0)
 25e:	fd843703          	ld	a4,-40(s0)
 262:	97ba                	add	a5,a5,a4
 264:	00078023          	sb	zero,0(a5)
  return buf;
 268:	fd843783          	ld	a5,-40(s0)
}
 26c:	853e                	mv	a0,a5
 26e:	70a2                	ld	ra,40(sp)
 270:	7402                	ld	s0,32(sp)
 272:	6145                	addi	sp,sp,48
 274:	8082                	ret

0000000000000276 <stat>:

int
stat(const char *n, struct stat *st)
{
 276:	7179                	addi	sp,sp,-48
 278:	f406                	sd	ra,40(sp)
 27a:	f022                	sd	s0,32(sp)
 27c:	1800                	addi	s0,sp,48
 27e:	fca43c23          	sd	a0,-40(s0)
 282:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 286:	4581                	li	a1,0
 288:	fd843503          	ld	a0,-40(s0)
 28c:	00000097          	auipc	ra,0x0
 290:	28a080e7          	jalr	650(ra) # 516 <open>
 294:	87aa                	mv	a5,a0
 296:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 29a:	fec42783          	lw	a5,-20(s0)
 29e:	2781                	sext.w	a5,a5
 2a0:	0007d463          	bgez	a5,2a8 <stat+0x32>
    return -1;
 2a4:	57fd                	li	a5,-1
 2a6:	a035                	j	2d2 <stat+0x5c>
  r = fstat(fd, st);
 2a8:	fec42783          	lw	a5,-20(s0)
 2ac:	fd043583          	ld	a1,-48(s0)
 2b0:	853e                	mv	a0,a5
 2b2:	00000097          	auipc	ra,0x0
 2b6:	27c080e7          	jalr	636(ra) # 52e <fstat>
 2ba:	87aa                	mv	a5,a0
 2bc:	fef42423          	sw	a5,-24(s0)
  close(fd);
 2c0:	fec42783          	lw	a5,-20(s0)
 2c4:	853e                	mv	a0,a5
 2c6:	00000097          	auipc	ra,0x0
 2ca:	238080e7          	jalr	568(ra) # 4fe <close>
  return r;
 2ce:	fe842783          	lw	a5,-24(s0)
}
 2d2:	853e                	mv	a0,a5
 2d4:	70a2                	ld	ra,40(sp)
 2d6:	7402                	ld	s0,32(sp)
 2d8:	6145                	addi	sp,sp,48
 2da:	8082                	ret

00000000000002dc <atoi>:

int
atoi(const char *s)
{
 2dc:	7179                	addi	sp,sp,-48
 2de:	f422                	sd	s0,40(sp)
 2e0:	1800                	addi	s0,sp,48
 2e2:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 2e6:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 2ea:	a81d                	j	320 <atoi+0x44>
    n = n*10 + *s++ - '0';
 2ec:	fec42783          	lw	a5,-20(s0)
 2f0:	873e                	mv	a4,a5
 2f2:	87ba                	mv	a5,a4
 2f4:	0027979b          	slliw	a5,a5,0x2
 2f8:	9fb9                	addw	a5,a5,a4
 2fa:	0017979b          	slliw	a5,a5,0x1
 2fe:	0007871b          	sext.w	a4,a5
 302:	fd843783          	ld	a5,-40(s0)
 306:	00178693          	addi	a3,a5,1
 30a:	fcd43c23          	sd	a3,-40(s0)
 30e:	0007c783          	lbu	a5,0(a5)
 312:	2781                	sext.w	a5,a5
 314:	9fb9                	addw	a5,a5,a4
 316:	2781                	sext.w	a5,a5
 318:	fd07879b          	addiw	a5,a5,-48
 31c:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 320:	fd843783          	ld	a5,-40(s0)
 324:	0007c783          	lbu	a5,0(a5)
 328:	873e                	mv	a4,a5
 32a:	02f00793          	li	a5,47
 32e:	00e7fb63          	bgeu	a5,a4,344 <atoi+0x68>
 332:	fd843783          	ld	a5,-40(s0)
 336:	0007c783          	lbu	a5,0(a5)
 33a:	873e                	mv	a4,a5
 33c:	03900793          	li	a5,57
 340:	fae7f6e3          	bgeu	a5,a4,2ec <atoi+0x10>
  return n;
 344:	fec42783          	lw	a5,-20(s0)
}
 348:	853e                	mv	a0,a5
 34a:	7422                	ld	s0,40(sp)
 34c:	6145                	addi	sp,sp,48
 34e:	8082                	ret

0000000000000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	7139                	addi	sp,sp,-64
 352:	fc22                	sd	s0,56(sp)
 354:	0080                	addi	s0,sp,64
 356:	fca43c23          	sd	a0,-40(s0)
 35a:	fcb43823          	sd	a1,-48(s0)
 35e:	87b2                	mv	a5,a2
 360:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 364:	fd843783          	ld	a5,-40(s0)
 368:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 36c:	fd043783          	ld	a5,-48(s0)
 370:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 374:	fe043703          	ld	a4,-32(s0)
 378:	fe843783          	ld	a5,-24(s0)
 37c:	02e7fc63          	bgeu	a5,a4,3b4 <memmove+0x64>
    while(n-- > 0)
 380:	a00d                	j	3a2 <memmove+0x52>
      *dst++ = *src++;
 382:	fe043703          	ld	a4,-32(s0)
 386:	00170793          	addi	a5,a4,1
 38a:	fef43023          	sd	a5,-32(s0)
 38e:	fe843783          	ld	a5,-24(s0)
 392:	00178693          	addi	a3,a5,1
 396:	fed43423          	sd	a3,-24(s0)
 39a:	00074703          	lbu	a4,0(a4)
 39e:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3a2:	fcc42783          	lw	a5,-52(s0)
 3a6:	fff7871b          	addiw	a4,a5,-1
 3aa:	fce42623          	sw	a4,-52(s0)
 3ae:	fcf04ae3          	bgtz	a5,382 <memmove+0x32>
 3b2:	a891                	j	406 <memmove+0xb6>
  } else {
    dst += n;
 3b4:	fcc42783          	lw	a5,-52(s0)
 3b8:	fe843703          	ld	a4,-24(s0)
 3bc:	97ba                	add	a5,a5,a4
 3be:	fef43423          	sd	a5,-24(s0)
    src += n;
 3c2:	fcc42783          	lw	a5,-52(s0)
 3c6:	fe043703          	ld	a4,-32(s0)
 3ca:	97ba                	add	a5,a5,a4
 3cc:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 3d0:	a01d                	j	3f6 <memmove+0xa6>
      *--dst = *--src;
 3d2:	fe043783          	ld	a5,-32(s0)
 3d6:	17fd                	addi	a5,a5,-1
 3d8:	fef43023          	sd	a5,-32(s0)
 3dc:	fe843783          	ld	a5,-24(s0)
 3e0:	17fd                	addi	a5,a5,-1
 3e2:	fef43423          	sd	a5,-24(s0)
 3e6:	fe043783          	ld	a5,-32(s0)
 3ea:	0007c703          	lbu	a4,0(a5)
 3ee:	fe843783          	ld	a5,-24(s0)
 3f2:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3f6:	fcc42783          	lw	a5,-52(s0)
 3fa:	fff7871b          	addiw	a4,a5,-1
 3fe:	fce42623          	sw	a4,-52(s0)
 402:	fcf048e3          	bgtz	a5,3d2 <memmove+0x82>
  }
  return vdst;
 406:	fd843783          	ld	a5,-40(s0)
}
 40a:	853e                	mv	a0,a5
 40c:	7462                	ld	s0,56(sp)
 40e:	6121                	addi	sp,sp,64
 410:	8082                	ret

0000000000000412 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 412:	7139                	addi	sp,sp,-64
 414:	fc22                	sd	s0,56(sp)
 416:	0080                	addi	s0,sp,64
 418:	fca43c23          	sd	a0,-40(s0)
 41c:	fcb43823          	sd	a1,-48(s0)
 420:	87b2                	mv	a5,a2
 422:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 426:	fd843783          	ld	a5,-40(s0)
 42a:	fef43423          	sd	a5,-24(s0)
 42e:	fd043783          	ld	a5,-48(s0)
 432:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 436:	a0a1                	j	47e <memcmp+0x6c>
    if (*p1 != *p2) {
 438:	fe843783          	ld	a5,-24(s0)
 43c:	0007c703          	lbu	a4,0(a5)
 440:	fe043783          	ld	a5,-32(s0)
 444:	0007c783          	lbu	a5,0(a5)
 448:	02f70163          	beq	a4,a5,46a <memcmp+0x58>
      return *p1 - *p2;
 44c:	fe843783          	ld	a5,-24(s0)
 450:	0007c783          	lbu	a5,0(a5)
 454:	0007871b          	sext.w	a4,a5
 458:	fe043783          	ld	a5,-32(s0)
 45c:	0007c783          	lbu	a5,0(a5)
 460:	2781                	sext.w	a5,a5
 462:	40f707bb          	subw	a5,a4,a5
 466:	2781                	sext.w	a5,a5
 468:	a01d                	j	48e <memcmp+0x7c>
    }
    p1++;
 46a:	fe843783          	ld	a5,-24(s0)
 46e:	0785                	addi	a5,a5,1
 470:	fef43423          	sd	a5,-24(s0)
    p2++;
 474:	fe043783          	ld	a5,-32(s0)
 478:	0785                	addi	a5,a5,1
 47a:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 47e:	fcc42783          	lw	a5,-52(s0)
 482:	fff7871b          	addiw	a4,a5,-1
 486:	fce42623          	sw	a4,-52(s0)
 48a:	f7dd                	bnez	a5,438 <memcmp+0x26>
  }
  return 0;
 48c:	4781                	li	a5,0
}
 48e:	853e                	mv	a0,a5
 490:	7462                	ld	s0,56(sp)
 492:	6121                	addi	sp,sp,64
 494:	8082                	ret

0000000000000496 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 496:	7179                	addi	sp,sp,-48
 498:	f406                	sd	ra,40(sp)
 49a:	f022                	sd	s0,32(sp)
 49c:	1800                	addi	s0,sp,48
 49e:	fea43423          	sd	a0,-24(s0)
 4a2:	feb43023          	sd	a1,-32(s0)
 4a6:	87b2                	mv	a5,a2
 4a8:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 4ac:	fdc42783          	lw	a5,-36(s0)
 4b0:	863e                	mv	a2,a5
 4b2:	fe043583          	ld	a1,-32(s0)
 4b6:	fe843503          	ld	a0,-24(s0)
 4ba:	00000097          	auipc	ra,0x0
 4be:	e96080e7          	jalr	-362(ra) # 350 <memmove>
 4c2:	87aa                	mv	a5,a0
}
 4c4:	853e                	mv	a0,a5
 4c6:	70a2                	ld	ra,40(sp)
 4c8:	7402                	ld	s0,32(sp)
 4ca:	6145                	addi	sp,sp,48
 4cc:	8082                	ret

00000000000004ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ce:	4885                	li	a7,1
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d6:	4889                	li	a7,2
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <wait>:
.global wait
wait:
 li a7, SYS_wait
 4de:	488d                	li	a7,3
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e6:	4891                	li	a7,4
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <read>:
.global read
read:
 li a7, SYS_read
 4ee:	4895                	li	a7,5
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <write>:
.global write
write:
 li a7, SYS_write
 4f6:	48c1                	li	a7,16
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <close>:
.global close
close:
 li a7, SYS_close
 4fe:	48d5                	li	a7,21
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <kill>:
.global kill
kill:
 li a7, SYS_kill
 506:	4899                	li	a7,6
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <exec>:
.global exec
exec:
 li a7, SYS_exec
 50e:	489d                	li	a7,7
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <open>:
.global open
open:
 li a7, SYS_open
 516:	48bd                	li	a7,15
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51e:	48c5                	li	a7,17
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 526:	48c9                	li	a7,18
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52e:	48a1                	li	a7,8
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <link>:
.global link
link:
 li a7, SYS_link
 536:	48cd                	li	a7,19
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53e:	48d1                	li	a7,20
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 546:	48a5                	li	a7,9
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <dup>:
.global dup
dup:
 li a7, SYS_dup
 54e:	48a9                	li	a7,10
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 556:	48ad                	li	a7,11
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 55e:	48b1                	li	a7,12
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 566:	48b5                	li	a7,13
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56e:	48b9                	li	a7,14
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 576:	48d9                	li	a7,22
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 57e:	1101                	addi	sp,sp,-32
 580:	ec06                	sd	ra,24(sp)
 582:	e822                	sd	s0,16(sp)
 584:	1000                	addi	s0,sp,32
 586:	87aa                	mv	a5,a0
 588:	872e                	mv	a4,a1
 58a:	fef42623          	sw	a5,-20(s0)
 58e:	87ba                	mv	a5,a4
 590:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 594:	feb40713          	addi	a4,s0,-21
 598:	fec42783          	lw	a5,-20(s0)
 59c:	4605                	li	a2,1
 59e:	85ba                	mv	a1,a4
 5a0:	853e                	mv	a0,a5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	f54080e7          	jalr	-172(ra) # 4f6 <write>
}
 5aa:	0001                	nop
 5ac:	60e2                	ld	ra,24(sp)
 5ae:	6442                	ld	s0,16(sp)
 5b0:	6105                	addi	sp,sp,32
 5b2:	8082                	ret

00000000000005b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5b4:	7139                	addi	sp,sp,-64
 5b6:	fc06                	sd	ra,56(sp)
 5b8:	f822                	sd	s0,48(sp)
 5ba:	0080                	addi	s0,sp,64
 5bc:	87aa                	mv	a5,a0
 5be:	8736                	mv	a4,a3
 5c0:	fcf42623          	sw	a5,-52(s0)
 5c4:	87ae                	mv	a5,a1
 5c6:	fcf42423          	sw	a5,-56(s0)
 5ca:	87b2                	mv	a5,a2
 5cc:	fcf42223          	sw	a5,-60(s0)
 5d0:	87ba                	mv	a5,a4
 5d2:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5d6:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 5da:	fc042783          	lw	a5,-64(s0)
 5de:	2781                	sext.w	a5,a5
 5e0:	c38d                	beqz	a5,602 <printint+0x4e>
 5e2:	fc842783          	lw	a5,-56(s0)
 5e6:	2781                	sext.w	a5,a5
 5e8:	0007dd63          	bgez	a5,602 <printint+0x4e>
    neg = 1;
 5ec:	4785                	li	a5,1
 5ee:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 5f2:	fc842783          	lw	a5,-56(s0)
 5f6:	40f007bb          	negw	a5,a5
 5fa:	2781                	sext.w	a5,a5
 5fc:	fef42223          	sw	a5,-28(s0)
 600:	a029                	j	60a <printint+0x56>
  } else {
    x = xx;
 602:	fc842783          	lw	a5,-56(s0)
 606:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 60a:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 60e:	fc442783          	lw	a5,-60(s0)
 612:	fe442703          	lw	a4,-28(s0)
 616:	02f777bb          	remuw	a5,a4,a5
 61a:	0007861b          	sext.w	a2,a5
 61e:	fec42783          	lw	a5,-20(s0)
 622:	0017871b          	addiw	a4,a5,1
 626:	fee42623          	sw	a4,-20(s0)
 62a:	00001697          	auipc	a3,0x1
 62e:	d4668693          	addi	a3,a3,-698 # 1370 <digits>
 632:	02061713          	slli	a4,a2,0x20
 636:	9301                	srli	a4,a4,0x20
 638:	9736                	add	a4,a4,a3
 63a:	00074703          	lbu	a4,0(a4)
 63e:	17c1                	addi	a5,a5,-16
 640:	97a2                	add	a5,a5,s0
 642:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 646:	fc442783          	lw	a5,-60(s0)
 64a:	fe442703          	lw	a4,-28(s0)
 64e:	02f757bb          	divuw	a5,a4,a5
 652:	fef42223          	sw	a5,-28(s0)
 656:	fe442783          	lw	a5,-28(s0)
 65a:	2781                	sext.w	a5,a5
 65c:	fbcd                	bnez	a5,60e <printint+0x5a>
  if(neg)
 65e:	fe842783          	lw	a5,-24(s0)
 662:	2781                	sext.w	a5,a5
 664:	cf85                	beqz	a5,69c <printint+0xe8>
    buf[i++] = '-';
 666:	fec42783          	lw	a5,-20(s0)
 66a:	0017871b          	addiw	a4,a5,1
 66e:	fee42623          	sw	a4,-20(s0)
 672:	17c1                	addi	a5,a5,-16
 674:	97a2                	add	a5,a5,s0
 676:	02d00713          	li	a4,45
 67a:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 67e:	a839                	j	69c <printint+0xe8>
    putc(fd, buf[i]);
 680:	fec42783          	lw	a5,-20(s0)
 684:	17c1                	addi	a5,a5,-16
 686:	97a2                	add	a5,a5,s0
 688:	fe07c703          	lbu	a4,-32(a5)
 68c:	fcc42783          	lw	a5,-52(s0)
 690:	85ba                	mv	a1,a4
 692:	853e                	mv	a0,a5
 694:	00000097          	auipc	ra,0x0
 698:	eea080e7          	jalr	-278(ra) # 57e <putc>
  while(--i >= 0)
 69c:	fec42783          	lw	a5,-20(s0)
 6a0:	37fd                	addiw	a5,a5,-1
 6a2:	fef42623          	sw	a5,-20(s0)
 6a6:	fec42783          	lw	a5,-20(s0)
 6aa:	2781                	sext.w	a5,a5
 6ac:	fc07dae3          	bgez	a5,680 <printint+0xcc>
}
 6b0:	0001                	nop
 6b2:	0001                	nop
 6b4:	70e2                	ld	ra,56(sp)
 6b6:	7442                	ld	s0,48(sp)
 6b8:	6121                	addi	sp,sp,64
 6ba:	8082                	ret

00000000000006bc <printptr>:

static void
printptr(int fd, uint64 x) {
 6bc:	7179                	addi	sp,sp,-48
 6be:	f406                	sd	ra,40(sp)
 6c0:	f022                	sd	s0,32(sp)
 6c2:	1800                	addi	s0,sp,48
 6c4:	87aa                	mv	a5,a0
 6c6:	fcb43823          	sd	a1,-48(s0)
 6ca:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 6ce:	fdc42783          	lw	a5,-36(s0)
 6d2:	03000593          	li	a1,48
 6d6:	853e                	mv	a0,a5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	ea6080e7          	jalr	-346(ra) # 57e <putc>
  putc(fd, 'x');
 6e0:	fdc42783          	lw	a5,-36(s0)
 6e4:	07800593          	li	a1,120
 6e8:	853e                	mv	a0,a5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	e94080e7          	jalr	-364(ra) # 57e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f2:	fe042623          	sw	zero,-20(s0)
 6f6:	a82d                	j	730 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f8:	fd043783          	ld	a5,-48(s0)
 6fc:	93f1                	srli	a5,a5,0x3c
 6fe:	00001717          	auipc	a4,0x1
 702:	c7270713          	addi	a4,a4,-910 # 1370 <digits>
 706:	97ba                	add	a5,a5,a4
 708:	0007c703          	lbu	a4,0(a5)
 70c:	fdc42783          	lw	a5,-36(s0)
 710:	85ba                	mv	a1,a4
 712:	853e                	mv	a0,a5
 714:	00000097          	auipc	ra,0x0
 718:	e6a080e7          	jalr	-406(ra) # 57e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71c:	fec42783          	lw	a5,-20(s0)
 720:	2785                	addiw	a5,a5,1
 722:	fef42623          	sw	a5,-20(s0)
 726:	fd043783          	ld	a5,-48(s0)
 72a:	0792                	slli	a5,a5,0x4
 72c:	fcf43823          	sd	a5,-48(s0)
 730:	fec42783          	lw	a5,-20(s0)
 734:	873e                	mv	a4,a5
 736:	47bd                	li	a5,15
 738:	fce7f0e3          	bgeu	a5,a4,6f8 <printptr+0x3c>
}
 73c:	0001                	nop
 73e:	0001                	nop
 740:	70a2                	ld	ra,40(sp)
 742:	7402                	ld	s0,32(sp)
 744:	6145                	addi	sp,sp,48
 746:	8082                	ret

0000000000000748 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 748:	715d                	addi	sp,sp,-80
 74a:	e486                	sd	ra,72(sp)
 74c:	e0a2                	sd	s0,64(sp)
 74e:	0880                	addi	s0,sp,80
 750:	87aa                	mv	a5,a0
 752:	fcb43023          	sd	a1,-64(s0)
 756:	fac43c23          	sd	a2,-72(s0)
 75a:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 75e:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 762:	fe042223          	sw	zero,-28(s0)
 766:	a42d                	j	990 <vprintf+0x248>
    c = fmt[i] & 0xff;
 768:	fe442783          	lw	a5,-28(s0)
 76c:	fc043703          	ld	a4,-64(s0)
 770:	97ba                	add	a5,a5,a4
 772:	0007c783          	lbu	a5,0(a5)
 776:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 77a:	fe042783          	lw	a5,-32(s0)
 77e:	2781                	sext.w	a5,a5
 780:	eb9d                	bnez	a5,7b6 <vprintf+0x6e>
      if(c == '%'){
 782:	fdc42783          	lw	a5,-36(s0)
 786:	0007871b          	sext.w	a4,a5
 78a:	02500793          	li	a5,37
 78e:	00f71763          	bne	a4,a5,79c <vprintf+0x54>
        state = '%';
 792:	02500793          	li	a5,37
 796:	fef42023          	sw	a5,-32(s0)
 79a:	a2f5                	j	986 <vprintf+0x23e>
      } else {
        putc(fd, c);
 79c:	fdc42783          	lw	a5,-36(s0)
 7a0:	0ff7f713          	zext.b	a4,a5
 7a4:	fcc42783          	lw	a5,-52(s0)
 7a8:	85ba                	mv	a1,a4
 7aa:	853e                	mv	a0,a5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	dd2080e7          	jalr	-558(ra) # 57e <putc>
 7b4:	aac9                	j	986 <vprintf+0x23e>
      }
    } else if(state == '%'){
 7b6:	fe042783          	lw	a5,-32(s0)
 7ba:	0007871b          	sext.w	a4,a5
 7be:	02500793          	li	a5,37
 7c2:	1cf71263          	bne	a4,a5,986 <vprintf+0x23e>
      if(c == 'd'){
 7c6:	fdc42783          	lw	a5,-36(s0)
 7ca:	0007871b          	sext.w	a4,a5
 7ce:	06400793          	li	a5,100
 7d2:	02f71463          	bne	a4,a5,7fa <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 7d6:	fb843783          	ld	a5,-72(s0)
 7da:	00878713          	addi	a4,a5,8
 7de:	fae43c23          	sd	a4,-72(s0)
 7e2:	4398                	lw	a4,0(a5)
 7e4:	fcc42783          	lw	a5,-52(s0)
 7e8:	4685                	li	a3,1
 7ea:	4629                	li	a2,10
 7ec:	85ba                	mv	a1,a4
 7ee:	853e                	mv	a0,a5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	dc4080e7          	jalr	-572(ra) # 5b4 <printint>
 7f8:	a269                	j	982 <vprintf+0x23a>
      } else if(c == 'l') {
 7fa:	fdc42783          	lw	a5,-36(s0)
 7fe:	0007871b          	sext.w	a4,a5
 802:	06c00793          	li	a5,108
 806:	02f71663          	bne	a4,a5,832 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80a:	fb843783          	ld	a5,-72(s0)
 80e:	00878713          	addi	a4,a5,8
 812:	fae43c23          	sd	a4,-72(s0)
 816:	639c                	ld	a5,0(a5)
 818:	0007871b          	sext.w	a4,a5
 81c:	fcc42783          	lw	a5,-52(s0)
 820:	4681                	li	a3,0
 822:	4629                	li	a2,10
 824:	85ba                	mv	a1,a4
 826:	853e                	mv	a0,a5
 828:	00000097          	auipc	ra,0x0
 82c:	d8c080e7          	jalr	-628(ra) # 5b4 <printint>
 830:	aa89                	j	982 <vprintf+0x23a>
      } else if(c == 'x') {
 832:	fdc42783          	lw	a5,-36(s0)
 836:	0007871b          	sext.w	a4,a5
 83a:	07800793          	li	a5,120
 83e:	02f71463          	bne	a4,a5,866 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 842:	fb843783          	ld	a5,-72(s0)
 846:	00878713          	addi	a4,a5,8
 84a:	fae43c23          	sd	a4,-72(s0)
 84e:	4398                	lw	a4,0(a5)
 850:	fcc42783          	lw	a5,-52(s0)
 854:	4681                	li	a3,0
 856:	4641                	li	a2,16
 858:	85ba                	mv	a1,a4
 85a:	853e                	mv	a0,a5
 85c:	00000097          	auipc	ra,0x0
 860:	d58080e7          	jalr	-680(ra) # 5b4 <printint>
 864:	aa39                	j	982 <vprintf+0x23a>
      } else if(c == 'p') {
 866:	fdc42783          	lw	a5,-36(s0)
 86a:	0007871b          	sext.w	a4,a5
 86e:	07000793          	li	a5,112
 872:	02f71263          	bne	a4,a5,896 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 876:	fb843783          	ld	a5,-72(s0)
 87a:	00878713          	addi	a4,a5,8
 87e:	fae43c23          	sd	a4,-72(s0)
 882:	6398                	ld	a4,0(a5)
 884:	fcc42783          	lw	a5,-52(s0)
 888:	85ba                	mv	a1,a4
 88a:	853e                	mv	a0,a5
 88c:	00000097          	auipc	ra,0x0
 890:	e30080e7          	jalr	-464(ra) # 6bc <printptr>
 894:	a0fd                	j	982 <vprintf+0x23a>
      } else if(c == 's'){
 896:	fdc42783          	lw	a5,-36(s0)
 89a:	0007871b          	sext.w	a4,a5
 89e:	07300793          	li	a5,115
 8a2:	04f71c63          	bne	a4,a5,8fa <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8a6:	fb843783          	ld	a5,-72(s0)
 8aa:	00878713          	addi	a4,a5,8
 8ae:	fae43c23          	sd	a4,-72(s0)
 8b2:	639c                	ld	a5,0(a5)
 8b4:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8b8:	fe843783          	ld	a5,-24(s0)
 8bc:	eb8d                	bnez	a5,8ee <vprintf+0x1a6>
          s = "(null)";
 8be:	00000797          	auipc	a5,0x0
 8c2:	48278793          	addi	a5,a5,1154 # d40 <malloc+0x148>
 8c6:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8ca:	a015                	j	8ee <vprintf+0x1a6>
          putc(fd, *s);
 8cc:	fe843783          	ld	a5,-24(s0)
 8d0:	0007c703          	lbu	a4,0(a5)
 8d4:	fcc42783          	lw	a5,-52(s0)
 8d8:	85ba                	mv	a1,a4
 8da:	853e                	mv	a0,a5
 8dc:	00000097          	auipc	ra,0x0
 8e0:	ca2080e7          	jalr	-862(ra) # 57e <putc>
          s++;
 8e4:	fe843783          	ld	a5,-24(s0)
 8e8:	0785                	addi	a5,a5,1
 8ea:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8ee:	fe843783          	ld	a5,-24(s0)
 8f2:	0007c783          	lbu	a5,0(a5)
 8f6:	fbf9                	bnez	a5,8cc <vprintf+0x184>
 8f8:	a069                	j	982 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 8fa:	fdc42783          	lw	a5,-36(s0)
 8fe:	0007871b          	sext.w	a4,a5
 902:	06300793          	li	a5,99
 906:	02f71463          	bne	a4,a5,92e <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 90a:	fb843783          	ld	a5,-72(s0)
 90e:	00878713          	addi	a4,a5,8
 912:	fae43c23          	sd	a4,-72(s0)
 916:	439c                	lw	a5,0(a5)
 918:	0ff7f713          	zext.b	a4,a5
 91c:	fcc42783          	lw	a5,-52(s0)
 920:	85ba                	mv	a1,a4
 922:	853e                	mv	a0,a5
 924:	00000097          	auipc	ra,0x0
 928:	c5a080e7          	jalr	-934(ra) # 57e <putc>
 92c:	a899                	j	982 <vprintf+0x23a>
      } else if(c == '%'){
 92e:	fdc42783          	lw	a5,-36(s0)
 932:	0007871b          	sext.w	a4,a5
 936:	02500793          	li	a5,37
 93a:	00f71f63          	bne	a4,a5,958 <vprintf+0x210>
        putc(fd, c);
 93e:	fdc42783          	lw	a5,-36(s0)
 942:	0ff7f713          	zext.b	a4,a5
 946:	fcc42783          	lw	a5,-52(s0)
 94a:	85ba                	mv	a1,a4
 94c:	853e                	mv	a0,a5
 94e:	00000097          	auipc	ra,0x0
 952:	c30080e7          	jalr	-976(ra) # 57e <putc>
 956:	a035                	j	982 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 958:	fcc42783          	lw	a5,-52(s0)
 95c:	02500593          	li	a1,37
 960:	853e                	mv	a0,a5
 962:	00000097          	auipc	ra,0x0
 966:	c1c080e7          	jalr	-996(ra) # 57e <putc>
        putc(fd, c);
 96a:	fdc42783          	lw	a5,-36(s0)
 96e:	0ff7f713          	zext.b	a4,a5
 972:	fcc42783          	lw	a5,-52(s0)
 976:	85ba                	mv	a1,a4
 978:	853e                	mv	a0,a5
 97a:	00000097          	auipc	ra,0x0
 97e:	c04080e7          	jalr	-1020(ra) # 57e <putc>
      }
      state = 0;
 982:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 986:	fe442783          	lw	a5,-28(s0)
 98a:	2785                	addiw	a5,a5,1
 98c:	fef42223          	sw	a5,-28(s0)
 990:	fe442783          	lw	a5,-28(s0)
 994:	fc043703          	ld	a4,-64(s0)
 998:	97ba                	add	a5,a5,a4
 99a:	0007c783          	lbu	a5,0(a5)
 99e:	dc0795e3          	bnez	a5,768 <vprintf+0x20>
    }
  }
}
 9a2:	0001                	nop
 9a4:	0001                	nop
 9a6:	60a6                	ld	ra,72(sp)
 9a8:	6406                	ld	s0,64(sp)
 9aa:	6161                	addi	sp,sp,80
 9ac:	8082                	ret

00000000000009ae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9ae:	7159                	addi	sp,sp,-112
 9b0:	fc06                	sd	ra,56(sp)
 9b2:	f822                	sd	s0,48(sp)
 9b4:	0080                	addi	s0,sp,64
 9b6:	fcb43823          	sd	a1,-48(s0)
 9ba:	e010                	sd	a2,0(s0)
 9bc:	e414                	sd	a3,8(s0)
 9be:	e818                	sd	a4,16(s0)
 9c0:	ec1c                	sd	a5,24(s0)
 9c2:	03043023          	sd	a6,32(s0)
 9c6:	03143423          	sd	a7,40(s0)
 9ca:	87aa                	mv	a5,a0
 9cc:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 9d0:	03040793          	addi	a5,s0,48
 9d4:	fcf43423          	sd	a5,-56(s0)
 9d8:	fc843783          	ld	a5,-56(s0)
 9dc:	fd078793          	addi	a5,a5,-48
 9e0:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 9e4:	fe843703          	ld	a4,-24(s0)
 9e8:	fdc42783          	lw	a5,-36(s0)
 9ec:	863a                	mv	a2,a4
 9ee:	fd043583          	ld	a1,-48(s0)
 9f2:	853e                	mv	a0,a5
 9f4:	00000097          	auipc	ra,0x0
 9f8:	d54080e7          	jalr	-684(ra) # 748 <vprintf>
}
 9fc:	0001                	nop
 9fe:	70e2                	ld	ra,56(sp)
 a00:	7442                	ld	s0,48(sp)
 a02:	6165                	addi	sp,sp,112
 a04:	8082                	ret

0000000000000a06 <printf>:

void
printf(const char *fmt, ...)
{
 a06:	7159                	addi	sp,sp,-112
 a08:	f406                	sd	ra,40(sp)
 a0a:	f022                	sd	s0,32(sp)
 a0c:	1800                	addi	s0,sp,48
 a0e:	fca43c23          	sd	a0,-40(s0)
 a12:	e40c                	sd	a1,8(s0)
 a14:	e810                	sd	a2,16(s0)
 a16:	ec14                	sd	a3,24(s0)
 a18:	f018                	sd	a4,32(s0)
 a1a:	f41c                	sd	a5,40(s0)
 a1c:	03043823          	sd	a6,48(s0)
 a20:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a24:	04040793          	addi	a5,s0,64
 a28:	fcf43823          	sd	a5,-48(s0)
 a2c:	fd043783          	ld	a5,-48(s0)
 a30:	fc878793          	addi	a5,a5,-56
 a34:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a38:	fe843783          	ld	a5,-24(s0)
 a3c:	863e                	mv	a2,a5
 a3e:	fd843583          	ld	a1,-40(s0)
 a42:	4505                	li	a0,1
 a44:	00000097          	auipc	ra,0x0
 a48:	d04080e7          	jalr	-764(ra) # 748 <vprintf>
}
 a4c:	0001                	nop
 a4e:	70a2                	ld	ra,40(sp)
 a50:	7402                	ld	s0,32(sp)
 a52:	6165                	addi	sp,sp,112
 a54:	8082                	ret

0000000000000a56 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a56:	7179                	addi	sp,sp,-48
 a58:	f422                	sd	s0,40(sp)
 a5a:	1800                	addi	s0,sp,48
 a5c:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a60:	fd843783          	ld	a5,-40(s0)
 a64:	17c1                	addi	a5,a5,-16
 a66:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6a:	00001797          	auipc	a5,0x1
 a6e:	93678793          	addi	a5,a5,-1738 # 13a0 <freep>
 a72:	639c                	ld	a5,0(a5)
 a74:	fef43423          	sd	a5,-24(s0)
 a78:	a815                	j	aac <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a7a:	fe843783          	ld	a5,-24(s0)
 a7e:	639c                	ld	a5,0(a5)
 a80:	fe843703          	ld	a4,-24(s0)
 a84:	00f76f63          	bltu	a4,a5,aa2 <free+0x4c>
 a88:	fe043703          	ld	a4,-32(s0)
 a8c:	fe843783          	ld	a5,-24(s0)
 a90:	02e7eb63          	bltu	a5,a4,ac6 <free+0x70>
 a94:	fe843783          	ld	a5,-24(s0)
 a98:	639c                	ld	a5,0(a5)
 a9a:	fe043703          	ld	a4,-32(s0)
 a9e:	02f76463          	bltu	a4,a5,ac6 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa2:	fe843783          	ld	a5,-24(s0)
 aa6:	639c                	ld	a5,0(a5)
 aa8:	fef43423          	sd	a5,-24(s0)
 aac:	fe043703          	ld	a4,-32(s0)
 ab0:	fe843783          	ld	a5,-24(s0)
 ab4:	fce7f3e3          	bgeu	a5,a4,a7a <free+0x24>
 ab8:	fe843783          	ld	a5,-24(s0)
 abc:	639c                	ld	a5,0(a5)
 abe:	fe043703          	ld	a4,-32(s0)
 ac2:	faf77ce3          	bgeu	a4,a5,a7a <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ac6:	fe043783          	ld	a5,-32(s0)
 aca:	479c                	lw	a5,8(a5)
 acc:	1782                	slli	a5,a5,0x20
 ace:	9381                	srli	a5,a5,0x20
 ad0:	0792                	slli	a5,a5,0x4
 ad2:	fe043703          	ld	a4,-32(s0)
 ad6:	973e                	add	a4,a4,a5
 ad8:	fe843783          	ld	a5,-24(s0)
 adc:	639c                	ld	a5,0(a5)
 ade:	02f71763          	bne	a4,a5,b0c <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 ae2:	fe043783          	ld	a5,-32(s0)
 ae6:	4798                	lw	a4,8(a5)
 ae8:	fe843783          	ld	a5,-24(s0)
 aec:	639c                	ld	a5,0(a5)
 aee:	479c                	lw	a5,8(a5)
 af0:	9fb9                	addw	a5,a5,a4
 af2:	0007871b          	sext.w	a4,a5
 af6:	fe043783          	ld	a5,-32(s0)
 afa:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 afc:	fe843783          	ld	a5,-24(s0)
 b00:	639c                	ld	a5,0(a5)
 b02:	6398                	ld	a4,0(a5)
 b04:	fe043783          	ld	a5,-32(s0)
 b08:	e398                	sd	a4,0(a5)
 b0a:	a039                	j	b18 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b0c:	fe843783          	ld	a5,-24(s0)
 b10:	6398                	ld	a4,0(a5)
 b12:	fe043783          	ld	a5,-32(s0)
 b16:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b18:	fe843783          	ld	a5,-24(s0)
 b1c:	479c                	lw	a5,8(a5)
 b1e:	1782                	slli	a5,a5,0x20
 b20:	9381                	srli	a5,a5,0x20
 b22:	0792                	slli	a5,a5,0x4
 b24:	fe843703          	ld	a4,-24(s0)
 b28:	97ba                	add	a5,a5,a4
 b2a:	fe043703          	ld	a4,-32(s0)
 b2e:	02f71563          	bne	a4,a5,b58 <free+0x102>
    p->s.size += bp->s.size;
 b32:	fe843783          	ld	a5,-24(s0)
 b36:	4798                	lw	a4,8(a5)
 b38:	fe043783          	ld	a5,-32(s0)
 b3c:	479c                	lw	a5,8(a5)
 b3e:	9fb9                	addw	a5,a5,a4
 b40:	0007871b          	sext.w	a4,a5
 b44:	fe843783          	ld	a5,-24(s0)
 b48:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b4a:	fe043783          	ld	a5,-32(s0)
 b4e:	6398                	ld	a4,0(a5)
 b50:	fe843783          	ld	a5,-24(s0)
 b54:	e398                	sd	a4,0(a5)
 b56:	a031                	j	b62 <free+0x10c>
  } else
    p->s.ptr = bp;
 b58:	fe843783          	ld	a5,-24(s0)
 b5c:	fe043703          	ld	a4,-32(s0)
 b60:	e398                	sd	a4,0(a5)
  freep = p;
 b62:	00001797          	auipc	a5,0x1
 b66:	83e78793          	addi	a5,a5,-1986 # 13a0 <freep>
 b6a:	fe843703          	ld	a4,-24(s0)
 b6e:	e398                	sd	a4,0(a5)
}
 b70:	0001                	nop
 b72:	7422                	ld	s0,40(sp)
 b74:	6145                	addi	sp,sp,48
 b76:	8082                	ret

0000000000000b78 <morecore>:

static Header*
morecore(uint nu)
{
 b78:	7179                	addi	sp,sp,-48
 b7a:	f406                	sd	ra,40(sp)
 b7c:	f022                	sd	s0,32(sp)
 b7e:	1800                	addi	s0,sp,48
 b80:	87aa                	mv	a5,a0
 b82:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 b86:	fdc42783          	lw	a5,-36(s0)
 b8a:	0007871b          	sext.w	a4,a5
 b8e:	6785                	lui	a5,0x1
 b90:	00f77563          	bgeu	a4,a5,b9a <morecore+0x22>
    nu = 4096;
 b94:	6785                	lui	a5,0x1
 b96:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 b9a:	fdc42783          	lw	a5,-36(s0)
 b9e:	0047979b          	slliw	a5,a5,0x4
 ba2:	2781                	sext.w	a5,a5
 ba4:	2781                	sext.w	a5,a5
 ba6:	853e                	mv	a0,a5
 ba8:	00000097          	auipc	ra,0x0
 bac:	9b6080e7          	jalr	-1610(ra) # 55e <sbrk>
 bb0:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 bb4:	fe843703          	ld	a4,-24(s0)
 bb8:	57fd                	li	a5,-1
 bba:	00f71463          	bne	a4,a5,bc2 <morecore+0x4a>
    return 0;
 bbe:	4781                	li	a5,0
 bc0:	a03d                	j	bee <morecore+0x76>
  hp = (Header*)p;
 bc2:	fe843783          	ld	a5,-24(s0)
 bc6:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 bca:	fe043783          	ld	a5,-32(s0)
 bce:	fdc42703          	lw	a4,-36(s0)
 bd2:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 bd4:	fe043783          	ld	a5,-32(s0)
 bd8:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x418>
 bda:	853e                	mv	a0,a5
 bdc:	00000097          	auipc	ra,0x0
 be0:	e7a080e7          	jalr	-390(ra) # a56 <free>
  return freep;
 be4:	00000797          	auipc	a5,0x0
 be8:	7bc78793          	addi	a5,a5,1980 # 13a0 <freep>
 bec:	639c                	ld	a5,0(a5)
}
 bee:	853e                	mv	a0,a5
 bf0:	70a2                	ld	ra,40(sp)
 bf2:	7402                	ld	s0,32(sp)
 bf4:	6145                	addi	sp,sp,48
 bf6:	8082                	ret

0000000000000bf8 <malloc>:

void*
malloc(uint nbytes)
{
 bf8:	7139                	addi	sp,sp,-64
 bfa:	fc06                	sd	ra,56(sp)
 bfc:	f822                	sd	s0,48(sp)
 bfe:	0080                	addi	s0,sp,64
 c00:	87aa                	mv	a5,a0
 c02:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c06:	fcc46783          	lwu	a5,-52(s0)
 c0a:	07bd                	addi	a5,a5,15
 c0c:	8391                	srli	a5,a5,0x4
 c0e:	2781                	sext.w	a5,a5
 c10:	2785                	addiw	a5,a5,1
 c12:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c16:	00000797          	auipc	a5,0x0
 c1a:	78a78793          	addi	a5,a5,1930 # 13a0 <freep>
 c1e:	639c                	ld	a5,0(a5)
 c20:	fef43023          	sd	a5,-32(s0)
 c24:	fe043783          	ld	a5,-32(s0)
 c28:	ef95                	bnez	a5,c64 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c2a:	00000797          	auipc	a5,0x0
 c2e:	76678793          	addi	a5,a5,1894 # 1390 <base>
 c32:	fef43023          	sd	a5,-32(s0)
 c36:	00000797          	auipc	a5,0x0
 c3a:	76a78793          	addi	a5,a5,1898 # 13a0 <freep>
 c3e:	fe043703          	ld	a4,-32(s0)
 c42:	e398                	sd	a4,0(a5)
 c44:	00000797          	auipc	a5,0x0
 c48:	75c78793          	addi	a5,a5,1884 # 13a0 <freep>
 c4c:	6398                	ld	a4,0(a5)
 c4e:	00000797          	auipc	a5,0x0
 c52:	74278793          	addi	a5,a5,1858 # 1390 <base>
 c56:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c58:	00000797          	auipc	a5,0x0
 c5c:	73878793          	addi	a5,a5,1848 # 1390 <base>
 c60:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c64:	fe043783          	ld	a5,-32(s0)
 c68:	639c                	ld	a5,0(a5)
 c6a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 c6e:	fe843783          	ld	a5,-24(s0)
 c72:	4798                	lw	a4,8(a5)
 c74:	fdc42783          	lw	a5,-36(s0)
 c78:	2781                	sext.w	a5,a5
 c7a:	06f76763          	bltu	a4,a5,ce8 <malloc+0xf0>
      if(p->s.size == nunits)
 c7e:	fe843783          	ld	a5,-24(s0)
 c82:	4798                	lw	a4,8(a5)
 c84:	fdc42783          	lw	a5,-36(s0)
 c88:	2781                	sext.w	a5,a5
 c8a:	00e79963          	bne	a5,a4,c9c <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 c8e:	fe843783          	ld	a5,-24(s0)
 c92:	6398                	ld	a4,0(a5)
 c94:	fe043783          	ld	a5,-32(s0)
 c98:	e398                	sd	a4,0(a5)
 c9a:	a825                	j	cd2 <malloc+0xda>
      else {
        p->s.size -= nunits;
 c9c:	fe843783          	ld	a5,-24(s0)
 ca0:	479c                	lw	a5,8(a5)
 ca2:	fdc42703          	lw	a4,-36(s0)
 ca6:	9f99                	subw	a5,a5,a4
 ca8:	0007871b          	sext.w	a4,a5
 cac:	fe843783          	ld	a5,-24(s0)
 cb0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cb2:	fe843783          	ld	a5,-24(s0)
 cb6:	479c                	lw	a5,8(a5)
 cb8:	1782                	slli	a5,a5,0x20
 cba:	9381                	srli	a5,a5,0x20
 cbc:	0792                	slli	a5,a5,0x4
 cbe:	fe843703          	ld	a4,-24(s0)
 cc2:	97ba                	add	a5,a5,a4
 cc4:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cc8:	fe843783          	ld	a5,-24(s0)
 ccc:	fdc42703          	lw	a4,-36(s0)
 cd0:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 cd2:	00000797          	auipc	a5,0x0
 cd6:	6ce78793          	addi	a5,a5,1742 # 13a0 <freep>
 cda:	fe043703          	ld	a4,-32(s0)
 cde:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 ce0:	fe843783          	ld	a5,-24(s0)
 ce4:	07c1                	addi	a5,a5,16
 ce6:	a091                	j	d2a <malloc+0x132>
    }
    if(p == freep)
 ce8:	00000797          	auipc	a5,0x0
 cec:	6b878793          	addi	a5,a5,1720 # 13a0 <freep>
 cf0:	639c                	ld	a5,0(a5)
 cf2:	fe843703          	ld	a4,-24(s0)
 cf6:	02f71063          	bne	a4,a5,d16 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 cfa:	fdc42783          	lw	a5,-36(s0)
 cfe:	853e                	mv	a0,a5
 d00:	00000097          	auipc	ra,0x0
 d04:	e78080e7          	jalr	-392(ra) # b78 <morecore>
 d08:	fea43423          	sd	a0,-24(s0)
 d0c:	fe843783          	ld	a5,-24(s0)
 d10:	e399                	bnez	a5,d16 <malloc+0x11e>
        return 0;
 d12:	4781                	li	a5,0
 d14:	a819                	j	d2a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d16:	fe843783          	ld	a5,-24(s0)
 d1a:	fef43023          	sd	a5,-32(s0)
 d1e:	fe843783          	ld	a5,-24(s0)
 d22:	639c                	ld	a5,0(a5)
 d24:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d28:	b799                	j	c6e <malloc+0x76>
  }
}
 d2a:	853e                	mv	a0,a5
 d2c:	70e2                	ld	ra,56(sp)
 d2e:	7442                	ld	s0,48(sp)
 d30:	6121                	addi	sp,sp,64
 d32:	8082                	ret
