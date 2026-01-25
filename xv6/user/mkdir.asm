
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
  24:	da058593          	addi	a1,a1,-608 # dc0 <malloc+0x146>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	a06080e7          	jalr	-1530(ra) # a30 <fprintf>
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
  76:	d6658593          	addi	a1,a1,-666 # dd8 <malloc+0x15e>
  7a:	4509                	li	a0,2
  7c:	00001097          	auipc	ra,0x1
  80:	9b4080e7          	jalr	-1612(ra) # a30 <fprintf>
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

00000000000005f8 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 5f8:	48d9                	li	a7,22
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 600:	1101                	addi	sp,sp,-32
 602:	ec06                	sd	ra,24(sp)
 604:	e822                	sd	s0,16(sp)
 606:	1000                	addi	s0,sp,32
 608:	87aa                	mv	a5,a0
 60a:	872e                	mv	a4,a1
 60c:	fef42623          	sw	a5,-20(s0)
 610:	87ba                	mv	a5,a4
 612:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 616:	feb40713          	addi	a4,s0,-21
 61a:	fec42783          	lw	a5,-20(s0)
 61e:	4605                	li	a2,1
 620:	85ba                	mv	a1,a4
 622:	853e                	mv	a0,a5
 624:	00000097          	auipc	ra,0x0
 628:	f54080e7          	jalr	-172(ra) # 578 <write>
}
 62c:	0001                	nop
 62e:	60e2                	ld	ra,24(sp)
 630:	6442                	ld	s0,16(sp)
 632:	6105                	addi	sp,sp,32
 634:	8082                	ret

0000000000000636 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 636:	7139                	addi	sp,sp,-64
 638:	fc06                	sd	ra,56(sp)
 63a:	f822                	sd	s0,48(sp)
 63c:	0080                	addi	s0,sp,64
 63e:	87aa                	mv	a5,a0
 640:	8736                	mv	a4,a3
 642:	fcf42623          	sw	a5,-52(s0)
 646:	87ae                	mv	a5,a1
 648:	fcf42423          	sw	a5,-56(s0)
 64c:	87b2                	mv	a5,a2
 64e:	fcf42223          	sw	a5,-60(s0)
 652:	87ba                	mv	a5,a4
 654:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 658:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 65c:	fc042783          	lw	a5,-64(s0)
 660:	2781                	sext.w	a5,a5
 662:	c38d                	beqz	a5,684 <printint+0x4e>
 664:	fc842783          	lw	a5,-56(s0)
 668:	2781                	sext.w	a5,a5
 66a:	0007dd63          	bgez	a5,684 <printint+0x4e>
    neg = 1;
 66e:	4785                	li	a5,1
 670:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 674:	fc842783          	lw	a5,-56(s0)
 678:	40f007bb          	negw	a5,a5
 67c:	2781                	sext.w	a5,a5
 67e:	fef42223          	sw	a5,-28(s0)
 682:	a029                	j	68c <printint+0x56>
  } else {
    x = xx;
 684:	fc842783          	lw	a5,-56(s0)
 688:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 68c:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 690:	fc442783          	lw	a5,-60(s0)
 694:	fe442703          	lw	a4,-28(s0)
 698:	02f777bb          	remuw	a5,a4,a5
 69c:	0007861b          	sext.w	a2,a5
 6a0:	fec42783          	lw	a5,-20(s0)
 6a4:	0017871b          	addiw	a4,a5,1
 6a8:	fee42623          	sw	a4,-20(s0)
 6ac:	00001697          	auipc	a3,0x1
 6b0:	cc468693          	addi	a3,a3,-828 # 1370 <digits>
 6b4:	02061713          	slli	a4,a2,0x20
 6b8:	9301                	srli	a4,a4,0x20
 6ba:	9736                	add	a4,a4,a3
 6bc:	00074703          	lbu	a4,0(a4)
 6c0:	17c1                	addi	a5,a5,-16
 6c2:	97a2                	add	a5,a5,s0
 6c4:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6c8:	fc442783          	lw	a5,-60(s0)
 6cc:	fe442703          	lw	a4,-28(s0)
 6d0:	02f757bb          	divuw	a5,a4,a5
 6d4:	fef42223          	sw	a5,-28(s0)
 6d8:	fe442783          	lw	a5,-28(s0)
 6dc:	2781                	sext.w	a5,a5
 6de:	fbcd                	bnez	a5,690 <printint+0x5a>
  if(neg)
 6e0:	fe842783          	lw	a5,-24(s0)
 6e4:	2781                	sext.w	a5,a5
 6e6:	cf85                	beqz	a5,71e <printint+0xe8>
    buf[i++] = '-';
 6e8:	fec42783          	lw	a5,-20(s0)
 6ec:	0017871b          	addiw	a4,a5,1
 6f0:	fee42623          	sw	a4,-20(s0)
 6f4:	17c1                	addi	a5,a5,-16
 6f6:	97a2                	add	a5,a5,s0
 6f8:	02d00713          	li	a4,45
 6fc:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 700:	a839                	j	71e <printint+0xe8>
    putc(fd, buf[i]);
 702:	fec42783          	lw	a5,-20(s0)
 706:	17c1                	addi	a5,a5,-16
 708:	97a2                	add	a5,a5,s0
 70a:	fe07c703          	lbu	a4,-32(a5)
 70e:	fcc42783          	lw	a5,-52(s0)
 712:	85ba                	mv	a1,a4
 714:	853e                	mv	a0,a5
 716:	00000097          	auipc	ra,0x0
 71a:	eea080e7          	jalr	-278(ra) # 600 <putc>
  while(--i >= 0)
 71e:	fec42783          	lw	a5,-20(s0)
 722:	37fd                	addiw	a5,a5,-1
 724:	fef42623          	sw	a5,-20(s0)
 728:	fec42783          	lw	a5,-20(s0)
 72c:	2781                	sext.w	a5,a5
 72e:	fc07dae3          	bgez	a5,702 <printint+0xcc>
}
 732:	0001                	nop
 734:	0001                	nop
 736:	70e2                	ld	ra,56(sp)
 738:	7442                	ld	s0,48(sp)
 73a:	6121                	addi	sp,sp,64
 73c:	8082                	ret

000000000000073e <printptr>:

static void
printptr(int fd, uint64 x) {
 73e:	7179                	addi	sp,sp,-48
 740:	f406                	sd	ra,40(sp)
 742:	f022                	sd	s0,32(sp)
 744:	1800                	addi	s0,sp,48
 746:	87aa                	mv	a5,a0
 748:	fcb43823          	sd	a1,-48(s0)
 74c:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 750:	fdc42783          	lw	a5,-36(s0)
 754:	03000593          	li	a1,48
 758:	853e                	mv	a0,a5
 75a:	00000097          	auipc	ra,0x0
 75e:	ea6080e7          	jalr	-346(ra) # 600 <putc>
  putc(fd, 'x');
 762:	fdc42783          	lw	a5,-36(s0)
 766:	07800593          	li	a1,120
 76a:	853e                	mv	a0,a5
 76c:	00000097          	auipc	ra,0x0
 770:	e94080e7          	jalr	-364(ra) # 600 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 774:	fe042623          	sw	zero,-20(s0)
 778:	a82d                	j	7b2 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77a:	fd043783          	ld	a5,-48(s0)
 77e:	93f1                	srli	a5,a5,0x3c
 780:	00001717          	auipc	a4,0x1
 784:	bf070713          	addi	a4,a4,-1040 # 1370 <digits>
 788:	97ba                	add	a5,a5,a4
 78a:	0007c703          	lbu	a4,0(a5)
 78e:	fdc42783          	lw	a5,-36(s0)
 792:	85ba                	mv	a1,a4
 794:	853e                	mv	a0,a5
 796:	00000097          	auipc	ra,0x0
 79a:	e6a080e7          	jalr	-406(ra) # 600 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 79e:	fec42783          	lw	a5,-20(s0)
 7a2:	2785                	addiw	a5,a5,1
 7a4:	fef42623          	sw	a5,-20(s0)
 7a8:	fd043783          	ld	a5,-48(s0)
 7ac:	0792                	slli	a5,a5,0x4
 7ae:	fcf43823          	sd	a5,-48(s0)
 7b2:	fec42783          	lw	a5,-20(s0)
 7b6:	873e                	mv	a4,a5
 7b8:	47bd                	li	a5,15
 7ba:	fce7f0e3          	bgeu	a5,a4,77a <printptr+0x3c>
}
 7be:	0001                	nop
 7c0:	0001                	nop
 7c2:	70a2                	ld	ra,40(sp)
 7c4:	7402                	ld	s0,32(sp)
 7c6:	6145                	addi	sp,sp,48
 7c8:	8082                	ret

00000000000007ca <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7ca:	715d                	addi	sp,sp,-80
 7cc:	e486                	sd	ra,72(sp)
 7ce:	e0a2                	sd	s0,64(sp)
 7d0:	0880                	addi	s0,sp,80
 7d2:	87aa                	mv	a5,a0
 7d4:	fcb43023          	sd	a1,-64(s0)
 7d8:	fac43c23          	sd	a2,-72(s0)
 7dc:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7e0:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7e4:	fe042223          	sw	zero,-28(s0)
 7e8:	a42d                	j	a12 <vprintf+0x248>
    c = fmt[i] & 0xff;
 7ea:	fe442783          	lw	a5,-28(s0)
 7ee:	fc043703          	ld	a4,-64(s0)
 7f2:	97ba                	add	a5,a5,a4
 7f4:	0007c783          	lbu	a5,0(a5)
 7f8:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7fc:	fe042783          	lw	a5,-32(s0)
 800:	2781                	sext.w	a5,a5
 802:	eb9d                	bnez	a5,838 <vprintf+0x6e>
      if(c == '%'){
 804:	fdc42783          	lw	a5,-36(s0)
 808:	0007871b          	sext.w	a4,a5
 80c:	02500793          	li	a5,37
 810:	00f71763          	bne	a4,a5,81e <vprintf+0x54>
        state = '%';
 814:	02500793          	li	a5,37
 818:	fef42023          	sw	a5,-32(s0)
 81c:	a2f5                	j	a08 <vprintf+0x23e>
      } else {
        putc(fd, c);
 81e:	fdc42783          	lw	a5,-36(s0)
 822:	0ff7f713          	zext.b	a4,a5
 826:	fcc42783          	lw	a5,-52(s0)
 82a:	85ba                	mv	a1,a4
 82c:	853e                	mv	a0,a5
 82e:	00000097          	auipc	ra,0x0
 832:	dd2080e7          	jalr	-558(ra) # 600 <putc>
 836:	aac9                	j	a08 <vprintf+0x23e>
      }
    } else if(state == '%'){
 838:	fe042783          	lw	a5,-32(s0)
 83c:	0007871b          	sext.w	a4,a5
 840:	02500793          	li	a5,37
 844:	1cf71263          	bne	a4,a5,a08 <vprintf+0x23e>
      if(c == 'd'){
 848:	fdc42783          	lw	a5,-36(s0)
 84c:	0007871b          	sext.w	a4,a5
 850:	06400793          	li	a5,100
 854:	02f71463          	bne	a4,a5,87c <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 858:	fb843783          	ld	a5,-72(s0)
 85c:	00878713          	addi	a4,a5,8
 860:	fae43c23          	sd	a4,-72(s0)
 864:	4398                	lw	a4,0(a5)
 866:	fcc42783          	lw	a5,-52(s0)
 86a:	4685                	li	a3,1
 86c:	4629                	li	a2,10
 86e:	85ba                	mv	a1,a4
 870:	853e                	mv	a0,a5
 872:	00000097          	auipc	ra,0x0
 876:	dc4080e7          	jalr	-572(ra) # 636 <printint>
 87a:	a269                	j	a04 <vprintf+0x23a>
      } else if(c == 'l') {
 87c:	fdc42783          	lw	a5,-36(s0)
 880:	0007871b          	sext.w	a4,a5
 884:	06c00793          	li	a5,108
 888:	02f71663          	bne	a4,a5,8b4 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 88c:	fb843783          	ld	a5,-72(s0)
 890:	00878713          	addi	a4,a5,8
 894:	fae43c23          	sd	a4,-72(s0)
 898:	639c                	ld	a5,0(a5)
 89a:	0007871b          	sext.w	a4,a5
 89e:	fcc42783          	lw	a5,-52(s0)
 8a2:	4681                	li	a3,0
 8a4:	4629                	li	a2,10
 8a6:	85ba                	mv	a1,a4
 8a8:	853e                	mv	a0,a5
 8aa:	00000097          	auipc	ra,0x0
 8ae:	d8c080e7          	jalr	-628(ra) # 636 <printint>
 8b2:	aa89                	j	a04 <vprintf+0x23a>
      } else if(c == 'x') {
 8b4:	fdc42783          	lw	a5,-36(s0)
 8b8:	0007871b          	sext.w	a4,a5
 8bc:	07800793          	li	a5,120
 8c0:	02f71463          	bne	a4,a5,8e8 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8c4:	fb843783          	ld	a5,-72(s0)
 8c8:	00878713          	addi	a4,a5,8
 8cc:	fae43c23          	sd	a4,-72(s0)
 8d0:	4398                	lw	a4,0(a5)
 8d2:	fcc42783          	lw	a5,-52(s0)
 8d6:	4681                	li	a3,0
 8d8:	4641                	li	a2,16
 8da:	85ba                	mv	a1,a4
 8dc:	853e                	mv	a0,a5
 8de:	00000097          	auipc	ra,0x0
 8e2:	d58080e7          	jalr	-680(ra) # 636 <printint>
 8e6:	aa39                	j	a04 <vprintf+0x23a>
      } else if(c == 'p') {
 8e8:	fdc42783          	lw	a5,-36(s0)
 8ec:	0007871b          	sext.w	a4,a5
 8f0:	07000793          	li	a5,112
 8f4:	02f71263          	bne	a4,a5,918 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8f8:	fb843783          	ld	a5,-72(s0)
 8fc:	00878713          	addi	a4,a5,8
 900:	fae43c23          	sd	a4,-72(s0)
 904:	6398                	ld	a4,0(a5)
 906:	fcc42783          	lw	a5,-52(s0)
 90a:	85ba                	mv	a1,a4
 90c:	853e                	mv	a0,a5
 90e:	00000097          	auipc	ra,0x0
 912:	e30080e7          	jalr	-464(ra) # 73e <printptr>
 916:	a0fd                	j	a04 <vprintf+0x23a>
      } else if(c == 's'){
 918:	fdc42783          	lw	a5,-36(s0)
 91c:	0007871b          	sext.w	a4,a5
 920:	07300793          	li	a5,115
 924:	04f71c63          	bne	a4,a5,97c <vprintf+0x1b2>
        s = va_arg(ap, char*);
 928:	fb843783          	ld	a5,-72(s0)
 92c:	00878713          	addi	a4,a5,8
 930:	fae43c23          	sd	a4,-72(s0)
 934:	639c                	ld	a5,0(a5)
 936:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 93a:	fe843783          	ld	a5,-24(s0)
 93e:	eb8d                	bnez	a5,970 <vprintf+0x1a6>
          s = "(null)";
 940:	00000797          	auipc	a5,0x0
 944:	4b878793          	addi	a5,a5,1208 # df8 <malloc+0x17e>
 948:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 94c:	a015                	j	970 <vprintf+0x1a6>
          putc(fd, *s);
 94e:	fe843783          	ld	a5,-24(s0)
 952:	0007c703          	lbu	a4,0(a5)
 956:	fcc42783          	lw	a5,-52(s0)
 95a:	85ba                	mv	a1,a4
 95c:	853e                	mv	a0,a5
 95e:	00000097          	auipc	ra,0x0
 962:	ca2080e7          	jalr	-862(ra) # 600 <putc>
          s++;
 966:	fe843783          	ld	a5,-24(s0)
 96a:	0785                	addi	a5,a5,1
 96c:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 970:	fe843783          	ld	a5,-24(s0)
 974:	0007c783          	lbu	a5,0(a5)
 978:	fbf9                	bnez	a5,94e <vprintf+0x184>
 97a:	a069                	j	a04 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 97c:	fdc42783          	lw	a5,-36(s0)
 980:	0007871b          	sext.w	a4,a5
 984:	06300793          	li	a5,99
 988:	02f71463          	bne	a4,a5,9b0 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 98c:	fb843783          	ld	a5,-72(s0)
 990:	00878713          	addi	a4,a5,8
 994:	fae43c23          	sd	a4,-72(s0)
 998:	439c                	lw	a5,0(a5)
 99a:	0ff7f713          	zext.b	a4,a5
 99e:	fcc42783          	lw	a5,-52(s0)
 9a2:	85ba                	mv	a1,a4
 9a4:	853e                	mv	a0,a5
 9a6:	00000097          	auipc	ra,0x0
 9aa:	c5a080e7          	jalr	-934(ra) # 600 <putc>
 9ae:	a899                	j	a04 <vprintf+0x23a>
      } else if(c == '%'){
 9b0:	fdc42783          	lw	a5,-36(s0)
 9b4:	0007871b          	sext.w	a4,a5
 9b8:	02500793          	li	a5,37
 9bc:	00f71f63          	bne	a4,a5,9da <vprintf+0x210>
        putc(fd, c);
 9c0:	fdc42783          	lw	a5,-36(s0)
 9c4:	0ff7f713          	zext.b	a4,a5
 9c8:	fcc42783          	lw	a5,-52(s0)
 9cc:	85ba                	mv	a1,a4
 9ce:	853e                	mv	a0,a5
 9d0:	00000097          	auipc	ra,0x0
 9d4:	c30080e7          	jalr	-976(ra) # 600 <putc>
 9d8:	a035                	j	a04 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9da:	fcc42783          	lw	a5,-52(s0)
 9de:	02500593          	li	a1,37
 9e2:	853e                	mv	a0,a5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	c1c080e7          	jalr	-996(ra) # 600 <putc>
        putc(fd, c);
 9ec:	fdc42783          	lw	a5,-36(s0)
 9f0:	0ff7f713          	zext.b	a4,a5
 9f4:	fcc42783          	lw	a5,-52(s0)
 9f8:	85ba                	mv	a1,a4
 9fa:	853e                	mv	a0,a5
 9fc:	00000097          	auipc	ra,0x0
 a00:	c04080e7          	jalr	-1020(ra) # 600 <putc>
      }
      state = 0;
 a04:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a08:	fe442783          	lw	a5,-28(s0)
 a0c:	2785                	addiw	a5,a5,1
 a0e:	fef42223          	sw	a5,-28(s0)
 a12:	fe442783          	lw	a5,-28(s0)
 a16:	fc043703          	ld	a4,-64(s0)
 a1a:	97ba                	add	a5,a5,a4
 a1c:	0007c783          	lbu	a5,0(a5)
 a20:	dc0795e3          	bnez	a5,7ea <vprintf+0x20>
    }
  }
}
 a24:	0001                	nop
 a26:	0001                	nop
 a28:	60a6                	ld	ra,72(sp)
 a2a:	6406                	ld	s0,64(sp)
 a2c:	6161                	addi	sp,sp,80
 a2e:	8082                	ret

0000000000000a30 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a30:	7159                	addi	sp,sp,-112
 a32:	fc06                	sd	ra,56(sp)
 a34:	f822                	sd	s0,48(sp)
 a36:	0080                	addi	s0,sp,64
 a38:	fcb43823          	sd	a1,-48(s0)
 a3c:	e010                	sd	a2,0(s0)
 a3e:	e414                	sd	a3,8(s0)
 a40:	e818                	sd	a4,16(s0)
 a42:	ec1c                	sd	a5,24(s0)
 a44:	03043023          	sd	a6,32(s0)
 a48:	03143423          	sd	a7,40(s0)
 a4c:	87aa                	mv	a5,a0
 a4e:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a52:	03040793          	addi	a5,s0,48
 a56:	fcf43423          	sd	a5,-56(s0)
 a5a:	fc843783          	ld	a5,-56(s0)
 a5e:	fd078793          	addi	a5,a5,-48
 a62:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a66:	fe843703          	ld	a4,-24(s0)
 a6a:	fdc42783          	lw	a5,-36(s0)
 a6e:	863a                	mv	a2,a4
 a70:	fd043583          	ld	a1,-48(s0)
 a74:	853e                	mv	a0,a5
 a76:	00000097          	auipc	ra,0x0
 a7a:	d54080e7          	jalr	-684(ra) # 7ca <vprintf>
}
 a7e:	0001                	nop
 a80:	70e2                	ld	ra,56(sp)
 a82:	7442                	ld	s0,48(sp)
 a84:	6165                	addi	sp,sp,112
 a86:	8082                	ret

0000000000000a88 <printf>:

void
printf(const char *fmt, ...)
{
 a88:	7159                	addi	sp,sp,-112
 a8a:	f406                	sd	ra,40(sp)
 a8c:	f022                	sd	s0,32(sp)
 a8e:	1800                	addi	s0,sp,48
 a90:	fca43c23          	sd	a0,-40(s0)
 a94:	e40c                	sd	a1,8(s0)
 a96:	e810                	sd	a2,16(s0)
 a98:	ec14                	sd	a3,24(s0)
 a9a:	f018                	sd	a4,32(s0)
 a9c:	f41c                	sd	a5,40(s0)
 a9e:	03043823          	sd	a6,48(s0)
 aa2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aa6:	04040793          	addi	a5,s0,64
 aaa:	fcf43823          	sd	a5,-48(s0)
 aae:	fd043783          	ld	a5,-48(s0)
 ab2:	fc878793          	addi	a5,a5,-56
 ab6:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 aba:	fe843783          	ld	a5,-24(s0)
 abe:	863e                	mv	a2,a5
 ac0:	fd843583          	ld	a1,-40(s0)
 ac4:	4505                	li	a0,1
 ac6:	00000097          	auipc	ra,0x0
 aca:	d04080e7          	jalr	-764(ra) # 7ca <vprintf>
}
 ace:	0001                	nop
 ad0:	70a2                	ld	ra,40(sp)
 ad2:	7402                	ld	s0,32(sp)
 ad4:	6165                	addi	sp,sp,112
 ad6:	8082                	ret

0000000000000ad8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad8:	7179                	addi	sp,sp,-48
 ada:	f422                	sd	s0,40(sp)
 adc:	1800                	addi	s0,sp,48
 ade:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ae2:	fd843783          	ld	a5,-40(s0)
 ae6:	17c1                	addi	a5,a5,-16
 ae8:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aec:	00001797          	auipc	a5,0x1
 af0:	8b478793          	addi	a5,a5,-1868 # 13a0 <freep>
 af4:	639c                	ld	a5,0(a5)
 af6:	fef43423          	sd	a5,-24(s0)
 afa:	a815                	j	b2e <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 afc:	fe843783          	ld	a5,-24(s0)
 b00:	639c                	ld	a5,0(a5)
 b02:	fe843703          	ld	a4,-24(s0)
 b06:	00f76f63          	bltu	a4,a5,b24 <free+0x4c>
 b0a:	fe043703          	ld	a4,-32(s0)
 b0e:	fe843783          	ld	a5,-24(s0)
 b12:	02e7eb63          	bltu	a5,a4,b48 <free+0x70>
 b16:	fe843783          	ld	a5,-24(s0)
 b1a:	639c                	ld	a5,0(a5)
 b1c:	fe043703          	ld	a4,-32(s0)
 b20:	02f76463          	bltu	a4,a5,b48 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b24:	fe843783          	ld	a5,-24(s0)
 b28:	639c                	ld	a5,0(a5)
 b2a:	fef43423          	sd	a5,-24(s0)
 b2e:	fe043703          	ld	a4,-32(s0)
 b32:	fe843783          	ld	a5,-24(s0)
 b36:	fce7f3e3          	bgeu	a5,a4,afc <free+0x24>
 b3a:	fe843783          	ld	a5,-24(s0)
 b3e:	639c                	ld	a5,0(a5)
 b40:	fe043703          	ld	a4,-32(s0)
 b44:	faf77ce3          	bgeu	a4,a5,afc <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b48:	fe043783          	ld	a5,-32(s0)
 b4c:	479c                	lw	a5,8(a5)
 b4e:	1782                	slli	a5,a5,0x20
 b50:	9381                	srli	a5,a5,0x20
 b52:	0792                	slli	a5,a5,0x4
 b54:	fe043703          	ld	a4,-32(s0)
 b58:	973e                	add	a4,a4,a5
 b5a:	fe843783          	ld	a5,-24(s0)
 b5e:	639c                	ld	a5,0(a5)
 b60:	02f71763          	bne	a4,a5,b8e <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b64:	fe043783          	ld	a5,-32(s0)
 b68:	4798                	lw	a4,8(a5)
 b6a:	fe843783          	ld	a5,-24(s0)
 b6e:	639c                	ld	a5,0(a5)
 b70:	479c                	lw	a5,8(a5)
 b72:	9fb9                	addw	a5,a5,a4
 b74:	0007871b          	sext.w	a4,a5
 b78:	fe043783          	ld	a5,-32(s0)
 b7c:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b7e:	fe843783          	ld	a5,-24(s0)
 b82:	639c                	ld	a5,0(a5)
 b84:	6398                	ld	a4,0(a5)
 b86:	fe043783          	ld	a5,-32(s0)
 b8a:	e398                	sd	a4,0(a5)
 b8c:	a039                	j	b9a <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b8e:	fe843783          	ld	a5,-24(s0)
 b92:	6398                	ld	a4,0(a5)
 b94:	fe043783          	ld	a5,-32(s0)
 b98:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b9a:	fe843783          	ld	a5,-24(s0)
 b9e:	479c                	lw	a5,8(a5)
 ba0:	1782                	slli	a5,a5,0x20
 ba2:	9381                	srli	a5,a5,0x20
 ba4:	0792                	slli	a5,a5,0x4
 ba6:	fe843703          	ld	a4,-24(s0)
 baa:	97ba                	add	a5,a5,a4
 bac:	fe043703          	ld	a4,-32(s0)
 bb0:	02f71563          	bne	a4,a5,bda <free+0x102>
    p->s.size += bp->s.size;
 bb4:	fe843783          	ld	a5,-24(s0)
 bb8:	4798                	lw	a4,8(a5)
 bba:	fe043783          	ld	a5,-32(s0)
 bbe:	479c                	lw	a5,8(a5)
 bc0:	9fb9                	addw	a5,a5,a4
 bc2:	0007871b          	sext.w	a4,a5
 bc6:	fe843783          	ld	a5,-24(s0)
 bca:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bcc:	fe043783          	ld	a5,-32(s0)
 bd0:	6398                	ld	a4,0(a5)
 bd2:	fe843783          	ld	a5,-24(s0)
 bd6:	e398                	sd	a4,0(a5)
 bd8:	a031                	j	be4 <free+0x10c>
  } else
    p->s.ptr = bp;
 bda:	fe843783          	ld	a5,-24(s0)
 bde:	fe043703          	ld	a4,-32(s0)
 be2:	e398                	sd	a4,0(a5)
  freep = p;
 be4:	00000797          	auipc	a5,0x0
 be8:	7bc78793          	addi	a5,a5,1980 # 13a0 <freep>
 bec:	fe843703          	ld	a4,-24(s0)
 bf0:	e398                	sd	a4,0(a5)
}
 bf2:	0001                	nop
 bf4:	7422                	ld	s0,40(sp)
 bf6:	6145                	addi	sp,sp,48
 bf8:	8082                	ret

0000000000000bfa <morecore>:

static Header*
morecore(uint nu)
{
 bfa:	7179                	addi	sp,sp,-48
 bfc:	f406                	sd	ra,40(sp)
 bfe:	f022                	sd	s0,32(sp)
 c00:	1800                	addi	s0,sp,48
 c02:	87aa                	mv	a5,a0
 c04:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c08:	fdc42783          	lw	a5,-36(s0)
 c0c:	0007871b          	sext.w	a4,a5
 c10:	6785                	lui	a5,0x1
 c12:	00f77563          	bgeu	a4,a5,c1c <morecore+0x22>
    nu = 4096;
 c16:	6785                	lui	a5,0x1
 c18:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c1c:	fdc42783          	lw	a5,-36(s0)
 c20:	0047979b          	slliw	a5,a5,0x4
 c24:	2781                	sext.w	a5,a5
 c26:	2781                	sext.w	a5,a5
 c28:	853e                	mv	a0,a5
 c2a:	00000097          	auipc	ra,0x0
 c2e:	9b6080e7          	jalr	-1610(ra) # 5e0 <sbrk>
 c32:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c36:	fe843703          	ld	a4,-24(s0)
 c3a:	57fd                	li	a5,-1
 c3c:	00f71463          	bne	a4,a5,c44 <morecore+0x4a>
    return 0;
 c40:	4781                	li	a5,0
 c42:	a03d                	j	c70 <morecore+0x76>
  hp = (Header*)p;
 c44:	fe843783          	ld	a5,-24(s0)
 c48:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c4c:	fe043783          	ld	a5,-32(s0)
 c50:	fdc42703          	lw	a4,-36(s0)
 c54:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c56:	fe043783          	ld	a5,-32(s0)
 c5a:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x396>
 c5c:	853e                	mv	a0,a5
 c5e:	00000097          	auipc	ra,0x0
 c62:	e7a080e7          	jalr	-390(ra) # ad8 <free>
  return freep;
 c66:	00000797          	auipc	a5,0x0
 c6a:	73a78793          	addi	a5,a5,1850 # 13a0 <freep>
 c6e:	639c                	ld	a5,0(a5)
}
 c70:	853e                	mv	a0,a5
 c72:	70a2                	ld	ra,40(sp)
 c74:	7402                	ld	s0,32(sp)
 c76:	6145                	addi	sp,sp,48
 c78:	8082                	ret

0000000000000c7a <malloc>:

void*
malloc(uint nbytes)
{
 c7a:	7139                	addi	sp,sp,-64
 c7c:	fc06                	sd	ra,56(sp)
 c7e:	f822                	sd	s0,48(sp)
 c80:	0080                	addi	s0,sp,64
 c82:	87aa                	mv	a5,a0
 c84:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c88:	fcc46783          	lwu	a5,-52(s0)
 c8c:	07bd                	addi	a5,a5,15
 c8e:	8391                	srli	a5,a5,0x4
 c90:	2781                	sext.w	a5,a5
 c92:	2785                	addiw	a5,a5,1
 c94:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c98:	00000797          	auipc	a5,0x0
 c9c:	70878793          	addi	a5,a5,1800 # 13a0 <freep>
 ca0:	639c                	ld	a5,0(a5)
 ca2:	fef43023          	sd	a5,-32(s0)
 ca6:	fe043783          	ld	a5,-32(s0)
 caa:	ef95                	bnez	a5,ce6 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 cac:	00000797          	auipc	a5,0x0
 cb0:	6e478793          	addi	a5,a5,1764 # 1390 <base>
 cb4:	fef43023          	sd	a5,-32(s0)
 cb8:	00000797          	auipc	a5,0x0
 cbc:	6e878793          	addi	a5,a5,1768 # 13a0 <freep>
 cc0:	fe043703          	ld	a4,-32(s0)
 cc4:	e398                	sd	a4,0(a5)
 cc6:	00000797          	auipc	a5,0x0
 cca:	6da78793          	addi	a5,a5,1754 # 13a0 <freep>
 cce:	6398                	ld	a4,0(a5)
 cd0:	00000797          	auipc	a5,0x0
 cd4:	6c078793          	addi	a5,a5,1728 # 1390 <base>
 cd8:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cda:	00000797          	auipc	a5,0x0
 cde:	6b678793          	addi	a5,a5,1718 # 1390 <base>
 ce2:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ce6:	fe043783          	ld	a5,-32(s0)
 cea:	639c                	ld	a5,0(a5)
 cec:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 cf0:	fe843783          	ld	a5,-24(s0)
 cf4:	4798                	lw	a4,8(a5)
 cf6:	fdc42783          	lw	a5,-36(s0)
 cfa:	2781                	sext.w	a5,a5
 cfc:	06f76763          	bltu	a4,a5,d6a <malloc+0xf0>
      if(p->s.size == nunits)
 d00:	fe843783          	ld	a5,-24(s0)
 d04:	4798                	lw	a4,8(a5)
 d06:	fdc42783          	lw	a5,-36(s0)
 d0a:	2781                	sext.w	a5,a5
 d0c:	00e79963          	bne	a5,a4,d1e <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d10:	fe843783          	ld	a5,-24(s0)
 d14:	6398                	ld	a4,0(a5)
 d16:	fe043783          	ld	a5,-32(s0)
 d1a:	e398                	sd	a4,0(a5)
 d1c:	a825                	j	d54 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d1e:	fe843783          	ld	a5,-24(s0)
 d22:	479c                	lw	a5,8(a5)
 d24:	fdc42703          	lw	a4,-36(s0)
 d28:	9f99                	subw	a5,a5,a4
 d2a:	0007871b          	sext.w	a4,a5
 d2e:	fe843783          	ld	a5,-24(s0)
 d32:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d34:	fe843783          	ld	a5,-24(s0)
 d38:	479c                	lw	a5,8(a5)
 d3a:	1782                	slli	a5,a5,0x20
 d3c:	9381                	srli	a5,a5,0x20
 d3e:	0792                	slli	a5,a5,0x4
 d40:	fe843703          	ld	a4,-24(s0)
 d44:	97ba                	add	a5,a5,a4
 d46:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d4a:	fe843783          	ld	a5,-24(s0)
 d4e:	fdc42703          	lw	a4,-36(s0)
 d52:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d54:	00000797          	auipc	a5,0x0
 d58:	64c78793          	addi	a5,a5,1612 # 13a0 <freep>
 d5c:	fe043703          	ld	a4,-32(s0)
 d60:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d62:	fe843783          	ld	a5,-24(s0)
 d66:	07c1                	addi	a5,a5,16
 d68:	a091                	j	dac <malloc+0x132>
    }
    if(p == freep)
 d6a:	00000797          	auipc	a5,0x0
 d6e:	63678793          	addi	a5,a5,1590 # 13a0 <freep>
 d72:	639c                	ld	a5,0(a5)
 d74:	fe843703          	ld	a4,-24(s0)
 d78:	02f71063          	bne	a4,a5,d98 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d7c:	fdc42783          	lw	a5,-36(s0)
 d80:	853e                	mv	a0,a5
 d82:	00000097          	auipc	ra,0x0
 d86:	e78080e7          	jalr	-392(ra) # bfa <morecore>
 d8a:	fea43423          	sd	a0,-24(s0)
 d8e:	fe843783          	ld	a5,-24(s0)
 d92:	e399                	bnez	a5,d98 <malloc+0x11e>
        return 0;
 d94:	4781                	li	a5,0
 d96:	a819                	j	dac <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d98:	fe843783          	ld	a5,-24(s0)
 d9c:	fef43023          	sd	a5,-32(s0)
 da0:	fe843783          	ld	a5,-24(s0)
 da4:	639c                	ld	a5,0(a5)
 da6:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 daa:	b799                	j	cf0 <malloc+0x76>
  }
}
 dac:	853e                	mv	a0,a5
 dae:	70e2                	ld	ra,56(sp)
 db0:	7442                	ld	s0,48(sp)
 db2:	6121                	addi	sp,sp,64
 db4:	8082                	ret
