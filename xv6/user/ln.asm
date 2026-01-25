
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	87aa                	mv	a5,a0
   a:	feb43023          	sd	a1,-32(s0)
   e:	fef42623          	sw	a5,-20(s0)
  if(argc != 3){
  12:	fec42783          	lw	a5,-20(s0)
  16:	0007871b          	sext.w	a4,a5
  1a:	478d                	li	a5,3
  1c:	02f70063          	beq	a4,a5,3c <main+0x3c>
    fprintf(2, "Usage: ln old new\n");
  20:	00001597          	auipc	a1,0x1
  24:	d8058593          	addi	a1,a1,-640 # da0 <malloc+0x144>
  28:	4509                	li	a0,2
  2a:	00001097          	auipc	ra,0x1
  2e:	9e8080e7          	jalr	-1560(ra) # a12 <fprintf>
    exit(1);
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	506080e7          	jalr	1286(ra) # 53a <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  3c:	fe043783          	ld	a5,-32(s0)
  40:	07a1                	addi	a5,a5,8
  42:	6398                	ld	a4,0(a5)
  44:	fe043783          	ld	a5,-32(s0)
  48:	07c1                	addi	a5,a5,16
  4a:	639c                	ld	a5,0(a5)
  4c:	85be                	mv	a1,a5
  4e:	853a                	mv	a0,a4
  50:	00000097          	auipc	ra,0x0
  54:	54a080e7          	jalr	1354(ra) # 59a <link>
  58:	87aa                	mv	a5,a0
  5a:	0207d563          	bgez	a5,84 <main+0x84>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  5e:	fe043783          	ld	a5,-32(s0)
  62:	07a1                	addi	a5,a5,8
  64:	6398                	ld	a4,0(a5)
  66:	fe043783          	ld	a5,-32(s0)
  6a:	07c1                	addi	a5,a5,16
  6c:	639c                	ld	a5,0(a5)
  6e:	86be                	mv	a3,a5
  70:	863a                	mv	a2,a4
  72:	00001597          	auipc	a1,0x1
  76:	d4658593          	addi	a1,a1,-698 # db8 <malloc+0x15c>
  7a:	4509                	li	a0,2
  7c:	00001097          	auipc	ra,0x1
  80:	996080e7          	jalr	-1642(ra) # a12 <fprintf>
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

00000000000005da <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 5da:	48d9                	li	a7,22
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e2:	1101                	addi	sp,sp,-32
 5e4:	ec06                	sd	ra,24(sp)
 5e6:	e822                	sd	s0,16(sp)
 5e8:	1000                	addi	s0,sp,32
 5ea:	87aa                	mv	a5,a0
 5ec:	872e                	mv	a4,a1
 5ee:	fef42623          	sw	a5,-20(s0)
 5f2:	87ba                	mv	a5,a4
 5f4:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 5f8:	feb40713          	addi	a4,s0,-21
 5fc:	fec42783          	lw	a5,-20(s0)
 600:	4605                	li	a2,1
 602:	85ba                	mv	a1,a4
 604:	853e                	mv	a0,a5
 606:	00000097          	auipc	ra,0x0
 60a:	f54080e7          	jalr	-172(ra) # 55a <write>
}
 60e:	0001                	nop
 610:	60e2                	ld	ra,24(sp)
 612:	6442                	ld	s0,16(sp)
 614:	6105                	addi	sp,sp,32
 616:	8082                	ret

0000000000000618 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 618:	7139                	addi	sp,sp,-64
 61a:	fc06                	sd	ra,56(sp)
 61c:	f822                	sd	s0,48(sp)
 61e:	0080                	addi	s0,sp,64
 620:	87aa                	mv	a5,a0
 622:	8736                	mv	a4,a3
 624:	fcf42623          	sw	a5,-52(s0)
 628:	87ae                	mv	a5,a1
 62a:	fcf42423          	sw	a5,-56(s0)
 62e:	87b2                	mv	a5,a2
 630:	fcf42223          	sw	a5,-60(s0)
 634:	87ba                	mv	a5,a4
 636:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 63a:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 63e:	fc042783          	lw	a5,-64(s0)
 642:	2781                	sext.w	a5,a5
 644:	c38d                	beqz	a5,666 <printint+0x4e>
 646:	fc842783          	lw	a5,-56(s0)
 64a:	2781                	sext.w	a5,a5
 64c:	0007dd63          	bgez	a5,666 <printint+0x4e>
    neg = 1;
 650:	4785                	li	a5,1
 652:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 656:	fc842783          	lw	a5,-56(s0)
 65a:	40f007bb          	negw	a5,a5
 65e:	2781                	sext.w	a5,a5
 660:	fef42223          	sw	a5,-28(s0)
 664:	a029                	j	66e <printint+0x56>
  } else {
    x = xx;
 666:	fc842783          	lw	a5,-56(s0)
 66a:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 66e:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 672:	fc442783          	lw	a5,-60(s0)
 676:	fe442703          	lw	a4,-28(s0)
 67a:	02f777bb          	remuw	a5,a4,a5
 67e:	0007861b          	sext.w	a2,a5
 682:	fec42783          	lw	a5,-20(s0)
 686:	0017871b          	addiw	a4,a5,1
 68a:	fee42623          	sw	a4,-20(s0)
 68e:	00001697          	auipc	a3,0x1
 692:	ce268693          	addi	a3,a3,-798 # 1370 <digits>
 696:	02061713          	slli	a4,a2,0x20
 69a:	9301                	srli	a4,a4,0x20
 69c:	9736                	add	a4,a4,a3
 69e:	00074703          	lbu	a4,0(a4)
 6a2:	17c1                	addi	a5,a5,-16
 6a4:	97a2                	add	a5,a5,s0
 6a6:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 6aa:	fc442783          	lw	a5,-60(s0)
 6ae:	fe442703          	lw	a4,-28(s0)
 6b2:	02f757bb          	divuw	a5,a4,a5
 6b6:	fef42223          	sw	a5,-28(s0)
 6ba:	fe442783          	lw	a5,-28(s0)
 6be:	2781                	sext.w	a5,a5
 6c0:	fbcd                	bnez	a5,672 <printint+0x5a>
  if(neg)
 6c2:	fe842783          	lw	a5,-24(s0)
 6c6:	2781                	sext.w	a5,a5
 6c8:	cf85                	beqz	a5,700 <printint+0xe8>
    buf[i++] = '-';
 6ca:	fec42783          	lw	a5,-20(s0)
 6ce:	0017871b          	addiw	a4,a5,1
 6d2:	fee42623          	sw	a4,-20(s0)
 6d6:	17c1                	addi	a5,a5,-16
 6d8:	97a2                	add	a5,a5,s0
 6da:	02d00713          	li	a4,45
 6de:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 6e2:	a839                	j	700 <printint+0xe8>
    putc(fd, buf[i]);
 6e4:	fec42783          	lw	a5,-20(s0)
 6e8:	17c1                	addi	a5,a5,-16
 6ea:	97a2                	add	a5,a5,s0
 6ec:	fe07c703          	lbu	a4,-32(a5)
 6f0:	fcc42783          	lw	a5,-52(s0)
 6f4:	85ba                	mv	a1,a4
 6f6:	853e                	mv	a0,a5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	eea080e7          	jalr	-278(ra) # 5e2 <putc>
  while(--i >= 0)
 700:	fec42783          	lw	a5,-20(s0)
 704:	37fd                	addiw	a5,a5,-1
 706:	fef42623          	sw	a5,-20(s0)
 70a:	fec42783          	lw	a5,-20(s0)
 70e:	2781                	sext.w	a5,a5
 710:	fc07dae3          	bgez	a5,6e4 <printint+0xcc>
}
 714:	0001                	nop
 716:	0001                	nop
 718:	70e2                	ld	ra,56(sp)
 71a:	7442                	ld	s0,48(sp)
 71c:	6121                	addi	sp,sp,64
 71e:	8082                	ret

0000000000000720 <printptr>:

static void
printptr(int fd, uint64 x) {
 720:	7179                	addi	sp,sp,-48
 722:	f406                	sd	ra,40(sp)
 724:	f022                	sd	s0,32(sp)
 726:	1800                	addi	s0,sp,48
 728:	87aa                	mv	a5,a0
 72a:	fcb43823          	sd	a1,-48(s0)
 72e:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 732:	fdc42783          	lw	a5,-36(s0)
 736:	03000593          	li	a1,48
 73a:	853e                	mv	a0,a5
 73c:	00000097          	auipc	ra,0x0
 740:	ea6080e7          	jalr	-346(ra) # 5e2 <putc>
  putc(fd, 'x');
 744:	fdc42783          	lw	a5,-36(s0)
 748:	07800593          	li	a1,120
 74c:	853e                	mv	a0,a5
 74e:	00000097          	auipc	ra,0x0
 752:	e94080e7          	jalr	-364(ra) # 5e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 756:	fe042623          	sw	zero,-20(s0)
 75a:	a82d                	j	794 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75c:	fd043783          	ld	a5,-48(s0)
 760:	93f1                	srli	a5,a5,0x3c
 762:	00001717          	auipc	a4,0x1
 766:	c0e70713          	addi	a4,a4,-1010 # 1370 <digits>
 76a:	97ba                	add	a5,a5,a4
 76c:	0007c703          	lbu	a4,0(a5)
 770:	fdc42783          	lw	a5,-36(s0)
 774:	85ba                	mv	a1,a4
 776:	853e                	mv	a0,a5
 778:	00000097          	auipc	ra,0x0
 77c:	e6a080e7          	jalr	-406(ra) # 5e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 780:	fec42783          	lw	a5,-20(s0)
 784:	2785                	addiw	a5,a5,1
 786:	fef42623          	sw	a5,-20(s0)
 78a:	fd043783          	ld	a5,-48(s0)
 78e:	0792                	slli	a5,a5,0x4
 790:	fcf43823          	sd	a5,-48(s0)
 794:	fec42783          	lw	a5,-20(s0)
 798:	873e                	mv	a4,a5
 79a:	47bd                	li	a5,15
 79c:	fce7f0e3          	bgeu	a5,a4,75c <printptr+0x3c>
}
 7a0:	0001                	nop
 7a2:	0001                	nop
 7a4:	70a2                	ld	ra,40(sp)
 7a6:	7402                	ld	s0,32(sp)
 7a8:	6145                	addi	sp,sp,48
 7aa:	8082                	ret

00000000000007ac <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7ac:	715d                	addi	sp,sp,-80
 7ae:	e486                	sd	ra,72(sp)
 7b0:	e0a2                	sd	s0,64(sp)
 7b2:	0880                	addi	s0,sp,80
 7b4:	87aa                	mv	a5,a0
 7b6:	fcb43023          	sd	a1,-64(s0)
 7ba:	fac43c23          	sd	a2,-72(s0)
 7be:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 7c2:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 7c6:	fe042223          	sw	zero,-28(s0)
 7ca:	a42d                	j	9f4 <vprintf+0x248>
    c = fmt[i] & 0xff;
 7cc:	fe442783          	lw	a5,-28(s0)
 7d0:	fc043703          	ld	a4,-64(s0)
 7d4:	97ba                	add	a5,a5,a4
 7d6:	0007c783          	lbu	a5,0(a5)
 7da:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 7de:	fe042783          	lw	a5,-32(s0)
 7e2:	2781                	sext.w	a5,a5
 7e4:	eb9d                	bnez	a5,81a <vprintf+0x6e>
      if(c == '%'){
 7e6:	fdc42783          	lw	a5,-36(s0)
 7ea:	0007871b          	sext.w	a4,a5
 7ee:	02500793          	li	a5,37
 7f2:	00f71763          	bne	a4,a5,800 <vprintf+0x54>
        state = '%';
 7f6:	02500793          	li	a5,37
 7fa:	fef42023          	sw	a5,-32(s0)
 7fe:	a2f5                	j	9ea <vprintf+0x23e>
      } else {
        putc(fd, c);
 800:	fdc42783          	lw	a5,-36(s0)
 804:	0ff7f713          	zext.b	a4,a5
 808:	fcc42783          	lw	a5,-52(s0)
 80c:	85ba                	mv	a1,a4
 80e:	853e                	mv	a0,a5
 810:	00000097          	auipc	ra,0x0
 814:	dd2080e7          	jalr	-558(ra) # 5e2 <putc>
 818:	aac9                	j	9ea <vprintf+0x23e>
      }
    } else if(state == '%'){
 81a:	fe042783          	lw	a5,-32(s0)
 81e:	0007871b          	sext.w	a4,a5
 822:	02500793          	li	a5,37
 826:	1cf71263          	bne	a4,a5,9ea <vprintf+0x23e>
      if(c == 'd'){
 82a:	fdc42783          	lw	a5,-36(s0)
 82e:	0007871b          	sext.w	a4,a5
 832:	06400793          	li	a5,100
 836:	02f71463          	bne	a4,a5,85e <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 83a:	fb843783          	ld	a5,-72(s0)
 83e:	00878713          	addi	a4,a5,8
 842:	fae43c23          	sd	a4,-72(s0)
 846:	4398                	lw	a4,0(a5)
 848:	fcc42783          	lw	a5,-52(s0)
 84c:	4685                	li	a3,1
 84e:	4629                	li	a2,10
 850:	85ba                	mv	a1,a4
 852:	853e                	mv	a0,a5
 854:	00000097          	auipc	ra,0x0
 858:	dc4080e7          	jalr	-572(ra) # 618 <printint>
 85c:	a269                	j	9e6 <vprintf+0x23a>
      } else if(c == 'l') {
 85e:	fdc42783          	lw	a5,-36(s0)
 862:	0007871b          	sext.w	a4,a5
 866:	06c00793          	li	a5,108
 86a:	02f71663          	bne	a4,a5,896 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 86e:	fb843783          	ld	a5,-72(s0)
 872:	00878713          	addi	a4,a5,8
 876:	fae43c23          	sd	a4,-72(s0)
 87a:	639c                	ld	a5,0(a5)
 87c:	0007871b          	sext.w	a4,a5
 880:	fcc42783          	lw	a5,-52(s0)
 884:	4681                	li	a3,0
 886:	4629                	li	a2,10
 888:	85ba                	mv	a1,a4
 88a:	853e                	mv	a0,a5
 88c:	00000097          	auipc	ra,0x0
 890:	d8c080e7          	jalr	-628(ra) # 618 <printint>
 894:	aa89                	j	9e6 <vprintf+0x23a>
      } else if(c == 'x') {
 896:	fdc42783          	lw	a5,-36(s0)
 89a:	0007871b          	sext.w	a4,a5
 89e:	07800793          	li	a5,120
 8a2:	02f71463          	bne	a4,a5,8ca <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 8a6:	fb843783          	ld	a5,-72(s0)
 8aa:	00878713          	addi	a4,a5,8
 8ae:	fae43c23          	sd	a4,-72(s0)
 8b2:	4398                	lw	a4,0(a5)
 8b4:	fcc42783          	lw	a5,-52(s0)
 8b8:	4681                	li	a3,0
 8ba:	4641                	li	a2,16
 8bc:	85ba                	mv	a1,a4
 8be:	853e                	mv	a0,a5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	d58080e7          	jalr	-680(ra) # 618 <printint>
 8c8:	aa39                	j	9e6 <vprintf+0x23a>
      } else if(c == 'p') {
 8ca:	fdc42783          	lw	a5,-36(s0)
 8ce:	0007871b          	sext.w	a4,a5
 8d2:	07000793          	li	a5,112
 8d6:	02f71263          	bne	a4,a5,8fa <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 8da:	fb843783          	ld	a5,-72(s0)
 8de:	00878713          	addi	a4,a5,8
 8e2:	fae43c23          	sd	a4,-72(s0)
 8e6:	6398                	ld	a4,0(a5)
 8e8:	fcc42783          	lw	a5,-52(s0)
 8ec:	85ba                	mv	a1,a4
 8ee:	853e                	mv	a0,a5
 8f0:	00000097          	auipc	ra,0x0
 8f4:	e30080e7          	jalr	-464(ra) # 720 <printptr>
 8f8:	a0fd                	j	9e6 <vprintf+0x23a>
      } else if(c == 's'){
 8fa:	fdc42783          	lw	a5,-36(s0)
 8fe:	0007871b          	sext.w	a4,a5
 902:	07300793          	li	a5,115
 906:	04f71c63          	bne	a4,a5,95e <vprintf+0x1b2>
        s = va_arg(ap, char*);
 90a:	fb843783          	ld	a5,-72(s0)
 90e:	00878713          	addi	a4,a5,8
 912:	fae43c23          	sd	a4,-72(s0)
 916:	639c                	ld	a5,0(a5)
 918:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 91c:	fe843783          	ld	a5,-24(s0)
 920:	eb8d                	bnez	a5,952 <vprintf+0x1a6>
          s = "(null)";
 922:	00000797          	auipc	a5,0x0
 926:	4ae78793          	addi	a5,a5,1198 # dd0 <malloc+0x174>
 92a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 92e:	a015                	j	952 <vprintf+0x1a6>
          putc(fd, *s);
 930:	fe843783          	ld	a5,-24(s0)
 934:	0007c703          	lbu	a4,0(a5)
 938:	fcc42783          	lw	a5,-52(s0)
 93c:	85ba                	mv	a1,a4
 93e:	853e                	mv	a0,a5
 940:	00000097          	auipc	ra,0x0
 944:	ca2080e7          	jalr	-862(ra) # 5e2 <putc>
          s++;
 948:	fe843783          	ld	a5,-24(s0)
 94c:	0785                	addi	a5,a5,1
 94e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 952:	fe843783          	ld	a5,-24(s0)
 956:	0007c783          	lbu	a5,0(a5)
 95a:	fbf9                	bnez	a5,930 <vprintf+0x184>
 95c:	a069                	j	9e6 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 95e:	fdc42783          	lw	a5,-36(s0)
 962:	0007871b          	sext.w	a4,a5
 966:	06300793          	li	a5,99
 96a:	02f71463          	bne	a4,a5,992 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 96e:	fb843783          	ld	a5,-72(s0)
 972:	00878713          	addi	a4,a5,8
 976:	fae43c23          	sd	a4,-72(s0)
 97a:	439c                	lw	a5,0(a5)
 97c:	0ff7f713          	zext.b	a4,a5
 980:	fcc42783          	lw	a5,-52(s0)
 984:	85ba                	mv	a1,a4
 986:	853e                	mv	a0,a5
 988:	00000097          	auipc	ra,0x0
 98c:	c5a080e7          	jalr	-934(ra) # 5e2 <putc>
 990:	a899                	j	9e6 <vprintf+0x23a>
      } else if(c == '%'){
 992:	fdc42783          	lw	a5,-36(s0)
 996:	0007871b          	sext.w	a4,a5
 99a:	02500793          	li	a5,37
 99e:	00f71f63          	bne	a4,a5,9bc <vprintf+0x210>
        putc(fd, c);
 9a2:	fdc42783          	lw	a5,-36(s0)
 9a6:	0ff7f713          	zext.b	a4,a5
 9aa:	fcc42783          	lw	a5,-52(s0)
 9ae:	85ba                	mv	a1,a4
 9b0:	853e                	mv	a0,a5
 9b2:	00000097          	auipc	ra,0x0
 9b6:	c30080e7          	jalr	-976(ra) # 5e2 <putc>
 9ba:	a035                	j	9e6 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9bc:	fcc42783          	lw	a5,-52(s0)
 9c0:	02500593          	li	a1,37
 9c4:	853e                	mv	a0,a5
 9c6:	00000097          	auipc	ra,0x0
 9ca:	c1c080e7          	jalr	-996(ra) # 5e2 <putc>
        putc(fd, c);
 9ce:	fdc42783          	lw	a5,-36(s0)
 9d2:	0ff7f713          	zext.b	a4,a5
 9d6:	fcc42783          	lw	a5,-52(s0)
 9da:	85ba                	mv	a1,a4
 9dc:	853e                	mv	a0,a5
 9de:	00000097          	auipc	ra,0x0
 9e2:	c04080e7          	jalr	-1020(ra) # 5e2 <putc>
      }
      state = 0;
 9e6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 9ea:	fe442783          	lw	a5,-28(s0)
 9ee:	2785                	addiw	a5,a5,1
 9f0:	fef42223          	sw	a5,-28(s0)
 9f4:	fe442783          	lw	a5,-28(s0)
 9f8:	fc043703          	ld	a4,-64(s0)
 9fc:	97ba                	add	a5,a5,a4
 9fe:	0007c783          	lbu	a5,0(a5)
 a02:	dc0795e3          	bnez	a5,7cc <vprintf+0x20>
    }
  }
}
 a06:	0001                	nop
 a08:	0001                	nop
 a0a:	60a6                	ld	ra,72(sp)
 a0c:	6406                	ld	s0,64(sp)
 a0e:	6161                	addi	sp,sp,80
 a10:	8082                	ret

0000000000000a12 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a12:	7159                	addi	sp,sp,-112
 a14:	fc06                	sd	ra,56(sp)
 a16:	f822                	sd	s0,48(sp)
 a18:	0080                	addi	s0,sp,64
 a1a:	fcb43823          	sd	a1,-48(s0)
 a1e:	e010                	sd	a2,0(s0)
 a20:	e414                	sd	a3,8(s0)
 a22:	e818                	sd	a4,16(s0)
 a24:	ec1c                	sd	a5,24(s0)
 a26:	03043023          	sd	a6,32(s0)
 a2a:	03143423          	sd	a7,40(s0)
 a2e:	87aa                	mv	a5,a0
 a30:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 a34:	03040793          	addi	a5,s0,48
 a38:	fcf43423          	sd	a5,-56(s0)
 a3c:	fc843783          	ld	a5,-56(s0)
 a40:	fd078793          	addi	a5,a5,-48
 a44:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 a48:	fe843703          	ld	a4,-24(s0)
 a4c:	fdc42783          	lw	a5,-36(s0)
 a50:	863a                	mv	a2,a4
 a52:	fd043583          	ld	a1,-48(s0)
 a56:	853e                	mv	a0,a5
 a58:	00000097          	auipc	ra,0x0
 a5c:	d54080e7          	jalr	-684(ra) # 7ac <vprintf>
}
 a60:	0001                	nop
 a62:	70e2                	ld	ra,56(sp)
 a64:	7442                	ld	s0,48(sp)
 a66:	6165                	addi	sp,sp,112
 a68:	8082                	ret

0000000000000a6a <printf>:

void
printf(const char *fmt, ...)
{
 a6a:	7159                	addi	sp,sp,-112
 a6c:	f406                	sd	ra,40(sp)
 a6e:	f022                	sd	s0,32(sp)
 a70:	1800                	addi	s0,sp,48
 a72:	fca43c23          	sd	a0,-40(s0)
 a76:	e40c                	sd	a1,8(s0)
 a78:	e810                	sd	a2,16(s0)
 a7a:	ec14                	sd	a3,24(s0)
 a7c:	f018                	sd	a4,32(s0)
 a7e:	f41c                	sd	a5,40(s0)
 a80:	03043823          	sd	a6,48(s0)
 a84:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a88:	04040793          	addi	a5,s0,64
 a8c:	fcf43823          	sd	a5,-48(s0)
 a90:	fd043783          	ld	a5,-48(s0)
 a94:	fc878793          	addi	a5,a5,-56
 a98:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 a9c:	fe843783          	ld	a5,-24(s0)
 aa0:	863e                	mv	a2,a5
 aa2:	fd843583          	ld	a1,-40(s0)
 aa6:	4505                	li	a0,1
 aa8:	00000097          	auipc	ra,0x0
 aac:	d04080e7          	jalr	-764(ra) # 7ac <vprintf>
}
 ab0:	0001                	nop
 ab2:	70a2                	ld	ra,40(sp)
 ab4:	7402                	ld	s0,32(sp)
 ab6:	6165                	addi	sp,sp,112
 ab8:	8082                	ret

0000000000000aba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aba:	7179                	addi	sp,sp,-48
 abc:	f422                	sd	s0,40(sp)
 abe:	1800                	addi	s0,sp,48
 ac0:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ac4:	fd843783          	ld	a5,-40(s0)
 ac8:	17c1                	addi	a5,a5,-16
 aca:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ace:	00001797          	auipc	a5,0x1
 ad2:	8d278793          	addi	a5,a5,-1838 # 13a0 <freep>
 ad6:	639c                	ld	a5,0(a5)
 ad8:	fef43423          	sd	a5,-24(s0)
 adc:	a815                	j	b10 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ade:	fe843783          	ld	a5,-24(s0)
 ae2:	639c                	ld	a5,0(a5)
 ae4:	fe843703          	ld	a4,-24(s0)
 ae8:	00f76f63          	bltu	a4,a5,b06 <free+0x4c>
 aec:	fe043703          	ld	a4,-32(s0)
 af0:	fe843783          	ld	a5,-24(s0)
 af4:	02e7eb63          	bltu	a5,a4,b2a <free+0x70>
 af8:	fe843783          	ld	a5,-24(s0)
 afc:	639c                	ld	a5,0(a5)
 afe:	fe043703          	ld	a4,-32(s0)
 b02:	02f76463          	bltu	a4,a5,b2a <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b06:	fe843783          	ld	a5,-24(s0)
 b0a:	639c                	ld	a5,0(a5)
 b0c:	fef43423          	sd	a5,-24(s0)
 b10:	fe043703          	ld	a4,-32(s0)
 b14:	fe843783          	ld	a5,-24(s0)
 b18:	fce7f3e3          	bgeu	a5,a4,ade <free+0x24>
 b1c:	fe843783          	ld	a5,-24(s0)
 b20:	639c                	ld	a5,0(a5)
 b22:	fe043703          	ld	a4,-32(s0)
 b26:	faf77ce3          	bgeu	a4,a5,ade <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b2a:	fe043783          	ld	a5,-32(s0)
 b2e:	479c                	lw	a5,8(a5)
 b30:	1782                	slli	a5,a5,0x20
 b32:	9381                	srli	a5,a5,0x20
 b34:	0792                	slli	a5,a5,0x4
 b36:	fe043703          	ld	a4,-32(s0)
 b3a:	973e                	add	a4,a4,a5
 b3c:	fe843783          	ld	a5,-24(s0)
 b40:	639c                	ld	a5,0(a5)
 b42:	02f71763          	bne	a4,a5,b70 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 b46:	fe043783          	ld	a5,-32(s0)
 b4a:	4798                	lw	a4,8(a5)
 b4c:	fe843783          	ld	a5,-24(s0)
 b50:	639c                	ld	a5,0(a5)
 b52:	479c                	lw	a5,8(a5)
 b54:	9fb9                	addw	a5,a5,a4
 b56:	0007871b          	sext.w	a4,a5
 b5a:	fe043783          	ld	a5,-32(s0)
 b5e:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 b60:	fe843783          	ld	a5,-24(s0)
 b64:	639c                	ld	a5,0(a5)
 b66:	6398                	ld	a4,0(a5)
 b68:	fe043783          	ld	a5,-32(s0)
 b6c:	e398                	sd	a4,0(a5)
 b6e:	a039                	j	b7c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 b70:	fe843783          	ld	a5,-24(s0)
 b74:	6398                	ld	a4,0(a5)
 b76:	fe043783          	ld	a5,-32(s0)
 b7a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 b7c:	fe843783          	ld	a5,-24(s0)
 b80:	479c                	lw	a5,8(a5)
 b82:	1782                	slli	a5,a5,0x20
 b84:	9381                	srli	a5,a5,0x20
 b86:	0792                	slli	a5,a5,0x4
 b88:	fe843703          	ld	a4,-24(s0)
 b8c:	97ba                	add	a5,a5,a4
 b8e:	fe043703          	ld	a4,-32(s0)
 b92:	02f71563          	bne	a4,a5,bbc <free+0x102>
    p->s.size += bp->s.size;
 b96:	fe843783          	ld	a5,-24(s0)
 b9a:	4798                	lw	a4,8(a5)
 b9c:	fe043783          	ld	a5,-32(s0)
 ba0:	479c                	lw	a5,8(a5)
 ba2:	9fb9                	addw	a5,a5,a4
 ba4:	0007871b          	sext.w	a4,a5
 ba8:	fe843783          	ld	a5,-24(s0)
 bac:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bae:	fe043783          	ld	a5,-32(s0)
 bb2:	6398                	ld	a4,0(a5)
 bb4:	fe843783          	ld	a5,-24(s0)
 bb8:	e398                	sd	a4,0(a5)
 bba:	a031                	j	bc6 <free+0x10c>
  } else
    p->s.ptr = bp;
 bbc:	fe843783          	ld	a5,-24(s0)
 bc0:	fe043703          	ld	a4,-32(s0)
 bc4:	e398                	sd	a4,0(a5)
  freep = p;
 bc6:	00000797          	auipc	a5,0x0
 bca:	7da78793          	addi	a5,a5,2010 # 13a0 <freep>
 bce:	fe843703          	ld	a4,-24(s0)
 bd2:	e398                	sd	a4,0(a5)
}
 bd4:	0001                	nop
 bd6:	7422                	ld	s0,40(sp)
 bd8:	6145                	addi	sp,sp,48
 bda:	8082                	ret

0000000000000bdc <morecore>:

static Header*
morecore(uint nu)
{
 bdc:	7179                	addi	sp,sp,-48
 bde:	f406                	sd	ra,40(sp)
 be0:	f022                	sd	s0,32(sp)
 be2:	1800                	addi	s0,sp,48
 be4:	87aa                	mv	a5,a0
 be6:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 bea:	fdc42783          	lw	a5,-36(s0)
 bee:	0007871b          	sext.w	a4,a5
 bf2:	6785                	lui	a5,0x1
 bf4:	00f77563          	bgeu	a4,a5,bfe <morecore+0x22>
    nu = 4096;
 bf8:	6785                	lui	a5,0x1
 bfa:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 bfe:	fdc42783          	lw	a5,-36(s0)
 c02:	0047979b          	slliw	a5,a5,0x4
 c06:	2781                	sext.w	a5,a5
 c08:	2781                	sext.w	a5,a5
 c0a:	853e                	mv	a0,a5
 c0c:	00000097          	auipc	ra,0x0
 c10:	9b6080e7          	jalr	-1610(ra) # 5c2 <sbrk>
 c14:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 c18:	fe843703          	ld	a4,-24(s0)
 c1c:	57fd                	li	a5,-1
 c1e:	00f71463          	bne	a4,a5,c26 <morecore+0x4a>
    return 0;
 c22:	4781                	li	a5,0
 c24:	a03d                	j	c52 <morecore+0x76>
  hp = (Header*)p;
 c26:	fe843783          	ld	a5,-24(s0)
 c2a:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 c2e:	fe043783          	ld	a5,-32(s0)
 c32:	fdc42703          	lw	a4,-36(s0)
 c36:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 c38:	fe043783          	ld	a5,-32(s0)
 c3c:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x3b4>
 c3e:	853e                	mv	a0,a5
 c40:	00000097          	auipc	ra,0x0
 c44:	e7a080e7          	jalr	-390(ra) # aba <free>
  return freep;
 c48:	00000797          	auipc	a5,0x0
 c4c:	75878793          	addi	a5,a5,1880 # 13a0 <freep>
 c50:	639c                	ld	a5,0(a5)
}
 c52:	853e                	mv	a0,a5
 c54:	70a2                	ld	ra,40(sp)
 c56:	7402                	ld	s0,32(sp)
 c58:	6145                	addi	sp,sp,48
 c5a:	8082                	ret

0000000000000c5c <malloc>:

void*
malloc(uint nbytes)
{
 c5c:	7139                	addi	sp,sp,-64
 c5e:	fc06                	sd	ra,56(sp)
 c60:	f822                	sd	s0,48(sp)
 c62:	0080                	addi	s0,sp,64
 c64:	87aa                	mv	a5,a0
 c66:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c6a:	fcc46783          	lwu	a5,-52(s0)
 c6e:	07bd                	addi	a5,a5,15
 c70:	8391                	srli	a5,a5,0x4
 c72:	2781                	sext.w	a5,a5
 c74:	2785                	addiw	a5,a5,1
 c76:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 c7a:	00000797          	auipc	a5,0x0
 c7e:	72678793          	addi	a5,a5,1830 # 13a0 <freep>
 c82:	639c                	ld	a5,0(a5)
 c84:	fef43023          	sd	a5,-32(s0)
 c88:	fe043783          	ld	a5,-32(s0)
 c8c:	ef95                	bnez	a5,cc8 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 c8e:	00000797          	auipc	a5,0x0
 c92:	70278793          	addi	a5,a5,1794 # 1390 <base>
 c96:	fef43023          	sd	a5,-32(s0)
 c9a:	00000797          	auipc	a5,0x0
 c9e:	70678793          	addi	a5,a5,1798 # 13a0 <freep>
 ca2:	fe043703          	ld	a4,-32(s0)
 ca6:	e398                	sd	a4,0(a5)
 ca8:	00000797          	auipc	a5,0x0
 cac:	6f878793          	addi	a5,a5,1784 # 13a0 <freep>
 cb0:	6398                	ld	a4,0(a5)
 cb2:	00000797          	auipc	a5,0x0
 cb6:	6de78793          	addi	a5,a5,1758 # 1390 <base>
 cba:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 cbc:	00000797          	auipc	a5,0x0
 cc0:	6d478793          	addi	a5,a5,1748 # 1390 <base>
 cc4:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc8:	fe043783          	ld	a5,-32(s0)
 ccc:	639c                	ld	a5,0(a5)
 cce:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 cd2:	fe843783          	ld	a5,-24(s0)
 cd6:	4798                	lw	a4,8(a5)
 cd8:	fdc42783          	lw	a5,-36(s0)
 cdc:	2781                	sext.w	a5,a5
 cde:	06f76763          	bltu	a4,a5,d4c <malloc+0xf0>
      if(p->s.size == nunits)
 ce2:	fe843783          	ld	a5,-24(s0)
 ce6:	4798                	lw	a4,8(a5)
 ce8:	fdc42783          	lw	a5,-36(s0)
 cec:	2781                	sext.w	a5,a5
 cee:	00e79963          	bne	a5,a4,d00 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 cf2:	fe843783          	ld	a5,-24(s0)
 cf6:	6398                	ld	a4,0(a5)
 cf8:	fe043783          	ld	a5,-32(s0)
 cfc:	e398                	sd	a4,0(a5)
 cfe:	a825                	j	d36 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d00:	fe843783          	ld	a5,-24(s0)
 d04:	479c                	lw	a5,8(a5)
 d06:	fdc42703          	lw	a4,-36(s0)
 d0a:	9f99                	subw	a5,a5,a4
 d0c:	0007871b          	sext.w	a4,a5
 d10:	fe843783          	ld	a5,-24(s0)
 d14:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d16:	fe843783          	ld	a5,-24(s0)
 d1a:	479c                	lw	a5,8(a5)
 d1c:	1782                	slli	a5,a5,0x20
 d1e:	9381                	srli	a5,a5,0x20
 d20:	0792                	slli	a5,a5,0x4
 d22:	fe843703          	ld	a4,-24(s0)
 d26:	97ba                	add	a5,a5,a4
 d28:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 d2c:	fe843783          	ld	a5,-24(s0)
 d30:	fdc42703          	lw	a4,-36(s0)
 d34:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 d36:	00000797          	auipc	a5,0x0
 d3a:	66a78793          	addi	a5,a5,1642 # 13a0 <freep>
 d3e:	fe043703          	ld	a4,-32(s0)
 d42:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 d44:	fe843783          	ld	a5,-24(s0)
 d48:	07c1                	addi	a5,a5,16
 d4a:	a091                	j	d8e <malloc+0x132>
    }
    if(p == freep)
 d4c:	00000797          	auipc	a5,0x0
 d50:	65478793          	addi	a5,a5,1620 # 13a0 <freep>
 d54:	639c                	ld	a5,0(a5)
 d56:	fe843703          	ld	a4,-24(s0)
 d5a:	02f71063          	bne	a4,a5,d7a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 d5e:	fdc42783          	lw	a5,-36(s0)
 d62:	853e                	mv	a0,a5
 d64:	00000097          	auipc	ra,0x0
 d68:	e78080e7          	jalr	-392(ra) # bdc <morecore>
 d6c:	fea43423          	sd	a0,-24(s0)
 d70:	fe843783          	ld	a5,-24(s0)
 d74:	e399                	bnez	a5,d7a <malloc+0x11e>
        return 0;
 d76:	4781                	li	a5,0
 d78:	a819                	j	d8e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d7a:	fe843783          	ld	a5,-24(s0)
 d7e:	fef43023          	sd	a5,-32(s0)
 d82:	fe843783          	ld	a5,-24(s0)
 d86:	639c                	ld	a5,0(a5)
 d88:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d8c:	b799                	j	cd2 <malloc+0x76>
  }
}
 d8e:	853e                	mv	a0,a5
 d90:	70e2                	ld	ra,56(sp)
 d92:	7442                	ld	s0,48(sp)
 d94:	6121                	addi	sp,sp,64
 d96:	8082                	ret
