
user/_HelloWorld:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include <user/user.h>


int main(int argc, int * argv[]){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	87aa                	mv	a5,a0
   a:	feb43023          	sd	a1,-32(s0)
   e:	fef42623          	sw	a5,-20(s0)

    if(argc != 1){
  12:	fec42783          	lw	a5,-20(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	4785                	li	a5,1
  1c:	02f70463          	beq	a4,a5,44 <main+0x44>
        printf("Hello %s nice to meet you!\n", argv[1]);
  20:	fe043783          	ld	a5,-32(s0)
  24:	07a1                	addi	a5,a5,8
  26:	639c                	ld	a5,0(a5)
  28:	85be                	mv	a1,a5
  2a:	00001517          	auipc	a0,0x1
  2e:	d3650513          	addi	a0,a0,-714 # d60 <malloc+0x13c>
  32:	00001097          	auipc	ra,0x1
  36:	a00080e7          	jalr	-1536(ra) # a32 <printf>
        exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	4ce080e7          	jalr	1230(ra) # 50a <exit>
    }

    printf("Hello World!\n");
  44:	00001517          	auipc	a0,0x1
  48:	d3c50513          	addi	a0,a0,-708 # d80 <malloc+0x15c>
  4c:	00001097          	auipc	ra,0x1
  50:	9e6080e7          	jalr	-1562(ra) # a32 <printf>
    exit(0);
  54:	4501                	li	a0,0
  56:	00000097          	auipc	ra,0x0
  5a:	4b4080e7          	jalr	1204(ra) # 50a <exit>

000000000000005e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  extern int main();
  main();
  66:	00000097          	auipc	ra,0x0
  6a:	f9a080e7          	jalr	-102(ra) # 0 <main>
  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	49a080e7          	jalr	1178(ra) # 50a <exit>

0000000000000078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  78:	7179                	addi	sp,sp,-48
  7a:	f422                	sd	s0,40(sp)
  7c:	1800                	addi	s0,sp,48
  7e:	fca43c23          	sd	a0,-40(s0)
  82:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  86:	fd843783          	ld	a5,-40(s0)
  8a:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  8e:	0001                	nop
  90:	fd043703          	ld	a4,-48(s0)
  94:	00170793          	addi	a5,a4,1
  98:	fcf43823          	sd	a5,-48(s0)
  9c:	fd843783          	ld	a5,-40(s0)
  a0:	00178693          	addi	a3,a5,1
  a4:	fcd43c23          	sd	a3,-40(s0)
  a8:	00074703          	lbu	a4,0(a4)
  ac:	00e78023          	sb	a4,0(a5)
  b0:	0007c783          	lbu	a5,0(a5)
  b4:	fff1                	bnez	a5,90 <strcpy+0x18>
    ;
  return os;
  b6:	fe843783          	ld	a5,-24(s0)
}
  ba:	853e                	mv	a0,a5
  bc:	7422                	ld	s0,40(sp)
  be:	6145                	addi	sp,sp,48
  c0:	8082                	ret

00000000000000c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c2:	1101                	addi	sp,sp,-32
  c4:	ec22                	sd	s0,24(sp)
  c6:	1000                	addi	s0,sp,32
  c8:	fea43423          	sd	a0,-24(s0)
  cc:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
  d0:	a819                	j	e6 <strcmp+0x24>
    p++, q++;
  d2:	fe843783          	ld	a5,-24(s0)
  d6:	0785                	addi	a5,a5,1
  d8:	fef43423          	sd	a5,-24(s0)
  dc:	fe043783          	ld	a5,-32(s0)
  e0:	0785                	addi	a5,a5,1
  e2:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
  e6:	fe843783          	ld	a5,-24(s0)
  ea:	0007c783          	lbu	a5,0(a5)
  ee:	cb99                	beqz	a5,104 <strcmp+0x42>
  f0:	fe843783          	ld	a5,-24(s0)
  f4:	0007c703          	lbu	a4,0(a5)
  f8:	fe043783          	ld	a5,-32(s0)
  fc:	0007c783          	lbu	a5,0(a5)
 100:	fcf709e3          	beq	a4,a5,d2 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 104:	fe843783          	ld	a5,-24(s0)
 108:	0007c783          	lbu	a5,0(a5)
 10c:	0007871b          	sext.w	a4,a5
 110:	fe043783          	ld	a5,-32(s0)
 114:	0007c783          	lbu	a5,0(a5)
 118:	2781                	sext.w	a5,a5
 11a:	40f707bb          	subw	a5,a4,a5
 11e:	2781                	sext.w	a5,a5
}
 120:	853e                	mv	a0,a5
 122:	6462                	ld	s0,24(sp)
 124:	6105                	addi	sp,sp,32
 126:	8082                	ret

0000000000000128 <strlen>:

uint
strlen(const char *s)
{
 128:	7179                	addi	sp,sp,-48
 12a:	f422                	sd	s0,40(sp)
 12c:	1800                	addi	s0,sp,48
 12e:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 132:	fe042623          	sw	zero,-20(s0)
 136:	a031                	j	142 <strlen+0x1a>
 138:	fec42783          	lw	a5,-20(s0)
 13c:	2785                	addiw	a5,a5,1
 13e:	fef42623          	sw	a5,-20(s0)
 142:	fec42783          	lw	a5,-20(s0)
 146:	fd843703          	ld	a4,-40(s0)
 14a:	97ba                	add	a5,a5,a4
 14c:	0007c783          	lbu	a5,0(a5)
 150:	f7e5                	bnez	a5,138 <strlen+0x10>
    ;
  return n;
 152:	fec42783          	lw	a5,-20(s0)
}
 156:	853e                	mv	a0,a5
 158:	7422                	ld	s0,40(sp)
 15a:	6145                	addi	sp,sp,48
 15c:	8082                	ret

000000000000015e <memset>:

void*
memset(void *dst, int c, uint n)
{
 15e:	7179                	addi	sp,sp,-48
 160:	f422                	sd	s0,40(sp)
 162:	1800                	addi	s0,sp,48
 164:	fca43c23          	sd	a0,-40(s0)
 168:	87ae                	mv	a5,a1
 16a:	8732                	mv	a4,a2
 16c:	fcf42a23          	sw	a5,-44(s0)
 170:	87ba                	mv	a5,a4
 172:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 176:	fd843783          	ld	a5,-40(s0)
 17a:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 17e:	fe042623          	sw	zero,-20(s0)
 182:	a00d                	j	1a4 <memset+0x46>
    cdst[i] = c;
 184:	fec42783          	lw	a5,-20(s0)
 188:	fe043703          	ld	a4,-32(s0)
 18c:	97ba                	add	a5,a5,a4
 18e:	fd442703          	lw	a4,-44(s0)
 192:	0ff77713          	zext.b	a4,a4
 196:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 19a:	fec42783          	lw	a5,-20(s0)
 19e:	2785                	addiw	a5,a5,1
 1a0:	fef42623          	sw	a5,-20(s0)
 1a4:	fec42703          	lw	a4,-20(s0)
 1a8:	fd042783          	lw	a5,-48(s0)
 1ac:	2781                	sext.w	a5,a5
 1ae:	fcf76be3          	bltu	a4,a5,184 <memset+0x26>
  }
  return dst;
 1b2:	fd843783          	ld	a5,-40(s0)
}
 1b6:	853e                	mv	a0,a5
 1b8:	7422                	ld	s0,40(sp)
 1ba:	6145                	addi	sp,sp,48
 1bc:	8082                	ret

00000000000001be <strchr>:

char*
strchr(const char *s, char c)
{
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec22                	sd	s0,24(sp)
 1c2:	1000                	addi	s0,sp,32
 1c4:	fea43423          	sd	a0,-24(s0)
 1c8:	87ae                	mv	a5,a1
 1ca:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 1ce:	a01d                	j	1f4 <strchr+0x36>
    if(*s == c)
 1d0:	fe843783          	ld	a5,-24(s0)
 1d4:	0007c703          	lbu	a4,0(a5)
 1d8:	fe744783          	lbu	a5,-25(s0)
 1dc:	0ff7f793          	zext.b	a5,a5
 1e0:	00e79563          	bne	a5,a4,1ea <strchr+0x2c>
      return (char*)s;
 1e4:	fe843783          	ld	a5,-24(s0)
 1e8:	a821                	j	200 <strchr+0x42>
  for(; *s; s++)
 1ea:	fe843783          	ld	a5,-24(s0)
 1ee:	0785                	addi	a5,a5,1
 1f0:	fef43423          	sd	a5,-24(s0)
 1f4:	fe843783          	ld	a5,-24(s0)
 1f8:	0007c783          	lbu	a5,0(a5)
 1fc:	fbf1                	bnez	a5,1d0 <strchr+0x12>
  return 0;
 1fe:	4781                	li	a5,0
}
 200:	853e                	mv	a0,a5
 202:	6462                	ld	s0,24(sp)
 204:	6105                	addi	sp,sp,32
 206:	8082                	ret

0000000000000208 <gets>:

char*
gets(char *buf, int max)
{
 208:	7179                	addi	sp,sp,-48
 20a:	f406                	sd	ra,40(sp)
 20c:	f022                	sd	s0,32(sp)
 20e:	1800                	addi	s0,sp,48
 210:	fca43c23          	sd	a0,-40(s0)
 214:	87ae                	mv	a5,a1
 216:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21a:	fe042623          	sw	zero,-20(s0)
 21e:	a8a1                	j	276 <gets+0x6e>
    cc = read(0, &c, 1);
 220:	fe740793          	addi	a5,s0,-25
 224:	4605                	li	a2,1
 226:	85be                	mv	a1,a5
 228:	4501                	li	a0,0
 22a:	00000097          	auipc	ra,0x0
 22e:	2f8080e7          	jalr	760(ra) # 522 <read>
 232:	87aa                	mv	a5,a0
 234:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 238:	fe842783          	lw	a5,-24(s0)
 23c:	2781                	sext.w	a5,a5
 23e:	04f05763          	blez	a5,28c <gets+0x84>
      break;
    buf[i++] = c;
 242:	fec42783          	lw	a5,-20(s0)
 246:	0017871b          	addiw	a4,a5,1
 24a:	fee42623          	sw	a4,-20(s0)
 24e:	873e                	mv	a4,a5
 250:	fd843783          	ld	a5,-40(s0)
 254:	97ba                	add	a5,a5,a4
 256:	fe744703          	lbu	a4,-25(s0)
 25a:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 25e:	fe744783          	lbu	a5,-25(s0)
 262:	873e                	mv	a4,a5
 264:	47a9                	li	a5,10
 266:	02f70463          	beq	a4,a5,28e <gets+0x86>
 26a:	fe744783          	lbu	a5,-25(s0)
 26e:	873e                	mv	a4,a5
 270:	47b5                	li	a5,13
 272:	00f70e63          	beq	a4,a5,28e <gets+0x86>
  for(i=0; i+1 < max; ){
 276:	fec42783          	lw	a5,-20(s0)
 27a:	2785                	addiw	a5,a5,1
 27c:	0007871b          	sext.w	a4,a5
 280:	fd442783          	lw	a5,-44(s0)
 284:	2781                	sext.w	a5,a5
 286:	f8f74de3          	blt	a4,a5,220 <gets+0x18>
 28a:	a011                	j	28e <gets+0x86>
      break;
 28c:	0001                	nop
      break;
  }
  buf[i] = '\0';
 28e:	fec42783          	lw	a5,-20(s0)
 292:	fd843703          	ld	a4,-40(s0)
 296:	97ba                	add	a5,a5,a4
 298:	00078023          	sb	zero,0(a5)
  return buf;
 29c:	fd843783          	ld	a5,-40(s0)
}
 2a0:	853e                	mv	a0,a5
 2a2:	70a2                	ld	ra,40(sp)
 2a4:	7402                	ld	s0,32(sp)
 2a6:	6145                	addi	sp,sp,48
 2a8:	8082                	ret

00000000000002aa <stat>:

int
stat(const char *n, struct stat *st)
{
 2aa:	7179                	addi	sp,sp,-48
 2ac:	f406                	sd	ra,40(sp)
 2ae:	f022                	sd	s0,32(sp)
 2b0:	1800                	addi	s0,sp,48
 2b2:	fca43c23          	sd	a0,-40(s0)
 2b6:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ba:	4581                	li	a1,0
 2bc:	fd843503          	ld	a0,-40(s0)
 2c0:	00000097          	auipc	ra,0x0
 2c4:	28a080e7          	jalr	650(ra) # 54a <open>
 2c8:	87aa                	mv	a5,a0
 2ca:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 2ce:	fec42783          	lw	a5,-20(s0)
 2d2:	2781                	sext.w	a5,a5
 2d4:	0007d463          	bgez	a5,2dc <stat+0x32>
    return -1;
 2d8:	57fd                	li	a5,-1
 2da:	a035                	j	306 <stat+0x5c>
  r = fstat(fd, st);
 2dc:	fec42783          	lw	a5,-20(s0)
 2e0:	fd043583          	ld	a1,-48(s0)
 2e4:	853e                	mv	a0,a5
 2e6:	00000097          	auipc	ra,0x0
 2ea:	27c080e7          	jalr	636(ra) # 562 <fstat>
 2ee:	87aa                	mv	a5,a0
 2f0:	fef42423          	sw	a5,-24(s0)
  close(fd);
 2f4:	fec42783          	lw	a5,-20(s0)
 2f8:	853e                	mv	a0,a5
 2fa:	00000097          	auipc	ra,0x0
 2fe:	238080e7          	jalr	568(ra) # 532 <close>
  return r;
 302:	fe842783          	lw	a5,-24(s0)
}
 306:	853e                	mv	a0,a5
 308:	70a2                	ld	ra,40(sp)
 30a:	7402                	ld	s0,32(sp)
 30c:	6145                	addi	sp,sp,48
 30e:	8082                	ret

0000000000000310 <atoi>:

int
atoi(const char *s)
{
 310:	7179                	addi	sp,sp,-48
 312:	f422                	sd	s0,40(sp)
 314:	1800                	addi	s0,sp,48
 316:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 31a:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 31e:	a81d                	j	354 <atoi+0x44>
    n = n*10 + *s++ - '0';
 320:	fec42783          	lw	a5,-20(s0)
 324:	873e                	mv	a4,a5
 326:	87ba                	mv	a5,a4
 328:	0027979b          	slliw	a5,a5,0x2
 32c:	9fb9                	addw	a5,a5,a4
 32e:	0017979b          	slliw	a5,a5,0x1
 332:	0007871b          	sext.w	a4,a5
 336:	fd843783          	ld	a5,-40(s0)
 33a:	00178693          	addi	a3,a5,1
 33e:	fcd43c23          	sd	a3,-40(s0)
 342:	0007c783          	lbu	a5,0(a5)
 346:	2781                	sext.w	a5,a5
 348:	9fb9                	addw	a5,a5,a4
 34a:	2781                	sext.w	a5,a5
 34c:	fd07879b          	addiw	a5,a5,-48
 350:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 354:	fd843783          	ld	a5,-40(s0)
 358:	0007c783          	lbu	a5,0(a5)
 35c:	873e                	mv	a4,a5
 35e:	02f00793          	li	a5,47
 362:	00e7fb63          	bgeu	a5,a4,378 <atoi+0x68>
 366:	fd843783          	ld	a5,-40(s0)
 36a:	0007c783          	lbu	a5,0(a5)
 36e:	873e                	mv	a4,a5
 370:	03900793          	li	a5,57
 374:	fae7f6e3          	bgeu	a5,a4,320 <atoi+0x10>
  return n;
 378:	fec42783          	lw	a5,-20(s0)
}
 37c:	853e                	mv	a0,a5
 37e:	7422                	ld	s0,40(sp)
 380:	6145                	addi	sp,sp,48
 382:	8082                	ret

0000000000000384 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 384:	7139                	addi	sp,sp,-64
 386:	fc22                	sd	s0,56(sp)
 388:	0080                	addi	s0,sp,64
 38a:	fca43c23          	sd	a0,-40(s0)
 38e:	fcb43823          	sd	a1,-48(s0)
 392:	87b2                	mv	a5,a2
 394:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 398:	fd843783          	ld	a5,-40(s0)
 39c:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3a0:	fd043783          	ld	a5,-48(s0)
 3a4:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3a8:	fe043703          	ld	a4,-32(s0)
 3ac:	fe843783          	ld	a5,-24(s0)
 3b0:	02e7fc63          	bgeu	a5,a4,3e8 <memmove+0x64>
    while(n-- > 0)
 3b4:	a00d                	j	3d6 <memmove+0x52>
      *dst++ = *src++;
 3b6:	fe043703          	ld	a4,-32(s0)
 3ba:	00170793          	addi	a5,a4,1
 3be:	fef43023          	sd	a5,-32(s0)
 3c2:	fe843783          	ld	a5,-24(s0)
 3c6:	00178693          	addi	a3,a5,1
 3ca:	fed43423          	sd	a3,-24(s0)
 3ce:	00074703          	lbu	a4,0(a4)
 3d2:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 3d6:	fcc42783          	lw	a5,-52(s0)
 3da:	fff7871b          	addiw	a4,a5,-1
 3de:	fce42623          	sw	a4,-52(s0)
 3e2:	fcf04ae3          	bgtz	a5,3b6 <memmove+0x32>
 3e6:	a891                	j	43a <memmove+0xb6>
  } else {
    dst += n;
 3e8:	fcc42783          	lw	a5,-52(s0)
 3ec:	fe843703          	ld	a4,-24(s0)
 3f0:	97ba                	add	a5,a5,a4
 3f2:	fef43423          	sd	a5,-24(s0)
    src += n;
 3f6:	fcc42783          	lw	a5,-52(s0)
 3fa:	fe043703          	ld	a4,-32(s0)
 3fe:	97ba                	add	a5,a5,a4
 400:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 404:	a01d                	j	42a <memmove+0xa6>
      *--dst = *--src;
 406:	fe043783          	ld	a5,-32(s0)
 40a:	17fd                	addi	a5,a5,-1
 40c:	fef43023          	sd	a5,-32(s0)
 410:	fe843783          	ld	a5,-24(s0)
 414:	17fd                	addi	a5,a5,-1
 416:	fef43423          	sd	a5,-24(s0)
 41a:	fe043783          	ld	a5,-32(s0)
 41e:	0007c703          	lbu	a4,0(a5)
 422:	fe843783          	ld	a5,-24(s0)
 426:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 42a:	fcc42783          	lw	a5,-52(s0)
 42e:	fff7871b          	addiw	a4,a5,-1
 432:	fce42623          	sw	a4,-52(s0)
 436:	fcf048e3          	bgtz	a5,406 <memmove+0x82>
  }
  return vdst;
 43a:	fd843783          	ld	a5,-40(s0)
}
 43e:	853e                	mv	a0,a5
 440:	7462                	ld	s0,56(sp)
 442:	6121                	addi	sp,sp,64
 444:	8082                	ret

0000000000000446 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 446:	7139                	addi	sp,sp,-64
 448:	fc22                	sd	s0,56(sp)
 44a:	0080                	addi	s0,sp,64
 44c:	fca43c23          	sd	a0,-40(s0)
 450:	fcb43823          	sd	a1,-48(s0)
 454:	87b2                	mv	a5,a2
 456:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 45a:	fd843783          	ld	a5,-40(s0)
 45e:	fef43423          	sd	a5,-24(s0)
 462:	fd043783          	ld	a5,-48(s0)
 466:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 46a:	a0a1                	j	4b2 <memcmp+0x6c>
    if (*p1 != *p2) {
 46c:	fe843783          	ld	a5,-24(s0)
 470:	0007c703          	lbu	a4,0(a5)
 474:	fe043783          	ld	a5,-32(s0)
 478:	0007c783          	lbu	a5,0(a5)
 47c:	02f70163          	beq	a4,a5,49e <memcmp+0x58>
      return *p1 - *p2;
 480:	fe843783          	ld	a5,-24(s0)
 484:	0007c783          	lbu	a5,0(a5)
 488:	0007871b          	sext.w	a4,a5
 48c:	fe043783          	ld	a5,-32(s0)
 490:	0007c783          	lbu	a5,0(a5)
 494:	2781                	sext.w	a5,a5
 496:	40f707bb          	subw	a5,a4,a5
 49a:	2781                	sext.w	a5,a5
 49c:	a01d                	j	4c2 <memcmp+0x7c>
    }
    p1++;
 49e:	fe843783          	ld	a5,-24(s0)
 4a2:	0785                	addi	a5,a5,1
 4a4:	fef43423          	sd	a5,-24(s0)
    p2++;
 4a8:	fe043783          	ld	a5,-32(s0)
 4ac:	0785                	addi	a5,a5,1
 4ae:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4b2:	fcc42783          	lw	a5,-52(s0)
 4b6:	fff7871b          	addiw	a4,a5,-1
 4ba:	fce42623          	sw	a4,-52(s0)
 4be:	f7dd                	bnez	a5,46c <memcmp+0x26>
  }
  return 0;
 4c0:	4781                	li	a5,0
}
 4c2:	853e                	mv	a0,a5
 4c4:	7462                	ld	s0,56(sp)
 4c6:	6121                	addi	sp,sp,64
 4c8:	8082                	ret

00000000000004ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ca:	7179                	addi	sp,sp,-48
 4cc:	f406                	sd	ra,40(sp)
 4ce:	f022                	sd	s0,32(sp)
 4d0:	1800                	addi	s0,sp,48
 4d2:	fea43423          	sd	a0,-24(s0)
 4d6:	feb43023          	sd	a1,-32(s0)
 4da:	87b2                	mv	a5,a2
 4dc:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 4e0:	fdc42783          	lw	a5,-36(s0)
 4e4:	863e                	mv	a2,a5
 4e6:	fe043583          	ld	a1,-32(s0)
 4ea:	fe843503          	ld	a0,-24(s0)
 4ee:	00000097          	auipc	ra,0x0
 4f2:	e96080e7          	jalr	-362(ra) # 384 <memmove>
 4f6:	87aa                	mv	a5,a0
}
 4f8:	853e                	mv	a0,a5
 4fa:	70a2                	ld	ra,40(sp)
 4fc:	7402                	ld	s0,32(sp)
 4fe:	6145                	addi	sp,sp,48
 500:	8082                	ret

0000000000000502 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 502:	4885                	li	a7,1
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exit>:
.global exit
exit:
 li a7, SYS_exit
 50a:	4889                	li	a7,2
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <wait>:
.global wait
wait:
 li a7, SYS_wait
 512:	488d                	li	a7,3
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 51a:	4891                	li	a7,4
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <read>:
.global read
read:
 li a7, SYS_read
 522:	4895                	li	a7,5
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <write>:
.global write
write:
 li a7, SYS_write
 52a:	48c1                	li	a7,16
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <close>:
.global close
close:
 li a7, SYS_close
 532:	48d5                	li	a7,21
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <kill>:
.global kill
kill:
 li a7, SYS_kill
 53a:	4899                	li	a7,6
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <exec>:
.global exec
exec:
 li a7, SYS_exec
 542:	489d                	li	a7,7
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <open>:
.global open
open:
 li a7, SYS_open
 54a:	48bd                	li	a7,15
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 552:	48c5                	li	a7,17
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 55a:	48c9                	li	a7,18
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 562:	48a1                	li	a7,8
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <link>:
.global link
link:
 li a7, SYS_link
 56a:	48cd                	li	a7,19
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 572:	48d1                	li	a7,20
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 57a:	48a5                	li	a7,9
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <dup>:
.global dup
dup:
 li a7, SYS_dup
 582:	48a9                	li	a7,10
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 58a:	48ad                	li	a7,11
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 592:	48b1                	li	a7,12
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 59a:	48b5                	li	a7,13
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a2:	48b9                	li	a7,14
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5aa:	1101                	addi	sp,sp,-32
 5ac:	ec06                	sd	ra,24(sp)
 5ae:	e822                	sd	s0,16(sp)
 5b0:	1000                	addi	s0,sp,32
 5b2:	87aa                	mv	a5,a0
 5b4:	872e                	mv	a4,a1
 5b6:	fef42623          	sw	a5,-20(s0)
 5ba:	87ba                	mv	a5,a4
 5bc:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5c0:	feb40713          	addi	a4,s0,-21
 5c4:	fec42783          	lw	a5,-20(s0)
 5c8:	4605                	li	a2,1
 5ca:	85ba                	mv	a1,a4
 5cc:	853e                	mv	a0,a5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	f5c080e7          	jalr	-164(ra) # 52a <write>
}
 5d6:	0001                	nop
 5d8:	60e2                	ld	ra,24(sp)
 5da:	6442                	ld	s0,16(sp)
 5dc:	6105                	addi	sp,sp,32
 5de:	8082                	ret

00000000000005e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e0:	7139                	addi	sp,sp,-64
 5e2:	fc06                	sd	ra,56(sp)
 5e4:	f822                	sd	s0,48(sp)
 5e6:	0080                	addi	s0,sp,64
 5e8:	87aa                	mv	a5,a0
 5ea:	8736                	mv	a4,a3
 5ec:	fcf42623          	sw	a5,-52(s0)
 5f0:	87ae                	mv	a5,a1
 5f2:	fcf42423          	sw	a5,-56(s0)
 5f6:	87b2                	mv	a5,a2
 5f8:	fcf42223          	sw	a5,-60(s0)
 5fc:	87ba                	mv	a5,a4
 5fe:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 602:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 606:	fc042783          	lw	a5,-64(s0)
 60a:	2781                	sext.w	a5,a5
 60c:	c38d                	beqz	a5,62e <printint+0x4e>
 60e:	fc842783          	lw	a5,-56(s0)
 612:	2781                	sext.w	a5,a5
 614:	0007dd63          	bgez	a5,62e <printint+0x4e>
    neg = 1;
 618:	4785                	li	a5,1
 61a:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 61e:	fc842783          	lw	a5,-56(s0)
 622:	40f007bb          	negw	a5,a5
 626:	2781                	sext.w	a5,a5
 628:	fef42223          	sw	a5,-28(s0)
 62c:	a029                	j	636 <printint+0x56>
  } else {
    x = xx;
 62e:	fc842783          	lw	a5,-56(s0)
 632:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 636:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 63a:	fc442783          	lw	a5,-60(s0)
 63e:	fe442703          	lw	a4,-28(s0)
 642:	02f777bb          	remuw	a5,a4,a5
 646:	0007861b          	sext.w	a2,a5
 64a:	fec42783          	lw	a5,-20(s0)
 64e:	0017871b          	addiw	a4,a5,1
 652:	fee42623          	sw	a4,-20(s0)
 656:	00001697          	auipc	a3,0x1
 65a:	d1a68693          	addi	a3,a3,-742 # 1370 <digits>
 65e:	02061713          	slli	a4,a2,0x20
 662:	9301                	srli	a4,a4,0x20
 664:	9736                	add	a4,a4,a3
 666:	00074703          	lbu	a4,0(a4)
 66a:	17c1                	addi	a5,a5,-16
 66c:	97a2                	add	a5,a5,s0
 66e:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 672:	fc442783          	lw	a5,-60(s0)
 676:	fe442703          	lw	a4,-28(s0)
 67a:	02f757bb          	divuw	a5,a4,a5
 67e:	fef42223          	sw	a5,-28(s0)
 682:	fe442783          	lw	a5,-28(s0)
 686:	2781                	sext.w	a5,a5
 688:	fbcd                	bnez	a5,63a <printint+0x5a>
  if(neg)
 68a:	fe842783          	lw	a5,-24(s0)
 68e:	2781                	sext.w	a5,a5
 690:	cf85                	beqz	a5,6c8 <printint+0xe8>
    buf[i++] = '-';
 692:	fec42783          	lw	a5,-20(s0)
 696:	0017871b          	addiw	a4,a5,1
 69a:	fee42623          	sw	a4,-20(s0)
 69e:	17c1                	addi	a5,a5,-16
 6a0:	97a2                	add	a5,a5,s0
 6a2:	02d00713          	li	a4,45
 6a6:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6aa:	a839                	j	6c8 <printint+0xe8>
    putc(fd, buf[i]);
 6ac:	fec42783          	lw	a5,-20(s0)
 6b0:	17c1                	addi	a5,a5,-16
 6b2:	97a2                	add	a5,a5,s0
 6b4:	fe07c703          	lbu	a4,-32(a5)
 6b8:	fcc42783          	lw	a5,-52(s0)
 6bc:	85ba                	mv	a1,a4
 6be:	853e                	mv	a0,a5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	eea080e7          	jalr	-278(ra) # 5aa <putc>
  while(--i >= 0)
 6c8:	fec42783          	lw	a5,-20(s0)
 6cc:	37fd                	addiw	a5,a5,-1
 6ce:	fef42623          	sw	a5,-20(s0)
 6d2:	fec42783          	lw	a5,-20(s0)
 6d6:	2781                	sext.w	a5,a5
 6d8:	fc07dae3          	bgez	a5,6ac <printint+0xcc>
}
 6dc:	0001                	nop
 6de:	0001                	nop
 6e0:	70e2                	ld	ra,56(sp)
 6e2:	7442                	ld	s0,48(sp)
 6e4:	6121                	addi	sp,sp,64
 6e6:	8082                	ret

00000000000006e8 <printptr>:

static void
printptr(int fd, uint64 x) {
 6e8:	7179                	addi	sp,sp,-48
 6ea:	f406                	sd	ra,40(sp)
 6ec:	f022                	sd	s0,32(sp)
 6ee:	1800                	addi	s0,sp,48
 6f0:	87aa                	mv	a5,a0
 6f2:	fcb43823          	sd	a1,-48(s0)
 6f6:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 6fa:	fdc42783          	lw	a5,-36(s0)
 6fe:	03000593          	li	a1,48
 702:	853e                	mv	a0,a5
 704:	00000097          	auipc	ra,0x0
 708:	ea6080e7          	jalr	-346(ra) # 5aa <putc>
  putc(fd, 'x');
 70c:	fdc42783          	lw	a5,-36(s0)
 710:	07800593          	li	a1,120
 714:	853e                	mv	a0,a5
 716:	00000097          	auipc	ra,0x0
 71a:	e94080e7          	jalr	-364(ra) # 5aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71e:	fe042623          	sw	zero,-20(s0)
 722:	a82d                	j	75c <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 724:	fd043783          	ld	a5,-48(s0)
 728:	93f1                	srli	a5,a5,0x3c
 72a:	00001717          	auipc	a4,0x1
 72e:	c4670713          	addi	a4,a4,-954 # 1370 <digits>
 732:	97ba                	add	a5,a5,a4
 734:	0007c703          	lbu	a4,0(a5)
 738:	fdc42783          	lw	a5,-36(s0)
 73c:	85ba                	mv	a1,a4
 73e:	853e                	mv	a0,a5
 740:	00000097          	auipc	ra,0x0
 744:	e6a080e7          	jalr	-406(ra) # 5aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 748:	fec42783          	lw	a5,-20(s0)
 74c:	2785                	addiw	a5,a5,1
 74e:	fef42623          	sw	a5,-20(s0)
 752:	fd043783          	ld	a5,-48(s0)
 756:	0792                	slli	a5,a5,0x4
 758:	fcf43823          	sd	a5,-48(s0)
 75c:	fec42783          	lw	a5,-20(s0)
 760:	873e                	mv	a4,a5
 762:	47bd                	li	a5,15
 764:	fce7f0e3          	bgeu	a5,a4,724 <printptr+0x3c>
}
 768:	0001                	nop
 76a:	0001                	nop
 76c:	70a2                	ld	ra,40(sp)
 76e:	7402                	ld	s0,32(sp)
 770:	6145                	addi	sp,sp,48
 772:	8082                	ret

0000000000000774 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 774:	715d                	addi	sp,sp,-80
 776:	e486                	sd	ra,72(sp)
 778:	e0a2                	sd	s0,64(sp)
 77a:	0880                	addi	s0,sp,80
 77c:	87aa                	mv	a5,a0
 77e:	fcb43023          	sd	a1,-64(s0)
 782:	fac43c23          	sd	a2,-72(s0)
 786:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 78a:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 78e:	fe042223          	sw	zero,-28(s0)
 792:	a42d                	j	9bc <vprintf+0x248>
    c = fmt[i] & 0xff;
 794:	fe442783          	lw	a5,-28(s0)
 798:	fc043703          	ld	a4,-64(s0)
 79c:	97ba                	add	a5,a5,a4
 79e:	0007c783          	lbu	a5,0(a5)
 7a2:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7a6:	fe042783          	lw	a5,-32(s0)
 7aa:	2781                	sext.w	a5,a5
 7ac:	eb9d                	bnez	a5,7e2 <vprintf+0x6e>
      if(c == '%'){
 7ae:	fdc42783          	lw	a5,-36(s0)
 7b2:	0007871b          	sext.w	a4,a5
 7b6:	02500793          	li	a5,37
 7ba:	00f71763          	bne	a4,a5,7c8 <vprintf+0x54>
        state = '%';
 7be:	02500793          	li	a5,37
 7c2:	fef42023          	sw	a5,-32(s0)
 7c6:	a2f5                	j	9b2 <vprintf+0x23e>
      } else {
        putc(fd, c);
 7c8:	fdc42783          	lw	a5,-36(s0)
 7cc:	0ff7f713          	zext.b	a4,a5
 7d0:	fcc42783          	lw	a5,-52(s0)
 7d4:	85ba                	mv	a1,a4
 7d6:	853e                	mv	a0,a5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	dd2080e7          	jalr	-558(ra) # 5aa <putc>
 7e0:	aac9                	j	9b2 <vprintf+0x23e>
      }
    } else if(state == '%'){
 7e2:	fe042783          	lw	a5,-32(s0)
 7e6:	0007871b          	sext.w	a4,a5
 7ea:	02500793          	li	a5,37
 7ee:	1cf71263          	bne	a4,a5,9b2 <vprintf+0x23e>
      if(c == 'd'){
 7f2:	fdc42783          	lw	a5,-36(s0)
 7f6:	0007871b          	sext.w	a4,a5
 7fa:	06400793          	li	a5,100
 7fe:	02f71463          	bne	a4,a5,826 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 802:	fb843783          	ld	a5,-72(s0)
 806:	00878713          	addi	a4,a5,8
 80a:	fae43c23          	sd	a4,-72(s0)
 80e:	4398                	lw	a4,0(a5)
 810:	fcc42783          	lw	a5,-52(s0)
 814:	4685                	li	a3,1
 816:	4629                	li	a2,10
 818:	85ba                	mv	a1,a4
 81a:	853e                	mv	a0,a5
 81c:	00000097          	auipc	ra,0x0
 820:	dc4080e7          	jalr	-572(ra) # 5e0 <printint>
 824:	a269                	j	9ae <vprintf+0x23a>
      } else if(c == 'l') {
 826:	fdc42783          	lw	a5,-36(s0)
 82a:	0007871b          	sext.w	a4,a5
 82e:	06c00793          	li	a5,108
 832:	02f71663          	bne	a4,a5,85e <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 836:	fb843783          	ld	a5,-72(s0)
 83a:	00878713          	addi	a4,a5,8
 83e:	fae43c23          	sd	a4,-72(s0)
 842:	639c                	ld	a5,0(a5)
 844:	0007871b          	sext.w	a4,a5
 848:	fcc42783          	lw	a5,-52(s0)
 84c:	4681                	li	a3,0
 84e:	4629                	li	a2,10
 850:	85ba                	mv	a1,a4
 852:	853e                	mv	a0,a5
 854:	00000097          	auipc	ra,0x0
 858:	d8c080e7          	jalr	-628(ra) # 5e0 <printint>
 85c:	aa89                	j	9ae <vprintf+0x23a>
      } else if(c == 'x') {
 85e:	fdc42783          	lw	a5,-36(s0)
 862:	0007871b          	sext.w	a4,a5
 866:	07800793          	li	a5,120
 86a:	02f71463          	bne	a4,a5,892 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 86e:	fb843783          	ld	a5,-72(s0)
 872:	00878713          	addi	a4,a5,8
 876:	fae43c23          	sd	a4,-72(s0)
 87a:	4398                	lw	a4,0(a5)
 87c:	fcc42783          	lw	a5,-52(s0)
 880:	4681                	li	a3,0
 882:	4641                	li	a2,16
 884:	85ba                	mv	a1,a4
 886:	853e                	mv	a0,a5
 888:	00000097          	auipc	ra,0x0
 88c:	d58080e7          	jalr	-680(ra) # 5e0 <printint>
 890:	aa39                	j	9ae <vprintf+0x23a>
      } else if(c == 'p') {
 892:	fdc42783          	lw	a5,-36(s0)
 896:	0007871b          	sext.w	a4,a5
 89a:	07000793          	li	a5,112
 89e:	02f71263          	bne	a4,a5,8c2 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8a2:	fb843783          	ld	a5,-72(s0)
 8a6:	00878713          	addi	a4,a5,8
 8aa:	fae43c23          	sd	a4,-72(s0)
 8ae:	6398                	ld	a4,0(a5)
 8b0:	fcc42783          	lw	a5,-52(s0)
 8b4:	85ba                	mv	a1,a4
 8b6:	853e                	mv	a0,a5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	e30080e7          	jalr	-464(ra) # 6e8 <printptr>
 8c0:	a0fd                	j	9ae <vprintf+0x23a>
      } else if(c == 's'){
 8c2:	fdc42783          	lw	a5,-36(s0)
 8c6:	0007871b          	sext.w	a4,a5
 8ca:	07300793          	li	a5,115
 8ce:	04f71c63          	bne	a4,a5,926 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8d2:	fb843783          	ld	a5,-72(s0)
 8d6:	00878713          	addi	a4,a5,8
 8da:	fae43c23          	sd	a4,-72(s0)
 8de:	639c                	ld	a5,0(a5)
 8e0:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8e4:	fe843783          	ld	a5,-24(s0)
 8e8:	eb8d                	bnez	a5,91a <vprintf+0x1a6>
          s = "(null)";
 8ea:	00000797          	auipc	a5,0x0
 8ee:	4a678793          	addi	a5,a5,1190 # d90 <malloc+0x16c>
 8f2:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8f6:	a015                	j	91a <vprintf+0x1a6>
          putc(fd, *s);
 8f8:	fe843783          	ld	a5,-24(s0)
 8fc:	0007c703          	lbu	a4,0(a5)
 900:	fcc42783          	lw	a5,-52(s0)
 904:	85ba                	mv	a1,a4
 906:	853e                	mv	a0,a5
 908:	00000097          	auipc	ra,0x0
 90c:	ca2080e7          	jalr	-862(ra) # 5aa <putc>
          s++;
 910:	fe843783          	ld	a5,-24(s0)
 914:	0785                	addi	a5,a5,1
 916:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 91a:	fe843783          	ld	a5,-24(s0)
 91e:	0007c783          	lbu	a5,0(a5)
 922:	fbf9                	bnez	a5,8f8 <vprintf+0x184>
 924:	a069                	j	9ae <vprintf+0x23a>
        }
      } else if(c == 'c'){
 926:	fdc42783          	lw	a5,-36(s0)
 92a:	0007871b          	sext.w	a4,a5
 92e:	06300793          	li	a5,99
 932:	02f71463          	bne	a4,a5,95a <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 936:	fb843783          	ld	a5,-72(s0)
 93a:	00878713          	addi	a4,a5,8
 93e:	fae43c23          	sd	a4,-72(s0)
 942:	439c                	lw	a5,0(a5)
 944:	0ff7f713          	zext.b	a4,a5
 948:	fcc42783          	lw	a5,-52(s0)
 94c:	85ba                	mv	a1,a4
 94e:	853e                	mv	a0,a5
 950:	00000097          	auipc	ra,0x0
 954:	c5a080e7          	jalr	-934(ra) # 5aa <putc>
 958:	a899                	j	9ae <vprintf+0x23a>
      } else if(c == '%'){
 95a:	fdc42783          	lw	a5,-36(s0)
 95e:	0007871b          	sext.w	a4,a5
 962:	02500793          	li	a5,37
 966:	00f71f63          	bne	a4,a5,984 <vprintf+0x210>
        putc(fd, c);
 96a:	fdc42783          	lw	a5,-36(s0)
 96e:	0ff7f713          	zext.b	a4,a5
 972:	fcc42783          	lw	a5,-52(s0)
 976:	85ba                	mv	a1,a4
 978:	853e                	mv	a0,a5
 97a:	00000097          	auipc	ra,0x0
 97e:	c30080e7          	jalr	-976(ra) # 5aa <putc>
 982:	a035                	j	9ae <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 984:	fcc42783          	lw	a5,-52(s0)
 988:	02500593          	li	a1,37
 98c:	853e                	mv	a0,a5
 98e:	00000097          	auipc	ra,0x0
 992:	c1c080e7          	jalr	-996(ra) # 5aa <putc>
        putc(fd, c);
 996:	fdc42783          	lw	a5,-36(s0)
 99a:	0ff7f713          	zext.b	a4,a5
 99e:	fcc42783          	lw	a5,-52(s0)
 9a2:	85ba                	mv	a1,a4
 9a4:	853e                	mv	a0,a5
 9a6:	00000097          	auipc	ra,0x0
 9aa:	c04080e7          	jalr	-1020(ra) # 5aa <putc>
      }
      state = 0;
 9ae:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9b2:	fe442783          	lw	a5,-28(s0)
 9b6:	2785                	addiw	a5,a5,1
 9b8:	fef42223          	sw	a5,-28(s0)
 9bc:	fe442783          	lw	a5,-28(s0)
 9c0:	fc043703          	ld	a4,-64(s0)
 9c4:	97ba                	add	a5,a5,a4
 9c6:	0007c783          	lbu	a5,0(a5)
 9ca:	dc0795e3          	bnez	a5,794 <vprintf+0x20>
    }
  }
}
 9ce:	0001                	nop
 9d0:	0001                	nop
 9d2:	60a6                	ld	ra,72(sp)
 9d4:	6406                	ld	s0,64(sp)
 9d6:	6161                	addi	sp,sp,80
 9d8:	8082                	ret

00000000000009da <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9da:	7159                	addi	sp,sp,-112
 9dc:	fc06                	sd	ra,56(sp)
 9de:	f822                	sd	s0,48(sp)
 9e0:	0080                	addi	s0,sp,64
 9e2:	fcb43823          	sd	a1,-48(s0)
 9e6:	e010                	sd	a2,0(s0)
 9e8:	e414                	sd	a3,8(s0)
 9ea:	e818                	sd	a4,16(s0)
 9ec:	ec1c                	sd	a5,24(s0)
 9ee:	03043023          	sd	a6,32(s0)
 9f2:	03143423          	sd	a7,40(s0)
 9f6:	87aa                	mv	a5,a0
 9f8:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 9fc:	03040793          	addi	a5,s0,48
 a00:	fcf43423          	sd	a5,-56(s0)
 a04:	fc843783          	ld	a5,-56(s0)
 a08:	fd078793          	addi	a5,a5,-48
 a0c:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a10:	fe843703          	ld	a4,-24(s0)
 a14:	fdc42783          	lw	a5,-36(s0)
 a18:	863a                	mv	a2,a4
 a1a:	fd043583          	ld	a1,-48(s0)
 a1e:	853e                	mv	a0,a5
 a20:	00000097          	auipc	ra,0x0
 a24:	d54080e7          	jalr	-684(ra) # 774 <vprintf>
}
 a28:	0001                	nop
 a2a:	70e2                	ld	ra,56(sp)
 a2c:	7442                	ld	s0,48(sp)
 a2e:	6165                	addi	sp,sp,112
 a30:	8082                	ret

0000000000000a32 <printf>:

void
printf(const char *fmt, ...)
{
 a32:	7159                	addi	sp,sp,-112
 a34:	f406                	sd	ra,40(sp)
 a36:	f022                	sd	s0,32(sp)
 a38:	1800                	addi	s0,sp,48
 a3a:	fca43c23          	sd	a0,-40(s0)
 a3e:	e40c                	sd	a1,8(s0)
 a40:	e810                	sd	a2,16(s0)
 a42:	ec14                	sd	a3,24(s0)
 a44:	f018                	sd	a4,32(s0)
 a46:	f41c                	sd	a5,40(s0)
 a48:	03043823          	sd	a6,48(s0)
 a4c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a50:	04040793          	addi	a5,s0,64
 a54:	fcf43823          	sd	a5,-48(s0)
 a58:	fd043783          	ld	a5,-48(s0)
 a5c:	fc878793          	addi	a5,a5,-56
 a60:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a64:	fe843783          	ld	a5,-24(s0)
 a68:	863e                	mv	a2,a5
 a6a:	fd843583          	ld	a1,-40(s0)
 a6e:	4505                	li	a0,1
 a70:	00000097          	auipc	ra,0x0
 a74:	d04080e7          	jalr	-764(ra) # 774 <vprintf>
}
 a78:	0001                	nop
 a7a:	70a2                	ld	ra,40(sp)
 a7c:	7402                	ld	s0,32(sp)
 a7e:	6165                	addi	sp,sp,112
 a80:	8082                	ret

0000000000000a82 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a82:	7179                	addi	sp,sp,-48
 a84:	f422                	sd	s0,40(sp)
 a86:	1800                	addi	s0,sp,48
 a88:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a8c:	fd843783          	ld	a5,-40(s0)
 a90:	17c1                	addi	a5,a5,-16
 a92:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a96:	00001797          	auipc	a5,0x1
 a9a:	90a78793          	addi	a5,a5,-1782 # 13a0 <freep>
 a9e:	639c                	ld	a5,0(a5)
 aa0:	fef43423          	sd	a5,-24(s0)
 aa4:	a815                	j	ad8 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa6:	fe843783          	ld	a5,-24(s0)
 aaa:	639c                	ld	a5,0(a5)
 aac:	fe843703          	ld	a4,-24(s0)
 ab0:	00f76f63          	bltu	a4,a5,ace <free+0x4c>
 ab4:	fe043703          	ld	a4,-32(s0)
 ab8:	fe843783          	ld	a5,-24(s0)
 abc:	02e7eb63          	bltu	a5,a4,af2 <free+0x70>
 ac0:	fe843783          	ld	a5,-24(s0)
 ac4:	639c                	ld	a5,0(a5)
 ac6:	fe043703          	ld	a4,-32(s0)
 aca:	02f76463          	bltu	a4,a5,af2 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ace:	fe843783          	ld	a5,-24(s0)
 ad2:	639c                	ld	a5,0(a5)
 ad4:	fef43423          	sd	a5,-24(s0)
 ad8:	fe043703          	ld	a4,-32(s0)
 adc:	fe843783          	ld	a5,-24(s0)
 ae0:	fce7f3e3          	bgeu	a5,a4,aa6 <free+0x24>
 ae4:	fe843783          	ld	a5,-24(s0)
 ae8:	639c                	ld	a5,0(a5)
 aea:	fe043703          	ld	a4,-32(s0)
 aee:	faf77ce3          	bgeu	a4,a5,aa6 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 af2:	fe043783          	ld	a5,-32(s0)
 af6:	479c                	lw	a5,8(a5)
 af8:	1782                	slli	a5,a5,0x20
 afa:	9381                	srli	a5,a5,0x20
 afc:	0792                	slli	a5,a5,0x4
 afe:	fe043703          	ld	a4,-32(s0)
 b02:	973e                	add	a4,a4,a5
 b04:	fe843783          	ld	a5,-24(s0)
 b08:	639c                	ld	a5,0(a5)
 b0a:	02f71763          	bne	a4,a5,b38 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b0e:	fe043783          	ld	a5,-32(s0)
 b12:	4798                	lw	a4,8(a5)
 b14:	fe843783          	ld	a5,-24(s0)
 b18:	639c                	ld	a5,0(a5)
 b1a:	479c                	lw	a5,8(a5)
 b1c:	9fb9                	addw	a5,a5,a4
 b1e:	0007871b          	sext.w	a4,a5
 b22:	fe043783          	ld	a5,-32(s0)
 b26:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b28:	fe843783          	ld	a5,-24(s0)
 b2c:	639c                	ld	a5,0(a5)
 b2e:	6398                	ld	a4,0(a5)
 b30:	fe043783          	ld	a5,-32(s0)
 b34:	e398                	sd	a4,0(a5)
 b36:	a039                	j	b44 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b38:	fe843783          	ld	a5,-24(s0)
 b3c:	6398                	ld	a4,0(a5)
 b3e:	fe043783          	ld	a5,-32(s0)
 b42:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b44:	fe843783          	ld	a5,-24(s0)
 b48:	479c                	lw	a5,8(a5)
 b4a:	1782                	slli	a5,a5,0x20
 b4c:	9381                	srli	a5,a5,0x20
 b4e:	0792                	slli	a5,a5,0x4
 b50:	fe843703          	ld	a4,-24(s0)
 b54:	97ba                	add	a5,a5,a4
 b56:	fe043703          	ld	a4,-32(s0)
 b5a:	02f71563          	bne	a4,a5,b84 <free+0x102>
    p->s.size += bp->s.size;
 b5e:	fe843783          	ld	a5,-24(s0)
 b62:	4798                	lw	a4,8(a5)
 b64:	fe043783          	ld	a5,-32(s0)
 b68:	479c                	lw	a5,8(a5)
 b6a:	9fb9                	addw	a5,a5,a4
 b6c:	0007871b          	sext.w	a4,a5
 b70:	fe843783          	ld	a5,-24(s0)
 b74:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b76:	fe043783          	ld	a5,-32(s0)
 b7a:	6398                	ld	a4,0(a5)
 b7c:	fe843783          	ld	a5,-24(s0)
 b80:	e398                	sd	a4,0(a5)
 b82:	a031                	j	b8e <free+0x10c>
  } else
    p->s.ptr = bp;
 b84:	fe843783          	ld	a5,-24(s0)
 b88:	fe043703          	ld	a4,-32(s0)
 b8c:	e398                	sd	a4,0(a5)
  freep = p;
 b8e:	00001797          	auipc	a5,0x1
 b92:	81278793          	addi	a5,a5,-2030 # 13a0 <freep>
 b96:	fe843703          	ld	a4,-24(s0)
 b9a:	e398                	sd	a4,0(a5)
}
 b9c:	0001                	nop
 b9e:	7422                	ld	s0,40(sp)
 ba0:	6145                	addi	sp,sp,48
 ba2:	8082                	ret

0000000000000ba4 <morecore>:

static Header*
morecore(uint nu)
{
 ba4:	7179                	addi	sp,sp,-48
 ba6:	f406                	sd	ra,40(sp)
 ba8:	f022                	sd	s0,32(sp)
 baa:	1800                	addi	s0,sp,48
 bac:	87aa                	mv	a5,a0
 bae:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bb2:	fdc42783          	lw	a5,-36(s0)
 bb6:	0007871b          	sext.w	a4,a5
 bba:	6785                	lui	a5,0x1
 bbc:	00f77563          	bgeu	a4,a5,bc6 <morecore+0x22>
    nu = 4096;
 bc0:	6785                	lui	a5,0x1
 bc2:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bc6:	fdc42783          	lw	a5,-36(s0)
 bca:	0047979b          	slliw	a5,a5,0x4
 bce:	2781                	sext.w	a5,a5
 bd0:	2781                	sext.w	a5,a5
 bd2:	853e                	mv	a0,a5
 bd4:	00000097          	auipc	ra,0x0
 bd8:	9be080e7          	jalr	-1602(ra) # 592 <sbrk>
 bdc:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 be0:	fe843703          	ld	a4,-24(s0)
 be4:	57fd                	li	a5,-1
 be6:	00f71463          	bne	a4,a5,bee <morecore+0x4a>
    return 0;
 bea:	4781                	li	a5,0
 bec:	a03d                	j	c1a <morecore+0x76>
  hp = (Header*)p;
 bee:	fe843783          	ld	a5,-24(s0)
 bf2:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 bf6:	fe043783          	ld	a5,-32(s0)
 bfa:	fdc42703          	lw	a4,-36(s0)
 bfe:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c00:	fe043783          	ld	a5,-32(s0)
 c04:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3ec>
 c06:	853e                	mv	a0,a5
 c08:	00000097          	auipc	ra,0x0
 c0c:	e7a080e7          	jalr	-390(ra) # a82 <free>
  return freep;
 c10:	00000797          	auipc	a5,0x0
 c14:	79078793          	addi	a5,a5,1936 # 13a0 <freep>
 c18:	639c                	ld	a5,0(a5)
}
 c1a:	853e                	mv	a0,a5
 c1c:	70a2                	ld	ra,40(sp)
 c1e:	7402                	ld	s0,32(sp)
 c20:	6145                	addi	sp,sp,48
 c22:	8082                	ret

0000000000000c24 <malloc>:

void*
malloc(uint nbytes)
{
 c24:	7139                	addi	sp,sp,-64
 c26:	fc06                	sd	ra,56(sp)
 c28:	f822                	sd	s0,48(sp)
 c2a:	0080                	addi	s0,sp,64
 c2c:	87aa                	mv	a5,a0
 c2e:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c32:	fcc46783          	lwu	a5,-52(s0)
 c36:	07bd                	addi	a5,a5,15
 c38:	8391                	srli	a5,a5,0x4
 c3a:	2781                	sext.w	a5,a5
 c3c:	2785                	addiw	a5,a5,1
 c3e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c42:	00000797          	auipc	a5,0x0
 c46:	75e78793          	addi	a5,a5,1886 # 13a0 <freep>
 c4a:	639c                	ld	a5,0(a5)
 c4c:	fef43023          	sd	a5,-32(s0)
 c50:	fe043783          	ld	a5,-32(s0)
 c54:	ef95                	bnez	a5,c90 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c56:	00000797          	auipc	a5,0x0
 c5a:	73a78793          	addi	a5,a5,1850 # 1390 <base>
 c5e:	fef43023          	sd	a5,-32(s0)
 c62:	00000797          	auipc	a5,0x0
 c66:	73e78793          	addi	a5,a5,1854 # 13a0 <freep>
 c6a:	fe043703          	ld	a4,-32(s0)
 c6e:	e398                	sd	a4,0(a5)
 c70:	00000797          	auipc	a5,0x0
 c74:	73078793          	addi	a5,a5,1840 # 13a0 <freep>
 c78:	6398                	ld	a4,0(a5)
 c7a:	00000797          	auipc	a5,0x0
 c7e:	71678793          	addi	a5,a5,1814 # 1390 <base>
 c82:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c84:	00000797          	auipc	a5,0x0
 c88:	70c78793          	addi	a5,a5,1804 # 1390 <base>
 c8c:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c90:	fe043783          	ld	a5,-32(s0)
 c94:	639c                	ld	a5,0(a5)
 c96:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 c9a:	fe843783          	ld	a5,-24(s0)
 c9e:	4798                	lw	a4,8(a5)
 ca0:	fdc42783          	lw	a5,-36(s0)
 ca4:	2781                	sext.w	a5,a5
 ca6:	06f76763          	bltu	a4,a5,d14 <malloc+0xf0>
      if(p->s.size == nunits)
 caa:	fe843783          	ld	a5,-24(s0)
 cae:	4798                	lw	a4,8(a5)
 cb0:	fdc42783          	lw	a5,-36(s0)
 cb4:	2781                	sext.w	a5,a5
 cb6:	00e79963          	bne	a5,a4,cc8 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cba:	fe843783          	ld	a5,-24(s0)
 cbe:	6398                	ld	a4,0(a5)
 cc0:	fe043783          	ld	a5,-32(s0)
 cc4:	e398                	sd	a4,0(a5)
 cc6:	a825                	j	cfe <malloc+0xda>
      else {
        p->s.size -= nunits;
 cc8:	fe843783          	ld	a5,-24(s0)
 ccc:	479c                	lw	a5,8(a5)
 cce:	fdc42703          	lw	a4,-36(s0)
 cd2:	9f99                	subw	a5,a5,a4
 cd4:	0007871b          	sext.w	a4,a5
 cd8:	fe843783          	ld	a5,-24(s0)
 cdc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cde:	fe843783          	ld	a5,-24(s0)
 ce2:	479c                	lw	a5,8(a5)
 ce4:	1782                	slli	a5,a5,0x20
 ce6:	9381                	srli	a5,a5,0x20
 ce8:	0792                	slli	a5,a5,0x4
 cea:	fe843703          	ld	a4,-24(s0)
 cee:	97ba                	add	a5,a5,a4
 cf0:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cf4:	fe843783          	ld	a5,-24(s0)
 cf8:	fdc42703          	lw	a4,-36(s0)
 cfc:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 cfe:	00000797          	auipc	a5,0x0
 d02:	6a278793          	addi	a5,a5,1698 # 13a0 <freep>
 d06:	fe043703          	ld	a4,-32(s0)
 d0a:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d0c:	fe843783          	ld	a5,-24(s0)
 d10:	07c1                	addi	a5,a5,16
 d12:	a091                	j	d56 <malloc+0x132>
    }
    if(p == freep)
 d14:	00000797          	auipc	a5,0x0
 d18:	68c78793          	addi	a5,a5,1676 # 13a0 <freep>
 d1c:	639c                	ld	a5,0(a5)
 d1e:	fe843703          	ld	a4,-24(s0)
 d22:	02f71063          	bne	a4,a5,d42 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d26:	fdc42783          	lw	a5,-36(s0)
 d2a:	853e                	mv	a0,a5
 d2c:	00000097          	auipc	ra,0x0
 d30:	e78080e7          	jalr	-392(ra) # ba4 <morecore>
 d34:	fea43423          	sd	a0,-24(s0)
 d38:	fe843783          	ld	a5,-24(s0)
 d3c:	e399                	bnez	a5,d42 <malloc+0x11e>
        return 0;
 d3e:	4781                	li	a5,0
 d40:	a819                	j	d56 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d42:	fe843783          	ld	a5,-24(s0)
 d46:	fef43023          	sd	a5,-32(s0)
 d4a:	fe843783          	ld	a5,-24(s0)
 d4e:	639c                	ld	a5,0(a5)
 d50:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d54:	b799                	j	c9a <malloc+0x76>
  }
}
 d56:	853e                	mv	a0,a5
 d58:	70e2                	ld	ra,56(sp)
 d5a:	7442                	ld	s0,48(sp)
 d5c:	6121                	addi	sp,sp,64
 d5e:	8082                	ret
