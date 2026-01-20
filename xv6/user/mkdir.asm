
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
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
    fprintf(2, "Usage: mkdir files...\n");
  20:	00001597          	auipc	a1,0x1
  24:	d9058593          	addi	a1,a1,-624 # db0 <malloc+0x13e>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	9fe080e7          	jalr	-1538(ra) # a28 <fprintf>
    exit(1);
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	524080e7          	jalr	1316(ra) # 558 <exit>
  }

  for(i = 1; i < argc; i++){
  3c:	4785                	li	a5,1
  3e:	fef42623          	sw	a5,-20(s0)
  42:	a0b9                	j	90 <main+0x90>
    if(mkdir(argv[i]) < 0){
  44:	fec42783          	lw	a5,-20(s0)
  48:	078e                	slli	a5,a5,0x3
  4a:	fd043703          	ld	a4,-48(s0)
  4e:	97ba                	add	a5,a5,a4
  50:	639c                	ld	a5,0(a5)
  52:	853e                	mv	a0,a5
  54:	00000097          	auipc	ra,0x0
  58:	56c080e7          	jalr	1388(ra) # 5c0 <mkdir>
  5c:	87aa                	mv	a5,a0
  5e:	0207d463          	bgez	a5,86 <main+0x86>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  62:	fec42783          	lw	a5,-20(s0)
  66:	078e                	slli	a5,a5,0x3
  68:	fd043703          	ld	a4,-48(s0)
  6c:	97ba                	add	a5,a5,a4
  6e:	639c                	ld	a5,0(a5)
  70:	863e                	mv	a2,a5
  72:	00001597          	auipc	a1,0x1
  76:	d5658593          	addi	a1,a1,-682 # dc8 <malloc+0x156>
  7a:	4509                	li	a0,2
  7c:	00001097          	auipc	ra,0x1
  80:	9ac080e7          	jalr	-1620(ra) # a28 <fprintf>
      break;
  84:	a839                	j	a2 <main+0xa2>
  for(i = 1; i < argc; i++){
  86:	fec42783          	lw	a5,-20(s0)
  8a:	2785                	addiw	a5,a5,1
  8c:	fef42623          	sw	a5,-20(s0)
  90:	fec42783          	lw	a5,-20(s0)
  94:	873e                	mv	a4,a5
  96:	fdc42783          	lw	a5,-36(s0)
  9a:	2701                	sext.w	a4,a4
  9c:	2781                	sext.w	a5,a5
  9e:	faf743e3          	blt	a4,a5,44 <main+0x44>
    }
  }

  exit(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	4b4080e7          	jalr	1204(ra) # 558 <exit>

00000000000000ac <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  b4:	00000097          	auipc	ra,0x0
  b8:	f4c080e7          	jalr	-180(ra) # 0 <main>
  exit(0);
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	49a080e7          	jalr	1178(ra) # 558 <exit>

00000000000000c6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  c6:	7179                	addi	sp,sp,-48
  c8:	f422                	sd	s0,40(sp)
  ca:	1800                	addi	s0,sp,48
  cc:	fca43c23          	sd	a0,-40(s0)
  d0:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
  d4:	fd843783          	ld	a5,-40(s0)
  d8:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
  dc:	0001                	nop
  de:	fd043703          	ld	a4,-48(s0)
  e2:	00170793          	addi	a5,a4,1
  e6:	fcf43823          	sd	a5,-48(s0)
  ea:	fd843783          	ld	a5,-40(s0)
  ee:	00178693          	addi	a3,a5,1
  f2:	fcd43c23          	sd	a3,-40(s0)
  f6:	00074703          	lbu	a4,0(a4)
  fa:	00e78023          	sb	a4,0(a5)
  fe:	0007c783          	lbu	a5,0(a5)
 102:	fff1                	bnez	a5,de <strcpy+0x18>
    ;
  return os;
 104:	fe843783          	ld	a5,-24(s0)
}
 108:	853e                	mv	a0,a5
 10a:	7422                	ld	s0,40(sp)
 10c:	6145                	addi	sp,sp,48
 10e:	8082                	ret

0000000000000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	1101                	addi	sp,sp,-32
 112:	ec22                	sd	s0,24(sp)
 114:	1000                	addi	s0,sp,32
 116:	fea43423          	sd	a0,-24(s0)
 11a:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 11e:	a819                	j	134 <strcmp+0x24>
    p++, q++;
 120:	fe843783          	ld	a5,-24(s0)
 124:	0785                	addi	a5,a5,1
 126:	fef43423          	sd	a5,-24(s0)
 12a:	fe043783          	ld	a5,-32(s0)
 12e:	0785                	addi	a5,a5,1
 130:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 134:	fe843783          	ld	a5,-24(s0)
 138:	0007c783          	lbu	a5,0(a5)
 13c:	cb99                	beqz	a5,152 <strcmp+0x42>
 13e:	fe843783          	ld	a5,-24(s0)
 142:	0007c703          	lbu	a4,0(a5)
 146:	fe043783          	ld	a5,-32(s0)
 14a:	0007c783          	lbu	a5,0(a5)
 14e:	fcf709e3          	beq	a4,a5,120 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 152:	fe843783          	ld	a5,-24(s0)
 156:	0007c783          	lbu	a5,0(a5)
 15a:	0007871b          	sext.w	a4,a5
 15e:	fe043783          	ld	a5,-32(s0)
 162:	0007c783          	lbu	a5,0(a5)
 166:	2781                	sext.w	a5,a5
 168:	40f707bb          	subw	a5,a4,a5
 16c:	2781                	sext.w	a5,a5
}
 16e:	853e                	mv	a0,a5
 170:	6462                	ld	s0,24(sp)
 172:	6105                	addi	sp,sp,32
 174:	8082                	ret

0000000000000176 <strlen>:

uint
strlen(const char *s)
{
 176:	7179                	addi	sp,sp,-48
 178:	f422                	sd	s0,40(sp)
 17a:	1800                	addi	s0,sp,48
 17c:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 180:	fe042623          	sw	zero,-20(s0)
 184:	a031                	j	190 <strlen+0x1a>
 186:	fec42783          	lw	a5,-20(s0)
 18a:	2785                	addiw	a5,a5,1
 18c:	fef42623          	sw	a5,-20(s0)
 190:	fec42783          	lw	a5,-20(s0)
 194:	fd843703          	ld	a4,-40(s0)
 198:	97ba                	add	a5,a5,a4
 19a:	0007c783          	lbu	a5,0(a5)
 19e:	f7e5                	bnez	a5,186 <strlen+0x10>
    ;
  return n;
 1a0:	fec42783          	lw	a5,-20(s0)
}
 1a4:	853e                	mv	a0,a5
 1a6:	7422                	ld	s0,40(sp)
 1a8:	6145                	addi	sp,sp,48
 1aa:	8082                	ret

00000000000001ac <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ac:	7179                	addi	sp,sp,-48
 1ae:	f422                	sd	s0,40(sp)
 1b0:	1800                	addi	s0,sp,48
 1b2:	fca43c23          	sd	a0,-40(s0)
 1b6:	87ae                	mv	a5,a1
 1b8:	8732                	mv	a4,a2
 1ba:	fcf42a23          	sw	a5,-44(s0)
 1be:	87ba                	mv	a5,a4
 1c0:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 1c4:	fd843783          	ld	a5,-40(s0)
 1c8:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 1cc:	fe042623          	sw	zero,-20(s0)
 1d0:	a00d                	j	1f2 <memset+0x46>
    cdst[i] = c;
 1d2:	fec42783          	lw	a5,-20(s0)
 1d6:	fe043703          	ld	a4,-32(s0)
 1da:	97ba                	add	a5,a5,a4
 1dc:	fd442703          	lw	a4,-44(s0)
 1e0:	0ff77713          	zext.b	a4,a4
 1e4:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 1e8:	fec42783          	lw	a5,-20(s0)
 1ec:	2785                	addiw	a5,a5,1
 1ee:	fef42623          	sw	a5,-20(s0)
 1f2:	fec42703          	lw	a4,-20(s0)
 1f6:	fd042783          	lw	a5,-48(s0)
 1fa:	2781                	sext.w	a5,a5
 1fc:	fcf76be3          	bltu	a4,a5,1d2 <memset+0x26>
  }
  return dst;
 200:	fd843783          	ld	a5,-40(s0)
}
 204:	853e                	mv	a0,a5
 206:	7422                	ld	s0,40(sp)
 208:	6145                	addi	sp,sp,48
 20a:	8082                	ret

000000000000020c <strchr>:

char*
strchr(const char *s, char c)
{
 20c:	1101                	addi	sp,sp,-32
 20e:	ec22                	sd	s0,24(sp)
 210:	1000                	addi	s0,sp,32
 212:	fea43423          	sd	a0,-24(s0)
 216:	87ae                	mv	a5,a1
 218:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 21c:	a01d                	j	242 <strchr+0x36>
    if(*s == c)
 21e:	fe843783          	ld	a5,-24(s0)
 222:	0007c703          	lbu	a4,0(a5)
 226:	fe744783          	lbu	a5,-25(s0)
 22a:	0ff7f793          	zext.b	a5,a5
 22e:	00e79563          	bne	a5,a4,238 <strchr+0x2c>
      return (char*)s;
 232:	fe843783          	ld	a5,-24(s0)
 236:	a821                	j	24e <strchr+0x42>
  for(; *s; s++)
 238:	fe843783          	ld	a5,-24(s0)
 23c:	0785                	addi	a5,a5,1
 23e:	fef43423          	sd	a5,-24(s0)
 242:	fe843783          	ld	a5,-24(s0)
 246:	0007c783          	lbu	a5,0(a5)
 24a:	fbf1                	bnez	a5,21e <strchr+0x12>
  return 0;
 24c:	4781                	li	a5,0
}
 24e:	853e                	mv	a0,a5
 250:	6462                	ld	s0,24(sp)
 252:	6105                	addi	sp,sp,32
 254:	8082                	ret

0000000000000256 <gets>:

char*
gets(char *buf, int max)
{
 256:	7179                	addi	sp,sp,-48
 258:	f406                	sd	ra,40(sp)
 25a:	f022                	sd	s0,32(sp)
 25c:	1800                	addi	s0,sp,48
 25e:	fca43c23          	sd	a0,-40(s0)
 262:	87ae                	mv	a5,a1
 264:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 268:	fe042623          	sw	zero,-20(s0)
 26c:	a8a1                	j	2c4 <gets+0x6e>
    cc = read(0, &c, 1);
 26e:	fe740793          	addi	a5,s0,-25
 272:	4605                	li	a2,1
 274:	85be                	mv	a1,a5
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	2f8080e7          	jalr	760(ra) # 570 <read>
 280:	87aa                	mv	a5,a0
 282:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 286:	fe842783          	lw	a5,-24(s0)
 28a:	2781                	sext.w	a5,a5
 28c:	04f05763          	blez	a5,2da <gets+0x84>
      break;
    buf[i++] = c;
 290:	fec42783          	lw	a5,-20(s0)
 294:	0017871b          	addiw	a4,a5,1
 298:	fee42623          	sw	a4,-20(s0)
 29c:	873e                	mv	a4,a5
 29e:	fd843783          	ld	a5,-40(s0)
 2a2:	97ba                	add	a5,a5,a4
 2a4:	fe744703          	lbu	a4,-25(s0)
 2a8:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 2ac:	fe744783          	lbu	a5,-25(s0)
 2b0:	873e                	mv	a4,a5
 2b2:	47a9                	li	a5,10
 2b4:	02f70463          	beq	a4,a5,2dc <gets+0x86>
 2b8:	fe744783          	lbu	a5,-25(s0)
 2bc:	873e                	mv	a4,a5
 2be:	47b5                	li	a5,13
 2c0:	00f70e63          	beq	a4,a5,2dc <gets+0x86>
  for(i=0; i+1 < max; ){
 2c4:	fec42783          	lw	a5,-20(s0)
 2c8:	2785                	addiw	a5,a5,1
 2ca:	0007871b          	sext.w	a4,a5
 2ce:	fd442783          	lw	a5,-44(s0)
 2d2:	2781                	sext.w	a5,a5
 2d4:	f8f74de3          	blt	a4,a5,26e <gets+0x18>
 2d8:	a011                	j	2dc <gets+0x86>
      break;
 2da:	0001                	nop
      break;
  }
  buf[i] = '\0';
 2dc:	fec42783          	lw	a5,-20(s0)
 2e0:	fd843703          	ld	a4,-40(s0)
 2e4:	97ba                	add	a5,a5,a4
 2e6:	00078023          	sb	zero,0(a5)
  return buf;
 2ea:	fd843783          	ld	a5,-40(s0)
}
 2ee:	853e                	mv	a0,a5
 2f0:	70a2                	ld	ra,40(sp)
 2f2:	7402                	ld	s0,32(sp)
 2f4:	6145                	addi	sp,sp,48
 2f6:	8082                	ret

00000000000002f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f8:	7179                	addi	sp,sp,-48
 2fa:	f406                	sd	ra,40(sp)
 2fc:	f022                	sd	s0,32(sp)
 2fe:	1800                	addi	s0,sp,48
 300:	fca43c23          	sd	a0,-40(s0)
 304:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 308:	4581                	li	a1,0
 30a:	fd843503          	ld	a0,-40(s0)
 30e:	00000097          	auipc	ra,0x0
 312:	28a080e7          	jalr	650(ra) # 598 <open>
 316:	87aa                	mv	a5,a0
 318:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 31c:	fec42783          	lw	a5,-20(s0)
 320:	2781                	sext.w	a5,a5
 322:	0007d463          	bgez	a5,32a <stat+0x32>
    return -1;
 326:	57fd                	li	a5,-1
 328:	a035                	j	354 <stat+0x5c>
  r = fstat(fd, st);
 32a:	fec42783          	lw	a5,-20(s0)
 32e:	fd043583          	ld	a1,-48(s0)
 332:	853e                	mv	a0,a5
 334:	00000097          	auipc	ra,0x0
 338:	27c080e7          	jalr	636(ra) # 5b0 <fstat>
 33c:	87aa                	mv	a5,a0
 33e:	fef42423          	sw	a5,-24(s0)
  close(fd);
 342:	fec42783          	lw	a5,-20(s0)
 346:	853e                	mv	a0,a5
 348:	00000097          	auipc	ra,0x0
 34c:	238080e7          	jalr	568(ra) # 580 <close>
  return r;
 350:	fe842783          	lw	a5,-24(s0)
}
 354:	853e                	mv	a0,a5
 356:	70a2                	ld	ra,40(sp)
 358:	7402                	ld	s0,32(sp)
 35a:	6145                	addi	sp,sp,48
 35c:	8082                	ret

000000000000035e <atoi>:

int
atoi(const char *s)
{
 35e:	7179                	addi	sp,sp,-48
 360:	f422                	sd	s0,40(sp)
 362:	1800                	addi	s0,sp,48
 364:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 368:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 36c:	a81d                	j	3a2 <atoi+0x44>
    n = n*10 + *s++ - '0';
 36e:	fec42783          	lw	a5,-20(s0)
 372:	873e                	mv	a4,a5
 374:	87ba                	mv	a5,a4
 376:	0027979b          	slliw	a5,a5,0x2
 37a:	9fb9                	addw	a5,a5,a4
 37c:	0017979b          	slliw	a5,a5,0x1
 380:	0007871b          	sext.w	a4,a5
 384:	fd843783          	ld	a5,-40(s0)
 388:	00178693          	addi	a3,a5,1
 38c:	fcd43c23          	sd	a3,-40(s0)
 390:	0007c783          	lbu	a5,0(a5)
 394:	2781                	sext.w	a5,a5
 396:	9fb9                	addw	a5,a5,a4
 398:	2781                	sext.w	a5,a5
 39a:	fd07879b          	addiw	a5,a5,-48
 39e:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 3a2:	fd843783          	ld	a5,-40(s0)
 3a6:	0007c783          	lbu	a5,0(a5)
 3aa:	873e                	mv	a4,a5
 3ac:	02f00793          	li	a5,47
 3b0:	00e7fb63          	bgeu	a5,a4,3c6 <atoi+0x68>
 3b4:	fd843783          	ld	a5,-40(s0)
 3b8:	0007c783          	lbu	a5,0(a5)
 3bc:	873e                	mv	a4,a5
 3be:	03900793          	li	a5,57
 3c2:	fae7f6e3          	bgeu	a5,a4,36e <atoi+0x10>
  return n;
 3c6:	fec42783          	lw	a5,-20(s0)
}
 3ca:	853e                	mv	a0,a5
 3cc:	7422                	ld	s0,40(sp)
 3ce:	6145                	addi	sp,sp,48
 3d0:	8082                	ret

00000000000003d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d2:	7139                	addi	sp,sp,-64
 3d4:	fc22                	sd	s0,56(sp)
 3d6:	0080                	addi	s0,sp,64
 3d8:	fca43c23          	sd	a0,-40(s0)
 3dc:	fcb43823          	sd	a1,-48(s0)
 3e0:	87b2                	mv	a5,a2
 3e2:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 3e6:	fd843783          	ld	a5,-40(s0)
 3ea:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 3ee:	fd043783          	ld	a5,-48(s0)
 3f2:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 3f6:	fe043703          	ld	a4,-32(s0)
 3fa:	fe843783          	ld	a5,-24(s0)
 3fe:	02e7fc63          	bgeu	a5,a4,436 <memmove+0x64>
    while(n-- > 0)
 402:	a00d                	j	424 <memmove+0x52>
      *dst++ = *src++;
 404:	fe043703          	ld	a4,-32(s0)
 408:	00170793          	addi	a5,a4,1
 40c:	fef43023          	sd	a5,-32(s0)
 410:	fe843783          	ld	a5,-24(s0)
 414:	00178693          	addi	a3,a5,1
 418:	fed43423          	sd	a3,-24(s0)
 41c:	00074703          	lbu	a4,0(a4)
 420:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 424:	fcc42783          	lw	a5,-52(s0)
 428:	fff7871b          	addiw	a4,a5,-1
 42c:	fce42623          	sw	a4,-52(s0)
 430:	fcf04ae3          	bgtz	a5,404 <memmove+0x32>
 434:	a891                	j	488 <memmove+0xb6>
  } else {
    dst += n;
 436:	fcc42783          	lw	a5,-52(s0)
 43a:	fe843703          	ld	a4,-24(s0)
 43e:	97ba                	add	a5,a5,a4
 440:	fef43423          	sd	a5,-24(s0)
    src += n;
 444:	fcc42783          	lw	a5,-52(s0)
 448:	fe043703          	ld	a4,-32(s0)
 44c:	97ba                	add	a5,a5,a4
 44e:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 452:	a01d                	j	478 <memmove+0xa6>
      *--dst = *--src;
 454:	fe043783          	ld	a5,-32(s0)
 458:	17fd                	addi	a5,a5,-1
 45a:	fef43023          	sd	a5,-32(s0)
 45e:	fe843783          	ld	a5,-24(s0)
 462:	17fd                	addi	a5,a5,-1
 464:	fef43423          	sd	a5,-24(s0)
 468:	fe043783          	ld	a5,-32(s0)
 46c:	0007c703          	lbu	a4,0(a5)
 470:	fe843783          	ld	a5,-24(s0)
 474:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 478:	fcc42783          	lw	a5,-52(s0)
 47c:	fff7871b          	addiw	a4,a5,-1
 480:	fce42623          	sw	a4,-52(s0)
 484:	fcf048e3          	bgtz	a5,454 <memmove+0x82>
  }
  return vdst;
 488:	fd843783          	ld	a5,-40(s0)
}
 48c:	853e                	mv	a0,a5
 48e:	7462                	ld	s0,56(sp)
 490:	6121                	addi	sp,sp,64
 492:	8082                	ret

0000000000000494 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 494:	7139                	addi	sp,sp,-64
 496:	fc22                	sd	s0,56(sp)
 498:	0080                	addi	s0,sp,64
 49a:	fca43c23          	sd	a0,-40(s0)
 49e:	fcb43823          	sd	a1,-48(s0)
 4a2:	87b2                	mv	a5,a2
 4a4:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 4a8:	fd843783          	ld	a5,-40(s0)
 4ac:	fef43423          	sd	a5,-24(s0)
 4b0:	fd043783          	ld	a5,-48(s0)
 4b4:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 4b8:	a0a1                	j	500 <memcmp+0x6c>
    if (*p1 != *p2) {
 4ba:	fe843783          	ld	a5,-24(s0)
 4be:	0007c703          	lbu	a4,0(a5)
 4c2:	fe043783          	ld	a5,-32(s0)
 4c6:	0007c783          	lbu	a5,0(a5)
 4ca:	02f70163          	beq	a4,a5,4ec <memcmp+0x58>
      return *p1 - *p2;
 4ce:	fe843783          	ld	a5,-24(s0)
 4d2:	0007c783          	lbu	a5,0(a5)
 4d6:	0007871b          	sext.w	a4,a5
 4da:	fe043783          	ld	a5,-32(s0)
 4de:	0007c783          	lbu	a5,0(a5)
 4e2:	2781                	sext.w	a5,a5
 4e4:	40f707bb          	subw	a5,a4,a5
 4e8:	2781                	sext.w	a5,a5
 4ea:	a01d                	j	510 <memcmp+0x7c>
    }
    p1++;
 4ec:	fe843783          	ld	a5,-24(s0)
 4f0:	0785                	addi	a5,a5,1
 4f2:	fef43423          	sd	a5,-24(s0)
    p2++;
 4f6:	fe043783          	ld	a5,-32(s0)
 4fa:	0785                	addi	a5,a5,1
 4fc:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 500:	fcc42783          	lw	a5,-52(s0)
 504:	fff7871b          	addiw	a4,a5,-1
 508:	fce42623          	sw	a4,-52(s0)
 50c:	f7dd                	bnez	a5,4ba <memcmp+0x26>
  }
  return 0;
 50e:	4781                	li	a5,0
}
 510:	853e                	mv	a0,a5
 512:	7462                	ld	s0,56(sp)
 514:	6121                	addi	sp,sp,64
 516:	8082                	ret

0000000000000518 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 518:	7179                	addi	sp,sp,-48
 51a:	f406                	sd	ra,40(sp)
 51c:	f022                	sd	s0,32(sp)
 51e:	1800                	addi	s0,sp,48
 520:	fea43423          	sd	a0,-24(s0)
 524:	feb43023          	sd	a1,-32(s0)
 528:	87b2                	mv	a5,a2
 52a:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 52e:	fdc42783          	lw	a5,-36(s0)
 532:	863e                	mv	a2,a5
 534:	fe043583          	ld	a1,-32(s0)
 538:	fe843503          	ld	a0,-24(s0)
 53c:	00000097          	auipc	ra,0x0
 540:	e96080e7          	jalr	-362(ra) # 3d2 <memmove>
 544:	87aa                	mv	a5,a0
}
 546:	853e                	mv	a0,a5
 548:	70a2                	ld	ra,40(sp)
 54a:	7402                	ld	s0,32(sp)
 54c:	6145                	addi	sp,sp,48
 54e:	8082                	ret

0000000000000550 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 550:	4885                	li	a7,1
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <exit>:
.global exit
exit:
 li a7, SYS_exit
 558:	4889                	li	a7,2
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <wait>:
.global wait
wait:
 li a7, SYS_wait
 560:	488d                	li	a7,3
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 568:	4891                	li	a7,4
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <read>:
.global read
read:
 li a7, SYS_read
 570:	4895                	li	a7,5
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <write>:
.global write
write:
 li a7, SYS_write
 578:	48c1                	li	a7,16
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <close>:
.global close
close:
 li a7, SYS_close
 580:	48d5                	li	a7,21
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <kill>:
.global kill
kill:
 li a7, SYS_kill
 588:	4899                	li	a7,6
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <exec>:
.global exec
exec:
 li a7, SYS_exec
 590:	489d                	li	a7,7
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <open>:
.global open
open:
 li a7, SYS_open
 598:	48bd                	li	a7,15
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5a0:	48c5                	li	a7,17
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a8:	48c9                	li	a7,18
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5b0:	48a1                	li	a7,8
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <link>:
.global link
link:
 li a7, SYS_link
 5b8:	48cd                	li	a7,19
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5c0:	48d1                	li	a7,20
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c8:	48a5                	li	a7,9
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5d0:	48a9                	li	a7,10
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d8:	48ad                	li	a7,11
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5e0:	48b1                	li	a7,12
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5e8:	48b5                	li	a7,13
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5f0:	48b9                	li	a7,14
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5f8:	1101                	addi	sp,sp,-32
 5fa:	ec06                	sd	ra,24(sp)
 5fc:	e822                	sd	s0,16(sp)
 5fe:	1000                	addi	s0,sp,32
 600:	87aa                	mv	a5,a0
 602:	872e                	mv	a4,a1
 604:	fef42623          	sw	a5,-20(s0)
 608:	87ba                	mv	a5,a4
 60a:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 60e:	feb40713          	addi	a4,s0,-21
 612:	fec42783          	lw	a5,-20(s0)
 616:	4605                	li	a2,1
 618:	85ba                	mv	a1,a4
 61a:	853e                	mv	a0,a5
 61c:	00000097          	auipc	ra,0x0
 620:	f5c080e7          	jalr	-164(ra) # 578 <write>
}
 624:	0001                	nop
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6105                	addi	sp,sp,32
 62c:	8082                	ret

000000000000062e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62e:	7139                	addi	sp,sp,-64
 630:	fc06                	sd	ra,56(sp)
 632:	f822                	sd	s0,48(sp)
 634:	0080                	addi	s0,sp,64
 636:	87aa                	mv	a5,a0
 638:	8736                	mv	a4,a3
 63a:	fcf42623          	sw	a5,-52(s0)
 63e:	87ae                	mv	a5,a1
 640:	fcf42423          	sw	a5,-56(s0)
 644:	87b2                	mv	a5,a2
 646:	fcf42223          	sw	a5,-60(s0)
 64a:	87ba                	mv	a5,a4
 64c:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 650:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 654:	fc042783          	lw	a5,-64(s0)
 658:	2781                	sext.w	a5,a5
 65a:	c38d                	beqz	a5,67c <printint+0x4e>
 65c:	fc842783          	lw	a5,-56(s0)
 660:	2781                	sext.w	a5,a5
 662:	0007dd63          	bgez	a5,67c <printint+0x4e>
    neg = 1;
 666:	4785                	li	a5,1
 668:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 66c:	fc842783          	lw	a5,-56(s0)
 670:	40f007bb          	negw	a5,a5
 674:	2781                	sext.w	a5,a5
 676:	fef42223          	sw	a5,-28(s0)
 67a:	a029                	j	684 <printint+0x56>
  } else {
    x = xx;
 67c:	fc842783          	lw	a5,-56(s0)
 680:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 684:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 688:	fc442783          	lw	a5,-60(s0)
 68c:	fe442703          	lw	a4,-28(s0)
 690:	02f777bb          	remuw	a5,a4,a5
 694:	0007861b          	sext.w	a2,a5
 698:	fec42783          	lw	a5,-20(s0)
 69c:	0017871b          	addiw	a4,a5,1
 6a0:	fee42623          	sw	a4,-20(s0)
 6a4:	00001697          	auipc	a3,0x1
 6a8:	ccc68693          	addi	a3,a3,-820 # 1370 <digits>
 6ac:	02061713          	slli	a4,a2,0x20
 6b0:	9301                	srli	a4,a4,0x20
 6b2:	9736                	add	a4,a4,a3
 6b4:	00074703          	lbu	a4,0(a4)
 6b8:	17c1                	addi	a5,a5,-16
 6ba:	97a2                	add	a5,a5,s0
 6bc:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6c0:	fc442783          	lw	a5,-60(s0)
 6c4:	fe442703          	lw	a4,-28(s0)
 6c8:	02f757bb          	divuw	a5,a4,a5
 6cc:	fef42223          	sw	a5,-28(s0)
 6d0:	fe442783          	lw	a5,-28(s0)
 6d4:	2781                	sext.w	a5,a5
 6d6:	fbcd                	bnez	a5,688 <printint+0x5a>
  if(neg)
 6d8:	fe842783          	lw	a5,-24(s0)
 6dc:	2781                	sext.w	a5,a5
 6de:	cf85                	beqz	a5,716 <printint+0xe8>
    buf[i++] = '-';
 6e0:	fec42783          	lw	a5,-20(s0)
 6e4:	0017871b          	addiw	a4,a5,1
 6e8:	fee42623          	sw	a4,-20(s0)
 6ec:	17c1                	addi	a5,a5,-16
 6ee:	97a2                	add	a5,a5,s0
 6f0:	02d00713          	li	a4,45
 6f4:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6f8:	a839                	j	716 <printint+0xe8>
    putc(fd, buf[i]);
 6fa:	fec42783          	lw	a5,-20(s0)
 6fe:	17c1                	addi	a5,a5,-16
 700:	97a2                	add	a5,a5,s0
 702:	fe07c703          	lbu	a4,-32(a5)
 706:	fcc42783          	lw	a5,-52(s0)
 70a:	85ba                	mv	a1,a4
 70c:	853e                	mv	a0,a5
 70e:	00000097          	auipc	ra,0x0
 712:	eea080e7          	jalr	-278(ra) # 5f8 <putc>
  while(--i >= 0)
 716:	fec42783          	lw	a5,-20(s0)
 71a:	37fd                	addiw	a5,a5,-1
 71c:	fef42623          	sw	a5,-20(s0)
 720:	fec42783          	lw	a5,-20(s0)
 724:	2781                	sext.w	a5,a5
 726:	fc07dae3          	bgez	a5,6fa <printint+0xcc>
}
 72a:	0001                	nop
 72c:	0001                	nop
 72e:	70e2                	ld	ra,56(sp)
 730:	7442                	ld	s0,48(sp)
 732:	6121                	addi	sp,sp,64
 734:	8082                	ret

0000000000000736 <printptr>:

static void
printptr(int fd, uint64 x) {
 736:	7179                	addi	sp,sp,-48
 738:	f406                	sd	ra,40(sp)
 73a:	f022                	sd	s0,32(sp)
 73c:	1800                	addi	s0,sp,48
 73e:	87aa                	mv	a5,a0
 740:	fcb43823          	sd	a1,-48(s0)
 744:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 748:	fdc42783          	lw	a5,-36(s0)
 74c:	03000593          	li	a1,48
 750:	853e                	mv	a0,a5
 752:	00000097          	auipc	ra,0x0
 756:	ea6080e7          	jalr	-346(ra) # 5f8 <putc>
  putc(fd, 'x');
 75a:	fdc42783          	lw	a5,-36(s0)
 75e:	07800593          	li	a1,120
 762:	853e                	mv	a0,a5
 764:	00000097          	auipc	ra,0x0
 768:	e94080e7          	jalr	-364(ra) # 5f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 76c:	fe042623          	sw	zero,-20(s0)
 770:	a82d                	j	7aa <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 772:	fd043783          	ld	a5,-48(s0)
 776:	93f1                	srli	a5,a5,0x3c
 778:	00001717          	auipc	a4,0x1
 77c:	bf870713          	addi	a4,a4,-1032 # 1370 <digits>
 780:	97ba                	add	a5,a5,a4
 782:	0007c703          	lbu	a4,0(a5)
 786:	fdc42783          	lw	a5,-36(s0)
 78a:	85ba                	mv	a1,a4
 78c:	853e                	mv	a0,a5
 78e:	00000097          	auipc	ra,0x0
 792:	e6a080e7          	jalr	-406(ra) # 5f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 796:	fec42783          	lw	a5,-20(s0)
 79a:	2785                	addiw	a5,a5,1
 79c:	fef42623          	sw	a5,-20(s0)
 7a0:	fd043783          	ld	a5,-48(s0)
 7a4:	0792                	slli	a5,a5,0x4
 7a6:	fcf43823          	sd	a5,-48(s0)
 7aa:	fec42783          	lw	a5,-20(s0)
 7ae:	873e                	mv	a4,a5
 7b0:	47bd                	li	a5,15
 7b2:	fce7f0e3          	bgeu	a5,a4,772 <printptr+0x3c>
}
 7b6:	0001                	nop
 7b8:	0001                	nop
 7ba:	70a2                	ld	ra,40(sp)
 7bc:	7402                	ld	s0,32(sp)
 7be:	6145                	addi	sp,sp,48
 7c0:	8082                	ret

00000000000007c2 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7c2:	715d                	addi	sp,sp,-80
 7c4:	e486                	sd	ra,72(sp)
 7c6:	e0a2                	sd	s0,64(sp)
 7c8:	0880                	addi	s0,sp,80
 7ca:	87aa                	mv	a5,a0
 7cc:	fcb43023          	sd	a1,-64(s0)
 7d0:	fac43c23          	sd	a2,-72(s0)
 7d4:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7d8:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7dc:	fe042223          	sw	zero,-28(s0)
 7e0:	a42d                	j	a0a <vprintf+0x248>
    c = fmt[i] & 0xff;
 7e2:	fe442783          	lw	a5,-28(s0)
 7e6:	fc043703          	ld	a4,-64(s0)
 7ea:	97ba                	add	a5,a5,a4
 7ec:	0007c783          	lbu	a5,0(a5)
 7f0:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7f4:	fe042783          	lw	a5,-32(s0)
 7f8:	2781                	sext.w	a5,a5
 7fa:	eb9d                	bnez	a5,830 <vprintf+0x6e>
      if(c == '%'){
 7fc:	fdc42783          	lw	a5,-36(s0)
 800:	0007871b          	sext.w	a4,a5
 804:	02500793          	li	a5,37
 808:	00f71763          	bne	a4,a5,816 <vprintf+0x54>
        state = '%';
 80c:	02500793          	li	a5,37
 810:	fef42023          	sw	a5,-32(s0)
 814:	a2f5                	j	a00 <vprintf+0x23e>
      } else {
        putc(fd, c);
 816:	fdc42783          	lw	a5,-36(s0)
 81a:	0ff7f713          	zext.b	a4,a5
 81e:	fcc42783          	lw	a5,-52(s0)
 822:	85ba                	mv	a1,a4
 824:	853e                	mv	a0,a5
 826:	00000097          	auipc	ra,0x0
 82a:	dd2080e7          	jalr	-558(ra) # 5f8 <putc>
 82e:	aac9                	j	a00 <vprintf+0x23e>
      }
    } else if(state == '%'){
 830:	fe042783          	lw	a5,-32(s0)
 834:	0007871b          	sext.w	a4,a5
 838:	02500793          	li	a5,37
 83c:	1cf71263          	bne	a4,a5,a00 <vprintf+0x23e>
      if(c == 'd'){
 840:	fdc42783          	lw	a5,-36(s0)
 844:	0007871b          	sext.w	a4,a5
 848:	06400793          	li	a5,100
 84c:	02f71463          	bne	a4,a5,874 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 850:	fb843783          	ld	a5,-72(s0)
 854:	00878713          	addi	a4,a5,8
 858:	fae43c23          	sd	a4,-72(s0)
 85c:	4398                	lw	a4,0(a5)
 85e:	fcc42783          	lw	a5,-52(s0)
 862:	4685                	li	a3,1
 864:	4629                	li	a2,10
 866:	85ba                	mv	a1,a4
 868:	853e                	mv	a0,a5
 86a:	00000097          	auipc	ra,0x0
 86e:	dc4080e7          	jalr	-572(ra) # 62e <printint>
 872:	a269                	j	9fc <vprintf+0x23a>
      } else if(c == 'l') {
 874:	fdc42783          	lw	a5,-36(s0)
 878:	0007871b          	sext.w	a4,a5
 87c:	06c00793          	li	a5,108
 880:	02f71663          	bne	a4,a5,8ac <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 884:	fb843783          	ld	a5,-72(s0)
 888:	00878713          	addi	a4,a5,8
 88c:	fae43c23          	sd	a4,-72(s0)
 890:	639c                	ld	a5,0(a5)
 892:	0007871b          	sext.w	a4,a5
 896:	fcc42783          	lw	a5,-52(s0)
 89a:	4681                	li	a3,0
 89c:	4629                	li	a2,10
 89e:	85ba                	mv	a1,a4
 8a0:	853e                	mv	a0,a5
 8a2:	00000097          	auipc	ra,0x0
 8a6:	d8c080e7          	jalr	-628(ra) # 62e <printint>
 8aa:	aa89                	j	9fc <vprintf+0x23a>
      } else if(c == 'x') {
 8ac:	fdc42783          	lw	a5,-36(s0)
 8b0:	0007871b          	sext.w	a4,a5
 8b4:	07800793          	li	a5,120
 8b8:	02f71463          	bne	a4,a5,8e0 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8bc:	fb843783          	ld	a5,-72(s0)
 8c0:	00878713          	addi	a4,a5,8
 8c4:	fae43c23          	sd	a4,-72(s0)
 8c8:	4398                	lw	a4,0(a5)
 8ca:	fcc42783          	lw	a5,-52(s0)
 8ce:	4681                	li	a3,0
 8d0:	4641                	li	a2,16
 8d2:	85ba                	mv	a1,a4
 8d4:	853e                	mv	a0,a5
 8d6:	00000097          	auipc	ra,0x0
 8da:	d58080e7          	jalr	-680(ra) # 62e <printint>
 8de:	aa39                	j	9fc <vprintf+0x23a>
      } else if(c == 'p') {
 8e0:	fdc42783          	lw	a5,-36(s0)
 8e4:	0007871b          	sext.w	a4,a5
 8e8:	07000793          	li	a5,112
 8ec:	02f71263          	bne	a4,a5,910 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8f0:	fb843783          	ld	a5,-72(s0)
 8f4:	00878713          	addi	a4,a5,8
 8f8:	fae43c23          	sd	a4,-72(s0)
 8fc:	6398                	ld	a4,0(a5)
 8fe:	fcc42783          	lw	a5,-52(s0)
 902:	85ba                	mv	a1,a4
 904:	853e                	mv	a0,a5
 906:	00000097          	auipc	ra,0x0
 90a:	e30080e7          	jalr	-464(ra) # 736 <printptr>
 90e:	a0fd                	j	9fc <vprintf+0x23a>
      } else if(c == 's'){
 910:	fdc42783          	lw	a5,-36(s0)
 914:	0007871b          	sext.w	a4,a5
 918:	07300793          	li	a5,115
 91c:	04f71c63          	bne	a4,a5,974 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 920:	fb843783          	ld	a5,-72(s0)
 924:	00878713          	addi	a4,a5,8
 928:	fae43c23          	sd	a4,-72(s0)
 92c:	639c                	ld	a5,0(a5)
 92e:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 932:	fe843783          	ld	a5,-24(s0)
 936:	eb8d                	bnez	a5,968 <vprintf+0x1a6>
          s = "(null)";
 938:	00000797          	auipc	a5,0x0
 93c:	4b078793          	addi	a5,a5,1200 # de8 <malloc+0x176>
 940:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 944:	a015                	j	968 <vprintf+0x1a6>
          putc(fd, *s);
 946:	fe843783          	ld	a5,-24(s0)
 94a:	0007c703          	lbu	a4,0(a5)
 94e:	fcc42783          	lw	a5,-52(s0)
 952:	85ba                	mv	a1,a4
 954:	853e                	mv	a0,a5
 956:	00000097          	auipc	ra,0x0
 95a:	ca2080e7          	jalr	-862(ra) # 5f8 <putc>
          s++;
 95e:	fe843783          	ld	a5,-24(s0)
 962:	0785                	addi	a5,a5,1
 964:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 968:	fe843783          	ld	a5,-24(s0)
 96c:	0007c783          	lbu	a5,0(a5)
 970:	fbf9                	bnez	a5,946 <vprintf+0x184>
 972:	a069                	j	9fc <vprintf+0x23a>
        }
      } else if(c == 'c'){
 974:	fdc42783          	lw	a5,-36(s0)
 978:	0007871b          	sext.w	a4,a5
 97c:	06300793          	li	a5,99
 980:	02f71463          	bne	a4,a5,9a8 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 984:	fb843783          	ld	a5,-72(s0)
 988:	00878713          	addi	a4,a5,8
 98c:	fae43c23          	sd	a4,-72(s0)
 990:	439c                	lw	a5,0(a5)
 992:	0ff7f713          	zext.b	a4,a5
 996:	fcc42783          	lw	a5,-52(s0)
 99a:	85ba                	mv	a1,a4
 99c:	853e                	mv	a0,a5
 99e:	00000097          	auipc	ra,0x0
 9a2:	c5a080e7          	jalr	-934(ra) # 5f8 <putc>
 9a6:	a899                	j	9fc <vprintf+0x23a>
      } else if(c == '%'){
 9a8:	fdc42783          	lw	a5,-36(s0)
 9ac:	0007871b          	sext.w	a4,a5
 9b0:	02500793          	li	a5,37
 9b4:	00f71f63          	bne	a4,a5,9d2 <vprintf+0x210>
        putc(fd, c);
 9b8:	fdc42783          	lw	a5,-36(s0)
 9bc:	0ff7f713          	zext.b	a4,a5
 9c0:	fcc42783          	lw	a5,-52(s0)
 9c4:	85ba                	mv	a1,a4
 9c6:	853e                	mv	a0,a5
 9c8:	00000097          	auipc	ra,0x0
 9cc:	c30080e7          	jalr	-976(ra) # 5f8 <putc>
 9d0:	a035                	j	9fc <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9d2:	fcc42783          	lw	a5,-52(s0)
 9d6:	02500593          	li	a1,37
 9da:	853e                	mv	a0,a5
 9dc:	00000097          	auipc	ra,0x0
 9e0:	c1c080e7          	jalr	-996(ra) # 5f8 <putc>
        putc(fd, c);
 9e4:	fdc42783          	lw	a5,-36(s0)
 9e8:	0ff7f713          	zext.b	a4,a5
 9ec:	fcc42783          	lw	a5,-52(s0)
 9f0:	85ba                	mv	a1,a4
 9f2:	853e                	mv	a0,a5
 9f4:	00000097          	auipc	ra,0x0
 9f8:	c04080e7          	jalr	-1020(ra) # 5f8 <putc>
      }
      state = 0;
 9fc:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a00:	fe442783          	lw	a5,-28(s0)
 a04:	2785                	addiw	a5,a5,1
 a06:	fef42223          	sw	a5,-28(s0)
 a0a:	fe442783          	lw	a5,-28(s0)
 a0e:	fc043703          	ld	a4,-64(s0)
 a12:	97ba                	add	a5,a5,a4
 a14:	0007c783          	lbu	a5,0(a5)
 a18:	dc0795e3          	bnez	a5,7e2 <vprintf+0x20>
    }
  }
}
 a1c:	0001                	nop
 a1e:	0001                	nop
 a20:	60a6                	ld	ra,72(sp)
 a22:	6406                	ld	s0,64(sp)
 a24:	6161                	addi	sp,sp,80
 a26:	8082                	ret

0000000000000a28 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a28:	7159                	addi	sp,sp,-112
 a2a:	fc06                	sd	ra,56(sp)
 a2c:	f822                	sd	s0,48(sp)
 a2e:	0080                	addi	s0,sp,64
 a30:	fcb43823          	sd	a1,-48(s0)
 a34:	e010                	sd	a2,0(s0)
 a36:	e414                	sd	a3,8(s0)
 a38:	e818                	sd	a4,16(s0)
 a3a:	ec1c                	sd	a5,24(s0)
 a3c:	03043023          	sd	a6,32(s0)
 a40:	03143423          	sd	a7,40(s0)
 a44:	87aa                	mv	a5,a0
 a46:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a4a:	03040793          	addi	a5,s0,48
 a4e:	fcf43423          	sd	a5,-56(s0)
 a52:	fc843783          	ld	a5,-56(s0)
 a56:	fd078793          	addi	a5,a5,-48
 a5a:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a5e:	fe843703          	ld	a4,-24(s0)
 a62:	fdc42783          	lw	a5,-36(s0)
 a66:	863a                	mv	a2,a4
 a68:	fd043583          	ld	a1,-48(s0)
 a6c:	853e                	mv	a0,a5
 a6e:	00000097          	auipc	ra,0x0
 a72:	d54080e7          	jalr	-684(ra) # 7c2 <vprintf>
}
 a76:	0001                	nop
 a78:	70e2                	ld	ra,56(sp)
 a7a:	7442                	ld	s0,48(sp)
 a7c:	6165                	addi	sp,sp,112
 a7e:	8082                	ret

0000000000000a80 <printf>:

void
printf(const char *fmt, ...)
{
 a80:	7159                	addi	sp,sp,-112
 a82:	f406                	sd	ra,40(sp)
 a84:	f022                	sd	s0,32(sp)
 a86:	1800                	addi	s0,sp,48
 a88:	fca43c23          	sd	a0,-40(s0)
 a8c:	e40c                	sd	a1,8(s0)
 a8e:	e810                	sd	a2,16(s0)
 a90:	ec14                	sd	a3,24(s0)
 a92:	f018                	sd	a4,32(s0)
 a94:	f41c                	sd	a5,40(s0)
 a96:	03043823          	sd	a6,48(s0)
 a9a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a9e:	04040793          	addi	a5,s0,64
 aa2:	fcf43823          	sd	a5,-48(s0)
 aa6:	fd043783          	ld	a5,-48(s0)
 aaa:	fc878793          	addi	a5,a5,-56
 aae:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ab2:	fe843783          	ld	a5,-24(s0)
 ab6:	863e                	mv	a2,a5
 ab8:	fd843583          	ld	a1,-40(s0)
 abc:	4505                	li	a0,1
 abe:	00000097          	auipc	ra,0x0
 ac2:	d04080e7          	jalr	-764(ra) # 7c2 <vprintf>
}
 ac6:	0001                	nop
 ac8:	70a2                	ld	ra,40(sp)
 aca:	7402                	ld	s0,32(sp)
 acc:	6165                	addi	sp,sp,112
 ace:	8082                	ret

0000000000000ad0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad0:	7179                	addi	sp,sp,-48
 ad2:	f422                	sd	s0,40(sp)
 ad4:	1800                	addi	s0,sp,48
 ad6:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ada:	fd843783          	ld	a5,-40(s0)
 ade:	17c1                	addi	a5,a5,-16
 ae0:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae4:	00001797          	auipc	a5,0x1
 ae8:	8bc78793          	addi	a5,a5,-1860 # 13a0 <freep>
 aec:	639c                	ld	a5,0(a5)
 aee:	fef43423          	sd	a5,-24(s0)
 af2:	a815                	j	b26 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af4:	fe843783          	ld	a5,-24(s0)
 af8:	639c                	ld	a5,0(a5)
 afa:	fe843703          	ld	a4,-24(s0)
 afe:	00f76f63          	bltu	a4,a5,b1c <free+0x4c>
 b02:	fe043703          	ld	a4,-32(s0)
 b06:	fe843783          	ld	a5,-24(s0)
 b0a:	02e7eb63          	bltu	a5,a4,b40 <free+0x70>
 b0e:	fe843783          	ld	a5,-24(s0)
 b12:	639c                	ld	a5,0(a5)
 b14:	fe043703          	ld	a4,-32(s0)
 b18:	02f76463          	bltu	a4,a5,b40 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b1c:	fe843783          	ld	a5,-24(s0)
 b20:	639c                	ld	a5,0(a5)
 b22:	fef43423          	sd	a5,-24(s0)
 b26:	fe043703          	ld	a4,-32(s0)
 b2a:	fe843783          	ld	a5,-24(s0)
 b2e:	fce7f3e3          	bgeu	a5,a4,af4 <free+0x24>
 b32:	fe843783          	ld	a5,-24(s0)
 b36:	639c                	ld	a5,0(a5)
 b38:	fe043703          	ld	a4,-32(s0)
 b3c:	faf77ce3          	bgeu	a4,a5,af4 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b40:	fe043783          	ld	a5,-32(s0)
 b44:	479c                	lw	a5,8(a5)
 b46:	1782                	slli	a5,a5,0x20
 b48:	9381                	srli	a5,a5,0x20
 b4a:	0792                	slli	a5,a5,0x4
 b4c:	fe043703          	ld	a4,-32(s0)
 b50:	973e                	add	a4,a4,a5
 b52:	fe843783          	ld	a5,-24(s0)
 b56:	639c                	ld	a5,0(a5)
 b58:	02f71763          	bne	a4,a5,b86 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b5c:	fe043783          	ld	a5,-32(s0)
 b60:	4798                	lw	a4,8(a5)
 b62:	fe843783          	ld	a5,-24(s0)
 b66:	639c                	ld	a5,0(a5)
 b68:	479c                	lw	a5,8(a5)
 b6a:	9fb9                	addw	a5,a5,a4
 b6c:	0007871b          	sext.w	a4,a5
 b70:	fe043783          	ld	a5,-32(s0)
 b74:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b76:	fe843783          	ld	a5,-24(s0)
 b7a:	639c                	ld	a5,0(a5)
 b7c:	6398                	ld	a4,0(a5)
 b7e:	fe043783          	ld	a5,-32(s0)
 b82:	e398                	sd	a4,0(a5)
 b84:	a039                	j	b92 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b86:	fe843783          	ld	a5,-24(s0)
 b8a:	6398                	ld	a4,0(a5)
 b8c:	fe043783          	ld	a5,-32(s0)
 b90:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b92:	fe843783          	ld	a5,-24(s0)
 b96:	479c                	lw	a5,8(a5)
 b98:	1782                	slli	a5,a5,0x20
 b9a:	9381                	srli	a5,a5,0x20
 b9c:	0792                	slli	a5,a5,0x4
 b9e:	fe843703          	ld	a4,-24(s0)
 ba2:	97ba                	add	a5,a5,a4
 ba4:	fe043703          	ld	a4,-32(s0)
 ba8:	02f71563          	bne	a4,a5,bd2 <free+0x102>
    p->s.size += bp->s.size;
 bac:	fe843783          	ld	a5,-24(s0)
 bb0:	4798                	lw	a4,8(a5)
 bb2:	fe043783          	ld	a5,-32(s0)
 bb6:	479c                	lw	a5,8(a5)
 bb8:	9fb9                	addw	a5,a5,a4
 bba:	0007871b          	sext.w	a4,a5
 bbe:	fe843783          	ld	a5,-24(s0)
 bc2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bc4:	fe043783          	ld	a5,-32(s0)
 bc8:	6398                	ld	a4,0(a5)
 bca:	fe843783          	ld	a5,-24(s0)
 bce:	e398                	sd	a4,0(a5)
 bd0:	a031                	j	bdc <free+0x10c>
  } else
    p->s.ptr = bp;
 bd2:	fe843783          	ld	a5,-24(s0)
 bd6:	fe043703          	ld	a4,-32(s0)
 bda:	e398                	sd	a4,0(a5)
  freep = p;
 bdc:	00000797          	auipc	a5,0x0
 be0:	7c478793          	addi	a5,a5,1988 # 13a0 <freep>
 be4:	fe843703          	ld	a4,-24(s0)
 be8:	e398                	sd	a4,0(a5)
}
 bea:	0001                	nop
 bec:	7422                	ld	s0,40(sp)
 bee:	6145                	addi	sp,sp,48
 bf0:	8082                	ret

0000000000000bf2 <morecore>:

static Header*
morecore(uint nu)
{
 bf2:	7179                	addi	sp,sp,-48
 bf4:	f406                	sd	ra,40(sp)
 bf6:	f022                	sd	s0,32(sp)
 bf8:	1800                	addi	s0,sp,48
 bfa:	87aa                	mv	a5,a0
 bfc:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c00:	fdc42783          	lw	a5,-36(s0)
 c04:	0007871b          	sext.w	a4,a5
 c08:	6785                	lui	a5,0x1
 c0a:	00f77563          	bgeu	a4,a5,c14 <morecore+0x22>
    nu = 4096;
 c0e:	6785                	lui	a5,0x1
 c10:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c14:	fdc42783          	lw	a5,-36(s0)
 c18:	0047979b          	slliw	a5,a5,0x4
 c1c:	2781                	sext.w	a5,a5
 c1e:	2781                	sext.w	a5,a5
 c20:	853e                	mv	a0,a5
 c22:	00000097          	auipc	ra,0x0
 c26:	9be080e7          	jalr	-1602(ra) # 5e0 <sbrk>
 c2a:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c2e:	fe843703          	ld	a4,-24(s0)
 c32:	57fd                	li	a5,-1
 c34:	00f71463          	bne	a4,a5,c3c <morecore+0x4a>
    return 0;
 c38:	4781                	li	a5,0
 c3a:	a03d                	j	c68 <morecore+0x76>
  hp = (Header*)p;
 c3c:	fe843783          	ld	a5,-24(s0)
 c40:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c44:	fe043783          	ld	a5,-32(s0)
 c48:	fdc42703          	lw	a4,-36(s0)
 c4c:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c4e:	fe043783          	ld	a5,-32(s0)
 c52:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x39e>
 c54:	853e                	mv	a0,a5
 c56:	00000097          	auipc	ra,0x0
 c5a:	e7a080e7          	jalr	-390(ra) # ad0 <free>
  return freep;
 c5e:	00000797          	auipc	a5,0x0
 c62:	74278793          	addi	a5,a5,1858 # 13a0 <freep>
 c66:	639c                	ld	a5,0(a5)
}
 c68:	853e                	mv	a0,a5
 c6a:	70a2                	ld	ra,40(sp)
 c6c:	7402                	ld	s0,32(sp)
 c6e:	6145                	addi	sp,sp,48
 c70:	8082                	ret

0000000000000c72 <malloc>:

void*
malloc(uint nbytes)
{
 c72:	7139                	addi	sp,sp,-64
 c74:	fc06                	sd	ra,56(sp)
 c76:	f822                	sd	s0,48(sp)
 c78:	0080                	addi	s0,sp,64
 c7a:	87aa                	mv	a5,a0
 c7c:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c80:	fcc46783          	lwu	a5,-52(s0)
 c84:	07bd                	addi	a5,a5,15
 c86:	8391                	srli	a5,a5,0x4
 c88:	2781                	sext.w	a5,a5
 c8a:	2785                	addiw	a5,a5,1
 c8c:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c90:	00000797          	auipc	a5,0x0
 c94:	71078793          	addi	a5,a5,1808 # 13a0 <freep>
 c98:	639c                	ld	a5,0(a5)
 c9a:	fef43023          	sd	a5,-32(s0)
 c9e:	fe043783          	ld	a5,-32(s0)
 ca2:	ef95                	bnez	a5,cde <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 ca4:	00000797          	auipc	a5,0x0
 ca8:	6ec78793          	addi	a5,a5,1772 # 1390 <base>
 cac:	fef43023          	sd	a5,-32(s0)
 cb0:	00000797          	auipc	a5,0x0
 cb4:	6f078793          	addi	a5,a5,1776 # 13a0 <freep>
 cb8:	fe043703          	ld	a4,-32(s0)
 cbc:	e398                	sd	a4,0(a5)
 cbe:	00000797          	auipc	a5,0x0
 cc2:	6e278793          	addi	a5,a5,1762 # 13a0 <freep>
 cc6:	6398                	ld	a4,0(a5)
 cc8:	00000797          	auipc	a5,0x0
 ccc:	6c878793          	addi	a5,a5,1736 # 1390 <base>
 cd0:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cd2:	00000797          	auipc	a5,0x0
 cd6:	6be78793          	addi	a5,a5,1726 # 1390 <base>
 cda:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cde:	fe043783          	ld	a5,-32(s0)
 ce2:	639c                	ld	a5,0(a5)
 ce4:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 ce8:	fe843783          	ld	a5,-24(s0)
 cec:	4798                	lw	a4,8(a5)
 cee:	fdc42783          	lw	a5,-36(s0)
 cf2:	2781                	sext.w	a5,a5
 cf4:	06f76763          	bltu	a4,a5,d62 <malloc+0xf0>
      if(p->s.size == nunits)
 cf8:	fe843783          	ld	a5,-24(s0)
 cfc:	4798                	lw	a4,8(a5)
 cfe:	fdc42783          	lw	a5,-36(s0)
 d02:	2781                	sext.w	a5,a5
 d04:	00e79963          	bne	a5,a4,d16 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d08:	fe843783          	ld	a5,-24(s0)
 d0c:	6398                	ld	a4,0(a5)
 d0e:	fe043783          	ld	a5,-32(s0)
 d12:	e398                	sd	a4,0(a5)
 d14:	a825                	j	d4c <malloc+0xda>
      else {
        p->s.size -= nunits;
 d16:	fe843783          	ld	a5,-24(s0)
 d1a:	479c                	lw	a5,8(a5)
 d1c:	fdc42703          	lw	a4,-36(s0)
 d20:	9f99                	subw	a5,a5,a4
 d22:	0007871b          	sext.w	a4,a5
 d26:	fe843783          	ld	a5,-24(s0)
 d2a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d2c:	fe843783          	ld	a5,-24(s0)
 d30:	479c                	lw	a5,8(a5)
 d32:	1782                	slli	a5,a5,0x20
 d34:	9381                	srli	a5,a5,0x20
 d36:	0792                	slli	a5,a5,0x4
 d38:	fe843703          	ld	a4,-24(s0)
 d3c:	97ba                	add	a5,a5,a4
 d3e:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d42:	fe843783          	ld	a5,-24(s0)
 d46:	fdc42703          	lw	a4,-36(s0)
 d4a:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d4c:	00000797          	auipc	a5,0x0
 d50:	65478793          	addi	a5,a5,1620 # 13a0 <freep>
 d54:	fe043703          	ld	a4,-32(s0)
 d58:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d5a:	fe843783          	ld	a5,-24(s0)
 d5e:	07c1                	addi	a5,a5,16
 d60:	a091                	j	da4 <malloc+0x132>
    }
    if(p == freep)
 d62:	00000797          	auipc	a5,0x0
 d66:	63e78793          	addi	a5,a5,1598 # 13a0 <freep>
 d6a:	639c                	ld	a5,0(a5)
 d6c:	fe843703          	ld	a4,-24(s0)
 d70:	02f71063          	bne	a4,a5,d90 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d74:	fdc42783          	lw	a5,-36(s0)
 d78:	853e                	mv	a0,a5
 d7a:	00000097          	auipc	ra,0x0
 d7e:	e78080e7          	jalr	-392(ra) # bf2 <morecore>
 d82:	fea43423          	sd	a0,-24(s0)
 d86:	fe843783          	ld	a5,-24(s0)
 d8a:	e399                	bnez	a5,d90 <malloc+0x11e>
        return 0;
 d8c:	4781                	li	a5,0
 d8e:	a819                	j	da4 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d90:	fe843783          	ld	a5,-24(s0)
 d94:	fef43023          	sd	a5,-32(s0)
 d98:	fe843783          	ld	a5,-24(s0)
 d9c:	639c                	ld	a5,0(a5)
 d9e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 da2:	b799                	j	ce8 <malloc+0x76>
  }
}
 da4:	853e                	mv	a0,a5
 da6:	70e2                	ld	ra,56(sp)
 da8:	7442                	ld	s0,48(sp)
 daa:	6121                	addi	sp,sp,64
 dac:	8082                	ret
