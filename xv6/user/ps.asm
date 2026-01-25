
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include <kernel/types.h>
#include <kernel/stat.h>
#include <user/user.h>


int main(){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    getprocs();
   8:	00000097          	auipc	ra,0x0
   c:	55e080e7          	jalr	1374(ra) # 566 <getprocs>
    exit(0);
  10:	4501                	li	a0,0
  12:	00000097          	auipc	ra,0x0
  16:	4b4080e7          	jalr	1204(ra) # 4c6 <exit>

000000000000001a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  1a:	1141                	addi	sp,sp,-16
  1c:	e406                	sd	ra,8(sp)
  1e:	e022                	sd	s0,0(sp)
  20:	0800                	addi	s0,sp,16
  extern int main();
  main();
  22:	00000097          	auipc	ra,0x0
  26:	fde080e7          	jalr	-34(ra) # 0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	00000097          	auipc	ra,0x0
  30:	49a080e7          	jalr	1178(ra) # 4c6 <exit>

0000000000000034 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  34:	7179                	addi	sp,sp,-48
  36:	f422                	sd	s0,40(sp)
  38:	1800                	addi	s0,sp,48
  3a:	fca43c23          	sd	a0,-40(s0)
  3e:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  42:	fd843783          	ld	a5,-40(s0)
  46:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  4a:	0001                	nop
  4c:	fd043703          	ld	a4,-48(s0)
  50:	00170793          	addi	a5,a4,1
  54:	fcf43823          	sd	a5,-48(s0)
  58:	fd843783          	ld	a5,-40(s0)
  5c:	00178693          	addi	a3,a5,1
  60:	fcd43c23          	sd	a3,-40(s0)
  64:	00074703          	lbu	a4,0(a4)
  68:	00e78023          	sb	a4,0(a5)
  6c:	0007c783          	lbu	a5,0(a5)
  70:	fff1                	bnez	a5,4c <strcpy+0x18>
    ;
  return os;
  72:	fe843783          	ld	a5,-24(s0)
}
  76:	853e                	mv	a0,a5
  78:	7422                	ld	s0,40(sp)
  7a:	6145                	addi	sp,sp,48
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1101                	addi	sp,sp,-32
  80:	ec22                	sd	s0,24(sp)
  82:	1000                	addi	s0,sp,32
  84:	fea43423          	sd	a0,-24(s0)
  88:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
  8c:	a819                	j	a2 <strcmp+0x24>
    p++, q++;
  8e:	fe843783          	ld	a5,-24(s0)
  92:	0785                	addi	a5,a5,1
  94:	fef43423          	sd	a5,-24(s0)
  98:	fe043783          	ld	a5,-32(s0)
  9c:	0785                	addi	a5,a5,1
  9e:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
  a2:	fe843783          	ld	a5,-24(s0)
  a6:	0007c783          	lbu	a5,0(a5)
  aa:	cb99                	beqz	a5,c0 <strcmp+0x42>
  ac:	fe843783          	ld	a5,-24(s0)
  b0:	0007c703          	lbu	a4,0(a5)
  b4:	fe043783          	ld	a5,-32(s0)
  b8:	0007c783          	lbu	a5,0(a5)
  bc:	fcf709e3          	beq	a4,a5,8e <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
  c0:	fe843783          	ld	a5,-24(s0)
  c4:	0007c783          	lbu	a5,0(a5)
  c8:	0007871b          	sext.w	a4,a5
  cc:	fe043783          	ld	a5,-32(s0)
  d0:	0007c783          	lbu	a5,0(a5)
  d4:	2781                	sext.w	a5,a5
  d6:	40f707bb          	subw	a5,a4,a5
  da:	2781                	sext.w	a5,a5
}
  dc:	853e                	mv	a0,a5
  de:	6462                	ld	s0,24(sp)
  e0:	6105                	addi	sp,sp,32
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	7179                	addi	sp,sp,-48
  e6:	f422                	sd	s0,40(sp)
  e8:	1800                	addi	s0,sp,48
  ea:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
  ee:	fe042623          	sw	zero,-20(s0)
  f2:	a031                	j	fe <strlen+0x1a>
  f4:	fec42783          	lw	a5,-20(s0)
  f8:	2785                	addiw	a5,a5,1
  fa:	fef42623          	sw	a5,-20(s0)
  fe:	fec42783          	lw	a5,-20(s0)
 102:	fd843703          	ld	a4,-40(s0)
 106:	97ba                	add	a5,a5,a4
 108:	0007c783          	lbu	a5,0(a5)
 10c:	f7e5                	bnez	a5,f4 <strlen+0x10>
    ;
  return n;
 10e:	fec42783          	lw	a5,-20(s0)
}
 112:	853e                	mv	a0,a5
 114:	7422                	ld	s0,40(sp)
 116:	6145                	addi	sp,sp,48
 118:	8082                	ret

000000000000011a <memset>:

void*
memset(void *dst, int c, uint n)
{
 11a:	7179                	addi	sp,sp,-48
 11c:	f422                	sd	s0,40(sp)
 11e:	1800                	addi	s0,sp,48
 120:	fca43c23          	sd	a0,-40(s0)
 124:	87ae                	mv	a5,a1
 126:	8732                	mv	a4,a2
 128:	fcf42a23          	sw	a5,-44(s0)
 12c:	87ba                	mv	a5,a4
 12e:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 132:	fd843783          	ld	a5,-40(s0)
 136:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 13a:	fe042623          	sw	zero,-20(s0)
 13e:	a00d                	j	160 <memset+0x46>
    cdst[i] = c;
 140:	fec42783          	lw	a5,-20(s0)
 144:	fe043703          	ld	a4,-32(s0)
 148:	97ba                	add	a5,a5,a4
 14a:	fd442703          	lw	a4,-44(s0)
 14e:	0ff77713          	zext.b	a4,a4
 152:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 156:	fec42783          	lw	a5,-20(s0)
 15a:	2785                	addiw	a5,a5,1
 15c:	fef42623          	sw	a5,-20(s0)
 160:	fec42703          	lw	a4,-20(s0)
 164:	fd042783          	lw	a5,-48(s0)
 168:	2781                	sext.w	a5,a5
 16a:	fcf76be3          	bltu	a4,a5,140 <memset+0x26>
  }
  return dst;
 16e:	fd843783          	ld	a5,-40(s0)
}
 172:	853e                	mv	a0,a5
 174:	7422                	ld	s0,40(sp)
 176:	6145                	addi	sp,sp,48
 178:	8082                	ret

000000000000017a <strchr>:

char*
strchr(const char *s, char c)
{
 17a:	1101                	addi	sp,sp,-32
 17c:	ec22                	sd	s0,24(sp)
 17e:	1000                	addi	s0,sp,32
 180:	fea43423          	sd	a0,-24(s0)
 184:	87ae                	mv	a5,a1
 186:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 18a:	a01d                	j	1b0 <strchr+0x36>
    if(*s == c)
 18c:	fe843783          	ld	a5,-24(s0)
 190:	0007c703          	lbu	a4,0(a5)
 194:	fe744783          	lbu	a5,-25(s0)
 198:	0ff7f793          	zext.b	a5,a5
 19c:	00e79563          	bne	a5,a4,1a6 <strchr+0x2c>
      return (char*)s;
 1a0:	fe843783          	ld	a5,-24(s0)
 1a4:	a821                	j	1bc <strchr+0x42>
  for(; *s; s++)
 1a6:	fe843783          	ld	a5,-24(s0)
 1aa:	0785                	addi	a5,a5,1
 1ac:	fef43423          	sd	a5,-24(s0)
 1b0:	fe843783          	ld	a5,-24(s0)
 1b4:	0007c783          	lbu	a5,0(a5)
 1b8:	fbf1                	bnez	a5,18c <strchr+0x12>
  return 0;
 1ba:	4781                	li	a5,0
}
 1bc:	853e                	mv	a0,a5
 1be:	6462                	ld	s0,24(sp)
 1c0:	6105                	addi	sp,sp,32
 1c2:	8082                	ret

00000000000001c4 <gets>:

char*
gets(char *buf, int max)
{
 1c4:	7179                	addi	sp,sp,-48
 1c6:	f406                	sd	ra,40(sp)
 1c8:	f022                	sd	s0,32(sp)
 1ca:	1800                	addi	s0,sp,48
 1cc:	fca43c23          	sd	a0,-40(s0)
 1d0:	87ae                	mv	a5,a1
 1d2:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d6:	fe042623          	sw	zero,-20(s0)
 1da:	a8a1                	j	232 <gets+0x6e>
    cc = read(0, &c, 1);
 1dc:	fe740793          	addi	a5,s0,-25
 1e0:	4605                	li	a2,1
 1e2:	85be                	mv	a1,a5
 1e4:	4501                	li	a0,0
 1e6:	00000097          	auipc	ra,0x0
 1ea:	2f8080e7          	jalr	760(ra) # 4de <read>
 1ee:	87aa                	mv	a5,a0
 1f0:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 1f4:	fe842783          	lw	a5,-24(s0)
 1f8:	2781                	sext.w	a5,a5
 1fa:	04f05763          	blez	a5,248 <gets+0x84>
      break;
    buf[i++] = c;
 1fe:	fec42783          	lw	a5,-20(s0)
 202:	0017871b          	addiw	a4,a5,1
 206:	fee42623          	sw	a4,-20(s0)
 20a:	873e                	mv	a4,a5
 20c:	fd843783          	ld	a5,-40(s0)
 210:	97ba                	add	a5,a5,a4
 212:	fe744703          	lbu	a4,-25(s0)
 216:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 21a:	fe744783          	lbu	a5,-25(s0)
 21e:	873e                	mv	a4,a5
 220:	47a9                	li	a5,10
 222:	02f70463          	beq	a4,a5,24a <gets+0x86>
 226:	fe744783          	lbu	a5,-25(s0)
 22a:	873e                	mv	a4,a5
 22c:	47b5                	li	a5,13
 22e:	00f70e63          	beq	a4,a5,24a <gets+0x86>
  for(i=0; i+1 < max; ){
 232:	fec42783          	lw	a5,-20(s0)
 236:	2785                	addiw	a5,a5,1
 238:	0007871b          	sext.w	a4,a5
 23c:	fd442783          	lw	a5,-44(s0)
 240:	2781                	sext.w	a5,a5
 242:	f8f74de3          	blt	a4,a5,1dc <gets+0x18>
 246:	a011                	j	24a <gets+0x86>
      break;
 248:	0001                	nop
      break;
  }
  buf[i] = '\0';
 24a:	fec42783          	lw	a5,-20(s0)
 24e:	fd843703          	ld	a4,-40(s0)
 252:	97ba                	add	a5,a5,a4
 254:	00078023          	sb	zero,0(a5)
  return buf;
 258:	fd843783          	ld	a5,-40(s0)
}
 25c:	853e                	mv	a0,a5
 25e:	70a2                	ld	ra,40(sp)
 260:	7402                	ld	s0,32(sp)
 262:	6145                	addi	sp,sp,48
 264:	8082                	ret

0000000000000266 <stat>:

int
stat(const char *n, struct stat *st)
{
 266:	7179                	addi	sp,sp,-48
 268:	f406                	sd	ra,40(sp)
 26a:	f022                	sd	s0,32(sp)
 26c:	1800                	addi	s0,sp,48
 26e:	fca43c23          	sd	a0,-40(s0)
 272:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 276:	4581                	li	a1,0
 278:	fd843503          	ld	a0,-40(s0)
 27c:	00000097          	auipc	ra,0x0
 280:	28a080e7          	jalr	650(ra) # 506 <open>
 284:	87aa                	mv	a5,a0
 286:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 28a:	fec42783          	lw	a5,-20(s0)
 28e:	2781                	sext.w	a5,a5
 290:	0007d463          	bgez	a5,298 <stat+0x32>
    return -1;
 294:	57fd                	li	a5,-1
 296:	a035                	j	2c2 <stat+0x5c>
  r = fstat(fd, st);
 298:	fec42783          	lw	a5,-20(s0)
 29c:	fd043583          	ld	a1,-48(s0)
 2a0:	853e                	mv	a0,a5
 2a2:	00000097          	auipc	ra,0x0
 2a6:	27c080e7          	jalr	636(ra) # 51e <fstat>
 2aa:	87aa                	mv	a5,a0
 2ac:	fef42423          	sw	a5,-24(s0)
  close(fd);
 2b0:	fec42783          	lw	a5,-20(s0)
 2b4:	853e                	mv	a0,a5
 2b6:	00000097          	auipc	ra,0x0
 2ba:	238080e7          	jalr	568(ra) # 4ee <close>
  return r;
 2be:	fe842783          	lw	a5,-24(s0)
}
 2c2:	853e                	mv	a0,a5
 2c4:	70a2                	ld	ra,40(sp)
 2c6:	7402                	ld	s0,32(sp)
 2c8:	6145                	addi	sp,sp,48
 2ca:	8082                	ret

00000000000002cc <atoi>:

int
atoi(const char *s)
{
 2cc:	7179                	addi	sp,sp,-48
 2ce:	f422                	sd	s0,40(sp)
 2d0:	1800                	addi	s0,sp,48
 2d2:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 2d6:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 2da:	a81d                	j	310 <atoi+0x44>
    n = n*10 + *s++ - '0';
 2dc:	fec42783          	lw	a5,-20(s0)
 2e0:	873e                	mv	a4,a5
 2e2:	87ba                	mv	a5,a4
 2e4:	0027979b          	slliw	a5,a5,0x2
 2e8:	9fb9                	addw	a5,a5,a4
 2ea:	0017979b          	slliw	a5,a5,0x1
 2ee:	0007871b          	sext.w	a4,a5
 2f2:	fd843783          	ld	a5,-40(s0)
 2f6:	00178693          	addi	a3,a5,1
 2fa:	fcd43c23          	sd	a3,-40(s0)
 2fe:	0007c783          	lbu	a5,0(a5)
 302:	2781                	sext.w	a5,a5
 304:	9fb9                	addw	a5,a5,a4
 306:	2781                	sext.w	a5,a5
 308:	fd07879b          	addiw	a5,a5,-48
 30c:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 310:	fd843783          	ld	a5,-40(s0)
 314:	0007c783          	lbu	a5,0(a5)
 318:	873e                	mv	a4,a5
 31a:	02f00793          	li	a5,47
 31e:	00e7fb63          	bgeu	a5,a4,334 <atoi+0x68>
 322:	fd843783          	ld	a5,-40(s0)
 326:	0007c783          	lbu	a5,0(a5)
 32a:	873e                	mv	a4,a5
 32c:	03900793          	li	a5,57
 330:	fae7f6e3          	bgeu	a5,a4,2dc <atoi+0x10>
  return n;
 334:	fec42783          	lw	a5,-20(s0)
}
 338:	853e                	mv	a0,a5
 33a:	7422                	ld	s0,40(sp)
 33c:	6145                	addi	sp,sp,48
 33e:	8082                	ret

0000000000000340 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 340:	7139                	addi	sp,sp,-64
 342:	fc22                	sd	s0,56(sp)
 344:	0080                	addi	s0,sp,64
 346:	fca43c23          	sd	a0,-40(s0)
 34a:	fcb43823          	sd	a1,-48(s0)
 34e:	87b2                	mv	a5,a2
 350:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 354:	fd843783          	ld	a5,-40(s0)
 358:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 35c:	fd043783          	ld	a5,-48(s0)
 360:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 364:	fe043703          	ld	a4,-32(s0)
 368:	fe843783          	ld	a5,-24(s0)
 36c:	02e7fc63          	bgeu	a5,a4,3a4 <memmove+0x64>
    while(n-- > 0)
 370:	a00d                	j	392 <memmove+0x52>
      *dst++ = *src++;
 372:	fe043703          	ld	a4,-32(s0)
 376:	00170793          	addi	a5,a4,1
 37a:	fef43023          	sd	a5,-32(s0)
 37e:	fe843783          	ld	a5,-24(s0)
 382:	00178693          	addi	a3,a5,1
 386:	fed43423          	sd	a3,-24(s0)
 38a:	00074703          	lbu	a4,0(a4)
 38e:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 392:	fcc42783          	lw	a5,-52(s0)
 396:	fff7871b          	addiw	a4,a5,-1
 39a:	fce42623          	sw	a4,-52(s0)
 39e:	fcf04ae3          	bgtz	a5,372 <memmove+0x32>
 3a2:	a891                	j	3f6 <memmove+0xb6>
  } else {
    dst += n;
 3a4:	fcc42783          	lw	a5,-52(s0)
 3a8:	fe843703          	ld	a4,-24(s0)
 3ac:	97ba                	add	a5,a5,a4
 3ae:	fef43423          	sd	a5,-24(s0)
    src += n;
 3b2:	fcc42783          	lw	a5,-52(s0)
 3b6:	fe043703          	ld	a4,-32(s0)
 3ba:	97ba                	add	a5,a5,a4
 3bc:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 3c0:	a01d                	j	3e6 <memmove+0xa6>
      *--dst = *--src;
 3c2:	fe043783          	ld	a5,-32(s0)
 3c6:	17fd                	addi	a5,a5,-1
 3c8:	fef43023          	sd	a5,-32(s0)
 3cc:	fe843783          	ld	a5,-24(s0)
 3d0:	17fd                	addi	a5,a5,-1
 3d2:	fef43423          	sd	a5,-24(s0)
 3d6:	fe043783          	ld	a5,-32(s0)
 3da:	0007c703          	lbu	a4,0(a5)
 3de:	fe843783          	ld	a5,-24(s0)
 3e2:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3e6:	fcc42783          	lw	a5,-52(s0)
 3ea:	fff7871b          	addiw	a4,a5,-1
 3ee:	fce42623          	sw	a4,-52(s0)
 3f2:	fcf048e3          	bgtz	a5,3c2 <memmove+0x82>
  }
  return vdst;
 3f6:	fd843783          	ld	a5,-40(s0)
}
 3fa:	853e                	mv	a0,a5
 3fc:	7462                	ld	s0,56(sp)
 3fe:	6121                	addi	sp,sp,64
 400:	8082                	ret

0000000000000402 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 402:	7139                	addi	sp,sp,-64
 404:	fc22                	sd	s0,56(sp)
 406:	0080                	addi	s0,sp,64
 408:	fca43c23          	sd	a0,-40(s0)
 40c:	fcb43823          	sd	a1,-48(s0)
 410:	87b2                	mv	a5,a2
 412:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 416:	fd843783          	ld	a5,-40(s0)
 41a:	fef43423          	sd	a5,-24(s0)
 41e:	fd043783          	ld	a5,-48(s0)
 422:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 426:	a0a1                	j	46e <memcmp+0x6c>
    if (*p1 != *p2) {
 428:	fe843783          	ld	a5,-24(s0)
 42c:	0007c703          	lbu	a4,0(a5)
 430:	fe043783          	ld	a5,-32(s0)
 434:	0007c783          	lbu	a5,0(a5)
 438:	02f70163          	beq	a4,a5,45a <memcmp+0x58>
      return *p1 - *p2;
 43c:	fe843783          	ld	a5,-24(s0)
 440:	0007c783          	lbu	a5,0(a5)
 444:	0007871b          	sext.w	a4,a5
 448:	fe043783          	ld	a5,-32(s0)
 44c:	0007c783          	lbu	a5,0(a5)
 450:	2781                	sext.w	a5,a5
 452:	40f707bb          	subw	a5,a4,a5
 456:	2781                	sext.w	a5,a5
 458:	a01d                	j	47e <memcmp+0x7c>
    }
    p1++;
 45a:	fe843783          	ld	a5,-24(s0)
 45e:	0785                	addi	a5,a5,1
 460:	fef43423          	sd	a5,-24(s0)
    p2++;
 464:	fe043783          	ld	a5,-32(s0)
 468:	0785                	addi	a5,a5,1
 46a:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 46e:	fcc42783          	lw	a5,-52(s0)
 472:	fff7871b          	addiw	a4,a5,-1
 476:	fce42623          	sw	a4,-52(s0)
 47a:	f7dd                	bnez	a5,428 <memcmp+0x26>
  }
  return 0;
 47c:	4781                	li	a5,0
}
 47e:	853e                	mv	a0,a5
 480:	7462                	ld	s0,56(sp)
 482:	6121                	addi	sp,sp,64
 484:	8082                	ret

0000000000000486 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 486:	7179                	addi	sp,sp,-48
 488:	f406                	sd	ra,40(sp)
 48a:	f022                	sd	s0,32(sp)
 48c:	1800                	addi	s0,sp,48
 48e:	fea43423          	sd	a0,-24(s0)
 492:	feb43023          	sd	a1,-32(s0)
 496:	87b2                	mv	a5,a2
 498:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 49c:	fdc42783          	lw	a5,-36(s0)
 4a0:	863e                	mv	a2,a5
 4a2:	fe043583          	ld	a1,-32(s0)
 4a6:	fe843503          	ld	a0,-24(s0)
 4aa:	00000097          	auipc	ra,0x0
 4ae:	e96080e7          	jalr	-362(ra) # 340 <memmove>
 4b2:	87aa                	mv	a5,a0
}
 4b4:	853e                	mv	a0,a5
 4b6:	70a2                	ld	ra,40(sp)
 4b8:	7402                	ld	s0,32(sp)
 4ba:	6145                	addi	sp,sp,48
 4bc:	8082                	ret

00000000000004be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4be:	4885                	li	a7,1
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4c6:	4889                	li	a7,2
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ce:	488d                	li	a7,3
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4d6:	4891                	li	a7,4
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <read>:
.global read
read:
 li a7, SYS_read
 4de:	4895                	li	a7,5
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <write>:
.global write
write:
 li a7, SYS_write
 4e6:	48c1                	li	a7,16
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <close>:
.global close
close:
 li a7, SYS_close
 4ee:	48d5                	li	a7,21
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4f6:	4899                	li	a7,6
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 4fe:	489d                	li	a7,7
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <open>:
.global open
open:
 li a7, SYS_open
 506:	48bd                	li	a7,15
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 50e:	48c5                	li	a7,17
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 516:	48c9                	li	a7,18
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 51e:	48a1                	li	a7,8
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <link>:
.global link
link:
 li a7, SYS_link
 526:	48cd                	li	a7,19
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 52e:	48d1                	li	a7,20
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 536:	48a5                	li	a7,9
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <dup>:
.global dup
dup:
 li a7, SYS_dup
 53e:	48a9                	li	a7,10
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 546:	48ad                	li	a7,11
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 54e:	48b1                	li	a7,12
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 556:	48b5                	li	a7,13
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 55e:	48b9                	li	a7,14
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 566:	48d9                	li	a7,22
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56e:	1101                	addi	sp,sp,-32
 570:	ec06                	sd	ra,24(sp)
 572:	e822                	sd	s0,16(sp)
 574:	1000                	addi	s0,sp,32
 576:	87aa                	mv	a5,a0
 578:	872e                	mv	a4,a1
 57a:	fef42623          	sw	a5,-20(s0)
 57e:	87ba                	mv	a5,a4
 580:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 584:	feb40713          	addi	a4,s0,-21
 588:	fec42783          	lw	a5,-20(s0)
 58c:	4605                	li	a2,1
 58e:	85ba                	mv	a1,a4
 590:	853e                	mv	a0,a5
 592:	00000097          	auipc	ra,0x0
 596:	f54080e7          	jalr	-172(ra) # 4e6 <write>
}
 59a:	0001                	nop
 59c:	60e2                	ld	ra,24(sp)
 59e:	6442                	ld	s0,16(sp)
 5a0:	6105                	addi	sp,sp,32
 5a2:	8082                	ret

00000000000005a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a4:	7139                	addi	sp,sp,-64
 5a6:	fc06                	sd	ra,56(sp)
 5a8:	f822                	sd	s0,48(sp)
 5aa:	0080                	addi	s0,sp,64
 5ac:	87aa                	mv	a5,a0
 5ae:	8736                	mv	a4,a3
 5b0:	fcf42623          	sw	a5,-52(s0)
 5b4:	87ae                	mv	a5,a1
 5b6:	fcf42423          	sw	a5,-56(s0)
 5ba:	87b2                	mv	a5,a2
 5bc:	fcf42223          	sw	a5,-60(s0)
 5c0:	87ba                	mv	a5,a4
 5c2:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5c6:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 5ca:	fc042783          	lw	a5,-64(s0)
 5ce:	2781                	sext.w	a5,a5
 5d0:	c38d                	beqz	a5,5f2 <printint+0x4e>
 5d2:	fc842783          	lw	a5,-56(s0)
 5d6:	2781                	sext.w	a5,a5
 5d8:	0007dd63          	bgez	a5,5f2 <printint+0x4e>
    neg = 1;
 5dc:	4785                	li	a5,1
 5de:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 5e2:	fc842783          	lw	a5,-56(s0)
 5e6:	40f007bb          	negw	a5,a5
 5ea:	2781                	sext.w	a5,a5
 5ec:	fef42223          	sw	a5,-28(s0)
 5f0:	a029                	j	5fa <printint+0x56>
  } else {
    x = xx;
 5f2:	fc842783          	lw	a5,-56(s0)
 5f6:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 5fa:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 5fe:	fc442783          	lw	a5,-60(s0)
 602:	fe442703          	lw	a4,-28(s0)
 606:	02f777bb          	remuw	a5,a4,a5
 60a:	0007861b          	sext.w	a2,a5
 60e:	fec42783          	lw	a5,-20(s0)
 612:	0017871b          	addiw	a4,a5,1
 616:	fee42623          	sw	a4,-20(s0)
 61a:	00001697          	auipc	a3,0x1
 61e:	d5668693          	addi	a3,a3,-682 # 1370 <digits>
 622:	02061713          	slli	a4,a2,0x20
 626:	9301                	srli	a4,a4,0x20
 628:	9736                	add	a4,a4,a3
 62a:	00074703          	lbu	a4,0(a4)
 62e:	17c1                	addi	a5,a5,-16
 630:	97a2                	add	a5,a5,s0
 632:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 636:	fc442783          	lw	a5,-60(s0)
 63a:	fe442703          	lw	a4,-28(s0)
 63e:	02f757bb          	divuw	a5,a4,a5
 642:	fef42223          	sw	a5,-28(s0)
 646:	fe442783          	lw	a5,-28(s0)
 64a:	2781                	sext.w	a5,a5
 64c:	fbcd                	bnez	a5,5fe <printint+0x5a>
  if(neg)
 64e:	fe842783          	lw	a5,-24(s0)
 652:	2781                	sext.w	a5,a5
 654:	cf85                	beqz	a5,68c <printint+0xe8>
    buf[i++] = '-';
 656:	fec42783          	lw	a5,-20(s0)
 65a:	0017871b          	addiw	a4,a5,1
 65e:	fee42623          	sw	a4,-20(s0)
 662:	17c1                	addi	a5,a5,-16
 664:	97a2                	add	a5,a5,s0
 666:	02d00713          	li	a4,45
 66a:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 66e:	a839                	j	68c <printint+0xe8>
    putc(fd, buf[i]);
 670:	fec42783          	lw	a5,-20(s0)
 674:	17c1                	addi	a5,a5,-16
 676:	97a2                	add	a5,a5,s0
 678:	fe07c703          	lbu	a4,-32(a5)
 67c:	fcc42783          	lw	a5,-52(s0)
 680:	85ba                	mv	a1,a4
 682:	853e                	mv	a0,a5
 684:	00000097          	auipc	ra,0x0
 688:	eea080e7          	jalr	-278(ra) # 56e <putc>
  while(--i >= 0)
 68c:	fec42783          	lw	a5,-20(s0)
 690:	37fd                	addiw	a5,a5,-1
 692:	fef42623          	sw	a5,-20(s0)
 696:	fec42783          	lw	a5,-20(s0)
 69a:	2781                	sext.w	a5,a5
 69c:	fc07dae3          	bgez	a5,670 <printint+0xcc>
}
 6a0:	0001                	nop
 6a2:	0001                	nop
 6a4:	70e2                	ld	ra,56(sp)
 6a6:	7442                	ld	s0,48(sp)
 6a8:	6121                	addi	sp,sp,64
 6aa:	8082                	ret

00000000000006ac <printptr>:

static void
printptr(int fd, uint64 x) {
 6ac:	7179                	addi	sp,sp,-48
 6ae:	f406                	sd	ra,40(sp)
 6b0:	f022                	sd	s0,32(sp)
 6b2:	1800                	addi	s0,sp,48
 6b4:	87aa                	mv	a5,a0
 6b6:	fcb43823          	sd	a1,-48(s0)
 6ba:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 6be:	fdc42783          	lw	a5,-36(s0)
 6c2:	03000593          	li	a1,48
 6c6:	853e                	mv	a0,a5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	ea6080e7          	jalr	-346(ra) # 56e <putc>
  putc(fd, 'x');
 6d0:	fdc42783          	lw	a5,-36(s0)
 6d4:	07800593          	li	a1,120
 6d8:	853e                	mv	a0,a5
 6da:	00000097          	auipc	ra,0x0
 6de:	e94080e7          	jalr	-364(ra) # 56e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e2:	fe042623          	sw	zero,-20(s0)
 6e6:	a82d                	j	720 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e8:	fd043783          	ld	a5,-48(s0)
 6ec:	93f1                	srli	a5,a5,0x3c
 6ee:	00001717          	auipc	a4,0x1
 6f2:	c8270713          	addi	a4,a4,-894 # 1370 <digits>
 6f6:	97ba                	add	a5,a5,a4
 6f8:	0007c703          	lbu	a4,0(a5)
 6fc:	fdc42783          	lw	a5,-36(s0)
 700:	85ba                	mv	a1,a4
 702:	853e                	mv	a0,a5
 704:	00000097          	auipc	ra,0x0
 708:	e6a080e7          	jalr	-406(ra) # 56e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70c:	fec42783          	lw	a5,-20(s0)
 710:	2785                	addiw	a5,a5,1
 712:	fef42623          	sw	a5,-20(s0)
 716:	fd043783          	ld	a5,-48(s0)
 71a:	0792                	slli	a5,a5,0x4
 71c:	fcf43823          	sd	a5,-48(s0)
 720:	fec42783          	lw	a5,-20(s0)
 724:	873e                	mv	a4,a5
 726:	47bd                	li	a5,15
 728:	fce7f0e3          	bgeu	a5,a4,6e8 <printptr+0x3c>
}
 72c:	0001                	nop
 72e:	0001                	nop
 730:	70a2                	ld	ra,40(sp)
 732:	7402                	ld	s0,32(sp)
 734:	6145                	addi	sp,sp,48
 736:	8082                	ret

0000000000000738 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 738:	715d                	addi	sp,sp,-80
 73a:	e486                	sd	ra,72(sp)
 73c:	e0a2                	sd	s0,64(sp)
 73e:	0880                	addi	s0,sp,80
 740:	87aa                	mv	a5,a0
 742:	fcb43023          	sd	a1,-64(s0)
 746:	fac43c23          	sd	a2,-72(s0)
 74a:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 74e:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 752:	fe042223          	sw	zero,-28(s0)
 756:	a42d                	j	980 <vprintf+0x248>
    c = fmt[i] & 0xff;
 758:	fe442783          	lw	a5,-28(s0)
 75c:	fc043703          	ld	a4,-64(s0)
 760:	97ba                	add	a5,a5,a4
 762:	0007c783          	lbu	a5,0(a5)
 766:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 76a:	fe042783          	lw	a5,-32(s0)
 76e:	2781                	sext.w	a5,a5
 770:	eb9d                	bnez	a5,7a6 <vprintf+0x6e>
      if(c == '%'){
 772:	fdc42783          	lw	a5,-36(s0)
 776:	0007871b          	sext.w	a4,a5
 77a:	02500793          	li	a5,37
 77e:	00f71763          	bne	a4,a5,78c <vprintf+0x54>
        state = '%';
 782:	02500793          	li	a5,37
 786:	fef42023          	sw	a5,-32(s0)
 78a:	a2f5                	j	976 <vprintf+0x23e>
      } else {
        putc(fd, c);
 78c:	fdc42783          	lw	a5,-36(s0)
 790:	0ff7f713          	zext.b	a4,a5
 794:	fcc42783          	lw	a5,-52(s0)
 798:	85ba                	mv	a1,a4
 79a:	853e                	mv	a0,a5
 79c:	00000097          	auipc	ra,0x0
 7a0:	dd2080e7          	jalr	-558(ra) # 56e <putc>
 7a4:	aac9                	j	976 <vprintf+0x23e>
      }
    } else if(state == '%'){
 7a6:	fe042783          	lw	a5,-32(s0)
 7aa:	0007871b          	sext.w	a4,a5
 7ae:	02500793          	li	a5,37
 7b2:	1cf71263          	bne	a4,a5,976 <vprintf+0x23e>
      if(c == 'd'){
 7b6:	fdc42783          	lw	a5,-36(s0)
 7ba:	0007871b          	sext.w	a4,a5
 7be:	06400793          	li	a5,100
 7c2:	02f71463          	bne	a4,a5,7ea <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 7c6:	fb843783          	ld	a5,-72(s0)
 7ca:	00878713          	addi	a4,a5,8
 7ce:	fae43c23          	sd	a4,-72(s0)
 7d2:	4398                	lw	a4,0(a5)
 7d4:	fcc42783          	lw	a5,-52(s0)
 7d8:	4685                	li	a3,1
 7da:	4629                	li	a2,10
 7dc:	85ba                	mv	a1,a4
 7de:	853e                	mv	a0,a5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	dc4080e7          	jalr	-572(ra) # 5a4 <printint>
 7e8:	a269                	j	972 <vprintf+0x23a>
      } else if(c == 'l') {
 7ea:	fdc42783          	lw	a5,-36(s0)
 7ee:	0007871b          	sext.w	a4,a5
 7f2:	06c00793          	li	a5,108
 7f6:	02f71663          	bne	a4,a5,822 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fa:	fb843783          	ld	a5,-72(s0)
 7fe:	00878713          	addi	a4,a5,8
 802:	fae43c23          	sd	a4,-72(s0)
 806:	639c                	ld	a5,0(a5)
 808:	0007871b          	sext.w	a4,a5
 80c:	fcc42783          	lw	a5,-52(s0)
 810:	4681                	li	a3,0
 812:	4629                	li	a2,10
 814:	85ba                	mv	a1,a4
 816:	853e                	mv	a0,a5
 818:	00000097          	auipc	ra,0x0
 81c:	d8c080e7          	jalr	-628(ra) # 5a4 <printint>
 820:	aa89                	j	972 <vprintf+0x23a>
      } else if(c == 'x') {
 822:	fdc42783          	lw	a5,-36(s0)
 826:	0007871b          	sext.w	a4,a5
 82a:	07800793          	li	a5,120
 82e:	02f71463          	bne	a4,a5,856 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 832:	fb843783          	ld	a5,-72(s0)
 836:	00878713          	addi	a4,a5,8
 83a:	fae43c23          	sd	a4,-72(s0)
 83e:	4398                	lw	a4,0(a5)
 840:	fcc42783          	lw	a5,-52(s0)
 844:	4681                	li	a3,0
 846:	4641                	li	a2,16
 848:	85ba                	mv	a1,a4
 84a:	853e                	mv	a0,a5
 84c:	00000097          	auipc	ra,0x0
 850:	d58080e7          	jalr	-680(ra) # 5a4 <printint>
 854:	aa39                	j	972 <vprintf+0x23a>
      } else if(c == 'p') {
 856:	fdc42783          	lw	a5,-36(s0)
 85a:	0007871b          	sext.w	a4,a5
 85e:	07000793          	li	a5,112
 862:	02f71263          	bne	a4,a5,886 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 866:	fb843783          	ld	a5,-72(s0)
 86a:	00878713          	addi	a4,a5,8
 86e:	fae43c23          	sd	a4,-72(s0)
 872:	6398                	ld	a4,0(a5)
 874:	fcc42783          	lw	a5,-52(s0)
 878:	85ba                	mv	a1,a4
 87a:	853e                	mv	a0,a5
 87c:	00000097          	auipc	ra,0x0
 880:	e30080e7          	jalr	-464(ra) # 6ac <printptr>
 884:	a0fd                	j	972 <vprintf+0x23a>
      } else if(c == 's'){
 886:	fdc42783          	lw	a5,-36(s0)
 88a:	0007871b          	sext.w	a4,a5
 88e:	07300793          	li	a5,115
 892:	04f71c63          	bne	a4,a5,8ea <vprintf+0x1b2>
        s = va_arg(ap, char*);
 896:	fb843783          	ld	a5,-72(s0)
 89a:	00878713          	addi	a4,a5,8
 89e:	fae43c23          	sd	a4,-72(s0)
 8a2:	639c                	ld	a5,0(a5)
 8a4:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8a8:	fe843783          	ld	a5,-24(s0)
 8ac:	eb8d                	bnez	a5,8de <vprintf+0x1a6>
          s = "(null)";
 8ae:	00000797          	auipc	a5,0x0
 8b2:	48278793          	addi	a5,a5,1154 # d30 <malloc+0x148>
 8b6:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8ba:	a015                	j	8de <vprintf+0x1a6>
          putc(fd, *s);
 8bc:	fe843783          	ld	a5,-24(s0)
 8c0:	0007c703          	lbu	a4,0(a5)
 8c4:	fcc42783          	lw	a5,-52(s0)
 8c8:	85ba                	mv	a1,a4
 8ca:	853e                	mv	a0,a5
 8cc:	00000097          	auipc	ra,0x0
 8d0:	ca2080e7          	jalr	-862(ra) # 56e <putc>
          s++;
 8d4:	fe843783          	ld	a5,-24(s0)
 8d8:	0785                	addi	a5,a5,1
 8da:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8de:	fe843783          	ld	a5,-24(s0)
 8e2:	0007c783          	lbu	a5,0(a5)
 8e6:	fbf9                	bnez	a5,8bc <vprintf+0x184>
 8e8:	a069                	j	972 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 8ea:	fdc42783          	lw	a5,-36(s0)
 8ee:	0007871b          	sext.w	a4,a5
 8f2:	06300793          	li	a5,99
 8f6:	02f71463          	bne	a4,a5,91e <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 8fa:	fb843783          	ld	a5,-72(s0)
 8fe:	00878713          	addi	a4,a5,8
 902:	fae43c23          	sd	a4,-72(s0)
 906:	439c                	lw	a5,0(a5)
 908:	0ff7f713          	zext.b	a4,a5
 90c:	fcc42783          	lw	a5,-52(s0)
 910:	85ba                	mv	a1,a4
 912:	853e                	mv	a0,a5
 914:	00000097          	auipc	ra,0x0
 918:	c5a080e7          	jalr	-934(ra) # 56e <putc>
 91c:	a899                	j	972 <vprintf+0x23a>
      } else if(c == '%'){
 91e:	fdc42783          	lw	a5,-36(s0)
 922:	0007871b          	sext.w	a4,a5
 926:	02500793          	li	a5,37
 92a:	00f71f63          	bne	a4,a5,948 <vprintf+0x210>
        putc(fd, c);
 92e:	fdc42783          	lw	a5,-36(s0)
 932:	0ff7f713          	zext.b	a4,a5
 936:	fcc42783          	lw	a5,-52(s0)
 93a:	85ba                	mv	a1,a4
 93c:	853e                	mv	a0,a5
 93e:	00000097          	auipc	ra,0x0
 942:	c30080e7          	jalr	-976(ra) # 56e <putc>
 946:	a035                	j	972 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 948:	fcc42783          	lw	a5,-52(s0)
 94c:	02500593          	li	a1,37
 950:	853e                	mv	a0,a5
 952:	00000097          	auipc	ra,0x0
 956:	c1c080e7          	jalr	-996(ra) # 56e <putc>
        putc(fd, c);
 95a:	fdc42783          	lw	a5,-36(s0)
 95e:	0ff7f713          	zext.b	a4,a5
 962:	fcc42783          	lw	a5,-52(s0)
 966:	85ba                	mv	a1,a4
 968:	853e                	mv	a0,a5
 96a:	00000097          	auipc	ra,0x0
 96e:	c04080e7          	jalr	-1020(ra) # 56e <putc>
      }
      state = 0;
 972:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 976:	fe442783          	lw	a5,-28(s0)
 97a:	2785                	addiw	a5,a5,1
 97c:	fef42223          	sw	a5,-28(s0)
 980:	fe442783          	lw	a5,-28(s0)
 984:	fc043703          	ld	a4,-64(s0)
 988:	97ba                	add	a5,a5,a4
 98a:	0007c783          	lbu	a5,0(a5)
 98e:	dc0795e3          	bnez	a5,758 <vprintf+0x20>
    }
  }
}
 992:	0001                	nop
 994:	0001                	nop
 996:	60a6                	ld	ra,72(sp)
 998:	6406                	ld	s0,64(sp)
 99a:	6161                	addi	sp,sp,80
 99c:	8082                	ret

000000000000099e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 99e:	7159                	addi	sp,sp,-112
 9a0:	fc06                	sd	ra,56(sp)
 9a2:	f822                	sd	s0,48(sp)
 9a4:	0080                	addi	s0,sp,64
 9a6:	fcb43823          	sd	a1,-48(s0)
 9aa:	e010                	sd	a2,0(s0)
 9ac:	e414                	sd	a3,8(s0)
 9ae:	e818                	sd	a4,16(s0)
 9b0:	ec1c                	sd	a5,24(s0)
 9b2:	03043023          	sd	a6,32(s0)
 9b6:	03143423          	sd	a7,40(s0)
 9ba:	87aa                	mv	a5,a0
 9bc:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 9c0:	03040793          	addi	a5,s0,48
 9c4:	fcf43423          	sd	a5,-56(s0)
 9c8:	fc843783          	ld	a5,-56(s0)
 9cc:	fd078793          	addi	a5,a5,-48
 9d0:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 9d4:	fe843703          	ld	a4,-24(s0)
 9d8:	fdc42783          	lw	a5,-36(s0)
 9dc:	863a                	mv	a2,a4
 9de:	fd043583          	ld	a1,-48(s0)
 9e2:	853e                	mv	a0,a5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	d54080e7          	jalr	-684(ra) # 738 <vprintf>
}
 9ec:	0001                	nop
 9ee:	70e2                	ld	ra,56(sp)
 9f0:	7442                	ld	s0,48(sp)
 9f2:	6165                	addi	sp,sp,112
 9f4:	8082                	ret

00000000000009f6 <printf>:

void
printf(const char *fmt, ...)
{
 9f6:	7159                	addi	sp,sp,-112
 9f8:	f406                	sd	ra,40(sp)
 9fa:	f022                	sd	s0,32(sp)
 9fc:	1800                	addi	s0,sp,48
 9fe:	fca43c23          	sd	a0,-40(s0)
 a02:	e40c                	sd	a1,8(s0)
 a04:	e810                	sd	a2,16(s0)
 a06:	ec14                	sd	a3,24(s0)
 a08:	f018                	sd	a4,32(s0)
 a0a:	f41c                	sd	a5,40(s0)
 a0c:	03043823          	sd	a6,48(s0)
 a10:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a14:	04040793          	addi	a5,s0,64
 a18:	fcf43823          	sd	a5,-48(s0)
 a1c:	fd043783          	ld	a5,-48(s0)
 a20:	fc878793          	addi	a5,a5,-56
 a24:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a28:	fe843783          	ld	a5,-24(s0)
 a2c:	863e                	mv	a2,a5
 a2e:	fd843583          	ld	a1,-40(s0)
 a32:	4505                	li	a0,1
 a34:	00000097          	auipc	ra,0x0
 a38:	d04080e7          	jalr	-764(ra) # 738 <vprintf>
}
 a3c:	0001                	nop
 a3e:	70a2                	ld	ra,40(sp)
 a40:	7402                	ld	s0,32(sp)
 a42:	6165                	addi	sp,sp,112
 a44:	8082                	ret

0000000000000a46 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a46:	7179                	addi	sp,sp,-48
 a48:	f422                	sd	s0,40(sp)
 a4a:	1800                	addi	s0,sp,48
 a4c:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a50:	fd843783          	ld	a5,-40(s0)
 a54:	17c1                	addi	a5,a5,-16
 a56:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a5a:	00001797          	auipc	a5,0x1
 a5e:	94678793          	addi	a5,a5,-1722 # 13a0 <freep>
 a62:	639c                	ld	a5,0(a5)
 a64:	fef43423          	sd	a5,-24(s0)
 a68:	a815                	j	a9c <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a6a:	fe843783          	ld	a5,-24(s0)
 a6e:	639c                	ld	a5,0(a5)
 a70:	fe843703          	ld	a4,-24(s0)
 a74:	00f76f63          	bltu	a4,a5,a92 <free+0x4c>
 a78:	fe043703          	ld	a4,-32(s0)
 a7c:	fe843783          	ld	a5,-24(s0)
 a80:	02e7eb63          	bltu	a5,a4,ab6 <free+0x70>
 a84:	fe843783          	ld	a5,-24(s0)
 a88:	639c                	ld	a5,0(a5)
 a8a:	fe043703          	ld	a4,-32(s0)
 a8e:	02f76463          	bltu	a4,a5,ab6 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a92:	fe843783          	ld	a5,-24(s0)
 a96:	639c                	ld	a5,0(a5)
 a98:	fef43423          	sd	a5,-24(s0)
 a9c:	fe043703          	ld	a4,-32(s0)
 aa0:	fe843783          	ld	a5,-24(s0)
 aa4:	fce7f3e3          	bgeu	a5,a4,a6a <free+0x24>
 aa8:	fe843783          	ld	a5,-24(s0)
 aac:	639c                	ld	a5,0(a5)
 aae:	fe043703          	ld	a4,-32(s0)
 ab2:	faf77ce3          	bgeu	a4,a5,a6a <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ab6:	fe043783          	ld	a5,-32(s0)
 aba:	479c                	lw	a5,8(a5)
 abc:	1782                	slli	a5,a5,0x20
 abe:	9381                	srli	a5,a5,0x20
 ac0:	0792                	slli	a5,a5,0x4
 ac2:	fe043703          	ld	a4,-32(s0)
 ac6:	973e                	add	a4,a4,a5
 ac8:	fe843783          	ld	a5,-24(s0)
 acc:	639c                	ld	a5,0(a5)
 ace:	02f71763          	bne	a4,a5,afc <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 ad2:	fe043783          	ld	a5,-32(s0)
 ad6:	4798                	lw	a4,8(a5)
 ad8:	fe843783          	ld	a5,-24(s0)
 adc:	639c                	ld	a5,0(a5)
 ade:	479c                	lw	a5,8(a5)
 ae0:	9fb9                	addw	a5,a5,a4
 ae2:	0007871b          	sext.w	a4,a5
 ae6:	fe043783          	ld	a5,-32(s0)
 aea:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 aec:	fe843783          	ld	a5,-24(s0)
 af0:	639c                	ld	a5,0(a5)
 af2:	6398                	ld	a4,0(a5)
 af4:	fe043783          	ld	a5,-32(s0)
 af8:	e398                	sd	a4,0(a5)
 afa:	a039                	j	b08 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 afc:	fe843783          	ld	a5,-24(s0)
 b00:	6398                	ld	a4,0(a5)
 b02:	fe043783          	ld	a5,-32(s0)
 b06:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b08:	fe843783          	ld	a5,-24(s0)
 b0c:	479c                	lw	a5,8(a5)
 b0e:	1782                	slli	a5,a5,0x20
 b10:	9381                	srli	a5,a5,0x20
 b12:	0792                	slli	a5,a5,0x4
 b14:	fe843703          	ld	a4,-24(s0)
 b18:	97ba                	add	a5,a5,a4
 b1a:	fe043703          	ld	a4,-32(s0)
 b1e:	02f71563          	bne	a4,a5,b48 <free+0x102>
    p->s.size += bp->s.size;
 b22:	fe843783          	ld	a5,-24(s0)
 b26:	4798                	lw	a4,8(a5)
 b28:	fe043783          	ld	a5,-32(s0)
 b2c:	479c                	lw	a5,8(a5)
 b2e:	9fb9                	addw	a5,a5,a4
 b30:	0007871b          	sext.w	a4,a5
 b34:	fe843783          	ld	a5,-24(s0)
 b38:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b3a:	fe043783          	ld	a5,-32(s0)
 b3e:	6398                	ld	a4,0(a5)
 b40:	fe843783          	ld	a5,-24(s0)
 b44:	e398                	sd	a4,0(a5)
 b46:	a031                	j	b52 <free+0x10c>
  } else
    p->s.ptr = bp;
 b48:	fe843783          	ld	a5,-24(s0)
 b4c:	fe043703          	ld	a4,-32(s0)
 b50:	e398                	sd	a4,0(a5)
  freep = p;
 b52:	00001797          	auipc	a5,0x1
 b56:	84e78793          	addi	a5,a5,-1970 # 13a0 <freep>
 b5a:	fe843703          	ld	a4,-24(s0)
 b5e:	e398                	sd	a4,0(a5)
}
 b60:	0001                	nop
 b62:	7422                	ld	s0,40(sp)
 b64:	6145                	addi	sp,sp,48
 b66:	8082                	ret

0000000000000b68 <morecore>:

static Header*
morecore(uint nu)
{
 b68:	7179                	addi	sp,sp,-48
 b6a:	f406                	sd	ra,40(sp)
 b6c:	f022                	sd	s0,32(sp)
 b6e:	1800                	addi	s0,sp,48
 b70:	87aa                	mv	a5,a0
 b72:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 b76:	fdc42783          	lw	a5,-36(s0)
 b7a:	0007871b          	sext.w	a4,a5
 b7e:	6785                	lui	a5,0x1
 b80:	00f77563          	bgeu	a4,a5,b8a <morecore+0x22>
    nu = 4096;
 b84:	6785                	lui	a5,0x1
 b86:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 b8a:	fdc42783          	lw	a5,-36(s0)
 b8e:	0047979b          	slliw	a5,a5,0x4
 b92:	2781                	sext.w	a5,a5
 b94:	2781                	sext.w	a5,a5
 b96:	853e                	mv	a0,a5
 b98:	00000097          	auipc	ra,0x0
 b9c:	9b6080e7          	jalr	-1610(ra) # 54e <sbrk>
 ba0:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 ba4:	fe843703          	ld	a4,-24(s0)
 ba8:	57fd                	li	a5,-1
 baa:	00f71463          	bne	a4,a5,bb2 <morecore+0x4a>
    return 0;
 bae:	4781                	li	a5,0
 bb0:	a03d                	j	bde <morecore+0x76>
  hp = (Header*)p;
 bb2:	fe843783          	ld	a5,-24(s0)
 bb6:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 bba:	fe043783          	ld	a5,-32(s0)
 bbe:	fdc42703          	lw	a4,-36(s0)
 bc2:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 bc4:	fe043783          	ld	a5,-32(s0)
 bc8:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x428>
 bca:	853e                	mv	a0,a5
 bcc:	00000097          	auipc	ra,0x0
 bd0:	e7a080e7          	jalr	-390(ra) # a46 <free>
  return freep;
 bd4:	00000797          	auipc	a5,0x0
 bd8:	7cc78793          	addi	a5,a5,1996 # 13a0 <freep>
 bdc:	639c                	ld	a5,0(a5)
}
 bde:	853e                	mv	a0,a5
 be0:	70a2                	ld	ra,40(sp)
 be2:	7402                	ld	s0,32(sp)
 be4:	6145                	addi	sp,sp,48
 be6:	8082                	ret

0000000000000be8 <malloc>:

void*
malloc(uint nbytes)
{
 be8:	7139                	addi	sp,sp,-64
 bea:	fc06                	sd	ra,56(sp)
 bec:	f822                	sd	s0,48(sp)
 bee:	0080                	addi	s0,sp,64
 bf0:	87aa                	mv	a5,a0
 bf2:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bf6:	fcc46783          	lwu	a5,-52(s0)
 bfa:	07bd                	addi	a5,a5,15
 bfc:	8391                	srli	a5,a5,0x4
 bfe:	2781                	sext.w	a5,a5
 c00:	2785                	addiw	a5,a5,1
 c02:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c06:	00000797          	auipc	a5,0x0
 c0a:	79a78793          	addi	a5,a5,1946 # 13a0 <freep>
 c0e:	639c                	ld	a5,0(a5)
 c10:	fef43023          	sd	a5,-32(s0)
 c14:	fe043783          	ld	a5,-32(s0)
 c18:	ef95                	bnez	a5,c54 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c1a:	00000797          	auipc	a5,0x0
 c1e:	77678793          	addi	a5,a5,1910 # 1390 <base>
 c22:	fef43023          	sd	a5,-32(s0)
 c26:	00000797          	auipc	a5,0x0
 c2a:	77a78793          	addi	a5,a5,1914 # 13a0 <freep>
 c2e:	fe043703          	ld	a4,-32(s0)
 c32:	e398                	sd	a4,0(a5)
 c34:	00000797          	auipc	a5,0x0
 c38:	76c78793          	addi	a5,a5,1900 # 13a0 <freep>
 c3c:	6398                	ld	a4,0(a5)
 c3e:	00000797          	auipc	a5,0x0
 c42:	75278793          	addi	a5,a5,1874 # 1390 <base>
 c46:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c48:	00000797          	auipc	a5,0x0
 c4c:	74878793          	addi	a5,a5,1864 # 1390 <base>
 c50:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c54:	fe043783          	ld	a5,-32(s0)
 c58:	639c                	ld	a5,0(a5)
 c5a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 c5e:	fe843783          	ld	a5,-24(s0)
 c62:	4798                	lw	a4,8(a5)
 c64:	fdc42783          	lw	a5,-36(s0)
 c68:	2781                	sext.w	a5,a5
 c6a:	06f76763          	bltu	a4,a5,cd8 <malloc+0xf0>
      if(p->s.size == nunits)
 c6e:	fe843783          	ld	a5,-24(s0)
 c72:	4798                	lw	a4,8(a5)
 c74:	fdc42783          	lw	a5,-36(s0)
 c78:	2781                	sext.w	a5,a5
 c7a:	00e79963          	bne	a5,a4,c8c <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 c7e:	fe843783          	ld	a5,-24(s0)
 c82:	6398                	ld	a4,0(a5)
 c84:	fe043783          	ld	a5,-32(s0)
 c88:	e398                	sd	a4,0(a5)
 c8a:	a825                	j	cc2 <malloc+0xda>
      else {
        p->s.size -= nunits;
 c8c:	fe843783          	ld	a5,-24(s0)
 c90:	479c                	lw	a5,8(a5)
 c92:	fdc42703          	lw	a4,-36(s0)
 c96:	9f99                	subw	a5,a5,a4
 c98:	0007871b          	sext.w	a4,a5
 c9c:	fe843783          	ld	a5,-24(s0)
 ca0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ca2:	fe843783          	ld	a5,-24(s0)
 ca6:	479c                	lw	a5,8(a5)
 ca8:	1782                	slli	a5,a5,0x20
 caa:	9381                	srli	a5,a5,0x20
 cac:	0792                	slli	a5,a5,0x4
 cae:	fe843703          	ld	a4,-24(s0)
 cb2:	97ba                	add	a5,a5,a4
 cb4:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cb8:	fe843783          	ld	a5,-24(s0)
 cbc:	fdc42703          	lw	a4,-36(s0)
 cc0:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 cc2:	00000797          	auipc	a5,0x0
 cc6:	6de78793          	addi	a5,a5,1758 # 13a0 <freep>
 cca:	fe043703          	ld	a4,-32(s0)
 cce:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 cd0:	fe843783          	ld	a5,-24(s0)
 cd4:	07c1                	addi	a5,a5,16
 cd6:	a091                	j	d1a <malloc+0x132>
    }
    if(p == freep)
 cd8:	00000797          	auipc	a5,0x0
 cdc:	6c878793          	addi	a5,a5,1736 # 13a0 <freep>
 ce0:	639c                	ld	a5,0(a5)
 ce2:	fe843703          	ld	a4,-24(s0)
 ce6:	02f71063          	bne	a4,a5,d06 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 cea:	fdc42783          	lw	a5,-36(s0)
 cee:	853e                	mv	a0,a5
 cf0:	00000097          	auipc	ra,0x0
 cf4:	e78080e7          	jalr	-392(ra) # b68 <morecore>
 cf8:	fea43423          	sd	a0,-24(s0)
 cfc:	fe843783          	ld	a5,-24(s0)
 d00:	e399                	bnez	a5,d06 <malloc+0x11e>
        return 0;
 d02:	4781                	li	a5,0
 d04:	a819                	j	d1a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d06:	fe843783          	ld	a5,-24(s0)
 d0a:	fef43023          	sd	a5,-32(s0)
 d0e:	fe843783          	ld	a5,-24(s0)
 d12:	639c                	ld	a5,0(a5)
 d14:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d18:	b799                	j	c5e <malloc+0x76>
  }
}
 d1a:	853e                	mv	a0,a5
 d1c:	70e2                	ld	ra,56(sp)
 d1e:	7442                	ld	s0,48(sp)
 d20:	6121                	addi	sp,sp,64
 d22:	8082                	ret
