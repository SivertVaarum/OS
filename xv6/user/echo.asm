
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	87aa                	mv	a5,a0
   c:	fcb43023          	sd	a1,-64(s0)
  10:	fcf42623          	sw	a5,-52(s0)
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	fcf42e23          	sw	a5,-36(s0)
  1a:	a051                	j	9e <main+0x9e>
    write(1, argv[i], strlen(argv[i]));
  1c:	fdc42783          	lw	a5,-36(s0)
  20:	078e                	slli	a5,a5,0x3
  22:	fc043703          	ld	a4,-64(s0)
  26:	97ba                	add	a5,a5,a4
  28:	6384                	ld	s1,0(a5)
  2a:	fdc42783          	lw	a5,-36(s0)
  2e:	078e                	slli	a5,a5,0x3
  30:	fc043703          	ld	a4,-64(s0)
  34:	97ba                	add	a5,a5,a4
  36:	639c                	ld	a5,0(a5)
  38:	853e                	mv	a0,a5
  3a:	00000097          	auipc	ra,0x0
  3e:	14a080e7          	jalr	330(ra) # 184 <strlen>
  42:	87aa                	mv	a5,a0
  44:	2781                	sext.w	a5,a5
  46:	2781                	sext.w	a5,a5
  48:	863e                	mv	a2,a5
  4a:	85a6                	mv	a1,s1
  4c:	4505                	li	a0,1
  4e:	00000097          	auipc	ra,0x0
  52:	538080e7          	jalr	1336(ra) # 586 <write>
    if(i + 1 < argc){
  56:	fdc42783          	lw	a5,-36(s0)
  5a:	2785                	addiw	a5,a5,1
  5c:	0007871b          	sext.w	a4,a5
  60:	fcc42783          	lw	a5,-52(s0)
  64:	2781                	sext.w	a5,a5
  66:	00f75d63          	bge	a4,a5,80 <main+0x80>
      write(1, " ", 1);
  6a:	4605                	li	a2,1
  6c:	00001597          	auipc	a1,0x1
  70:	d5458593          	addi	a1,a1,-684 # dc0 <malloc+0x140>
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	510080e7          	jalr	1296(ra) # 586 <write>
  7e:	a819                	j	94 <main+0x94>
    } else {
      write(1, "\n", 1);
  80:	4605                	li	a2,1
  82:	00001597          	auipc	a1,0x1
  86:	d4658593          	addi	a1,a1,-698 # dc8 <malloc+0x148>
  8a:	4505                	li	a0,1
  8c:	00000097          	auipc	ra,0x0
  90:	4fa080e7          	jalr	1274(ra) # 586 <write>
  for(i = 1; i < argc; i++){
  94:	fdc42783          	lw	a5,-36(s0)
  98:	2785                	addiw	a5,a5,1
  9a:	fcf42e23          	sw	a5,-36(s0)
  9e:	fdc42783          	lw	a5,-36(s0)
  a2:	873e                	mv	a4,a5
  a4:	fcc42783          	lw	a5,-52(s0)
  a8:	2701                	sext.w	a4,a4
  aa:	2781                	sext.w	a5,a5
  ac:	f6f748e3          	blt	a4,a5,1c <main+0x1c>
    }
  }
  exit(0);
  b0:	4501                	li	a0,0
  b2:	00000097          	auipc	ra,0x0
  b6:	4b4080e7          	jalr	1204(ra) # 566 <exit>

00000000000000ba <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e406                	sd	ra,8(sp)
  be:	e022                	sd	s0,0(sp)
  c0:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c2:	00000097          	auipc	ra,0x0
  c6:	f3e080e7          	jalr	-194(ra) # 0 <main>
  exit(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	49a080e7          	jalr	1178(ra) # 566 <exit>

00000000000000d4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d4:	7179                	addi	sp,sp,-48
  d6:	f422                	sd	s0,40(sp)
  d8:	1800                	addi	s0,sp,48
  da:	fca43c23          	sd	a0,-40(s0)
  de:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  e2:	fd843783          	ld	a5,-40(s0)
  e6:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  ea:	0001                	nop
  ec:	fd043703          	ld	a4,-48(s0)
  f0:	00170793          	addi	a5,a4,1
  f4:	fcf43823          	sd	a5,-48(s0)
  f8:	fd843783          	ld	a5,-40(s0)
  fc:	00178693          	addi	a3,a5,1
 100:	fcd43c23          	sd	a3,-40(s0)
 104:	00074703          	lbu	a4,0(a4)
 108:	00e78023          	sb	a4,0(a5)
 10c:	0007c783          	lbu	a5,0(a5)
 110:	fff1                	bnez	a5,ec <strcpy+0x18>
    ;
  return os;
 112:	fe843783          	ld	a5,-24(s0)
}
 116:	853e                	mv	a0,a5
 118:	7422                	ld	s0,40(sp)
 11a:	6145                	addi	sp,sp,48
 11c:	8082                	ret

000000000000011e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11e:	1101                	addi	sp,sp,-32
 120:	ec22                	sd	s0,24(sp)
 122:	1000                	addi	s0,sp,32
 124:	fea43423          	sd	a0,-24(s0)
 128:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 12c:	a819                	j	142 <strcmp+0x24>
    p++, q++;
 12e:	fe843783          	ld	a5,-24(s0)
 132:	0785                	addi	a5,a5,1
 134:	fef43423          	sd	a5,-24(s0)
 138:	fe043783          	ld	a5,-32(s0)
 13c:	0785                	addi	a5,a5,1
 13e:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 142:	fe843783          	ld	a5,-24(s0)
 146:	0007c783          	lbu	a5,0(a5)
 14a:	cb99                	beqz	a5,160 <strcmp+0x42>
 14c:	fe843783          	ld	a5,-24(s0)
 150:	0007c703          	lbu	a4,0(a5)
 154:	fe043783          	ld	a5,-32(s0)
 158:	0007c783          	lbu	a5,0(a5)
 15c:	fcf709e3          	beq	a4,a5,12e <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 160:	fe843783          	ld	a5,-24(s0)
 164:	0007c783          	lbu	a5,0(a5)
 168:	0007871b          	sext.w	a4,a5
 16c:	fe043783          	ld	a5,-32(s0)
 170:	0007c783          	lbu	a5,0(a5)
 174:	2781                	sext.w	a5,a5
 176:	40f707bb          	subw	a5,a4,a5
 17a:	2781                	sext.w	a5,a5
}
 17c:	853e                	mv	a0,a5
 17e:	6462                	ld	s0,24(sp)
 180:	6105                	addi	sp,sp,32
 182:	8082                	ret

0000000000000184 <strlen>:

uint
strlen(const char *s)
{
 184:	7179                	addi	sp,sp,-48
 186:	f422                	sd	s0,40(sp)
 188:	1800                	addi	s0,sp,48
 18a:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 18e:	fe042623          	sw	zero,-20(s0)
 192:	a031                	j	19e <strlen+0x1a>
 194:	fec42783          	lw	a5,-20(s0)
 198:	2785                	addiw	a5,a5,1
 19a:	fef42623          	sw	a5,-20(s0)
 19e:	fec42783          	lw	a5,-20(s0)
 1a2:	fd843703          	ld	a4,-40(s0)
 1a6:	97ba                	add	a5,a5,a4
 1a8:	0007c783          	lbu	a5,0(a5)
 1ac:	f7e5                	bnez	a5,194 <strlen+0x10>
    ;
  return n;
 1ae:	fec42783          	lw	a5,-20(s0)
}
 1b2:	853e                	mv	a0,a5
 1b4:	7422                	ld	s0,40(sp)
 1b6:	6145                	addi	sp,sp,48
 1b8:	8082                	ret

00000000000001ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ba:	7179                	addi	sp,sp,-48
 1bc:	f422                	sd	s0,40(sp)
 1be:	1800                	addi	s0,sp,48
 1c0:	fca43c23          	sd	a0,-40(s0)
 1c4:	87ae                	mv	a5,a1
 1c6:	8732                	mv	a4,a2
 1c8:	fcf42a23          	sw	a5,-44(s0)
 1cc:	87ba                	mv	a5,a4
 1ce:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1d2:	fd843783          	ld	a5,-40(s0)
 1d6:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1da:	fe042623          	sw	zero,-20(s0)
 1de:	a00d                	j	200 <memset+0x46>
    cdst[i] = c;
 1e0:	fec42783          	lw	a5,-20(s0)
 1e4:	fe043703          	ld	a4,-32(s0)
 1e8:	97ba                	add	a5,a5,a4
 1ea:	fd442703          	lw	a4,-44(s0)
 1ee:	0ff77713          	zext.b	a4,a4
 1f2:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1f6:	fec42783          	lw	a5,-20(s0)
 1fa:	2785                	addiw	a5,a5,1
 1fc:	fef42623          	sw	a5,-20(s0)
 200:	fec42703          	lw	a4,-20(s0)
 204:	fd042783          	lw	a5,-48(s0)
 208:	2781                	sext.w	a5,a5
 20a:	fcf76be3          	bltu	a4,a5,1e0 <memset+0x26>
  }
  return dst;
 20e:	fd843783          	ld	a5,-40(s0)
}
 212:	853e                	mv	a0,a5
 214:	7422                	ld	s0,40(sp)
 216:	6145                	addi	sp,sp,48
 218:	8082                	ret

000000000000021a <strchr>:

char*
strchr(const char *s, char c)
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec22                	sd	s0,24(sp)
 21e:	1000                	addi	s0,sp,32
 220:	fea43423          	sd	a0,-24(s0)
 224:	87ae                	mv	a5,a1
 226:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 22a:	a01d                	j	250 <strchr+0x36>
    if(*s == c)
 22c:	fe843783          	ld	a5,-24(s0)
 230:	0007c703          	lbu	a4,0(a5)
 234:	fe744783          	lbu	a5,-25(s0)
 238:	0ff7f793          	zext.b	a5,a5
 23c:	00e79563          	bne	a5,a4,246 <strchr+0x2c>
      return (char*)s;
 240:	fe843783          	ld	a5,-24(s0)
 244:	a821                	j	25c <strchr+0x42>
  for(; *s; s++)
 246:	fe843783          	ld	a5,-24(s0)
 24a:	0785                	addi	a5,a5,1
 24c:	fef43423          	sd	a5,-24(s0)
 250:	fe843783          	ld	a5,-24(s0)
 254:	0007c783          	lbu	a5,0(a5)
 258:	fbf1                	bnez	a5,22c <strchr+0x12>
  return 0;
 25a:	4781                	li	a5,0
}
 25c:	853e                	mv	a0,a5
 25e:	6462                	ld	s0,24(sp)
 260:	6105                	addi	sp,sp,32
 262:	8082                	ret

0000000000000264 <gets>:

char*
gets(char *buf, int max)
{
 264:	7179                	addi	sp,sp,-48
 266:	f406                	sd	ra,40(sp)
 268:	f022                	sd	s0,32(sp)
 26a:	1800                	addi	s0,sp,48
 26c:	fca43c23          	sd	a0,-40(s0)
 270:	87ae                	mv	a5,a1
 272:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 276:	fe042623          	sw	zero,-20(s0)
 27a:	a8a1                	j	2d2 <gets+0x6e>
    cc = read(0, &c, 1);
 27c:	fe740793          	addi	a5,s0,-25
 280:	4605                	li	a2,1
 282:	85be                	mv	a1,a5
 284:	4501                	li	a0,0
 286:	00000097          	auipc	ra,0x0
 28a:	2f8080e7          	jalr	760(ra) # 57e <read>
 28e:	87aa                	mv	a5,a0
 290:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 294:	fe842783          	lw	a5,-24(s0)
 298:	2781                	sext.w	a5,a5
 29a:	04f05763          	blez	a5,2e8 <gets+0x84>
      break;
    buf[i++] = c;
 29e:	fec42783          	lw	a5,-20(s0)
 2a2:	0017871b          	addiw	a4,a5,1
 2a6:	fee42623          	sw	a4,-20(s0)
 2aa:	873e                	mv	a4,a5
 2ac:	fd843783          	ld	a5,-40(s0)
 2b0:	97ba                	add	a5,a5,a4
 2b2:	fe744703          	lbu	a4,-25(s0)
 2b6:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 2ba:	fe744783          	lbu	a5,-25(s0)
 2be:	873e                	mv	a4,a5
 2c0:	47a9                	li	a5,10
 2c2:	02f70463          	beq	a4,a5,2ea <gets+0x86>
 2c6:	fe744783          	lbu	a5,-25(s0)
 2ca:	873e                	mv	a4,a5
 2cc:	47b5                	li	a5,13
 2ce:	00f70e63          	beq	a4,a5,2ea <gets+0x86>
  for(i=0; i+1 < max; ){
 2d2:	fec42783          	lw	a5,-20(s0)
 2d6:	2785                	addiw	a5,a5,1
 2d8:	0007871b          	sext.w	a4,a5
 2dc:	fd442783          	lw	a5,-44(s0)
 2e0:	2781                	sext.w	a5,a5
 2e2:	f8f74de3          	blt	a4,a5,27c <gets+0x18>
 2e6:	a011                	j	2ea <gets+0x86>
      break;
 2e8:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2ea:	fec42783          	lw	a5,-20(s0)
 2ee:	fd843703          	ld	a4,-40(s0)
 2f2:	97ba                	add	a5,a5,a4
 2f4:	00078023          	sb	zero,0(a5)
  return buf;
 2f8:	fd843783          	ld	a5,-40(s0)
}
 2fc:	853e                	mv	a0,a5
 2fe:	70a2                	ld	ra,40(sp)
 300:	7402                	ld	s0,32(sp)
 302:	6145                	addi	sp,sp,48
 304:	8082                	ret

0000000000000306 <stat>:

int
stat(const char *n, struct stat *st)
{
 306:	7179                	addi	sp,sp,-48
 308:	f406                	sd	ra,40(sp)
 30a:	f022                	sd	s0,32(sp)
 30c:	1800                	addi	s0,sp,48
 30e:	fca43c23          	sd	a0,-40(s0)
 312:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 316:	4581                	li	a1,0
 318:	fd843503          	ld	a0,-40(s0)
 31c:	00000097          	auipc	ra,0x0
 320:	28a080e7          	jalr	650(ra) # 5a6 <open>
 324:	87aa                	mv	a5,a0
 326:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 32a:	fec42783          	lw	a5,-20(s0)
 32e:	2781                	sext.w	a5,a5
 330:	0007d463          	bgez	a5,338 <stat+0x32>
    return -1;
 334:	57fd                	li	a5,-1
 336:	a035                	j	362 <stat+0x5c>
  r = fstat(fd, st);
 338:	fec42783          	lw	a5,-20(s0)
 33c:	fd043583          	ld	a1,-48(s0)
 340:	853e                	mv	a0,a5
 342:	00000097          	auipc	ra,0x0
 346:	27c080e7          	jalr	636(ra) # 5be <fstat>
 34a:	87aa                	mv	a5,a0
 34c:	fef42423          	sw	a5,-24(s0)
  close(fd);
 350:	fec42783          	lw	a5,-20(s0)
 354:	853e                	mv	a0,a5
 356:	00000097          	auipc	ra,0x0
 35a:	238080e7          	jalr	568(ra) # 58e <close>
  return r;
 35e:	fe842783          	lw	a5,-24(s0)
}
 362:	853e                	mv	a0,a5
 364:	70a2                	ld	ra,40(sp)
 366:	7402                	ld	s0,32(sp)
 368:	6145                	addi	sp,sp,48
 36a:	8082                	ret

000000000000036c <atoi>:

int
atoi(const char *s)
{
 36c:	7179                	addi	sp,sp,-48
 36e:	f422                	sd	s0,40(sp)
 370:	1800                	addi	s0,sp,48
 372:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 376:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 37a:	a81d                	j	3b0 <atoi+0x44>
    n = n*10 + *s++ - '0';
 37c:	fec42783          	lw	a5,-20(s0)
 380:	873e                	mv	a4,a5
 382:	87ba                	mv	a5,a4
 384:	0027979b          	slliw	a5,a5,0x2
 388:	9fb9                	addw	a5,a5,a4
 38a:	0017979b          	slliw	a5,a5,0x1
 38e:	0007871b          	sext.w	a4,a5
 392:	fd843783          	ld	a5,-40(s0)
 396:	00178693          	addi	a3,a5,1
 39a:	fcd43c23          	sd	a3,-40(s0)
 39e:	0007c783          	lbu	a5,0(a5)
 3a2:	2781                	sext.w	a5,a5
 3a4:	9fb9                	addw	a5,a5,a4
 3a6:	2781                	sext.w	a5,a5
 3a8:	fd07879b          	addiw	a5,a5,-48
 3ac:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 3b0:	fd843783          	ld	a5,-40(s0)
 3b4:	0007c783          	lbu	a5,0(a5)
 3b8:	873e                	mv	a4,a5
 3ba:	02f00793          	li	a5,47
 3be:	00e7fb63          	bgeu	a5,a4,3d4 <atoi+0x68>
 3c2:	fd843783          	ld	a5,-40(s0)
 3c6:	0007c783          	lbu	a5,0(a5)
 3ca:	873e                	mv	a4,a5
 3cc:	03900793          	li	a5,57
 3d0:	fae7f6e3          	bgeu	a5,a4,37c <atoi+0x10>
  return n;
 3d4:	fec42783          	lw	a5,-20(s0)
}
 3d8:	853e                	mv	a0,a5
 3da:	7422                	ld	s0,40(sp)
 3dc:	6145                	addi	sp,sp,48
 3de:	8082                	ret

00000000000003e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e0:	7139                	addi	sp,sp,-64
 3e2:	fc22                	sd	s0,56(sp)
 3e4:	0080                	addi	s0,sp,64
 3e6:	fca43c23          	sd	a0,-40(s0)
 3ea:	fcb43823          	sd	a1,-48(s0)
 3ee:	87b2                	mv	a5,a2
 3f0:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3f4:	fd843783          	ld	a5,-40(s0)
 3f8:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3fc:	fd043783          	ld	a5,-48(s0)
 400:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 404:	fe043703          	ld	a4,-32(s0)
 408:	fe843783          	ld	a5,-24(s0)
 40c:	02e7fc63          	bgeu	a5,a4,444 <memmove+0x64>
    while(n-- > 0)
 410:	a00d                	j	432 <memmove+0x52>
      *dst++ = *src++;
 412:	fe043703          	ld	a4,-32(s0)
 416:	00170793          	addi	a5,a4,1
 41a:	fef43023          	sd	a5,-32(s0)
 41e:	fe843783          	ld	a5,-24(s0)
 422:	00178693          	addi	a3,a5,1
 426:	fed43423          	sd	a3,-24(s0)
 42a:	00074703          	lbu	a4,0(a4)
 42e:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 432:	fcc42783          	lw	a5,-52(s0)
 436:	fff7871b          	addiw	a4,a5,-1
 43a:	fce42623          	sw	a4,-52(s0)
 43e:	fcf04ae3          	bgtz	a5,412 <memmove+0x32>
 442:	a891                	j	496 <memmove+0xb6>
  } else {
    dst += n;
 444:	fcc42783          	lw	a5,-52(s0)
 448:	fe843703          	ld	a4,-24(s0)
 44c:	97ba                	add	a5,a5,a4
 44e:	fef43423          	sd	a5,-24(s0)
    src += n;
 452:	fcc42783          	lw	a5,-52(s0)
 456:	fe043703          	ld	a4,-32(s0)
 45a:	97ba                	add	a5,a5,a4
 45c:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 460:	a01d                	j	486 <memmove+0xa6>
      *--dst = *--src;
 462:	fe043783          	ld	a5,-32(s0)
 466:	17fd                	addi	a5,a5,-1
 468:	fef43023          	sd	a5,-32(s0)
 46c:	fe843783          	ld	a5,-24(s0)
 470:	17fd                	addi	a5,a5,-1
 472:	fef43423          	sd	a5,-24(s0)
 476:	fe043783          	ld	a5,-32(s0)
 47a:	0007c703          	lbu	a4,0(a5)
 47e:	fe843783          	ld	a5,-24(s0)
 482:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 486:	fcc42783          	lw	a5,-52(s0)
 48a:	fff7871b          	addiw	a4,a5,-1
 48e:	fce42623          	sw	a4,-52(s0)
 492:	fcf048e3          	bgtz	a5,462 <memmove+0x82>
  }
  return vdst;
 496:	fd843783          	ld	a5,-40(s0)
}
 49a:	853e                	mv	a0,a5
 49c:	7462                	ld	s0,56(sp)
 49e:	6121                	addi	sp,sp,64
 4a0:	8082                	ret

00000000000004a2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a2:	7139                	addi	sp,sp,-64
 4a4:	fc22                	sd	s0,56(sp)
 4a6:	0080                	addi	s0,sp,64
 4a8:	fca43c23          	sd	a0,-40(s0)
 4ac:	fcb43823          	sd	a1,-48(s0)
 4b0:	87b2                	mv	a5,a2
 4b2:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 4b6:	fd843783          	ld	a5,-40(s0)
 4ba:	fef43423          	sd	a5,-24(s0)
 4be:	fd043783          	ld	a5,-48(s0)
 4c2:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4c6:	a0a1                	j	50e <memcmp+0x6c>
    if (*p1 != *p2) {
 4c8:	fe843783          	ld	a5,-24(s0)
 4cc:	0007c703          	lbu	a4,0(a5)
 4d0:	fe043783          	ld	a5,-32(s0)
 4d4:	0007c783          	lbu	a5,0(a5)
 4d8:	02f70163          	beq	a4,a5,4fa <memcmp+0x58>
      return *p1 - *p2;
 4dc:	fe843783          	ld	a5,-24(s0)
 4e0:	0007c783          	lbu	a5,0(a5)
 4e4:	0007871b          	sext.w	a4,a5
 4e8:	fe043783          	ld	a5,-32(s0)
 4ec:	0007c783          	lbu	a5,0(a5)
 4f0:	2781                	sext.w	a5,a5
 4f2:	40f707bb          	subw	a5,a4,a5
 4f6:	2781                	sext.w	a5,a5
 4f8:	a01d                	j	51e <memcmp+0x7c>
    }
    p1++;
 4fa:	fe843783          	ld	a5,-24(s0)
 4fe:	0785                	addi	a5,a5,1
 500:	fef43423          	sd	a5,-24(s0)
    p2++;
 504:	fe043783          	ld	a5,-32(s0)
 508:	0785                	addi	a5,a5,1
 50a:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 50e:	fcc42783          	lw	a5,-52(s0)
 512:	fff7871b          	addiw	a4,a5,-1
 516:	fce42623          	sw	a4,-52(s0)
 51a:	f7dd                	bnez	a5,4c8 <memcmp+0x26>
  }
  return 0;
 51c:	4781                	li	a5,0
}
 51e:	853e                	mv	a0,a5
 520:	7462                	ld	s0,56(sp)
 522:	6121                	addi	sp,sp,64
 524:	8082                	ret

0000000000000526 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 526:	7179                	addi	sp,sp,-48
 528:	f406                	sd	ra,40(sp)
 52a:	f022                	sd	s0,32(sp)
 52c:	1800                	addi	s0,sp,48
 52e:	fea43423          	sd	a0,-24(s0)
 532:	feb43023          	sd	a1,-32(s0)
 536:	87b2                	mv	a5,a2
 538:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 53c:	fdc42783          	lw	a5,-36(s0)
 540:	863e                	mv	a2,a5
 542:	fe043583          	ld	a1,-32(s0)
 546:	fe843503          	ld	a0,-24(s0)
 54a:	00000097          	auipc	ra,0x0
 54e:	e96080e7          	jalr	-362(ra) # 3e0 <memmove>
 552:	87aa                	mv	a5,a0
}
 554:	853e                	mv	a0,a5
 556:	70a2                	ld	ra,40(sp)
 558:	7402                	ld	s0,32(sp)
 55a:	6145                	addi	sp,sp,48
 55c:	8082                	ret

000000000000055e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 55e:	4885                	li	a7,1
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <exit>:
.global exit
exit:
 li a7, SYS_exit
 566:	4889                	li	a7,2
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <wait>:
.global wait
wait:
 li a7, SYS_wait
 56e:	488d                	li	a7,3
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 576:	4891                	li	a7,4
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <read>:
.global read
read:
 li a7, SYS_read
 57e:	4895                	li	a7,5
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <write>:
.global write
write:
 li a7, SYS_write
 586:	48c1                	li	a7,16
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <close>:
.global close
close:
 li a7, SYS_close
 58e:	48d5                	li	a7,21
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <kill>:
.global kill
kill:
 li a7, SYS_kill
 596:	4899                	li	a7,6
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <exec>:
.global exec
exec:
 li a7, SYS_exec
 59e:	489d                	li	a7,7
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <open>:
.global open
open:
 li a7, SYS_open
 5a6:	48bd                	li	a7,15
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ae:	48c5                	li	a7,17
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5b6:	48c9                	li	a7,18
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5be:	48a1                	li	a7,8
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <link>:
.global link
link:
 li a7, SYS_link
 5c6:	48cd                	li	a7,19
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ce:	48d1                	li	a7,20
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5d6:	48a5                	li	a7,9
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <dup>:
.global dup
dup:
 li a7, SYS_dup
 5de:	48a9                	li	a7,10
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5e6:	48ad                	li	a7,11
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ee:	48b1                	li	a7,12
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5f6:	48b5                	li	a7,13
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5fe:	48b9                	li	a7,14
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 606:	1101                	addi	sp,sp,-32
 608:	ec06                	sd	ra,24(sp)
 60a:	e822                	sd	s0,16(sp)
 60c:	1000                	addi	s0,sp,32
 60e:	87aa                	mv	a5,a0
 610:	872e                	mv	a4,a1
 612:	fef42623          	sw	a5,-20(s0)
 616:	87ba                	mv	a5,a4
 618:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 61c:	feb40713          	addi	a4,s0,-21
 620:	fec42783          	lw	a5,-20(s0)
 624:	4605                	li	a2,1
 626:	85ba                	mv	a1,a4
 628:	853e                	mv	a0,a5
 62a:	00000097          	auipc	ra,0x0
 62e:	f5c080e7          	jalr	-164(ra) # 586 <write>
}
 632:	0001                	nop
 634:	60e2                	ld	ra,24(sp)
 636:	6442                	ld	s0,16(sp)
 638:	6105                	addi	sp,sp,32
 63a:	8082                	ret

000000000000063c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 63c:	7139                	addi	sp,sp,-64
 63e:	fc06                	sd	ra,56(sp)
 640:	f822                	sd	s0,48(sp)
 642:	0080                	addi	s0,sp,64
 644:	87aa                	mv	a5,a0
 646:	8736                	mv	a4,a3
 648:	fcf42623          	sw	a5,-52(s0)
 64c:	87ae                	mv	a5,a1
 64e:	fcf42423          	sw	a5,-56(s0)
 652:	87b2                	mv	a5,a2
 654:	fcf42223          	sw	a5,-60(s0)
 658:	87ba                	mv	a5,a4
 65a:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 65e:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 662:	fc042783          	lw	a5,-64(s0)
 666:	2781                	sext.w	a5,a5
 668:	c38d                	beqz	a5,68a <printint+0x4e>
 66a:	fc842783          	lw	a5,-56(s0)
 66e:	2781                	sext.w	a5,a5
 670:	0007dd63          	bgez	a5,68a <printint+0x4e>
    neg = 1;
 674:	4785                	li	a5,1
 676:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 67a:	fc842783          	lw	a5,-56(s0)
 67e:	40f007bb          	negw	a5,a5
 682:	2781                	sext.w	a5,a5
 684:	fef42223          	sw	a5,-28(s0)
 688:	a029                	j	692 <printint+0x56>
  } else {
    x = xx;
 68a:	fc842783          	lw	a5,-56(s0)
 68e:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 692:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 696:	fc442783          	lw	a5,-60(s0)
 69a:	fe442703          	lw	a4,-28(s0)
 69e:	02f777bb          	remuw	a5,a4,a5
 6a2:	0007861b          	sext.w	a2,a5
 6a6:	fec42783          	lw	a5,-20(s0)
 6aa:	0017871b          	addiw	a4,a5,1
 6ae:	fee42623          	sw	a4,-20(s0)
 6b2:	00001697          	auipc	a3,0x1
 6b6:	cbe68693          	addi	a3,a3,-834 # 1370 <digits>
 6ba:	02061713          	slli	a4,a2,0x20
 6be:	9301                	srli	a4,a4,0x20
 6c0:	9736                	add	a4,a4,a3
 6c2:	00074703          	lbu	a4,0(a4)
 6c6:	17c1                	addi	a5,a5,-16
 6c8:	97a2                	add	a5,a5,s0
 6ca:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6ce:	fc442783          	lw	a5,-60(s0)
 6d2:	fe442703          	lw	a4,-28(s0)
 6d6:	02f757bb          	divuw	a5,a4,a5
 6da:	fef42223          	sw	a5,-28(s0)
 6de:	fe442783          	lw	a5,-28(s0)
 6e2:	2781                	sext.w	a5,a5
 6e4:	fbcd                	bnez	a5,696 <printint+0x5a>
  if(neg)
 6e6:	fe842783          	lw	a5,-24(s0)
 6ea:	2781                	sext.w	a5,a5
 6ec:	cf85                	beqz	a5,724 <printint+0xe8>
    buf[i++] = '-';
 6ee:	fec42783          	lw	a5,-20(s0)
 6f2:	0017871b          	addiw	a4,a5,1
 6f6:	fee42623          	sw	a4,-20(s0)
 6fa:	17c1                	addi	a5,a5,-16
 6fc:	97a2                	add	a5,a5,s0
 6fe:	02d00713          	li	a4,45
 702:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 706:	a839                	j	724 <printint+0xe8>
    putc(fd, buf[i]);
 708:	fec42783          	lw	a5,-20(s0)
 70c:	17c1                	addi	a5,a5,-16
 70e:	97a2                	add	a5,a5,s0
 710:	fe07c703          	lbu	a4,-32(a5)
 714:	fcc42783          	lw	a5,-52(s0)
 718:	85ba                	mv	a1,a4
 71a:	853e                	mv	a0,a5
 71c:	00000097          	auipc	ra,0x0
 720:	eea080e7          	jalr	-278(ra) # 606 <putc>
  while(--i >= 0)
 724:	fec42783          	lw	a5,-20(s0)
 728:	37fd                	addiw	a5,a5,-1
 72a:	fef42623          	sw	a5,-20(s0)
 72e:	fec42783          	lw	a5,-20(s0)
 732:	2781                	sext.w	a5,a5
 734:	fc07dae3          	bgez	a5,708 <printint+0xcc>
}
 738:	0001                	nop
 73a:	0001                	nop
 73c:	70e2                	ld	ra,56(sp)
 73e:	7442                	ld	s0,48(sp)
 740:	6121                	addi	sp,sp,64
 742:	8082                	ret

0000000000000744 <printptr>:

static void
printptr(int fd, uint64 x) {
 744:	7179                	addi	sp,sp,-48
 746:	f406                	sd	ra,40(sp)
 748:	f022                	sd	s0,32(sp)
 74a:	1800                	addi	s0,sp,48
 74c:	87aa                	mv	a5,a0
 74e:	fcb43823          	sd	a1,-48(s0)
 752:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 756:	fdc42783          	lw	a5,-36(s0)
 75a:	03000593          	li	a1,48
 75e:	853e                	mv	a0,a5
 760:	00000097          	auipc	ra,0x0
 764:	ea6080e7          	jalr	-346(ra) # 606 <putc>
  putc(fd, 'x');
 768:	fdc42783          	lw	a5,-36(s0)
 76c:	07800593          	li	a1,120
 770:	853e                	mv	a0,a5
 772:	00000097          	auipc	ra,0x0
 776:	e94080e7          	jalr	-364(ra) # 606 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77a:	fe042623          	sw	zero,-20(s0)
 77e:	a82d                	j	7b8 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 780:	fd043783          	ld	a5,-48(s0)
 784:	93f1                	srli	a5,a5,0x3c
 786:	00001717          	auipc	a4,0x1
 78a:	bea70713          	addi	a4,a4,-1046 # 1370 <digits>
 78e:	97ba                	add	a5,a5,a4
 790:	0007c703          	lbu	a4,0(a5)
 794:	fdc42783          	lw	a5,-36(s0)
 798:	85ba                	mv	a1,a4
 79a:	853e                	mv	a0,a5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e6a080e7          	jalr	-406(ra) # 606 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a4:	fec42783          	lw	a5,-20(s0)
 7a8:	2785                	addiw	a5,a5,1
 7aa:	fef42623          	sw	a5,-20(s0)
 7ae:	fd043783          	ld	a5,-48(s0)
 7b2:	0792                	slli	a5,a5,0x4
 7b4:	fcf43823          	sd	a5,-48(s0)
 7b8:	fec42783          	lw	a5,-20(s0)
 7bc:	873e                	mv	a4,a5
 7be:	47bd                	li	a5,15
 7c0:	fce7f0e3          	bgeu	a5,a4,780 <printptr+0x3c>
}
 7c4:	0001                	nop
 7c6:	0001                	nop
 7c8:	70a2                	ld	ra,40(sp)
 7ca:	7402                	ld	s0,32(sp)
 7cc:	6145                	addi	sp,sp,48
 7ce:	8082                	ret

00000000000007d0 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7d0:	715d                	addi	sp,sp,-80
 7d2:	e486                	sd	ra,72(sp)
 7d4:	e0a2                	sd	s0,64(sp)
 7d6:	0880                	addi	s0,sp,80
 7d8:	87aa                	mv	a5,a0
 7da:	fcb43023          	sd	a1,-64(s0)
 7de:	fac43c23          	sd	a2,-72(s0)
 7e2:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7e6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7ea:	fe042223          	sw	zero,-28(s0)
 7ee:	a42d                	j	a18 <vprintf+0x248>
    c = fmt[i] & 0xff;
 7f0:	fe442783          	lw	a5,-28(s0)
 7f4:	fc043703          	ld	a4,-64(s0)
 7f8:	97ba                	add	a5,a5,a4
 7fa:	0007c783          	lbu	a5,0(a5)
 7fe:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 802:	fe042783          	lw	a5,-32(s0)
 806:	2781                	sext.w	a5,a5
 808:	eb9d                	bnez	a5,83e <vprintf+0x6e>
      if(c == '%'){
 80a:	fdc42783          	lw	a5,-36(s0)
 80e:	0007871b          	sext.w	a4,a5
 812:	02500793          	li	a5,37
 816:	00f71763          	bne	a4,a5,824 <vprintf+0x54>
        state = '%';
 81a:	02500793          	li	a5,37
 81e:	fef42023          	sw	a5,-32(s0)
 822:	a2f5                	j	a0e <vprintf+0x23e>
      } else {
        putc(fd, c);
 824:	fdc42783          	lw	a5,-36(s0)
 828:	0ff7f713          	zext.b	a4,a5
 82c:	fcc42783          	lw	a5,-52(s0)
 830:	85ba                	mv	a1,a4
 832:	853e                	mv	a0,a5
 834:	00000097          	auipc	ra,0x0
 838:	dd2080e7          	jalr	-558(ra) # 606 <putc>
 83c:	aac9                	j	a0e <vprintf+0x23e>
      }
    } else if(state == '%'){
 83e:	fe042783          	lw	a5,-32(s0)
 842:	0007871b          	sext.w	a4,a5
 846:	02500793          	li	a5,37
 84a:	1cf71263          	bne	a4,a5,a0e <vprintf+0x23e>
      if(c == 'd'){
 84e:	fdc42783          	lw	a5,-36(s0)
 852:	0007871b          	sext.w	a4,a5
 856:	06400793          	li	a5,100
 85a:	02f71463          	bne	a4,a5,882 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 85e:	fb843783          	ld	a5,-72(s0)
 862:	00878713          	addi	a4,a5,8
 866:	fae43c23          	sd	a4,-72(s0)
 86a:	4398                	lw	a4,0(a5)
 86c:	fcc42783          	lw	a5,-52(s0)
 870:	4685                	li	a3,1
 872:	4629                	li	a2,10
 874:	85ba                	mv	a1,a4
 876:	853e                	mv	a0,a5
 878:	00000097          	auipc	ra,0x0
 87c:	dc4080e7          	jalr	-572(ra) # 63c <printint>
 880:	a269                	j	a0a <vprintf+0x23a>
      } else if(c == 'l') {
 882:	fdc42783          	lw	a5,-36(s0)
 886:	0007871b          	sext.w	a4,a5
 88a:	06c00793          	li	a5,108
 88e:	02f71663          	bne	a4,a5,8ba <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 892:	fb843783          	ld	a5,-72(s0)
 896:	00878713          	addi	a4,a5,8
 89a:	fae43c23          	sd	a4,-72(s0)
 89e:	639c                	ld	a5,0(a5)
 8a0:	0007871b          	sext.w	a4,a5
 8a4:	fcc42783          	lw	a5,-52(s0)
 8a8:	4681                	li	a3,0
 8aa:	4629                	li	a2,10
 8ac:	85ba                	mv	a1,a4
 8ae:	853e                	mv	a0,a5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	d8c080e7          	jalr	-628(ra) # 63c <printint>
 8b8:	aa89                	j	a0a <vprintf+0x23a>
      } else if(c == 'x') {
 8ba:	fdc42783          	lw	a5,-36(s0)
 8be:	0007871b          	sext.w	a4,a5
 8c2:	07800793          	li	a5,120
 8c6:	02f71463          	bne	a4,a5,8ee <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8ca:	fb843783          	ld	a5,-72(s0)
 8ce:	00878713          	addi	a4,a5,8
 8d2:	fae43c23          	sd	a4,-72(s0)
 8d6:	4398                	lw	a4,0(a5)
 8d8:	fcc42783          	lw	a5,-52(s0)
 8dc:	4681                	li	a3,0
 8de:	4641                	li	a2,16
 8e0:	85ba                	mv	a1,a4
 8e2:	853e                	mv	a0,a5
 8e4:	00000097          	auipc	ra,0x0
 8e8:	d58080e7          	jalr	-680(ra) # 63c <printint>
 8ec:	aa39                	j	a0a <vprintf+0x23a>
      } else if(c == 'p') {
 8ee:	fdc42783          	lw	a5,-36(s0)
 8f2:	0007871b          	sext.w	a4,a5
 8f6:	07000793          	li	a5,112
 8fa:	02f71263          	bne	a4,a5,91e <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8fe:	fb843783          	ld	a5,-72(s0)
 902:	00878713          	addi	a4,a5,8
 906:	fae43c23          	sd	a4,-72(s0)
 90a:	6398                	ld	a4,0(a5)
 90c:	fcc42783          	lw	a5,-52(s0)
 910:	85ba                	mv	a1,a4
 912:	853e                	mv	a0,a5
 914:	00000097          	auipc	ra,0x0
 918:	e30080e7          	jalr	-464(ra) # 744 <printptr>
 91c:	a0fd                	j	a0a <vprintf+0x23a>
      } else if(c == 's'){
 91e:	fdc42783          	lw	a5,-36(s0)
 922:	0007871b          	sext.w	a4,a5
 926:	07300793          	li	a5,115
 92a:	04f71c63          	bne	a4,a5,982 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 92e:	fb843783          	ld	a5,-72(s0)
 932:	00878713          	addi	a4,a5,8
 936:	fae43c23          	sd	a4,-72(s0)
 93a:	639c                	ld	a5,0(a5)
 93c:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 940:	fe843783          	ld	a5,-24(s0)
 944:	eb8d                	bnez	a5,976 <vprintf+0x1a6>
          s = "(null)";
 946:	00000797          	auipc	a5,0x0
 94a:	48a78793          	addi	a5,a5,1162 # dd0 <malloc+0x150>
 94e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 952:	a015                	j	976 <vprintf+0x1a6>
          putc(fd, *s);
 954:	fe843783          	ld	a5,-24(s0)
 958:	0007c703          	lbu	a4,0(a5)
 95c:	fcc42783          	lw	a5,-52(s0)
 960:	85ba                	mv	a1,a4
 962:	853e                	mv	a0,a5
 964:	00000097          	auipc	ra,0x0
 968:	ca2080e7          	jalr	-862(ra) # 606 <putc>
          s++;
 96c:	fe843783          	ld	a5,-24(s0)
 970:	0785                	addi	a5,a5,1
 972:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 976:	fe843783          	ld	a5,-24(s0)
 97a:	0007c783          	lbu	a5,0(a5)
 97e:	fbf9                	bnez	a5,954 <vprintf+0x184>
 980:	a069                	j	a0a <vprintf+0x23a>
        }
      } else if(c == 'c'){
 982:	fdc42783          	lw	a5,-36(s0)
 986:	0007871b          	sext.w	a4,a5
 98a:	06300793          	li	a5,99
 98e:	02f71463          	bne	a4,a5,9b6 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 992:	fb843783          	ld	a5,-72(s0)
 996:	00878713          	addi	a4,a5,8
 99a:	fae43c23          	sd	a4,-72(s0)
 99e:	439c                	lw	a5,0(a5)
 9a0:	0ff7f713          	zext.b	a4,a5
 9a4:	fcc42783          	lw	a5,-52(s0)
 9a8:	85ba                	mv	a1,a4
 9aa:	853e                	mv	a0,a5
 9ac:	00000097          	auipc	ra,0x0
 9b0:	c5a080e7          	jalr	-934(ra) # 606 <putc>
 9b4:	a899                	j	a0a <vprintf+0x23a>
      } else if(c == '%'){
 9b6:	fdc42783          	lw	a5,-36(s0)
 9ba:	0007871b          	sext.w	a4,a5
 9be:	02500793          	li	a5,37
 9c2:	00f71f63          	bne	a4,a5,9e0 <vprintf+0x210>
        putc(fd, c);
 9c6:	fdc42783          	lw	a5,-36(s0)
 9ca:	0ff7f713          	zext.b	a4,a5
 9ce:	fcc42783          	lw	a5,-52(s0)
 9d2:	85ba                	mv	a1,a4
 9d4:	853e                	mv	a0,a5
 9d6:	00000097          	auipc	ra,0x0
 9da:	c30080e7          	jalr	-976(ra) # 606 <putc>
 9de:	a035                	j	a0a <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9e0:	fcc42783          	lw	a5,-52(s0)
 9e4:	02500593          	li	a1,37
 9e8:	853e                	mv	a0,a5
 9ea:	00000097          	auipc	ra,0x0
 9ee:	c1c080e7          	jalr	-996(ra) # 606 <putc>
        putc(fd, c);
 9f2:	fdc42783          	lw	a5,-36(s0)
 9f6:	0ff7f713          	zext.b	a4,a5
 9fa:	fcc42783          	lw	a5,-52(s0)
 9fe:	85ba                	mv	a1,a4
 a00:	853e                	mv	a0,a5
 a02:	00000097          	auipc	ra,0x0
 a06:	c04080e7          	jalr	-1020(ra) # 606 <putc>
      }
      state = 0;
 a0a:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a0e:	fe442783          	lw	a5,-28(s0)
 a12:	2785                	addiw	a5,a5,1
 a14:	fef42223          	sw	a5,-28(s0)
 a18:	fe442783          	lw	a5,-28(s0)
 a1c:	fc043703          	ld	a4,-64(s0)
 a20:	97ba                	add	a5,a5,a4
 a22:	0007c783          	lbu	a5,0(a5)
 a26:	dc0795e3          	bnez	a5,7f0 <vprintf+0x20>
    }
  }
}
 a2a:	0001                	nop
 a2c:	0001                	nop
 a2e:	60a6                	ld	ra,72(sp)
 a30:	6406                	ld	s0,64(sp)
 a32:	6161                	addi	sp,sp,80
 a34:	8082                	ret

0000000000000a36 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a36:	7159                	addi	sp,sp,-112
 a38:	fc06                	sd	ra,56(sp)
 a3a:	f822                	sd	s0,48(sp)
 a3c:	0080                	addi	s0,sp,64
 a3e:	fcb43823          	sd	a1,-48(s0)
 a42:	e010                	sd	a2,0(s0)
 a44:	e414                	sd	a3,8(s0)
 a46:	e818                	sd	a4,16(s0)
 a48:	ec1c                	sd	a5,24(s0)
 a4a:	03043023          	sd	a6,32(s0)
 a4e:	03143423          	sd	a7,40(s0)
 a52:	87aa                	mv	a5,a0
 a54:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a58:	03040793          	addi	a5,s0,48
 a5c:	fcf43423          	sd	a5,-56(s0)
 a60:	fc843783          	ld	a5,-56(s0)
 a64:	fd078793          	addi	a5,a5,-48
 a68:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a6c:	fe843703          	ld	a4,-24(s0)
 a70:	fdc42783          	lw	a5,-36(s0)
 a74:	863a                	mv	a2,a4
 a76:	fd043583          	ld	a1,-48(s0)
 a7a:	853e                	mv	a0,a5
 a7c:	00000097          	auipc	ra,0x0
 a80:	d54080e7          	jalr	-684(ra) # 7d0 <vprintf>
}
 a84:	0001                	nop
 a86:	70e2                	ld	ra,56(sp)
 a88:	7442                	ld	s0,48(sp)
 a8a:	6165                	addi	sp,sp,112
 a8c:	8082                	ret

0000000000000a8e <printf>:

void
printf(const char *fmt, ...)
{
 a8e:	7159                	addi	sp,sp,-112
 a90:	f406                	sd	ra,40(sp)
 a92:	f022                	sd	s0,32(sp)
 a94:	1800                	addi	s0,sp,48
 a96:	fca43c23          	sd	a0,-40(s0)
 a9a:	e40c                	sd	a1,8(s0)
 a9c:	e810                	sd	a2,16(s0)
 a9e:	ec14                	sd	a3,24(s0)
 aa0:	f018                	sd	a4,32(s0)
 aa2:	f41c                	sd	a5,40(s0)
 aa4:	03043823          	sd	a6,48(s0)
 aa8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aac:	04040793          	addi	a5,s0,64
 ab0:	fcf43823          	sd	a5,-48(s0)
 ab4:	fd043783          	ld	a5,-48(s0)
 ab8:	fc878793          	addi	a5,a5,-56
 abc:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ac0:	fe843783          	ld	a5,-24(s0)
 ac4:	863e                	mv	a2,a5
 ac6:	fd843583          	ld	a1,-40(s0)
 aca:	4505                	li	a0,1
 acc:	00000097          	auipc	ra,0x0
 ad0:	d04080e7          	jalr	-764(ra) # 7d0 <vprintf>
}
 ad4:	0001                	nop
 ad6:	70a2                	ld	ra,40(sp)
 ad8:	7402                	ld	s0,32(sp)
 ada:	6165                	addi	sp,sp,112
 adc:	8082                	ret

0000000000000ade <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ade:	7179                	addi	sp,sp,-48
 ae0:	f422                	sd	s0,40(sp)
 ae2:	1800                	addi	s0,sp,48
 ae4:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ae8:	fd843783          	ld	a5,-40(s0)
 aec:	17c1                	addi	a5,a5,-16
 aee:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af2:	00001797          	auipc	a5,0x1
 af6:	8ae78793          	addi	a5,a5,-1874 # 13a0 <freep>
 afa:	639c                	ld	a5,0(a5)
 afc:	fef43423          	sd	a5,-24(s0)
 b00:	a815                	j	b34 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b02:	fe843783          	ld	a5,-24(s0)
 b06:	639c                	ld	a5,0(a5)
 b08:	fe843703          	ld	a4,-24(s0)
 b0c:	00f76f63          	bltu	a4,a5,b2a <free+0x4c>
 b10:	fe043703          	ld	a4,-32(s0)
 b14:	fe843783          	ld	a5,-24(s0)
 b18:	02e7eb63          	bltu	a5,a4,b4e <free+0x70>
 b1c:	fe843783          	ld	a5,-24(s0)
 b20:	639c                	ld	a5,0(a5)
 b22:	fe043703          	ld	a4,-32(s0)
 b26:	02f76463          	bltu	a4,a5,b4e <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b2a:	fe843783          	ld	a5,-24(s0)
 b2e:	639c                	ld	a5,0(a5)
 b30:	fef43423          	sd	a5,-24(s0)
 b34:	fe043703          	ld	a4,-32(s0)
 b38:	fe843783          	ld	a5,-24(s0)
 b3c:	fce7f3e3          	bgeu	a5,a4,b02 <free+0x24>
 b40:	fe843783          	ld	a5,-24(s0)
 b44:	639c                	ld	a5,0(a5)
 b46:	fe043703          	ld	a4,-32(s0)
 b4a:	faf77ce3          	bgeu	a4,a5,b02 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b4e:	fe043783          	ld	a5,-32(s0)
 b52:	479c                	lw	a5,8(a5)
 b54:	1782                	slli	a5,a5,0x20
 b56:	9381                	srli	a5,a5,0x20
 b58:	0792                	slli	a5,a5,0x4
 b5a:	fe043703          	ld	a4,-32(s0)
 b5e:	973e                	add	a4,a4,a5
 b60:	fe843783          	ld	a5,-24(s0)
 b64:	639c                	ld	a5,0(a5)
 b66:	02f71763          	bne	a4,a5,b94 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b6a:	fe043783          	ld	a5,-32(s0)
 b6e:	4798                	lw	a4,8(a5)
 b70:	fe843783          	ld	a5,-24(s0)
 b74:	639c                	ld	a5,0(a5)
 b76:	479c                	lw	a5,8(a5)
 b78:	9fb9                	addw	a5,a5,a4
 b7a:	0007871b          	sext.w	a4,a5
 b7e:	fe043783          	ld	a5,-32(s0)
 b82:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b84:	fe843783          	ld	a5,-24(s0)
 b88:	639c                	ld	a5,0(a5)
 b8a:	6398                	ld	a4,0(a5)
 b8c:	fe043783          	ld	a5,-32(s0)
 b90:	e398                	sd	a4,0(a5)
 b92:	a039                	j	ba0 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b94:	fe843783          	ld	a5,-24(s0)
 b98:	6398                	ld	a4,0(a5)
 b9a:	fe043783          	ld	a5,-32(s0)
 b9e:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 ba0:	fe843783          	ld	a5,-24(s0)
 ba4:	479c                	lw	a5,8(a5)
 ba6:	1782                	slli	a5,a5,0x20
 ba8:	9381                	srli	a5,a5,0x20
 baa:	0792                	slli	a5,a5,0x4
 bac:	fe843703          	ld	a4,-24(s0)
 bb0:	97ba                	add	a5,a5,a4
 bb2:	fe043703          	ld	a4,-32(s0)
 bb6:	02f71563          	bne	a4,a5,be0 <free+0x102>
    p->s.size += bp->s.size;
 bba:	fe843783          	ld	a5,-24(s0)
 bbe:	4798                	lw	a4,8(a5)
 bc0:	fe043783          	ld	a5,-32(s0)
 bc4:	479c                	lw	a5,8(a5)
 bc6:	9fb9                	addw	a5,a5,a4
 bc8:	0007871b          	sext.w	a4,a5
 bcc:	fe843783          	ld	a5,-24(s0)
 bd0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bd2:	fe043783          	ld	a5,-32(s0)
 bd6:	6398                	ld	a4,0(a5)
 bd8:	fe843783          	ld	a5,-24(s0)
 bdc:	e398                	sd	a4,0(a5)
 bde:	a031                	j	bea <free+0x10c>
  } else
    p->s.ptr = bp;
 be0:	fe843783          	ld	a5,-24(s0)
 be4:	fe043703          	ld	a4,-32(s0)
 be8:	e398                	sd	a4,0(a5)
  freep = p;
 bea:	00000797          	auipc	a5,0x0
 bee:	7b678793          	addi	a5,a5,1974 # 13a0 <freep>
 bf2:	fe843703          	ld	a4,-24(s0)
 bf6:	e398                	sd	a4,0(a5)
}
 bf8:	0001                	nop
 bfa:	7422                	ld	s0,40(sp)
 bfc:	6145                	addi	sp,sp,48
 bfe:	8082                	ret

0000000000000c00 <morecore>:

static Header*
morecore(uint nu)
{
 c00:	7179                	addi	sp,sp,-48
 c02:	f406                	sd	ra,40(sp)
 c04:	f022                	sd	s0,32(sp)
 c06:	1800                	addi	s0,sp,48
 c08:	87aa                	mv	a5,a0
 c0a:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c0e:	fdc42783          	lw	a5,-36(s0)
 c12:	0007871b          	sext.w	a4,a5
 c16:	6785                	lui	a5,0x1
 c18:	00f77563          	bgeu	a4,a5,c22 <morecore+0x22>
    nu = 4096;
 c1c:	6785                	lui	a5,0x1
 c1e:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c22:	fdc42783          	lw	a5,-36(s0)
 c26:	0047979b          	slliw	a5,a5,0x4
 c2a:	2781                	sext.w	a5,a5
 c2c:	2781                	sext.w	a5,a5
 c2e:	853e                	mv	a0,a5
 c30:	00000097          	auipc	ra,0x0
 c34:	9be080e7          	jalr	-1602(ra) # 5ee <sbrk>
 c38:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c3c:	fe843703          	ld	a4,-24(s0)
 c40:	57fd                	li	a5,-1
 c42:	00f71463          	bne	a4,a5,c4a <morecore+0x4a>
    return 0;
 c46:	4781                	li	a5,0
 c48:	a03d                	j	c76 <morecore+0x76>
  hp = (Header*)p;
 c4a:	fe843783          	ld	a5,-24(s0)
 c4e:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c52:	fe043783          	ld	a5,-32(s0)
 c56:	fdc42703          	lw	a4,-36(s0)
 c5a:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c5c:	fe043783          	ld	a5,-32(s0)
 c60:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x390>
 c62:	853e                	mv	a0,a5
 c64:	00000097          	auipc	ra,0x0
 c68:	e7a080e7          	jalr	-390(ra) # ade <free>
  return freep;
 c6c:	00000797          	auipc	a5,0x0
 c70:	73478793          	addi	a5,a5,1844 # 13a0 <freep>
 c74:	639c                	ld	a5,0(a5)
}
 c76:	853e                	mv	a0,a5
 c78:	70a2                	ld	ra,40(sp)
 c7a:	7402                	ld	s0,32(sp)
 c7c:	6145                	addi	sp,sp,48
 c7e:	8082                	ret

0000000000000c80 <malloc>:

void*
malloc(uint nbytes)
{
 c80:	7139                	addi	sp,sp,-64
 c82:	fc06                	sd	ra,56(sp)
 c84:	f822                	sd	s0,48(sp)
 c86:	0080                	addi	s0,sp,64
 c88:	87aa                	mv	a5,a0
 c8a:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c8e:	fcc46783          	lwu	a5,-52(s0)
 c92:	07bd                	addi	a5,a5,15
 c94:	8391                	srli	a5,a5,0x4
 c96:	2781                	sext.w	a5,a5
 c98:	2785                	addiw	a5,a5,1
 c9a:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c9e:	00000797          	auipc	a5,0x0
 ca2:	70278793          	addi	a5,a5,1794 # 13a0 <freep>
 ca6:	639c                	ld	a5,0(a5)
 ca8:	fef43023          	sd	a5,-32(s0)
 cac:	fe043783          	ld	a5,-32(s0)
 cb0:	ef95                	bnez	a5,cec <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cb2:	00000797          	auipc	a5,0x0
 cb6:	6de78793          	addi	a5,a5,1758 # 1390 <base>
 cba:	fef43023          	sd	a5,-32(s0)
 cbe:	00000797          	auipc	a5,0x0
 cc2:	6e278793          	addi	a5,a5,1762 # 13a0 <freep>
 cc6:	fe043703          	ld	a4,-32(s0)
 cca:	e398                	sd	a4,0(a5)
 ccc:	00000797          	auipc	a5,0x0
 cd0:	6d478793          	addi	a5,a5,1748 # 13a0 <freep>
 cd4:	6398                	ld	a4,0(a5)
 cd6:	00000797          	auipc	a5,0x0
 cda:	6ba78793          	addi	a5,a5,1722 # 1390 <base>
 cde:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 ce0:	00000797          	auipc	a5,0x0
 ce4:	6b078793          	addi	a5,a5,1712 # 1390 <base>
 ce8:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cec:	fe043783          	ld	a5,-32(s0)
 cf0:	639c                	ld	a5,0(a5)
 cf2:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 cf6:	fe843783          	ld	a5,-24(s0)
 cfa:	4798                	lw	a4,8(a5)
 cfc:	fdc42783          	lw	a5,-36(s0)
 d00:	2781                	sext.w	a5,a5
 d02:	06f76763          	bltu	a4,a5,d70 <malloc+0xf0>
      if(p->s.size == nunits)
 d06:	fe843783          	ld	a5,-24(s0)
 d0a:	4798                	lw	a4,8(a5)
 d0c:	fdc42783          	lw	a5,-36(s0)
 d10:	2781                	sext.w	a5,a5
 d12:	00e79963          	bne	a5,a4,d24 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d16:	fe843783          	ld	a5,-24(s0)
 d1a:	6398                	ld	a4,0(a5)
 d1c:	fe043783          	ld	a5,-32(s0)
 d20:	e398                	sd	a4,0(a5)
 d22:	a825                	j	d5a <malloc+0xda>
      else {
        p->s.size -= nunits;
 d24:	fe843783          	ld	a5,-24(s0)
 d28:	479c                	lw	a5,8(a5)
 d2a:	fdc42703          	lw	a4,-36(s0)
 d2e:	9f99                	subw	a5,a5,a4
 d30:	0007871b          	sext.w	a4,a5
 d34:	fe843783          	ld	a5,-24(s0)
 d38:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d3a:	fe843783          	ld	a5,-24(s0)
 d3e:	479c                	lw	a5,8(a5)
 d40:	1782                	slli	a5,a5,0x20
 d42:	9381                	srli	a5,a5,0x20
 d44:	0792                	slli	a5,a5,0x4
 d46:	fe843703          	ld	a4,-24(s0)
 d4a:	97ba                	add	a5,a5,a4
 d4c:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d50:	fe843783          	ld	a5,-24(s0)
 d54:	fdc42703          	lw	a4,-36(s0)
 d58:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d5a:	00000797          	auipc	a5,0x0
 d5e:	64678793          	addi	a5,a5,1606 # 13a0 <freep>
 d62:	fe043703          	ld	a4,-32(s0)
 d66:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d68:	fe843783          	ld	a5,-24(s0)
 d6c:	07c1                	addi	a5,a5,16
 d6e:	a091                	j	db2 <malloc+0x132>
    }
    if(p == freep)
 d70:	00000797          	auipc	a5,0x0
 d74:	63078793          	addi	a5,a5,1584 # 13a0 <freep>
 d78:	639c                	ld	a5,0(a5)
 d7a:	fe843703          	ld	a4,-24(s0)
 d7e:	02f71063          	bne	a4,a5,d9e <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d82:	fdc42783          	lw	a5,-36(s0)
 d86:	853e                	mv	a0,a5
 d88:	00000097          	auipc	ra,0x0
 d8c:	e78080e7          	jalr	-392(ra) # c00 <morecore>
 d90:	fea43423          	sd	a0,-24(s0)
 d94:	fe843783          	ld	a5,-24(s0)
 d98:	e399                	bnez	a5,d9e <malloc+0x11e>
        return 0;
 d9a:	4781                	li	a5,0
 d9c:	a819                	j	db2 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d9e:	fe843783          	ld	a5,-24(s0)
 da2:	fef43023          	sd	a5,-32(s0)
 da6:	fe843783          	ld	a5,-24(s0)
 daa:	639c                	ld	a5,0(a5)
 dac:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 db0:	b799                	j	cf6 <malloc+0x76>
  }
}
 db2:	853e                	mv	a0,a5
 db4:	70e2                	ld	ra,56(sp)
 db6:	7442                	ld	s0,48(sp)
 db8:	6121                	addi	sp,sp,64
 dba:	8082                	ret
