
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
   8:	87aa                	mv	a5,a0
   a:	fcf42e23          	sw	a5,-36(s0)
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   e:	a091                	j	52 <cat+0x52>
    if (write(1, buf, n) != n) {
  10:	fec42783          	lw	a5,-20(s0)
  14:	863e                	mv	a2,a5
  16:	00001597          	auipc	a1,0x1
  1a:	39a58593          	addi	a1,a1,922 # 13b0 <buf>
  1e:	4505                	li	a0,1
  20:	00000097          	auipc	ra,0x0
  24:	62c080e7          	jalr	1580(ra) # 64c <write>
  28:	87aa                	mv	a5,a0
  2a:	873e                	mv	a4,a5
  2c:	fec42783          	lw	a5,-20(s0)
  30:	2781                	sext.w	a5,a5
  32:	02e78063          	beq	a5,a4,52 <cat+0x52>
      fprintf(2, "cat: write error\n");
  36:	00001597          	auipc	a1,0x1
  3a:	e5a58593          	addi	a1,a1,-422 # e90 <malloc+0x14a>
  3e:	4509                	li	a0,2
  40:	00001097          	auipc	ra,0x1
  44:	abc080e7          	jalr	-1348(ra) # afc <fprintf>
      exit(1);
  48:	4505                	li	a0,1
  4a:	00000097          	auipc	ra,0x0
  4e:	5e2080e7          	jalr	1506(ra) # 62c <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  52:	fdc42783          	lw	a5,-36(s0)
  56:	20000613          	li	a2,512
  5a:	00001597          	auipc	a1,0x1
  5e:	35658593          	addi	a1,a1,854 # 13b0 <buf>
  62:	853e                	mv	a0,a5
  64:	00000097          	auipc	ra,0x0
  68:	5e0080e7          	jalr	1504(ra) # 644 <read>
  6c:	87aa                	mv	a5,a0
  6e:	fef42623          	sw	a5,-20(s0)
  72:	fec42783          	lw	a5,-20(s0)
  76:	2781                	sext.w	a5,a5
  78:	f8f04ce3          	bgtz	a5,10 <cat+0x10>
    }
  }
  if(n < 0){
  7c:	fec42783          	lw	a5,-20(s0)
  80:	2781                	sext.w	a5,a5
  82:	0207d063          	bgez	a5,a2 <cat+0xa2>
    fprintf(2, "cat: read error\n");
  86:	00001597          	auipc	a1,0x1
  8a:	e2258593          	addi	a1,a1,-478 # ea8 <malloc+0x162>
  8e:	4509                	li	a0,2
  90:	00001097          	auipc	ra,0x1
  94:	a6c080e7          	jalr	-1428(ra) # afc <fprintf>
    exit(1);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	592080e7          	jalr	1426(ra) # 62c <exit>
  }
}
  a2:	0001                	nop
  a4:	70a2                	ld	ra,40(sp)
  a6:	7402                	ld	s0,32(sp)
  a8:	6145                	addi	sp,sp,48
  aa:	8082                	ret

00000000000000ac <main>:

int
main(int argc, char *argv[])
{
  ac:	7179                	addi	sp,sp,-48
  ae:	f406                	sd	ra,40(sp)
  b0:	f022                	sd	s0,32(sp)
  b2:	1800                	addi	s0,sp,48
  b4:	87aa                	mv	a5,a0
  b6:	fcb43823          	sd	a1,-48(s0)
  ba:	fcf42e23          	sw	a5,-36(s0)
  int fd, i;

  if(argc <= 1){
  be:	fdc42783          	lw	a5,-36(s0)
  c2:	0007871b          	sext.w	a4,a5
  c6:	4785                	li	a5,1
  c8:	00e7cc63          	blt	a5,a4,e0 <main+0x34>
    cat(0);
  cc:	4501                	li	a0,0
  ce:	00000097          	auipc	ra,0x0
  d2:	f32080e7          	jalr	-206(ra) # 0 <cat>
    exit(0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	554080e7          	jalr	1364(ra) # 62c <exit>
  }

  for(i = 1; i < argc; i++){
  e0:	4785                	li	a5,1
  e2:	fef42623          	sw	a5,-20(s0)
  e6:	a8bd                	j	164 <main+0xb8>
    if((fd = open(argv[i], 0)) < 0){
  e8:	fec42783          	lw	a5,-20(s0)
  ec:	078e                	slli	a5,a5,0x3
  ee:	fd043703          	ld	a4,-48(s0)
  f2:	97ba                	add	a5,a5,a4
  f4:	639c                	ld	a5,0(a5)
  f6:	4581                	li	a1,0
  f8:	853e                	mv	a0,a5
  fa:	00000097          	auipc	ra,0x0
  fe:	572080e7          	jalr	1394(ra) # 66c <open>
 102:	87aa                	mv	a5,a0
 104:	fef42423          	sw	a5,-24(s0)
 108:	fe842783          	lw	a5,-24(s0)
 10c:	2781                	sext.w	a5,a5
 10e:	0207d863          	bgez	a5,13e <main+0x92>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 112:	fec42783          	lw	a5,-20(s0)
 116:	078e                	slli	a5,a5,0x3
 118:	fd043703          	ld	a4,-48(s0)
 11c:	97ba                	add	a5,a5,a4
 11e:	639c                	ld	a5,0(a5)
 120:	863e                	mv	a2,a5
 122:	00001597          	auipc	a1,0x1
 126:	d9e58593          	addi	a1,a1,-610 # ec0 <malloc+0x17a>
 12a:	4509                	li	a0,2
 12c:	00001097          	auipc	ra,0x1
 130:	9d0080e7          	jalr	-1584(ra) # afc <fprintf>
      exit(1);
 134:	4505                	li	a0,1
 136:	00000097          	auipc	ra,0x0
 13a:	4f6080e7          	jalr	1270(ra) # 62c <exit>
    }
    cat(fd);
 13e:	fe842783          	lw	a5,-24(s0)
 142:	853e                	mv	a0,a5
 144:	00000097          	auipc	ra,0x0
 148:	ebc080e7          	jalr	-324(ra) # 0 <cat>
    close(fd);
 14c:	fe842783          	lw	a5,-24(s0)
 150:	853e                	mv	a0,a5
 152:	00000097          	auipc	ra,0x0
 156:	502080e7          	jalr	1282(ra) # 654 <close>
  for(i = 1; i < argc; i++){
 15a:	fec42783          	lw	a5,-20(s0)
 15e:	2785                	addiw	a5,a5,1
 160:	fef42623          	sw	a5,-20(s0)
 164:	fec42783          	lw	a5,-20(s0)
 168:	873e                	mv	a4,a5
 16a:	fdc42783          	lw	a5,-36(s0)
 16e:	2701                	sext.w	a4,a4
 170:	2781                	sext.w	a5,a5
 172:	f6f74be3          	blt	a4,a5,e8 <main+0x3c>
  }
  exit(0);
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	4b4080e7          	jalr	1204(ra) # 62c <exit>

0000000000000180 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 180:	1141                	addi	sp,sp,-16
 182:	e406                	sd	ra,8(sp)
 184:	e022                	sd	s0,0(sp)
 186:	0800                	addi	s0,sp,16
  extern int main();
  main();
 188:	00000097          	auipc	ra,0x0
 18c:	f24080e7          	jalr	-220(ra) # ac <main>
  exit(0);
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	49a080e7          	jalr	1178(ra) # 62c <exit>

000000000000019a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 19a:	7179                	addi	sp,sp,-48
 19c:	f422                	sd	s0,40(sp)
 19e:	1800                	addi	s0,sp,48
 1a0:	fca43c23          	sd	a0,-40(s0)
 1a4:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 1a8:	fd843783          	ld	a5,-40(s0)
 1ac:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 1b0:	0001                	nop
 1b2:	fd043703          	ld	a4,-48(s0)
 1b6:	00170793          	addi	a5,a4,1
 1ba:	fcf43823          	sd	a5,-48(s0)
 1be:	fd843783          	ld	a5,-40(s0)
 1c2:	00178693          	addi	a3,a5,1
 1c6:	fcd43c23          	sd	a3,-40(s0)
 1ca:	00074703          	lbu	a4,0(a4)
 1ce:	00e78023          	sb	a4,0(a5)
 1d2:	0007c783          	lbu	a5,0(a5)
 1d6:	fff1                	bnez	a5,1b2 <strcpy+0x18>
    ;
  return os;
 1d8:	fe843783          	ld	a5,-24(s0)
}
 1dc:	853e                	mv	a0,a5
 1de:	7422                	ld	s0,40(sp)
 1e0:	6145                	addi	sp,sp,48
 1e2:	8082                	ret

00000000000001e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e4:	1101                	addi	sp,sp,-32
 1e6:	ec22                	sd	s0,24(sp)
 1e8:	1000                	addi	s0,sp,32
 1ea:	fea43423          	sd	a0,-24(s0)
 1ee:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 1f2:	a819                	j	208 <strcmp+0x24>
    p++, q++;
 1f4:	fe843783          	ld	a5,-24(s0)
 1f8:	0785                	addi	a5,a5,1
 1fa:	fef43423          	sd	a5,-24(s0)
 1fe:	fe043783          	ld	a5,-32(s0)
 202:	0785                	addi	a5,a5,1
 204:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 208:	fe843783          	ld	a5,-24(s0)
 20c:	0007c783          	lbu	a5,0(a5)
 210:	cb99                	beqz	a5,226 <strcmp+0x42>
 212:	fe843783          	ld	a5,-24(s0)
 216:	0007c703          	lbu	a4,0(a5)
 21a:	fe043783          	ld	a5,-32(s0)
 21e:	0007c783          	lbu	a5,0(a5)
 222:	fcf709e3          	beq	a4,a5,1f4 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 226:	fe843783          	ld	a5,-24(s0)
 22a:	0007c783          	lbu	a5,0(a5)
 22e:	0007871b          	sext.w	a4,a5
 232:	fe043783          	ld	a5,-32(s0)
 236:	0007c783          	lbu	a5,0(a5)
 23a:	2781                	sext.w	a5,a5
 23c:	40f707bb          	subw	a5,a4,a5
 240:	2781                	sext.w	a5,a5
}
 242:	853e                	mv	a0,a5
 244:	6462                	ld	s0,24(sp)
 246:	6105                	addi	sp,sp,32
 248:	8082                	ret

000000000000024a <strlen>:

uint
strlen(const char *s)
{
 24a:	7179                	addi	sp,sp,-48
 24c:	f422                	sd	s0,40(sp)
 24e:	1800                	addi	s0,sp,48
 250:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 254:	fe042623          	sw	zero,-20(s0)
 258:	a031                	j	264 <strlen+0x1a>
 25a:	fec42783          	lw	a5,-20(s0)
 25e:	2785                	addiw	a5,a5,1
 260:	fef42623          	sw	a5,-20(s0)
 264:	fec42783          	lw	a5,-20(s0)
 268:	fd843703          	ld	a4,-40(s0)
 26c:	97ba                	add	a5,a5,a4
 26e:	0007c783          	lbu	a5,0(a5)
 272:	f7e5                	bnez	a5,25a <strlen+0x10>
    ;
  return n;
 274:	fec42783          	lw	a5,-20(s0)
}
 278:	853e                	mv	a0,a5
 27a:	7422                	ld	s0,40(sp)
 27c:	6145                	addi	sp,sp,48
 27e:	8082                	ret

0000000000000280 <memset>:

void*
memset(void *dst, int c, uint n)
{
 280:	7179                	addi	sp,sp,-48
 282:	f422                	sd	s0,40(sp)
 284:	1800                	addi	s0,sp,48
 286:	fca43c23          	sd	a0,-40(s0)
 28a:	87ae                	mv	a5,a1
 28c:	8732                	mv	a4,a2
 28e:	fcf42a23          	sw	a5,-44(s0)
 292:	87ba                	mv	a5,a4
 294:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 298:	fd843783          	ld	a5,-40(s0)
 29c:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 2a0:	fe042623          	sw	zero,-20(s0)
 2a4:	a00d                	j	2c6 <memset+0x46>
    cdst[i] = c;
 2a6:	fec42783          	lw	a5,-20(s0)
 2aa:	fe043703          	ld	a4,-32(s0)
 2ae:	97ba                	add	a5,a5,a4
 2b0:	fd442703          	lw	a4,-44(s0)
 2b4:	0ff77713          	zext.b	a4,a4
 2b8:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 2bc:	fec42783          	lw	a5,-20(s0)
 2c0:	2785                	addiw	a5,a5,1
 2c2:	fef42623          	sw	a5,-20(s0)
 2c6:	fec42703          	lw	a4,-20(s0)
 2ca:	fd042783          	lw	a5,-48(s0)
 2ce:	2781                	sext.w	a5,a5
 2d0:	fcf76be3          	bltu	a4,a5,2a6 <memset+0x26>
  }
  return dst;
 2d4:	fd843783          	ld	a5,-40(s0)
}
 2d8:	853e                	mv	a0,a5
 2da:	7422                	ld	s0,40(sp)
 2dc:	6145                	addi	sp,sp,48
 2de:	8082                	ret

00000000000002e0 <strchr>:

char*
strchr(const char *s, char c)
{
 2e0:	1101                	addi	sp,sp,-32
 2e2:	ec22                	sd	s0,24(sp)
 2e4:	1000                	addi	s0,sp,32
 2e6:	fea43423          	sd	a0,-24(s0)
 2ea:	87ae                	mv	a5,a1
 2ec:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 2f0:	a01d                	j	316 <strchr+0x36>
    if(*s == c)
 2f2:	fe843783          	ld	a5,-24(s0)
 2f6:	0007c703          	lbu	a4,0(a5)
 2fa:	fe744783          	lbu	a5,-25(s0)
 2fe:	0ff7f793          	zext.b	a5,a5
 302:	00e79563          	bne	a5,a4,30c <strchr+0x2c>
      return (char*)s;
 306:	fe843783          	ld	a5,-24(s0)
 30a:	a821                	j	322 <strchr+0x42>
  for(; *s; s++)
 30c:	fe843783          	ld	a5,-24(s0)
 310:	0785                	addi	a5,a5,1
 312:	fef43423          	sd	a5,-24(s0)
 316:	fe843783          	ld	a5,-24(s0)
 31a:	0007c783          	lbu	a5,0(a5)
 31e:	fbf1                	bnez	a5,2f2 <strchr+0x12>
  return 0;
 320:	4781                	li	a5,0
}
 322:	853e                	mv	a0,a5
 324:	6462                	ld	s0,24(sp)
 326:	6105                	addi	sp,sp,32
 328:	8082                	ret

000000000000032a <gets>:

char*
gets(char *buf, int max)
{
 32a:	7179                	addi	sp,sp,-48
 32c:	f406                	sd	ra,40(sp)
 32e:	f022                	sd	s0,32(sp)
 330:	1800                	addi	s0,sp,48
 332:	fca43c23          	sd	a0,-40(s0)
 336:	87ae                	mv	a5,a1
 338:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33c:	fe042623          	sw	zero,-20(s0)
 340:	a8a1                	j	398 <gets+0x6e>
    cc = read(0, &c, 1);
 342:	fe740793          	addi	a5,s0,-25
 346:	4605                	li	a2,1
 348:	85be                	mv	a1,a5
 34a:	4501                	li	a0,0
 34c:	00000097          	auipc	ra,0x0
 350:	2f8080e7          	jalr	760(ra) # 644 <read>
 354:	87aa                	mv	a5,a0
 356:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 35a:	fe842783          	lw	a5,-24(s0)
 35e:	2781                	sext.w	a5,a5
 360:	04f05763          	blez	a5,3ae <gets+0x84>
      break;
    buf[i++] = c;
 364:	fec42783          	lw	a5,-20(s0)
 368:	0017871b          	addiw	a4,a5,1
 36c:	fee42623          	sw	a4,-20(s0)
 370:	873e                	mv	a4,a5
 372:	fd843783          	ld	a5,-40(s0)
 376:	97ba                	add	a5,a5,a4
 378:	fe744703          	lbu	a4,-25(s0)
 37c:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 380:	fe744783          	lbu	a5,-25(s0)
 384:	873e                	mv	a4,a5
 386:	47a9                	li	a5,10
 388:	02f70463          	beq	a4,a5,3b0 <gets+0x86>
 38c:	fe744783          	lbu	a5,-25(s0)
 390:	873e                	mv	a4,a5
 392:	47b5                	li	a5,13
 394:	00f70e63          	beq	a4,a5,3b0 <gets+0x86>
  for(i=0; i+1 < max; ){
 398:	fec42783          	lw	a5,-20(s0)
 39c:	2785                	addiw	a5,a5,1
 39e:	0007871b          	sext.w	a4,a5
 3a2:	fd442783          	lw	a5,-44(s0)
 3a6:	2781                	sext.w	a5,a5
 3a8:	f8f74de3          	blt	a4,a5,342 <gets+0x18>
 3ac:	a011                	j	3b0 <gets+0x86>
      break;
 3ae:	0001                	nop
      break;
  }
  buf[i] = '\0';
 3b0:	fec42783          	lw	a5,-20(s0)
 3b4:	fd843703          	ld	a4,-40(s0)
 3b8:	97ba                	add	a5,a5,a4
 3ba:	00078023          	sb	zero,0(a5)
  return buf;
 3be:	fd843783          	ld	a5,-40(s0)
}
 3c2:	853e                	mv	a0,a5
 3c4:	70a2                	ld	ra,40(sp)
 3c6:	7402                	ld	s0,32(sp)
 3c8:	6145                	addi	sp,sp,48
 3ca:	8082                	ret

00000000000003cc <stat>:

int
stat(const char *n, struct stat *st)
{
 3cc:	7179                	addi	sp,sp,-48
 3ce:	f406                	sd	ra,40(sp)
 3d0:	f022                	sd	s0,32(sp)
 3d2:	1800                	addi	s0,sp,48
 3d4:	fca43c23          	sd	a0,-40(s0)
 3d8:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3dc:	4581                	li	a1,0
 3de:	fd843503          	ld	a0,-40(s0)
 3e2:	00000097          	auipc	ra,0x0
 3e6:	28a080e7          	jalr	650(ra) # 66c <open>
 3ea:	87aa                	mv	a5,a0
 3ec:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 3f0:	fec42783          	lw	a5,-20(s0)
 3f4:	2781                	sext.w	a5,a5
 3f6:	0007d463          	bgez	a5,3fe <stat+0x32>
    return -1;
 3fa:	57fd                	li	a5,-1
 3fc:	a035                	j	428 <stat+0x5c>
  r = fstat(fd, st);
 3fe:	fec42783          	lw	a5,-20(s0)
 402:	fd043583          	ld	a1,-48(s0)
 406:	853e                	mv	a0,a5
 408:	00000097          	auipc	ra,0x0
 40c:	27c080e7          	jalr	636(ra) # 684 <fstat>
 410:	87aa                	mv	a5,a0
 412:	fef42423          	sw	a5,-24(s0)
  close(fd);
 416:	fec42783          	lw	a5,-20(s0)
 41a:	853e                	mv	a0,a5
 41c:	00000097          	auipc	ra,0x0
 420:	238080e7          	jalr	568(ra) # 654 <close>
  return r;
 424:	fe842783          	lw	a5,-24(s0)
}
 428:	853e                	mv	a0,a5
 42a:	70a2                	ld	ra,40(sp)
 42c:	7402                	ld	s0,32(sp)
 42e:	6145                	addi	sp,sp,48
 430:	8082                	ret

0000000000000432 <atoi>:

int
atoi(const char *s)
{
 432:	7179                	addi	sp,sp,-48
 434:	f422                	sd	s0,40(sp)
 436:	1800                	addi	s0,sp,48
 438:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 43c:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 440:	a81d                	j	476 <atoi+0x44>
    n = n*10 + *s++ - '0';
 442:	fec42783          	lw	a5,-20(s0)
 446:	873e                	mv	a4,a5
 448:	87ba                	mv	a5,a4
 44a:	0027979b          	slliw	a5,a5,0x2
 44e:	9fb9                	addw	a5,a5,a4
 450:	0017979b          	slliw	a5,a5,0x1
 454:	0007871b          	sext.w	a4,a5
 458:	fd843783          	ld	a5,-40(s0)
 45c:	00178693          	addi	a3,a5,1
 460:	fcd43c23          	sd	a3,-40(s0)
 464:	0007c783          	lbu	a5,0(a5)
 468:	2781                	sext.w	a5,a5
 46a:	9fb9                	addw	a5,a5,a4
 46c:	2781                	sext.w	a5,a5
 46e:	fd07879b          	addiw	a5,a5,-48
 472:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 476:	fd843783          	ld	a5,-40(s0)
 47a:	0007c783          	lbu	a5,0(a5)
 47e:	873e                	mv	a4,a5
 480:	02f00793          	li	a5,47
 484:	00e7fb63          	bgeu	a5,a4,49a <atoi+0x68>
 488:	fd843783          	ld	a5,-40(s0)
 48c:	0007c783          	lbu	a5,0(a5)
 490:	873e                	mv	a4,a5
 492:	03900793          	li	a5,57
 496:	fae7f6e3          	bgeu	a5,a4,442 <atoi+0x10>
  return n;
 49a:	fec42783          	lw	a5,-20(s0)
}
 49e:	853e                	mv	a0,a5
 4a0:	7422                	ld	s0,40(sp)
 4a2:	6145                	addi	sp,sp,48
 4a4:	8082                	ret

00000000000004a6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a6:	7139                	addi	sp,sp,-64
 4a8:	fc22                	sd	s0,56(sp)
 4aa:	0080                	addi	s0,sp,64
 4ac:	fca43c23          	sd	a0,-40(s0)
 4b0:	fcb43823          	sd	a1,-48(s0)
 4b4:	87b2                	mv	a5,a2
 4b6:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 4ba:	fd843783          	ld	a5,-40(s0)
 4be:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 4c2:	fd043783          	ld	a5,-48(s0)
 4c6:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 4ca:	fe043703          	ld	a4,-32(s0)
 4ce:	fe843783          	ld	a5,-24(s0)
 4d2:	02e7fc63          	bgeu	a5,a4,50a <memmove+0x64>
    while(n-- > 0)
 4d6:	a00d                	j	4f8 <memmove+0x52>
      *dst++ = *src++;
 4d8:	fe043703          	ld	a4,-32(s0)
 4dc:	00170793          	addi	a5,a4,1
 4e0:	fef43023          	sd	a5,-32(s0)
 4e4:	fe843783          	ld	a5,-24(s0)
 4e8:	00178693          	addi	a3,a5,1
 4ec:	fed43423          	sd	a3,-24(s0)
 4f0:	00074703          	lbu	a4,0(a4)
 4f4:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 4f8:	fcc42783          	lw	a5,-52(s0)
 4fc:	fff7871b          	addiw	a4,a5,-1
 500:	fce42623          	sw	a4,-52(s0)
 504:	fcf04ae3          	bgtz	a5,4d8 <memmove+0x32>
 508:	a891                	j	55c <memmove+0xb6>
  } else {
    dst += n;
 50a:	fcc42783          	lw	a5,-52(s0)
 50e:	fe843703          	ld	a4,-24(s0)
 512:	97ba                	add	a5,a5,a4
 514:	fef43423          	sd	a5,-24(s0)
    src += n;
 518:	fcc42783          	lw	a5,-52(s0)
 51c:	fe043703          	ld	a4,-32(s0)
 520:	97ba                	add	a5,a5,a4
 522:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 526:	a01d                	j	54c <memmove+0xa6>
      *--dst = *--src;
 528:	fe043783          	ld	a5,-32(s0)
 52c:	17fd                	addi	a5,a5,-1
 52e:	fef43023          	sd	a5,-32(s0)
 532:	fe843783          	ld	a5,-24(s0)
 536:	17fd                	addi	a5,a5,-1
 538:	fef43423          	sd	a5,-24(s0)
 53c:	fe043783          	ld	a5,-32(s0)
 540:	0007c703          	lbu	a4,0(a5)
 544:	fe843783          	ld	a5,-24(s0)
 548:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 54c:	fcc42783          	lw	a5,-52(s0)
 550:	fff7871b          	addiw	a4,a5,-1
 554:	fce42623          	sw	a4,-52(s0)
 558:	fcf048e3          	bgtz	a5,528 <memmove+0x82>
  }
  return vdst;
 55c:	fd843783          	ld	a5,-40(s0)
}
 560:	853e                	mv	a0,a5
 562:	7462                	ld	s0,56(sp)
 564:	6121                	addi	sp,sp,64
 566:	8082                	ret

0000000000000568 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 568:	7139                	addi	sp,sp,-64
 56a:	fc22                	sd	s0,56(sp)
 56c:	0080                	addi	s0,sp,64
 56e:	fca43c23          	sd	a0,-40(s0)
 572:	fcb43823          	sd	a1,-48(s0)
 576:	87b2                	mv	a5,a2
 578:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 57c:	fd843783          	ld	a5,-40(s0)
 580:	fef43423          	sd	a5,-24(s0)
 584:	fd043783          	ld	a5,-48(s0)
 588:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 58c:	a0a1                	j	5d4 <memcmp+0x6c>
    if (*p1 != *p2) {
 58e:	fe843783          	ld	a5,-24(s0)
 592:	0007c703          	lbu	a4,0(a5)
 596:	fe043783          	ld	a5,-32(s0)
 59a:	0007c783          	lbu	a5,0(a5)
 59e:	02f70163          	beq	a4,a5,5c0 <memcmp+0x58>
      return *p1 - *p2;
 5a2:	fe843783          	ld	a5,-24(s0)
 5a6:	0007c783          	lbu	a5,0(a5)
 5aa:	0007871b          	sext.w	a4,a5
 5ae:	fe043783          	ld	a5,-32(s0)
 5b2:	0007c783          	lbu	a5,0(a5)
 5b6:	2781                	sext.w	a5,a5
 5b8:	40f707bb          	subw	a5,a4,a5
 5bc:	2781                	sext.w	a5,a5
 5be:	a01d                	j	5e4 <memcmp+0x7c>
    }
    p1++;
 5c0:	fe843783          	ld	a5,-24(s0)
 5c4:	0785                	addi	a5,a5,1
 5c6:	fef43423          	sd	a5,-24(s0)
    p2++;
 5ca:	fe043783          	ld	a5,-32(s0)
 5ce:	0785                	addi	a5,a5,1
 5d0:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 5d4:	fcc42783          	lw	a5,-52(s0)
 5d8:	fff7871b          	addiw	a4,a5,-1
 5dc:	fce42623          	sw	a4,-52(s0)
 5e0:	f7dd                	bnez	a5,58e <memcmp+0x26>
  }
  return 0;
 5e2:	4781                	li	a5,0
}
 5e4:	853e                	mv	a0,a5
 5e6:	7462                	ld	s0,56(sp)
 5e8:	6121                	addi	sp,sp,64
 5ea:	8082                	ret

00000000000005ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5ec:	7179                	addi	sp,sp,-48
 5ee:	f406                	sd	ra,40(sp)
 5f0:	f022                	sd	s0,32(sp)
 5f2:	1800                	addi	s0,sp,48
 5f4:	fea43423          	sd	a0,-24(s0)
 5f8:	feb43023          	sd	a1,-32(s0)
 5fc:	87b2                	mv	a5,a2
 5fe:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 602:	fdc42783          	lw	a5,-36(s0)
 606:	863e                	mv	a2,a5
 608:	fe043583          	ld	a1,-32(s0)
 60c:	fe843503          	ld	a0,-24(s0)
 610:	00000097          	auipc	ra,0x0
 614:	e96080e7          	jalr	-362(ra) # 4a6 <memmove>
 618:	87aa                	mv	a5,a0
}
 61a:	853e                	mv	a0,a5
 61c:	70a2                	ld	ra,40(sp)
 61e:	7402                	ld	s0,32(sp)
 620:	6145                	addi	sp,sp,48
 622:	8082                	ret

0000000000000624 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 624:	4885                	li	a7,1
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <exit>:
.global exit
exit:
 li a7, SYS_exit
 62c:	4889                	li	a7,2
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <wait>:
.global wait
wait:
 li a7, SYS_wait
 634:	488d                	li	a7,3
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 63c:	4891                	li	a7,4
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <read>:
.global read
read:
 li a7, SYS_read
 644:	4895                	li	a7,5
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <write>:
.global write
write:
 li a7, SYS_write
 64c:	48c1                	li	a7,16
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <close>:
.global close
close:
 li a7, SYS_close
 654:	48d5                	li	a7,21
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <kill>:
.global kill
kill:
 li a7, SYS_kill
 65c:	4899                	li	a7,6
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <exec>:
.global exec
exec:
 li a7, SYS_exec
 664:	489d                	li	a7,7
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <open>:
.global open
open:
 li a7, SYS_open
 66c:	48bd                	li	a7,15
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 674:	48c5                	li	a7,17
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 67c:	48c9                	li	a7,18
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 684:	48a1                	li	a7,8
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <link>:
.global link
link:
 li a7, SYS_link
 68c:	48cd                	li	a7,19
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 694:	48d1                	li	a7,20
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 69c:	48a5                	li	a7,9
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6a4:	48a9                	li	a7,10
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ac:	48ad                	li	a7,11
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6b4:	48b1                	li	a7,12
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6bc:	48b5                	li	a7,13
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6c4:	48b9                	li	a7,14
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6cc:	1101                	addi	sp,sp,-32
 6ce:	ec06                	sd	ra,24(sp)
 6d0:	e822                	sd	s0,16(sp)
 6d2:	1000                	addi	s0,sp,32
 6d4:	87aa                	mv	a5,a0
 6d6:	872e                	mv	a4,a1
 6d8:	fef42623          	sw	a5,-20(s0)
 6dc:	87ba                	mv	a5,a4
 6de:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 6e2:	feb40713          	addi	a4,s0,-21
 6e6:	fec42783          	lw	a5,-20(s0)
 6ea:	4605                	li	a2,1
 6ec:	85ba                	mv	a1,a4
 6ee:	853e                	mv	a0,a5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	f5c080e7          	jalr	-164(ra) # 64c <write>
}
 6f8:	0001                	nop
 6fa:	60e2                	ld	ra,24(sp)
 6fc:	6442                	ld	s0,16(sp)
 6fe:	6105                	addi	sp,sp,32
 700:	8082                	ret

0000000000000702 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 702:	7139                	addi	sp,sp,-64
 704:	fc06                	sd	ra,56(sp)
 706:	f822                	sd	s0,48(sp)
 708:	0080                	addi	s0,sp,64
 70a:	87aa                	mv	a5,a0
 70c:	8736                	mv	a4,a3
 70e:	fcf42623          	sw	a5,-52(s0)
 712:	87ae                	mv	a5,a1
 714:	fcf42423          	sw	a5,-56(s0)
 718:	87b2                	mv	a5,a2
 71a:	fcf42223          	sw	a5,-60(s0)
 71e:	87ba                	mv	a5,a4
 720:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 724:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 728:	fc042783          	lw	a5,-64(s0)
 72c:	2781                	sext.w	a5,a5
 72e:	c38d                	beqz	a5,750 <printint+0x4e>
 730:	fc842783          	lw	a5,-56(s0)
 734:	2781                	sext.w	a5,a5
 736:	0007dd63          	bgez	a5,750 <printint+0x4e>
    neg = 1;
 73a:	4785                	li	a5,1
 73c:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 740:	fc842783          	lw	a5,-56(s0)
 744:	40f007bb          	negw	a5,a5
 748:	2781                	sext.w	a5,a5
 74a:	fef42223          	sw	a5,-28(s0)
 74e:	a029                	j	758 <printint+0x56>
  } else {
    x = xx;
 750:	fc842783          	lw	a5,-56(s0)
 754:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 758:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 75c:	fc442783          	lw	a5,-60(s0)
 760:	fe442703          	lw	a4,-28(s0)
 764:	02f777bb          	remuw	a5,a4,a5
 768:	0007861b          	sext.w	a2,a5
 76c:	fec42783          	lw	a5,-20(s0)
 770:	0017871b          	addiw	a4,a5,1
 774:	fee42623          	sw	a4,-20(s0)
 778:	00001697          	auipc	a3,0x1
 77c:	c1868693          	addi	a3,a3,-1000 # 1390 <digits>
 780:	02061713          	slli	a4,a2,0x20
 784:	9301                	srli	a4,a4,0x20
 786:	9736                	add	a4,a4,a3
 788:	00074703          	lbu	a4,0(a4)
 78c:	17c1                	addi	a5,a5,-16
 78e:	97a2                	add	a5,a5,s0
 790:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 794:	fc442783          	lw	a5,-60(s0)
 798:	fe442703          	lw	a4,-28(s0)
 79c:	02f757bb          	divuw	a5,a4,a5
 7a0:	fef42223          	sw	a5,-28(s0)
 7a4:	fe442783          	lw	a5,-28(s0)
 7a8:	2781                	sext.w	a5,a5
 7aa:	fbcd                	bnez	a5,75c <printint+0x5a>
  if(neg)
 7ac:	fe842783          	lw	a5,-24(s0)
 7b0:	2781                	sext.w	a5,a5
 7b2:	cf85                	beqz	a5,7ea <printint+0xe8>
    buf[i++] = '-';
 7b4:	fec42783          	lw	a5,-20(s0)
 7b8:	0017871b          	addiw	a4,a5,1
 7bc:	fee42623          	sw	a4,-20(s0)
 7c0:	17c1                	addi	a5,a5,-16
 7c2:	97a2                	add	a5,a5,s0
 7c4:	02d00713          	li	a4,45
 7c8:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 7cc:	a839                	j	7ea <printint+0xe8>
    putc(fd, buf[i]);
 7ce:	fec42783          	lw	a5,-20(s0)
 7d2:	17c1                	addi	a5,a5,-16
 7d4:	97a2                	add	a5,a5,s0
 7d6:	fe07c703          	lbu	a4,-32(a5)
 7da:	fcc42783          	lw	a5,-52(s0)
 7de:	85ba                	mv	a1,a4
 7e0:	853e                	mv	a0,a5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	eea080e7          	jalr	-278(ra) # 6cc <putc>
  while(--i >= 0)
 7ea:	fec42783          	lw	a5,-20(s0)
 7ee:	37fd                	addiw	a5,a5,-1
 7f0:	fef42623          	sw	a5,-20(s0)
 7f4:	fec42783          	lw	a5,-20(s0)
 7f8:	2781                	sext.w	a5,a5
 7fa:	fc07dae3          	bgez	a5,7ce <printint+0xcc>
}
 7fe:	0001                	nop
 800:	0001                	nop
 802:	70e2                	ld	ra,56(sp)
 804:	7442                	ld	s0,48(sp)
 806:	6121                	addi	sp,sp,64
 808:	8082                	ret

000000000000080a <printptr>:

static void
printptr(int fd, uint64 x) {
 80a:	7179                	addi	sp,sp,-48
 80c:	f406                	sd	ra,40(sp)
 80e:	f022                	sd	s0,32(sp)
 810:	1800                	addi	s0,sp,48
 812:	87aa                	mv	a5,a0
 814:	fcb43823          	sd	a1,-48(s0)
 818:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 81c:	fdc42783          	lw	a5,-36(s0)
 820:	03000593          	li	a1,48
 824:	853e                	mv	a0,a5
 826:	00000097          	auipc	ra,0x0
 82a:	ea6080e7          	jalr	-346(ra) # 6cc <putc>
  putc(fd, 'x');
 82e:	fdc42783          	lw	a5,-36(s0)
 832:	07800593          	li	a1,120
 836:	853e                	mv	a0,a5
 838:	00000097          	auipc	ra,0x0
 83c:	e94080e7          	jalr	-364(ra) # 6cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 840:	fe042623          	sw	zero,-20(s0)
 844:	a82d                	j	87e <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 846:	fd043783          	ld	a5,-48(s0)
 84a:	93f1                	srli	a5,a5,0x3c
 84c:	00001717          	auipc	a4,0x1
 850:	b4470713          	addi	a4,a4,-1212 # 1390 <digits>
 854:	97ba                	add	a5,a5,a4
 856:	0007c703          	lbu	a4,0(a5)
 85a:	fdc42783          	lw	a5,-36(s0)
 85e:	85ba                	mv	a1,a4
 860:	853e                	mv	a0,a5
 862:	00000097          	auipc	ra,0x0
 866:	e6a080e7          	jalr	-406(ra) # 6cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 86a:	fec42783          	lw	a5,-20(s0)
 86e:	2785                	addiw	a5,a5,1
 870:	fef42623          	sw	a5,-20(s0)
 874:	fd043783          	ld	a5,-48(s0)
 878:	0792                	slli	a5,a5,0x4
 87a:	fcf43823          	sd	a5,-48(s0)
 87e:	fec42783          	lw	a5,-20(s0)
 882:	873e                	mv	a4,a5
 884:	47bd                	li	a5,15
 886:	fce7f0e3          	bgeu	a5,a4,846 <printptr+0x3c>
}
 88a:	0001                	nop
 88c:	0001                	nop
 88e:	70a2                	ld	ra,40(sp)
 890:	7402                	ld	s0,32(sp)
 892:	6145                	addi	sp,sp,48
 894:	8082                	ret

0000000000000896 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 896:	715d                	addi	sp,sp,-80
 898:	e486                	sd	ra,72(sp)
 89a:	e0a2                	sd	s0,64(sp)
 89c:	0880                	addi	s0,sp,80
 89e:	87aa                	mv	a5,a0
 8a0:	fcb43023          	sd	a1,-64(s0)
 8a4:	fac43c23          	sd	a2,-72(s0)
 8a8:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 8ac:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 8b0:	fe042223          	sw	zero,-28(s0)
 8b4:	a42d                	j	ade <vprintf+0x248>
    c = fmt[i] & 0xff;
 8b6:	fe442783          	lw	a5,-28(s0)
 8ba:	fc043703          	ld	a4,-64(s0)
 8be:	97ba                	add	a5,a5,a4
 8c0:	0007c783          	lbu	a5,0(a5)
 8c4:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 8c8:	fe042783          	lw	a5,-32(s0)
 8cc:	2781                	sext.w	a5,a5
 8ce:	eb9d                	bnez	a5,904 <vprintf+0x6e>
      if(c == '%'){
 8d0:	fdc42783          	lw	a5,-36(s0)
 8d4:	0007871b          	sext.w	a4,a5
 8d8:	02500793          	li	a5,37
 8dc:	00f71763          	bne	a4,a5,8ea <vprintf+0x54>
        state = '%';
 8e0:	02500793          	li	a5,37
 8e4:	fef42023          	sw	a5,-32(s0)
 8e8:	a2f5                	j	ad4 <vprintf+0x23e>
      } else {
        putc(fd, c);
 8ea:	fdc42783          	lw	a5,-36(s0)
 8ee:	0ff7f713          	zext.b	a4,a5
 8f2:	fcc42783          	lw	a5,-52(s0)
 8f6:	85ba                	mv	a1,a4
 8f8:	853e                	mv	a0,a5
 8fa:	00000097          	auipc	ra,0x0
 8fe:	dd2080e7          	jalr	-558(ra) # 6cc <putc>
 902:	aac9                	j	ad4 <vprintf+0x23e>
      }
    } else if(state == '%'){
 904:	fe042783          	lw	a5,-32(s0)
 908:	0007871b          	sext.w	a4,a5
 90c:	02500793          	li	a5,37
 910:	1cf71263          	bne	a4,a5,ad4 <vprintf+0x23e>
      if(c == 'd'){
 914:	fdc42783          	lw	a5,-36(s0)
 918:	0007871b          	sext.w	a4,a5
 91c:	06400793          	li	a5,100
 920:	02f71463          	bne	a4,a5,948 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 924:	fb843783          	ld	a5,-72(s0)
 928:	00878713          	addi	a4,a5,8
 92c:	fae43c23          	sd	a4,-72(s0)
 930:	4398                	lw	a4,0(a5)
 932:	fcc42783          	lw	a5,-52(s0)
 936:	4685                	li	a3,1
 938:	4629                	li	a2,10
 93a:	85ba                	mv	a1,a4
 93c:	853e                	mv	a0,a5
 93e:	00000097          	auipc	ra,0x0
 942:	dc4080e7          	jalr	-572(ra) # 702 <printint>
 946:	a269                	j	ad0 <vprintf+0x23a>
      } else if(c == 'l') {
 948:	fdc42783          	lw	a5,-36(s0)
 94c:	0007871b          	sext.w	a4,a5
 950:	06c00793          	li	a5,108
 954:	02f71663          	bne	a4,a5,980 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 958:	fb843783          	ld	a5,-72(s0)
 95c:	00878713          	addi	a4,a5,8
 960:	fae43c23          	sd	a4,-72(s0)
 964:	639c                	ld	a5,0(a5)
 966:	0007871b          	sext.w	a4,a5
 96a:	fcc42783          	lw	a5,-52(s0)
 96e:	4681                	li	a3,0
 970:	4629                	li	a2,10
 972:	85ba                	mv	a1,a4
 974:	853e                	mv	a0,a5
 976:	00000097          	auipc	ra,0x0
 97a:	d8c080e7          	jalr	-628(ra) # 702 <printint>
 97e:	aa89                	j	ad0 <vprintf+0x23a>
      } else if(c == 'x') {
 980:	fdc42783          	lw	a5,-36(s0)
 984:	0007871b          	sext.w	a4,a5
 988:	07800793          	li	a5,120
 98c:	02f71463          	bne	a4,a5,9b4 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 990:	fb843783          	ld	a5,-72(s0)
 994:	00878713          	addi	a4,a5,8
 998:	fae43c23          	sd	a4,-72(s0)
 99c:	4398                	lw	a4,0(a5)
 99e:	fcc42783          	lw	a5,-52(s0)
 9a2:	4681                	li	a3,0
 9a4:	4641                	li	a2,16
 9a6:	85ba                	mv	a1,a4
 9a8:	853e                	mv	a0,a5
 9aa:	00000097          	auipc	ra,0x0
 9ae:	d58080e7          	jalr	-680(ra) # 702 <printint>
 9b2:	aa39                	j	ad0 <vprintf+0x23a>
      } else if(c == 'p') {
 9b4:	fdc42783          	lw	a5,-36(s0)
 9b8:	0007871b          	sext.w	a4,a5
 9bc:	07000793          	li	a5,112
 9c0:	02f71263          	bne	a4,a5,9e4 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 9c4:	fb843783          	ld	a5,-72(s0)
 9c8:	00878713          	addi	a4,a5,8
 9cc:	fae43c23          	sd	a4,-72(s0)
 9d0:	6398                	ld	a4,0(a5)
 9d2:	fcc42783          	lw	a5,-52(s0)
 9d6:	85ba                	mv	a1,a4
 9d8:	853e                	mv	a0,a5
 9da:	00000097          	auipc	ra,0x0
 9de:	e30080e7          	jalr	-464(ra) # 80a <printptr>
 9e2:	a0fd                	j	ad0 <vprintf+0x23a>
      } else if(c == 's'){
 9e4:	fdc42783          	lw	a5,-36(s0)
 9e8:	0007871b          	sext.w	a4,a5
 9ec:	07300793          	li	a5,115
 9f0:	04f71c63          	bne	a4,a5,a48 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 9f4:	fb843783          	ld	a5,-72(s0)
 9f8:	00878713          	addi	a4,a5,8
 9fc:	fae43c23          	sd	a4,-72(s0)
 a00:	639c                	ld	a5,0(a5)
 a02:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 a06:	fe843783          	ld	a5,-24(s0)
 a0a:	eb8d                	bnez	a5,a3c <vprintf+0x1a6>
          s = "(null)";
 a0c:	00000797          	auipc	a5,0x0
 a10:	4cc78793          	addi	a5,a5,1228 # ed8 <malloc+0x192>
 a14:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a18:	a015                	j	a3c <vprintf+0x1a6>
          putc(fd, *s);
 a1a:	fe843783          	ld	a5,-24(s0)
 a1e:	0007c703          	lbu	a4,0(a5)
 a22:	fcc42783          	lw	a5,-52(s0)
 a26:	85ba                	mv	a1,a4
 a28:	853e                	mv	a0,a5
 a2a:	00000097          	auipc	ra,0x0
 a2e:	ca2080e7          	jalr	-862(ra) # 6cc <putc>
          s++;
 a32:	fe843783          	ld	a5,-24(s0)
 a36:	0785                	addi	a5,a5,1
 a38:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 a3c:	fe843783          	ld	a5,-24(s0)
 a40:	0007c783          	lbu	a5,0(a5)
 a44:	fbf9                	bnez	a5,a1a <vprintf+0x184>
 a46:	a069                	j	ad0 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 a48:	fdc42783          	lw	a5,-36(s0)
 a4c:	0007871b          	sext.w	a4,a5
 a50:	06300793          	li	a5,99
 a54:	02f71463          	bne	a4,a5,a7c <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 a58:	fb843783          	ld	a5,-72(s0)
 a5c:	00878713          	addi	a4,a5,8
 a60:	fae43c23          	sd	a4,-72(s0)
 a64:	439c                	lw	a5,0(a5)
 a66:	0ff7f713          	zext.b	a4,a5
 a6a:	fcc42783          	lw	a5,-52(s0)
 a6e:	85ba                	mv	a1,a4
 a70:	853e                	mv	a0,a5
 a72:	00000097          	auipc	ra,0x0
 a76:	c5a080e7          	jalr	-934(ra) # 6cc <putc>
 a7a:	a899                	j	ad0 <vprintf+0x23a>
      } else if(c == '%'){
 a7c:	fdc42783          	lw	a5,-36(s0)
 a80:	0007871b          	sext.w	a4,a5
 a84:	02500793          	li	a5,37
 a88:	00f71f63          	bne	a4,a5,aa6 <vprintf+0x210>
        putc(fd, c);
 a8c:	fdc42783          	lw	a5,-36(s0)
 a90:	0ff7f713          	zext.b	a4,a5
 a94:	fcc42783          	lw	a5,-52(s0)
 a98:	85ba                	mv	a1,a4
 a9a:	853e                	mv	a0,a5
 a9c:	00000097          	auipc	ra,0x0
 aa0:	c30080e7          	jalr	-976(ra) # 6cc <putc>
 aa4:	a035                	j	ad0 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 aa6:	fcc42783          	lw	a5,-52(s0)
 aaa:	02500593          	li	a1,37
 aae:	853e                	mv	a0,a5
 ab0:	00000097          	auipc	ra,0x0
 ab4:	c1c080e7          	jalr	-996(ra) # 6cc <putc>
        putc(fd, c);
 ab8:	fdc42783          	lw	a5,-36(s0)
 abc:	0ff7f713          	zext.b	a4,a5
 ac0:	fcc42783          	lw	a5,-52(s0)
 ac4:	85ba                	mv	a1,a4
 ac6:	853e                	mv	a0,a5
 ac8:	00000097          	auipc	ra,0x0
 acc:	c04080e7          	jalr	-1020(ra) # 6cc <putc>
      }
      state = 0;
 ad0:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 ad4:	fe442783          	lw	a5,-28(s0)
 ad8:	2785                	addiw	a5,a5,1
 ada:	fef42223          	sw	a5,-28(s0)
 ade:	fe442783          	lw	a5,-28(s0)
 ae2:	fc043703          	ld	a4,-64(s0)
 ae6:	97ba                	add	a5,a5,a4
 ae8:	0007c783          	lbu	a5,0(a5)
 aec:	dc0795e3          	bnez	a5,8b6 <vprintf+0x20>
    }
  }
}
 af0:	0001                	nop
 af2:	0001                	nop
 af4:	60a6                	ld	ra,72(sp)
 af6:	6406                	ld	s0,64(sp)
 af8:	6161                	addi	sp,sp,80
 afa:	8082                	ret

0000000000000afc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 afc:	7159                	addi	sp,sp,-112
 afe:	fc06                	sd	ra,56(sp)
 b00:	f822                	sd	s0,48(sp)
 b02:	0080                	addi	s0,sp,64
 b04:	fcb43823          	sd	a1,-48(s0)
 b08:	e010                	sd	a2,0(s0)
 b0a:	e414                	sd	a3,8(s0)
 b0c:	e818                	sd	a4,16(s0)
 b0e:	ec1c                	sd	a5,24(s0)
 b10:	03043023          	sd	a6,32(s0)
 b14:	03143423          	sd	a7,40(s0)
 b18:	87aa                	mv	a5,a0
 b1a:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 b1e:	03040793          	addi	a5,s0,48
 b22:	fcf43423          	sd	a5,-56(s0)
 b26:	fc843783          	ld	a5,-56(s0)
 b2a:	fd078793          	addi	a5,a5,-48
 b2e:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 b32:	fe843703          	ld	a4,-24(s0)
 b36:	fdc42783          	lw	a5,-36(s0)
 b3a:	863a                	mv	a2,a4
 b3c:	fd043583          	ld	a1,-48(s0)
 b40:	853e                	mv	a0,a5
 b42:	00000097          	auipc	ra,0x0
 b46:	d54080e7          	jalr	-684(ra) # 896 <vprintf>
}
 b4a:	0001                	nop
 b4c:	70e2                	ld	ra,56(sp)
 b4e:	7442                	ld	s0,48(sp)
 b50:	6165                	addi	sp,sp,112
 b52:	8082                	ret

0000000000000b54 <printf>:

void
printf(const char *fmt, ...)
{
 b54:	7159                	addi	sp,sp,-112
 b56:	f406                	sd	ra,40(sp)
 b58:	f022                	sd	s0,32(sp)
 b5a:	1800                	addi	s0,sp,48
 b5c:	fca43c23          	sd	a0,-40(s0)
 b60:	e40c                	sd	a1,8(s0)
 b62:	e810                	sd	a2,16(s0)
 b64:	ec14                	sd	a3,24(s0)
 b66:	f018                	sd	a4,32(s0)
 b68:	f41c                	sd	a5,40(s0)
 b6a:	03043823          	sd	a6,48(s0)
 b6e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b72:	04040793          	addi	a5,s0,64
 b76:	fcf43823          	sd	a5,-48(s0)
 b7a:	fd043783          	ld	a5,-48(s0)
 b7e:	fc878793          	addi	a5,a5,-56
 b82:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 b86:	fe843783          	ld	a5,-24(s0)
 b8a:	863e                	mv	a2,a5
 b8c:	fd843583          	ld	a1,-40(s0)
 b90:	4505                	li	a0,1
 b92:	00000097          	auipc	ra,0x0
 b96:	d04080e7          	jalr	-764(ra) # 896 <vprintf>
}
 b9a:	0001                	nop
 b9c:	70a2                	ld	ra,40(sp)
 b9e:	7402                	ld	s0,32(sp)
 ba0:	6165                	addi	sp,sp,112
 ba2:	8082                	ret

0000000000000ba4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ba4:	7179                	addi	sp,sp,-48
 ba6:	f422                	sd	s0,40(sp)
 ba8:	1800                	addi	s0,sp,48
 baa:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bae:	fd843783          	ld	a5,-40(s0)
 bb2:	17c1                	addi	a5,a5,-16
 bb4:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bb8:	00001797          	auipc	a5,0x1
 bbc:	a0878793          	addi	a5,a5,-1528 # 15c0 <freep>
 bc0:	639c                	ld	a5,0(a5)
 bc2:	fef43423          	sd	a5,-24(s0)
 bc6:	a815                	j	bfa <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc8:	fe843783          	ld	a5,-24(s0)
 bcc:	639c                	ld	a5,0(a5)
 bce:	fe843703          	ld	a4,-24(s0)
 bd2:	00f76f63          	bltu	a4,a5,bf0 <free+0x4c>
 bd6:	fe043703          	ld	a4,-32(s0)
 bda:	fe843783          	ld	a5,-24(s0)
 bde:	02e7eb63          	bltu	a5,a4,c14 <free+0x70>
 be2:	fe843783          	ld	a5,-24(s0)
 be6:	639c                	ld	a5,0(a5)
 be8:	fe043703          	ld	a4,-32(s0)
 bec:	02f76463          	bltu	a4,a5,c14 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bf0:	fe843783          	ld	a5,-24(s0)
 bf4:	639c                	ld	a5,0(a5)
 bf6:	fef43423          	sd	a5,-24(s0)
 bfa:	fe043703          	ld	a4,-32(s0)
 bfe:	fe843783          	ld	a5,-24(s0)
 c02:	fce7f3e3          	bgeu	a5,a4,bc8 <free+0x24>
 c06:	fe843783          	ld	a5,-24(s0)
 c0a:	639c                	ld	a5,0(a5)
 c0c:	fe043703          	ld	a4,-32(s0)
 c10:	faf77ce3          	bgeu	a4,a5,bc8 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c14:	fe043783          	ld	a5,-32(s0)
 c18:	479c                	lw	a5,8(a5)
 c1a:	1782                	slli	a5,a5,0x20
 c1c:	9381                	srli	a5,a5,0x20
 c1e:	0792                	slli	a5,a5,0x4
 c20:	fe043703          	ld	a4,-32(s0)
 c24:	973e                	add	a4,a4,a5
 c26:	fe843783          	ld	a5,-24(s0)
 c2a:	639c                	ld	a5,0(a5)
 c2c:	02f71763          	bne	a4,a5,c5a <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 c30:	fe043783          	ld	a5,-32(s0)
 c34:	4798                	lw	a4,8(a5)
 c36:	fe843783          	ld	a5,-24(s0)
 c3a:	639c                	ld	a5,0(a5)
 c3c:	479c                	lw	a5,8(a5)
 c3e:	9fb9                	addw	a5,a5,a4
 c40:	0007871b          	sext.w	a4,a5
 c44:	fe043783          	ld	a5,-32(s0)
 c48:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 c4a:	fe843783          	ld	a5,-24(s0)
 c4e:	639c                	ld	a5,0(a5)
 c50:	6398                	ld	a4,0(a5)
 c52:	fe043783          	ld	a5,-32(s0)
 c56:	e398                	sd	a4,0(a5)
 c58:	a039                	j	c66 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 c5a:	fe843783          	ld	a5,-24(s0)
 c5e:	6398                	ld	a4,0(a5)
 c60:	fe043783          	ld	a5,-32(s0)
 c64:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c66:	fe843783          	ld	a5,-24(s0)
 c6a:	479c                	lw	a5,8(a5)
 c6c:	1782                	slli	a5,a5,0x20
 c6e:	9381                	srli	a5,a5,0x20
 c70:	0792                	slli	a5,a5,0x4
 c72:	fe843703          	ld	a4,-24(s0)
 c76:	97ba                	add	a5,a5,a4
 c78:	fe043703          	ld	a4,-32(s0)
 c7c:	02f71563          	bne	a4,a5,ca6 <free+0x102>
    p->s.size += bp->s.size;
 c80:	fe843783          	ld	a5,-24(s0)
 c84:	4798                	lw	a4,8(a5)
 c86:	fe043783          	ld	a5,-32(s0)
 c8a:	479c                	lw	a5,8(a5)
 c8c:	9fb9                	addw	a5,a5,a4
 c8e:	0007871b          	sext.w	a4,a5
 c92:	fe843783          	ld	a5,-24(s0)
 c96:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c98:	fe043783          	ld	a5,-32(s0)
 c9c:	6398                	ld	a4,0(a5)
 c9e:	fe843783          	ld	a5,-24(s0)
 ca2:	e398                	sd	a4,0(a5)
 ca4:	a031                	j	cb0 <free+0x10c>
  } else
    p->s.ptr = bp;
 ca6:	fe843783          	ld	a5,-24(s0)
 caa:	fe043703          	ld	a4,-32(s0)
 cae:	e398                	sd	a4,0(a5)
  freep = p;
 cb0:	00001797          	auipc	a5,0x1
 cb4:	91078793          	addi	a5,a5,-1776 # 15c0 <freep>
 cb8:	fe843703          	ld	a4,-24(s0)
 cbc:	e398                	sd	a4,0(a5)
}
 cbe:	0001                	nop
 cc0:	7422                	ld	s0,40(sp)
 cc2:	6145                	addi	sp,sp,48
 cc4:	8082                	ret

0000000000000cc6 <morecore>:

static Header*
morecore(uint nu)
{
 cc6:	7179                	addi	sp,sp,-48
 cc8:	f406                	sd	ra,40(sp)
 cca:	f022                	sd	s0,32(sp)
 ccc:	1800                	addi	s0,sp,48
 cce:	87aa                	mv	a5,a0
 cd0:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 cd4:	fdc42783          	lw	a5,-36(s0)
 cd8:	0007871b          	sext.w	a4,a5
 cdc:	6785                	lui	a5,0x1
 cde:	00f77563          	bgeu	a4,a5,ce8 <morecore+0x22>
    nu = 4096;
 ce2:	6785                	lui	a5,0x1
 ce4:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 ce8:	fdc42783          	lw	a5,-36(s0)
 cec:	0047979b          	slliw	a5,a5,0x4
 cf0:	2781                	sext.w	a5,a5
 cf2:	2781                	sext.w	a5,a5
 cf4:	853e                	mv	a0,a5
 cf6:	00000097          	auipc	ra,0x0
 cfa:	9be080e7          	jalr	-1602(ra) # 6b4 <sbrk>
 cfe:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 d02:	fe843703          	ld	a4,-24(s0)
 d06:	57fd                	li	a5,-1
 d08:	00f71463          	bne	a4,a5,d10 <morecore+0x4a>
    return 0;
 d0c:	4781                	li	a5,0
 d0e:	a03d                	j	d3c <morecore+0x76>
  hp = (Header*)p;
 d10:	fe843783          	ld	a5,-24(s0)
 d14:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 d18:	fe043783          	ld	a5,-32(s0)
 d1c:	fdc42703          	lw	a4,-36(s0)
 d20:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 d22:	fe043783          	ld	a5,-32(s0)
 d26:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x2ca>
 d28:	853e                	mv	a0,a5
 d2a:	00000097          	auipc	ra,0x0
 d2e:	e7a080e7          	jalr	-390(ra) # ba4 <free>
  return freep;
 d32:	00001797          	auipc	a5,0x1
 d36:	88e78793          	addi	a5,a5,-1906 # 15c0 <freep>
 d3a:	639c                	ld	a5,0(a5)
}
 d3c:	853e                	mv	a0,a5
 d3e:	70a2                	ld	ra,40(sp)
 d40:	7402                	ld	s0,32(sp)
 d42:	6145                	addi	sp,sp,48
 d44:	8082                	ret

0000000000000d46 <malloc>:

void*
malloc(uint nbytes)
{
 d46:	7139                	addi	sp,sp,-64
 d48:	fc06                	sd	ra,56(sp)
 d4a:	f822                	sd	s0,48(sp)
 d4c:	0080                	addi	s0,sp,64
 d4e:	87aa                	mv	a5,a0
 d50:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d54:	fcc46783          	lwu	a5,-52(s0)
 d58:	07bd                	addi	a5,a5,15
 d5a:	8391                	srli	a5,a5,0x4
 d5c:	2781                	sext.w	a5,a5
 d5e:	2785                	addiw	a5,a5,1
 d60:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d64:	00001797          	auipc	a5,0x1
 d68:	85c78793          	addi	a5,a5,-1956 # 15c0 <freep>
 d6c:	639c                	ld	a5,0(a5)
 d6e:	fef43023          	sd	a5,-32(s0)
 d72:	fe043783          	ld	a5,-32(s0)
 d76:	ef95                	bnez	a5,db2 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d78:	00001797          	auipc	a5,0x1
 d7c:	83878793          	addi	a5,a5,-1992 # 15b0 <base>
 d80:	fef43023          	sd	a5,-32(s0)
 d84:	00001797          	auipc	a5,0x1
 d88:	83c78793          	addi	a5,a5,-1988 # 15c0 <freep>
 d8c:	fe043703          	ld	a4,-32(s0)
 d90:	e398                	sd	a4,0(a5)
 d92:	00001797          	auipc	a5,0x1
 d96:	82e78793          	addi	a5,a5,-2002 # 15c0 <freep>
 d9a:	6398                	ld	a4,0(a5)
 d9c:	00001797          	auipc	a5,0x1
 da0:	81478793          	addi	a5,a5,-2028 # 15b0 <base>
 da4:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 da6:	00001797          	auipc	a5,0x1
 daa:	80a78793          	addi	a5,a5,-2038 # 15b0 <base>
 dae:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 db2:	fe043783          	ld	a5,-32(s0)
 db6:	639c                	ld	a5,0(a5)
 db8:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 dbc:	fe843783          	ld	a5,-24(s0)
 dc0:	4798                	lw	a4,8(a5)
 dc2:	fdc42783          	lw	a5,-36(s0)
 dc6:	2781                	sext.w	a5,a5
 dc8:	06f76763          	bltu	a4,a5,e36 <malloc+0xf0>
      if(p->s.size == nunits)
 dcc:	fe843783          	ld	a5,-24(s0)
 dd0:	4798                	lw	a4,8(a5)
 dd2:	fdc42783          	lw	a5,-36(s0)
 dd6:	2781                	sext.w	a5,a5
 dd8:	00e79963          	bne	a5,a4,dea <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 ddc:	fe843783          	ld	a5,-24(s0)
 de0:	6398                	ld	a4,0(a5)
 de2:	fe043783          	ld	a5,-32(s0)
 de6:	e398                	sd	a4,0(a5)
 de8:	a825                	j	e20 <malloc+0xda>
      else {
        p->s.size -= nunits;
 dea:	fe843783          	ld	a5,-24(s0)
 dee:	479c                	lw	a5,8(a5)
 df0:	fdc42703          	lw	a4,-36(s0)
 df4:	9f99                	subw	a5,a5,a4
 df6:	0007871b          	sext.w	a4,a5
 dfa:	fe843783          	ld	a5,-24(s0)
 dfe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e00:	fe843783          	ld	a5,-24(s0)
 e04:	479c                	lw	a5,8(a5)
 e06:	1782                	slli	a5,a5,0x20
 e08:	9381                	srli	a5,a5,0x20
 e0a:	0792                	slli	a5,a5,0x4
 e0c:	fe843703          	ld	a4,-24(s0)
 e10:	97ba                	add	a5,a5,a4
 e12:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 e16:	fe843783          	ld	a5,-24(s0)
 e1a:	fdc42703          	lw	a4,-36(s0)
 e1e:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 e20:	00000797          	auipc	a5,0x0
 e24:	7a078793          	addi	a5,a5,1952 # 15c0 <freep>
 e28:	fe043703          	ld	a4,-32(s0)
 e2c:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 e2e:	fe843783          	ld	a5,-24(s0)
 e32:	07c1                	addi	a5,a5,16
 e34:	a091                	j	e78 <malloc+0x132>
    }
    if(p == freep)
 e36:	00000797          	auipc	a5,0x0
 e3a:	78a78793          	addi	a5,a5,1930 # 15c0 <freep>
 e3e:	639c                	ld	a5,0(a5)
 e40:	fe843703          	ld	a4,-24(s0)
 e44:	02f71063          	bne	a4,a5,e64 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 e48:	fdc42783          	lw	a5,-36(s0)
 e4c:	853e                	mv	a0,a5
 e4e:	00000097          	auipc	ra,0x0
 e52:	e78080e7          	jalr	-392(ra) # cc6 <morecore>
 e56:	fea43423          	sd	a0,-24(s0)
 e5a:	fe843783          	ld	a5,-24(s0)
 e5e:	e399                	bnez	a5,e64 <malloc+0x11e>
        return 0;
 e60:	4781                	li	a5,0
 e62:	a819                	j	e78 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e64:	fe843783          	ld	a5,-24(s0)
 e68:	fef43023          	sd	a5,-32(s0)
 e6c:	fe843783          	ld	a5,-24(s0)
 e70:	639c                	ld	a5,0(a5)
 e72:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e76:	b799                	j	dbc <malloc+0x76>
  }
}
 e78:	853e                	mv	a0,a5
 e7a:	70e2                	ld	ra,56(sp)
 e7c:	7442                	ld	s0,48(sp)
 e7e:	6121                	addi	sp,sp,64
 e80:	8082                	ret
