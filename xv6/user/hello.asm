
user/_hello:     file format elf64-littleriscv


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
        printf("Hello %s, nice to meet you!\n", argv[1]);
  20:	fe043783          	ld	a5,-32(s0)
  24:	07a1                	addi	a5,a5,8
  26:	639c                	ld	a5,0(a5)
  28:	85be                	mv	a1,a5
  2a:	00001517          	auipc	a0,0x1
  2e:	d4650513          	addi	a0,a0,-698 # d70 <malloc+0x144>
  32:	00001097          	auipc	ra,0x1
  36:	a08080e7          	jalr	-1528(ra) # a3a <printf>
        exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	4ce080e7          	jalr	1230(ra) # 50a <exit>
    }
    
    printf("Hello World\n");
  44:	00001517          	auipc	a0,0x1
  48:	d4c50513          	addi	a0,a0,-692 # d90 <malloc+0x164>
  4c:	00001097          	auipc	ra,0x1
  50:	9ee080e7          	jalr	-1554(ra) # a3a <printf>
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

00000000000005aa <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 5aa:	48d9                	li	a7,22
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b2:	1101                	addi	sp,sp,-32
 5b4:	ec06                	sd	ra,24(sp)
 5b6:	e822                	sd	s0,16(sp)
 5b8:	1000                	addi	s0,sp,32
 5ba:	87aa                	mv	a5,a0
 5bc:	872e                	mv	a4,a1
 5be:	fef42623          	sw	a5,-20(s0)
 5c2:	87ba                	mv	a5,a4
 5c4:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5c8:	feb40713          	addi	a4,s0,-21
 5cc:	fec42783          	lw	a5,-20(s0)
 5d0:	4605                	li	a2,1
 5d2:	85ba                	mv	a1,a4
 5d4:	853e                	mv	a0,a5
 5d6:	00000097          	auipc	ra,0x0
 5da:	f54080e7          	jalr	-172(ra) # 52a <write>
}
 5de:	0001                	nop
 5e0:	60e2                	ld	ra,24(sp)
 5e2:	6442                	ld	s0,16(sp)
 5e4:	6105                	addi	sp,sp,32
 5e6:	8082                	ret

00000000000005e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e8:	7139                	addi	sp,sp,-64
 5ea:	fc06                	sd	ra,56(sp)
 5ec:	f822                	sd	s0,48(sp)
 5ee:	0080                	addi	s0,sp,64
 5f0:	87aa                	mv	a5,a0
 5f2:	8736                	mv	a4,a3
 5f4:	fcf42623          	sw	a5,-52(s0)
 5f8:	87ae                	mv	a5,a1
 5fa:	fcf42423          	sw	a5,-56(s0)
 5fe:	87b2                	mv	a5,a2
 600:	fcf42223          	sw	a5,-60(s0)
 604:	87ba                	mv	a5,a4
 606:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 60a:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 60e:	fc042783          	lw	a5,-64(s0)
 612:	2781                	sext.w	a5,a5
 614:	c38d                	beqz	a5,636 <printint+0x4e>
 616:	fc842783          	lw	a5,-56(s0)
 61a:	2781                	sext.w	a5,a5
 61c:	0007dd63          	bgez	a5,636 <printint+0x4e>
    neg = 1;
 620:	4785                	li	a5,1
 622:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 626:	fc842783          	lw	a5,-56(s0)
 62a:	40f007bb          	negw	a5,a5
 62e:	2781                	sext.w	a5,a5
 630:	fef42223          	sw	a5,-28(s0)
 634:	a029                	j	63e <printint+0x56>
  } else {
    x = xx;
 636:	fc842783          	lw	a5,-56(s0)
 63a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 63e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 642:	fc442783          	lw	a5,-60(s0)
 646:	fe442703          	lw	a4,-28(s0)
 64a:	02f777bb          	remuw	a5,a4,a5
 64e:	0007861b          	sext.w	a2,a5
 652:	fec42783          	lw	a5,-20(s0)
 656:	0017871b          	addiw	a4,a5,1
 65a:	fee42623          	sw	a4,-20(s0)
 65e:	00001697          	auipc	a3,0x1
 662:	d1268693          	addi	a3,a3,-750 # 1370 <digits>
 666:	02061713          	slli	a4,a2,0x20
 66a:	9301                	srli	a4,a4,0x20
 66c:	9736                	add	a4,a4,a3
 66e:	00074703          	lbu	a4,0(a4)
 672:	17c1                	addi	a5,a5,-16
 674:	97a2                	add	a5,a5,s0
 676:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 67a:	fc442783          	lw	a5,-60(s0)
 67e:	fe442703          	lw	a4,-28(s0)
 682:	02f757bb          	divuw	a5,a4,a5
 686:	fef42223          	sw	a5,-28(s0)
 68a:	fe442783          	lw	a5,-28(s0)
 68e:	2781                	sext.w	a5,a5
 690:	fbcd                	bnez	a5,642 <printint+0x5a>
  if(neg)
 692:	fe842783          	lw	a5,-24(s0)
 696:	2781                	sext.w	a5,a5
 698:	cf85                	beqz	a5,6d0 <printint+0xe8>
    buf[i++] = '-';
 69a:	fec42783          	lw	a5,-20(s0)
 69e:	0017871b          	addiw	a4,a5,1
 6a2:	fee42623          	sw	a4,-20(s0)
 6a6:	17c1                	addi	a5,a5,-16
 6a8:	97a2                	add	a5,a5,s0
 6aa:	02d00713          	li	a4,45
 6ae:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6b2:	a839                	j	6d0 <printint+0xe8>
    putc(fd, buf[i]);
 6b4:	fec42783          	lw	a5,-20(s0)
 6b8:	17c1                	addi	a5,a5,-16
 6ba:	97a2                	add	a5,a5,s0
 6bc:	fe07c703          	lbu	a4,-32(a5)
 6c0:	fcc42783          	lw	a5,-52(s0)
 6c4:	85ba                	mv	a1,a4
 6c6:	853e                	mv	a0,a5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	eea080e7          	jalr	-278(ra) # 5b2 <putc>
  while(--i >= 0)
 6d0:	fec42783          	lw	a5,-20(s0)
 6d4:	37fd                	addiw	a5,a5,-1
 6d6:	fef42623          	sw	a5,-20(s0)
 6da:	fec42783          	lw	a5,-20(s0)
 6de:	2781                	sext.w	a5,a5
 6e0:	fc07dae3          	bgez	a5,6b4 <printint+0xcc>
}
 6e4:	0001                	nop
 6e6:	0001                	nop
 6e8:	70e2                	ld	ra,56(sp)
 6ea:	7442                	ld	s0,48(sp)
 6ec:	6121                	addi	sp,sp,64
 6ee:	8082                	ret

00000000000006f0 <printptr>:

static void
printptr(int fd, uint64 x) {
 6f0:	7179                	addi	sp,sp,-48
 6f2:	f406                	sd	ra,40(sp)
 6f4:	f022                	sd	s0,32(sp)
 6f6:	1800                	addi	s0,sp,48
 6f8:	87aa                	mv	a5,a0
 6fa:	fcb43823          	sd	a1,-48(s0)
 6fe:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 702:	fdc42783          	lw	a5,-36(s0)
 706:	03000593          	li	a1,48
 70a:	853e                	mv	a0,a5
 70c:	00000097          	auipc	ra,0x0
 710:	ea6080e7          	jalr	-346(ra) # 5b2 <putc>
  putc(fd, 'x');
 714:	fdc42783          	lw	a5,-36(s0)
 718:	07800593          	li	a1,120
 71c:	853e                	mv	a0,a5
 71e:	00000097          	auipc	ra,0x0
 722:	e94080e7          	jalr	-364(ra) # 5b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 726:	fe042623          	sw	zero,-20(s0)
 72a:	a82d                	j	764 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72c:	fd043783          	ld	a5,-48(s0)
 730:	93f1                	srli	a5,a5,0x3c
 732:	00001717          	auipc	a4,0x1
 736:	c3e70713          	addi	a4,a4,-962 # 1370 <digits>
 73a:	97ba                	add	a5,a5,a4
 73c:	0007c703          	lbu	a4,0(a5)
 740:	fdc42783          	lw	a5,-36(s0)
 744:	85ba                	mv	a1,a4
 746:	853e                	mv	a0,a5
 748:	00000097          	auipc	ra,0x0
 74c:	e6a080e7          	jalr	-406(ra) # 5b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 750:	fec42783          	lw	a5,-20(s0)
 754:	2785                	addiw	a5,a5,1
 756:	fef42623          	sw	a5,-20(s0)
 75a:	fd043783          	ld	a5,-48(s0)
 75e:	0792                	slli	a5,a5,0x4
 760:	fcf43823          	sd	a5,-48(s0)
 764:	fec42783          	lw	a5,-20(s0)
 768:	873e                	mv	a4,a5
 76a:	47bd                	li	a5,15
 76c:	fce7f0e3          	bgeu	a5,a4,72c <printptr+0x3c>
}
 770:	0001                	nop
 772:	0001                	nop
 774:	70a2                	ld	ra,40(sp)
 776:	7402                	ld	s0,32(sp)
 778:	6145                	addi	sp,sp,48
 77a:	8082                	ret

000000000000077c <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 77c:	715d                	addi	sp,sp,-80
 77e:	e486                	sd	ra,72(sp)
 780:	e0a2                	sd	s0,64(sp)
 782:	0880                	addi	s0,sp,80
 784:	87aa                	mv	a5,a0
 786:	fcb43023          	sd	a1,-64(s0)
 78a:	fac43c23          	sd	a2,-72(s0)
 78e:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 792:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 796:	fe042223          	sw	zero,-28(s0)
 79a:	a42d                	j	9c4 <vprintf+0x248>
    c = fmt[i] & 0xff;
 79c:	fe442783          	lw	a5,-28(s0)
 7a0:	fc043703          	ld	a4,-64(s0)
 7a4:	97ba                	add	a5,a5,a4
 7a6:	0007c783          	lbu	a5,0(a5)
 7aa:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7ae:	fe042783          	lw	a5,-32(s0)
 7b2:	2781                	sext.w	a5,a5
 7b4:	eb9d                	bnez	a5,7ea <vprintf+0x6e>
      if(c == '%'){
 7b6:	fdc42783          	lw	a5,-36(s0)
 7ba:	0007871b          	sext.w	a4,a5
 7be:	02500793          	li	a5,37
 7c2:	00f71763          	bne	a4,a5,7d0 <vprintf+0x54>
        state = '%';
 7c6:	02500793          	li	a5,37
 7ca:	fef42023          	sw	a5,-32(s0)
 7ce:	a2f5                	j	9ba <vprintf+0x23e>
      } else {
        putc(fd, c);
 7d0:	fdc42783          	lw	a5,-36(s0)
 7d4:	0ff7f713          	zext.b	a4,a5
 7d8:	fcc42783          	lw	a5,-52(s0)
 7dc:	85ba                	mv	a1,a4
 7de:	853e                	mv	a0,a5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	dd2080e7          	jalr	-558(ra) # 5b2 <putc>
 7e8:	aac9                	j	9ba <vprintf+0x23e>
      }
    } else if(state == '%'){
 7ea:	fe042783          	lw	a5,-32(s0)
 7ee:	0007871b          	sext.w	a4,a5
 7f2:	02500793          	li	a5,37
 7f6:	1cf71263          	bne	a4,a5,9ba <vprintf+0x23e>
      if(c == 'd'){
 7fa:	fdc42783          	lw	a5,-36(s0)
 7fe:	0007871b          	sext.w	a4,a5
 802:	06400793          	li	a5,100
 806:	02f71463          	bne	a4,a5,82e <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 80a:	fb843783          	ld	a5,-72(s0)
 80e:	00878713          	addi	a4,a5,8
 812:	fae43c23          	sd	a4,-72(s0)
 816:	4398                	lw	a4,0(a5)
 818:	fcc42783          	lw	a5,-52(s0)
 81c:	4685                	li	a3,1
 81e:	4629                	li	a2,10
 820:	85ba                	mv	a1,a4
 822:	853e                	mv	a0,a5
 824:	00000097          	auipc	ra,0x0
 828:	dc4080e7          	jalr	-572(ra) # 5e8 <printint>
 82c:	a269                	j	9b6 <vprintf+0x23a>
      } else if(c == 'l') {
 82e:	fdc42783          	lw	a5,-36(s0)
 832:	0007871b          	sext.w	a4,a5
 836:	06c00793          	li	a5,108
 83a:	02f71663          	bne	a4,a5,866 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 83e:	fb843783          	ld	a5,-72(s0)
 842:	00878713          	addi	a4,a5,8
 846:	fae43c23          	sd	a4,-72(s0)
 84a:	639c                	ld	a5,0(a5)
 84c:	0007871b          	sext.w	a4,a5
 850:	fcc42783          	lw	a5,-52(s0)
 854:	4681                	li	a3,0
 856:	4629                	li	a2,10
 858:	85ba                	mv	a1,a4
 85a:	853e                	mv	a0,a5
 85c:	00000097          	auipc	ra,0x0
 860:	d8c080e7          	jalr	-628(ra) # 5e8 <printint>
 864:	aa89                	j	9b6 <vprintf+0x23a>
      } else if(c == 'x') {
 866:	fdc42783          	lw	a5,-36(s0)
 86a:	0007871b          	sext.w	a4,a5
 86e:	07800793          	li	a5,120
 872:	02f71463          	bne	a4,a5,89a <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 876:	fb843783          	ld	a5,-72(s0)
 87a:	00878713          	addi	a4,a5,8
 87e:	fae43c23          	sd	a4,-72(s0)
 882:	4398                	lw	a4,0(a5)
 884:	fcc42783          	lw	a5,-52(s0)
 888:	4681                	li	a3,0
 88a:	4641                	li	a2,16
 88c:	85ba                	mv	a1,a4
 88e:	853e                	mv	a0,a5
 890:	00000097          	auipc	ra,0x0
 894:	d58080e7          	jalr	-680(ra) # 5e8 <printint>
 898:	aa39                	j	9b6 <vprintf+0x23a>
      } else if(c == 'p') {
 89a:	fdc42783          	lw	a5,-36(s0)
 89e:	0007871b          	sext.w	a4,a5
 8a2:	07000793          	li	a5,112
 8a6:	02f71263          	bne	a4,a5,8ca <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8aa:	fb843783          	ld	a5,-72(s0)
 8ae:	00878713          	addi	a4,a5,8
 8b2:	fae43c23          	sd	a4,-72(s0)
 8b6:	6398                	ld	a4,0(a5)
 8b8:	fcc42783          	lw	a5,-52(s0)
 8bc:	85ba                	mv	a1,a4
 8be:	853e                	mv	a0,a5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	e30080e7          	jalr	-464(ra) # 6f0 <printptr>
 8c8:	a0fd                	j	9b6 <vprintf+0x23a>
      } else if(c == 's'){
 8ca:	fdc42783          	lw	a5,-36(s0)
 8ce:	0007871b          	sext.w	a4,a5
 8d2:	07300793          	li	a5,115
 8d6:	04f71c63          	bne	a4,a5,92e <vprintf+0x1b2>
        s = va_arg(ap, char*);
 8da:	fb843783          	ld	a5,-72(s0)
 8de:	00878713          	addi	a4,a5,8
 8e2:	fae43c23          	sd	a4,-72(s0)
 8e6:	639c                	ld	a5,0(a5)
 8e8:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 8ec:	fe843783          	ld	a5,-24(s0)
 8f0:	eb8d                	bnez	a5,922 <vprintf+0x1a6>
          s = "(null)";
 8f2:	00000797          	auipc	a5,0x0
 8f6:	4ae78793          	addi	a5,a5,1198 # da0 <malloc+0x174>
 8fa:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 8fe:	a015                	j	922 <vprintf+0x1a6>
          putc(fd, *s);
 900:	fe843783          	ld	a5,-24(s0)
 904:	0007c703          	lbu	a4,0(a5)
 908:	fcc42783          	lw	a5,-52(s0)
 90c:	85ba                	mv	a1,a4
 90e:	853e                	mv	a0,a5
 910:	00000097          	auipc	ra,0x0
 914:	ca2080e7          	jalr	-862(ra) # 5b2 <putc>
          s++;
 918:	fe843783          	ld	a5,-24(s0)
 91c:	0785                	addi	a5,a5,1
 91e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 922:	fe843783          	ld	a5,-24(s0)
 926:	0007c783          	lbu	a5,0(a5)
 92a:	fbf9                	bnez	a5,900 <vprintf+0x184>
 92c:	a069                	j	9b6 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 92e:	fdc42783          	lw	a5,-36(s0)
 932:	0007871b          	sext.w	a4,a5
 936:	06300793          	li	a5,99
 93a:	02f71463          	bne	a4,a5,962 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 93e:	fb843783          	ld	a5,-72(s0)
 942:	00878713          	addi	a4,a5,8
 946:	fae43c23          	sd	a4,-72(s0)
 94a:	439c                	lw	a5,0(a5)
 94c:	0ff7f713          	zext.b	a4,a5
 950:	fcc42783          	lw	a5,-52(s0)
 954:	85ba                	mv	a1,a4
 956:	853e                	mv	a0,a5
 958:	00000097          	auipc	ra,0x0
 95c:	c5a080e7          	jalr	-934(ra) # 5b2 <putc>
 960:	a899                	j	9b6 <vprintf+0x23a>
      } else if(c == '%'){
 962:	fdc42783          	lw	a5,-36(s0)
 966:	0007871b          	sext.w	a4,a5
 96a:	02500793          	li	a5,37
 96e:	00f71f63          	bne	a4,a5,98c <vprintf+0x210>
        putc(fd, c);
 972:	fdc42783          	lw	a5,-36(s0)
 976:	0ff7f713          	zext.b	a4,a5
 97a:	fcc42783          	lw	a5,-52(s0)
 97e:	85ba                	mv	a1,a4
 980:	853e                	mv	a0,a5
 982:	00000097          	auipc	ra,0x0
 986:	c30080e7          	jalr	-976(ra) # 5b2 <putc>
 98a:	a035                	j	9b6 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 98c:	fcc42783          	lw	a5,-52(s0)
 990:	02500593          	li	a1,37
 994:	853e                	mv	a0,a5
 996:	00000097          	auipc	ra,0x0
 99a:	c1c080e7          	jalr	-996(ra) # 5b2 <putc>
        putc(fd, c);
 99e:	fdc42783          	lw	a5,-36(s0)
 9a2:	0ff7f713          	zext.b	a4,a5
 9a6:	fcc42783          	lw	a5,-52(s0)
 9aa:	85ba                	mv	a1,a4
 9ac:	853e                	mv	a0,a5
 9ae:	00000097          	auipc	ra,0x0
 9b2:	c04080e7          	jalr	-1020(ra) # 5b2 <putc>
      }
      state = 0;
 9b6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9ba:	fe442783          	lw	a5,-28(s0)
 9be:	2785                	addiw	a5,a5,1
 9c0:	fef42223          	sw	a5,-28(s0)
 9c4:	fe442783          	lw	a5,-28(s0)
 9c8:	fc043703          	ld	a4,-64(s0)
 9cc:	97ba                	add	a5,a5,a4
 9ce:	0007c783          	lbu	a5,0(a5)
 9d2:	dc0795e3          	bnez	a5,79c <vprintf+0x20>
    }
  }
}
 9d6:	0001                	nop
 9d8:	0001                	nop
 9da:	60a6                	ld	ra,72(sp)
 9dc:	6406                	ld	s0,64(sp)
 9de:	6161                	addi	sp,sp,80
 9e0:	8082                	ret

00000000000009e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9e2:	7159                	addi	sp,sp,-112
 9e4:	fc06                	sd	ra,56(sp)
 9e6:	f822                	sd	s0,48(sp)
 9e8:	0080                	addi	s0,sp,64
 9ea:	fcb43823          	sd	a1,-48(s0)
 9ee:	e010                	sd	a2,0(s0)
 9f0:	e414                	sd	a3,8(s0)
 9f2:	e818                	sd	a4,16(s0)
 9f4:	ec1c                	sd	a5,24(s0)
 9f6:	03043023          	sd	a6,32(s0)
 9fa:	03143423          	sd	a7,40(s0)
 9fe:	87aa                	mv	a5,a0
 a00:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a04:	03040793          	addi	a5,s0,48
 a08:	fcf43423          	sd	a5,-56(s0)
 a0c:	fc843783          	ld	a5,-56(s0)
 a10:	fd078793          	addi	a5,a5,-48
 a14:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a18:	fe843703          	ld	a4,-24(s0)
 a1c:	fdc42783          	lw	a5,-36(s0)
 a20:	863a                	mv	a2,a4
 a22:	fd043583          	ld	a1,-48(s0)
 a26:	853e                	mv	a0,a5
 a28:	00000097          	auipc	ra,0x0
 a2c:	d54080e7          	jalr	-684(ra) # 77c <vprintf>
}
 a30:	0001                	nop
 a32:	70e2                	ld	ra,56(sp)
 a34:	7442                	ld	s0,48(sp)
 a36:	6165                	addi	sp,sp,112
 a38:	8082                	ret

0000000000000a3a <printf>:

void
printf(const char *fmt, ...)
{
 a3a:	7159                	addi	sp,sp,-112
 a3c:	f406                	sd	ra,40(sp)
 a3e:	f022                	sd	s0,32(sp)
 a40:	1800                	addi	s0,sp,48
 a42:	fca43c23          	sd	a0,-40(s0)
 a46:	e40c                	sd	a1,8(s0)
 a48:	e810                	sd	a2,16(s0)
 a4a:	ec14                	sd	a3,24(s0)
 a4c:	f018                	sd	a4,32(s0)
 a4e:	f41c                	sd	a5,40(s0)
 a50:	03043823          	sd	a6,48(s0)
 a54:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a58:	04040793          	addi	a5,s0,64
 a5c:	fcf43823          	sd	a5,-48(s0)
 a60:	fd043783          	ld	a5,-48(s0)
 a64:	fc878793          	addi	a5,a5,-56
 a68:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a6c:	fe843783          	ld	a5,-24(s0)
 a70:	863e                	mv	a2,a5
 a72:	fd843583          	ld	a1,-40(s0)
 a76:	4505                	li	a0,1
 a78:	00000097          	auipc	ra,0x0
 a7c:	d04080e7          	jalr	-764(ra) # 77c <vprintf>
}
 a80:	0001                	nop
 a82:	70a2                	ld	ra,40(sp)
 a84:	7402                	ld	s0,32(sp)
 a86:	6165                	addi	sp,sp,112
 a88:	8082                	ret

0000000000000a8a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a8a:	7179                	addi	sp,sp,-48
 a8c:	f422                	sd	s0,40(sp)
 a8e:	1800                	addi	s0,sp,48
 a90:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a94:	fd843783          	ld	a5,-40(s0)
 a98:	17c1                	addi	a5,a5,-16
 a9a:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a9e:	00001797          	auipc	a5,0x1
 aa2:	90278793          	addi	a5,a5,-1790 # 13a0 <freep>
 aa6:	639c                	ld	a5,0(a5)
 aa8:	fef43423          	sd	a5,-24(s0)
 aac:	a815                	j	ae0 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aae:	fe843783          	ld	a5,-24(s0)
 ab2:	639c                	ld	a5,0(a5)
 ab4:	fe843703          	ld	a4,-24(s0)
 ab8:	00f76f63          	bltu	a4,a5,ad6 <free+0x4c>
 abc:	fe043703          	ld	a4,-32(s0)
 ac0:	fe843783          	ld	a5,-24(s0)
 ac4:	02e7eb63          	bltu	a5,a4,afa <free+0x70>
 ac8:	fe843783          	ld	a5,-24(s0)
 acc:	639c                	ld	a5,0(a5)
 ace:	fe043703          	ld	a4,-32(s0)
 ad2:	02f76463          	bltu	a4,a5,afa <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad6:	fe843783          	ld	a5,-24(s0)
 ada:	639c                	ld	a5,0(a5)
 adc:	fef43423          	sd	a5,-24(s0)
 ae0:	fe043703          	ld	a4,-32(s0)
 ae4:	fe843783          	ld	a5,-24(s0)
 ae8:	fce7f3e3          	bgeu	a5,a4,aae <free+0x24>
 aec:	fe843783          	ld	a5,-24(s0)
 af0:	639c                	ld	a5,0(a5)
 af2:	fe043703          	ld	a4,-32(s0)
 af6:	faf77ce3          	bgeu	a4,a5,aae <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 afa:	fe043783          	ld	a5,-32(s0)
 afe:	479c                	lw	a5,8(a5)
 b00:	1782                	slli	a5,a5,0x20
 b02:	9381                	srli	a5,a5,0x20
 b04:	0792                	slli	a5,a5,0x4
 b06:	fe043703          	ld	a4,-32(s0)
 b0a:	973e                	add	a4,a4,a5
 b0c:	fe843783          	ld	a5,-24(s0)
 b10:	639c                	ld	a5,0(a5)
 b12:	02f71763          	bne	a4,a5,b40 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b16:	fe043783          	ld	a5,-32(s0)
 b1a:	4798                	lw	a4,8(a5)
 b1c:	fe843783          	ld	a5,-24(s0)
 b20:	639c                	ld	a5,0(a5)
 b22:	479c                	lw	a5,8(a5)
 b24:	9fb9                	addw	a5,a5,a4
 b26:	0007871b          	sext.w	a4,a5
 b2a:	fe043783          	ld	a5,-32(s0)
 b2e:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b30:	fe843783          	ld	a5,-24(s0)
 b34:	639c                	ld	a5,0(a5)
 b36:	6398                	ld	a4,0(a5)
 b38:	fe043783          	ld	a5,-32(s0)
 b3c:	e398                	sd	a4,0(a5)
 b3e:	a039                	j	b4c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b40:	fe843783          	ld	a5,-24(s0)
 b44:	6398                	ld	a4,0(a5)
 b46:	fe043783          	ld	a5,-32(s0)
 b4a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b4c:	fe843783          	ld	a5,-24(s0)
 b50:	479c                	lw	a5,8(a5)
 b52:	1782                	slli	a5,a5,0x20
 b54:	9381                	srli	a5,a5,0x20
 b56:	0792                	slli	a5,a5,0x4
 b58:	fe843703          	ld	a4,-24(s0)
 b5c:	97ba                	add	a5,a5,a4
 b5e:	fe043703          	ld	a4,-32(s0)
 b62:	02f71563          	bne	a4,a5,b8c <free+0x102>
    p->s.size += bp->s.size;
 b66:	fe843783          	ld	a5,-24(s0)
 b6a:	4798                	lw	a4,8(a5)
 b6c:	fe043783          	ld	a5,-32(s0)
 b70:	479c                	lw	a5,8(a5)
 b72:	9fb9                	addw	a5,a5,a4
 b74:	0007871b          	sext.w	a4,a5
 b78:	fe843783          	ld	a5,-24(s0)
 b7c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b7e:	fe043783          	ld	a5,-32(s0)
 b82:	6398                	ld	a4,0(a5)
 b84:	fe843783          	ld	a5,-24(s0)
 b88:	e398                	sd	a4,0(a5)
 b8a:	a031                	j	b96 <free+0x10c>
  } else
    p->s.ptr = bp;
 b8c:	fe843783          	ld	a5,-24(s0)
 b90:	fe043703          	ld	a4,-32(s0)
 b94:	e398                	sd	a4,0(a5)
  freep = p;
 b96:	00001797          	auipc	a5,0x1
 b9a:	80a78793          	addi	a5,a5,-2038 # 13a0 <freep>
 b9e:	fe843703          	ld	a4,-24(s0)
 ba2:	e398                	sd	a4,0(a5)
}
 ba4:	0001                	nop
 ba6:	7422                	ld	s0,40(sp)
 ba8:	6145                	addi	sp,sp,48
 baa:	8082                	ret

0000000000000bac <morecore>:

static Header*
morecore(uint nu)
{
 bac:	7179                	addi	sp,sp,-48
 bae:	f406                	sd	ra,40(sp)
 bb0:	f022                	sd	s0,32(sp)
 bb2:	1800                	addi	s0,sp,48
 bb4:	87aa                	mv	a5,a0
 bb6:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bba:	fdc42783          	lw	a5,-36(s0)
 bbe:	0007871b          	sext.w	a4,a5
 bc2:	6785                	lui	a5,0x1
 bc4:	00f77563          	bgeu	a4,a5,bce <morecore+0x22>
    nu = 4096;
 bc8:	6785                	lui	a5,0x1
 bca:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bce:	fdc42783          	lw	a5,-36(s0)
 bd2:	0047979b          	slliw	a5,a5,0x4
 bd6:	2781                	sext.w	a5,a5
 bd8:	2781                	sext.w	a5,a5
 bda:	853e                	mv	a0,a5
 bdc:	00000097          	auipc	ra,0x0
 be0:	9b6080e7          	jalr	-1610(ra) # 592 <sbrk>
 be4:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 be8:	fe843703          	ld	a4,-24(s0)
 bec:	57fd                	li	a5,-1
 bee:	00f71463          	bne	a4,a5,bf6 <morecore+0x4a>
    return 0;
 bf2:	4781                	li	a5,0
 bf4:	a03d                	j	c22 <morecore+0x76>
  hp = (Header*)p;
 bf6:	fe843783          	ld	a5,-24(s0)
 bfa:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 bfe:	fe043783          	ld	a5,-32(s0)
 c02:	fdc42703          	lw	a4,-36(s0)
 c06:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c08:	fe043783          	ld	a5,-32(s0)
 c0c:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3e4>
 c0e:	853e                	mv	a0,a5
 c10:	00000097          	auipc	ra,0x0
 c14:	e7a080e7          	jalr	-390(ra) # a8a <free>
  return freep;
 c18:	00000797          	auipc	a5,0x0
 c1c:	78878793          	addi	a5,a5,1928 # 13a0 <freep>
 c20:	639c                	ld	a5,0(a5)
}
 c22:	853e                	mv	a0,a5
 c24:	70a2                	ld	ra,40(sp)
 c26:	7402                	ld	s0,32(sp)
 c28:	6145                	addi	sp,sp,48
 c2a:	8082                	ret

0000000000000c2c <malloc>:

void*
malloc(uint nbytes)
{
 c2c:	7139                	addi	sp,sp,-64
 c2e:	fc06                	sd	ra,56(sp)
 c30:	f822                	sd	s0,48(sp)
 c32:	0080                	addi	s0,sp,64
 c34:	87aa                	mv	a5,a0
 c36:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c3a:	fcc46783          	lwu	a5,-52(s0)
 c3e:	07bd                	addi	a5,a5,15
 c40:	8391                	srli	a5,a5,0x4
 c42:	2781                	sext.w	a5,a5
 c44:	2785                	addiw	a5,a5,1
 c46:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c4a:	00000797          	auipc	a5,0x0
 c4e:	75678793          	addi	a5,a5,1878 # 13a0 <freep>
 c52:	639c                	ld	a5,0(a5)
 c54:	fef43023          	sd	a5,-32(s0)
 c58:	fe043783          	ld	a5,-32(s0)
 c5c:	ef95                	bnez	a5,c98 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c5e:	00000797          	auipc	a5,0x0
 c62:	73278793          	addi	a5,a5,1842 # 1390 <base>
 c66:	fef43023          	sd	a5,-32(s0)
 c6a:	00000797          	auipc	a5,0x0
 c6e:	73678793          	addi	a5,a5,1846 # 13a0 <freep>
 c72:	fe043703          	ld	a4,-32(s0)
 c76:	e398                	sd	a4,0(a5)
 c78:	00000797          	auipc	a5,0x0
 c7c:	72878793          	addi	a5,a5,1832 # 13a0 <freep>
 c80:	6398                	ld	a4,0(a5)
 c82:	00000797          	auipc	a5,0x0
 c86:	70e78793          	addi	a5,a5,1806 # 1390 <base>
 c8a:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 c8c:	00000797          	auipc	a5,0x0
 c90:	70478793          	addi	a5,a5,1796 # 1390 <base>
 c94:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c98:	fe043783          	ld	a5,-32(s0)
 c9c:	639c                	ld	a5,0(a5)
 c9e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 ca2:	fe843783          	ld	a5,-24(s0)
 ca6:	4798                	lw	a4,8(a5)
 ca8:	fdc42783          	lw	a5,-36(s0)
 cac:	2781                	sext.w	a5,a5
 cae:	06f76763          	bltu	a4,a5,d1c <malloc+0xf0>
      if(p->s.size == nunits)
 cb2:	fe843783          	ld	a5,-24(s0)
 cb6:	4798                	lw	a4,8(a5)
 cb8:	fdc42783          	lw	a5,-36(s0)
 cbc:	2781                	sext.w	a5,a5
 cbe:	00e79963          	bne	a5,a4,cd0 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cc2:	fe843783          	ld	a5,-24(s0)
 cc6:	6398                	ld	a4,0(a5)
 cc8:	fe043783          	ld	a5,-32(s0)
 ccc:	e398                	sd	a4,0(a5)
 cce:	a825                	j	d06 <malloc+0xda>
      else {
        p->s.size -= nunits;
 cd0:	fe843783          	ld	a5,-24(s0)
 cd4:	479c                	lw	a5,8(a5)
 cd6:	fdc42703          	lw	a4,-36(s0)
 cda:	9f99                	subw	a5,a5,a4
 cdc:	0007871b          	sext.w	a4,a5
 ce0:	fe843783          	ld	a5,-24(s0)
 ce4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ce6:	fe843783          	ld	a5,-24(s0)
 cea:	479c                	lw	a5,8(a5)
 cec:	1782                	slli	a5,a5,0x20
 cee:	9381                	srli	a5,a5,0x20
 cf0:	0792                	slli	a5,a5,0x4
 cf2:	fe843703          	ld	a4,-24(s0)
 cf6:	97ba                	add	a5,a5,a4
 cf8:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 cfc:	fe843783          	ld	a5,-24(s0)
 d00:	fdc42703          	lw	a4,-36(s0)
 d04:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d06:	00000797          	auipc	a5,0x0
 d0a:	69a78793          	addi	a5,a5,1690 # 13a0 <freep>
 d0e:	fe043703          	ld	a4,-32(s0)
 d12:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d14:	fe843783          	ld	a5,-24(s0)
 d18:	07c1                	addi	a5,a5,16
 d1a:	a091                	j	d5e <malloc+0x132>
    }
    if(p == freep)
 d1c:	00000797          	auipc	a5,0x0
 d20:	68478793          	addi	a5,a5,1668 # 13a0 <freep>
 d24:	639c                	ld	a5,0(a5)
 d26:	fe843703          	ld	a4,-24(s0)
 d2a:	02f71063          	bne	a4,a5,d4a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d2e:	fdc42783          	lw	a5,-36(s0)
 d32:	853e                	mv	a0,a5
 d34:	00000097          	auipc	ra,0x0
 d38:	e78080e7          	jalr	-392(ra) # bac <morecore>
 d3c:	fea43423          	sd	a0,-24(s0)
 d40:	fe843783          	ld	a5,-24(s0)
 d44:	e399                	bnez	a5,d4a <malloc+0x11e>
        return 0;
 d46:	4781                	li	a5,0
 d48:	a819                	j	d5e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d4a:	fe843783          	ld	a5,-24(s0)
 d4e:	fef43023          	sd	a5,-32(s0)
 d52:	fe843783          	ld	a5,-24(s0)
 d56:	639c                	ld	a5,0(a5)
 d58:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d5c:	b799                	j	ca2 <malloc+0x76>
  }
}
 d5e:	853e                	mv	a0,a5
 d60:	70e2                	ld	ra,56(sp)
 d62:	7442                	ld	s0,48(sp)
 d64:	6121                	addi	sp,sp,64
 d66:	8082                	ret
