
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
   8:	87aa                	mv	a5,a0
   a:	fcb43023          	sd	a1,-64(s0)
   e:	fcf42623          	sw	a5,-52(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  12:	fe042023          	sw	zero,-32(s0)
  16:	fe042783          	lw	a5,-32(s0)
  1a:	fef42223          	sw	a5,-28(s0)
  1e:	fe442783          	lw	a5,-28(s0)
  22:	fef42423          	sw	a5,-24(s0)
  inword = 0;
  26:	fc042e23          	sw	zero,-36(s0)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2a:	a861                	j	c2 <wc+0xc2>
    for(i=0; i<n; i++){
  2c:	fe042623          	sw	zero,-20(s0)
  30:	a041                	j	b0 <wc+0xb0>
      c++;
  32:	fe042783          	lw	a5,-32(s0)
  36:	2785                	addiw	a5,a5,1
  38:	fef42023          	sw	a5,-32(s0)
      if(buf[i] == '\n')
  3c:	00001717          	auipc	a4,0x1
  40:	37470713          	addi	a4,a4,884 # 13b0 <buf>
  44:	fec42783          	lw	a5,-20(s0)
  48:	97ba                	add	a5,a5,a4
  4a:	0007c783          	lbu	a5,0(a5)
  4e:	873e                	mv	a4,a5
  50:	47a9                	li	a5,10
  52:	00f71763          	bne	a4,a5,60 <wc+0x60>
        l++;
  56:	fe842783          	lw	a5,-24(s0)
  5a:	2785                	addiw	a5,a5,1
  5c:	fef42423          	sw	a5,-24(s0)
      if(strchr(" \r\t\n\v", buf[i]))
  60:	00001717          	auipc	a4,0x1
  64:	35070713          	addi	a4,a4,848 # 13b0 <buf>
  68:	fec42783          	lw	a5,-20(s0)
  6c:	97ba                	add	a5,a5,a4
  6e:	0007c783          	lbu	a5,0(a5)
  72:	85be                	mv	a1,a5
  74:	00001517          	auipc	a0,0x1
  78:	ebc50513          	addi	a0,a0,-324 # f30 <malloc+0x144>
  7c:	00000097          	auipc	ra,0x0
  80:	30a080e7          	jalr	778(ra) # 386 <strchr>
  84:	87aa                	mv	a5,a0
  86:	c781                	beqz	a5,8e <wc+0x8e>
        inword = 0;
  88:	fc042e23          	sw	zero,-36(s0)
  8c:	a829                	j	a6 <wc+0xa6>
      else if(!inword){
  8e:	fdc42783          	lw	a5,-36(s0)
  92:	2781                	sext.w	a5,a5
  94:	eb89                	bnez	a5,a6 <wc+0xa6>
        w++;
  96:	fe442783          	lw	a5,-28(s0)
  9a:	2785                	addiw	a5,a5,1
  9c:	fef42223          	sw	a5,-28(s0)
        inword = 1;
  a0:	4785                	li	a5,1
  a2:	fcf42e23          	sw	a5,-36(s0)
    for(i=0; i<n; i++){
  a6:	fec42783          	lw	a5,-20(s0)
  aa:	2785                	addiw	a5,a5,1
  ac:	fef42623          	sw	a5,-20(s0)
  b0:	fec42783          	lw	a5,-20(s0)
  b4:	873e                	mv	a4,a5
  b6:	fd842783          	lw	a5,-40(s0)
  ba:	2701                	sext.w	a4,a4
  bc:	2781                	sext.w	a5,a5
  be:	f6f74ae3          	blt	a4,a5,32 <wc+0x32>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  c2:	fcc42783          	lw	a5,-52(s0)
  c6:	20000613          	li	a2,512
  ca:	00001597          	auipc	a1,0x1
  ce:	2e658593          	addi	a1,a1,742 # 13b0 <buf>
  d2:	853e                	mv	a0,a5
  d4:	00000097          	auipc	ra,0x0
  d8:	616080e7          	jalr	1558(ra) # 6ea <read>
  dc:	87aa                	mv	a5,a0
  de:	fcf42c23          	sw	a5,-40(s0)
  e2:	fd842783          	lw	a5,-40(s0)
  e6:	2781                	sext.w	a5,a5
  e8:	f4f042e3          	bgtz	a5,2c <wc+0x2c>
      }
    }
  }
  if(n < 0){
  ec:	fd842783          	lw	a5,-40(s0)
  f0:	2781                	sext.w	a5,a5
  f2:	0007df63          	bgez	a5,110 <wc+0x110>
    printf("wc: read error\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	e4250513          	addi	a0,a0,-446 # f38 <malloc+0x14c>
  fe:	00001097          	auipc	ra,0x1
 102:	afc080e7          	jalr	-1284(ra) # bfa <printf>
    exit(1);
 106:	4505                	li	a0,1
 108:	00000097          	auipc	ra,0x0
 10c:	5ca080e7          	jalr	1482(ra) # 6d2 <exit>
  }
  printf("%d %d %d %s\n", l, w, c, name);
 110:	fe042683          	lw	a3,-32(s0)
 114:	fe442603          	lw	a2,-28(s0)
 118:	fe842783          	lw	a5,-24(s0)
 11c:	fc043703          	ld	a4,-64(s0)
 120:	85be                	mv	a1,a5
 122:	00001517          	auipc	a0,0x1
 126:	e2650513          	addi	a0,a0,-474 # f48 <malloc+0x15c>
 12a:	00001097          	auipc	ra,0x1
 12e:	ad0080e7          	jalr	-1328(ra) # bfa <printf>
}
 132:	0001                	nop
 134:	70e2                	ld	ra,56(sp)
 136:	7442                	ld	s0,48(sp)
 138:	6121                	addi	sp,sp,64
 13a:	8082                	ret

000000000000013c <main>:

int
main(int argc, char *argv[])
{
 13c:	7179                	addi	sp,sp,-48
 13e:	f406                	sd	ra,40(sp)
 140:	f022                	sd	s0,32(sp)
 142:	1800                	addi	s0,sp,48
 144:	87aa                	mv	a5,a0
 146:	fcb43823          	sd	a1,-48(s0)
 14a:	fcf42e23          	sw	a5,-36(s0)
  int fd, i;

  if(argc <= 1){
 14e:	fdc42783          	lw	a5,-36(s0)
 152:	0007871b          	sext.w	a4,a5
 156:	4785                	li	a5,1
 158:	02e7c063          	blt	a5,a4,178 <main+0x3c>
    wc(0, "");
 15c:	00001597          	auipc	a1,0x1
 160:	dfc58593          	addi	a1,a1,-516 # f58 <malloc+0x16c>
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	e9a080e7          	jalr	-358(ra) # 0 <wc>
    exit(0);
 16e:	4501                	li	a0,0
 170:	00000097          	auipc	ra,0x0
 174:	562080e7          	jalr	1378(ra) # 6d2 <exit>
  }

  for(i = 1; i < argc; i++){
 178:	4785                	li	a5,1
 17a:	fef42623          	sw	a5,-20(s0)
 17e:	a071                	j	20a <main+0xce>
    if((fd = open(argv[i], 0)) < 0){
 180:	fec42783          	lw	a5,-20(s0)
 184:	078e                	slli	a5,a5,0x3
 186:	fd043703          	ld	a4,-48(s0)
 18a:	97ba                	add	a5,a5,a4
 18c:	639c                	ld	a5,0(a5)
 18e:	4581                	li	a1,0
 190:	853e                	mv	a0,a5
 192:	00000097          	auipc	ra,0x0
 196:	580080e7          	jalr	1408(ra) # 712 <open>
 19a:	87aa                	mv	a5,a0
 19c:	fef42423          	sw	a5,-24(s0)
 1a0:	fe842783          	lw	a5,-24(s0)
 1a4:	2781                	sext.w	a5,a5
 1a6:	0207d763          	bgez	a5,1d4 <main+0x98>
      printf("wc: cannot open %s\n", argv[i]);
 1aa:	fec42783          	lw	a5,-20(s0)
 1ae:	078e                	slli	a5,a5,0x3
 1b0:	fd043703          	ld	a4,-48(s0)
 1b4:	97ba                	add	a5,a5,a4
 1b6:	639c                	ld	a5,0(a5)
 1b8:	85be                	mv	a1,a5
 1ba:	00001517          	auipc	a0,0x1
 1be:	da650513          	addi	a0,a0,-602 # f60 <malloc+0x174>
 1c2:	00001097          	auipc	ra,0x1
 1c6:	a38080e7          	jalr	-1480(ra) # bfa <printf>
      exit(1);
 1ca:	4505                	li	a0,1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	506080e7          	jalr	1286(ra) # 6d2 <exit>
    }
    wc(fd, argv[i]);
 1d4:	fec42783          	lw	a5,-20(s0)
 1d8:	078e                	slli	a5,a5,0x3
 1da:	fd043703          	ld	a4,-48(s0)
 1de:	97ba                	add	a5,a5,a4
 1e0:	6398                	ld	a4,0(a5)
 1e2:	fe842783          	lw	a5,-24(s0)
 1e6:	85ba                	mv	a1,a4
 1e8:	853e                	mv	a0,a5
 1ea:	00000097          	auipc	ra,0x0
 1ee:	e16080e7          	jalr	-490(ra) # 0 <wc>
    close(fd);
 1f2:	fe842783          	lw	a5,-24(s0)
 1f6:	853e                	mv	a0,a5
 1f8:	00000097          	auipc	ra,0x0
 1fc:	502080e7          	jalr	1282(ra) # 6fa <close>
  for(i = 1; i < argc; i++){
 200:	fec42783          	lw	a5,-20(s0)
 204:	2785                	addiw	a5,a5,1
 206:	fef42623          	sw	a5,-20(s0)
 20a:	fec42783          	lw	a5,-20(s0)
 20e:	873e                	mv	a4,a5
 210:	fdc42783          	lw	a5,-36(s0)
 214:	2701                	sext.w	a4,a4
 216:	2781                	sext.w	a5,a5
 218:	f6f744e3          	blt	a4,a5,180 <main+0x44>
  }
  exit(0);
 21c:	4501                	li	a0,0
 21e:	00000097          	auipc	ra,0x0
 222:	4b4080e7          	jalr	1204(ra) # 6d2 <exit>

0000000000000226 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 22e:	00000097          	auipc	ra,0x0
 232:	f0e080e7          	jalr	-242(ra) # 13c <main>
  exit(0);
 236:	4501                	li	a0,0
 238:	00000097          	auipc	ra,0x0
 23c:	49a080e7          	jalr	1178(ra) # 6d2 <exit>

0000000000000240 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 240:	7179                	addi	sp,sp,-48
 242:	f422                	sd	s0,40(sp)
 244:	1800                	addi	s0,sp,48
 246:	fca43c23          	sd	a0,-40(s0)
 24a:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 24e:	fd843783          	ld	a5,-40(s0)
 252:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 256:	0001                	nop
 258:	fd043703          	ld	a4,-48(s0)
 25c:	00170793          	addi	a5,a4,1
 260:	fcf43823          	sd	a5,-48(s0)
 264:	fd843783          	ld	a5,-40(s0)
 268:	00178693          	addi	a3,a5,1
 26c:	fcd43c23          	sd	a3,-40(s0)
 270:	00074703          	lbu	a4,0(a4)
 274:	00e78023          	sb	a4,0(a5)
 278:	0007c783          	lbu	a5,0(a5)
 27c:	fff1                	bnez	a5,258 <strcpy+0x18>
    ;
  return os;
 27e:	fe843783          	ld	a5,-24(s0)
}
 282:	853e                	mv	a0,a5
 284:	7422                	ld	s0,40(sp)
 286:	6145                	addi	sp,sp,48
 288:	8082                	ret

000000000000028a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28a:	1101                	addi	sp,sp,-32
 28c:	ec22                	sd	s0,24(sp)
 28e:	1000                	addi	s0,sp,32
 290:	fea43423          	sd	a0,-24(s0)
 294:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 298:	a819                	j	2ae <strcmp+0x24>
    p++, q++;
 29a:	fe843783          	ld	a5,-24(s0)
 29e:	0785                	addi	a5,a5,1
 2a0:	fef43423          	sd	a5,-24(s0)
 2a4:	fe043783          	ld	a5,-32(s0)
 2a8:	0785                	addi	a5,a5,1
 2aa:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 2ae:	fe843783          	ld	a5,-24(s0)
 2b2:	0007c783          	lbu	a5,0(a5)
 2b6:	cb99                	beqz	a5,2cc <strcmp+0x42>
 2b8:	fe843783          	ld	a5,-24(s0)
 2bc:	0007c703          	lbu	a4,0(a5)
 2c0:	fe043783          	ld	a5,-32(s0)
 2c4:	0007c783          	lbu	a5,0(a5)
 2c8:	fcf709e3          	beq	a4,a5,29a <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 2cc:	fe843783          	ld	a5,-24(s0)
 2d0:	0007c783          	lbu	a5,0(a5)
 2d4:	0007871b          	sext.w	a4,a5
 2d8:	fe043783          	ld	a5,-32(s0)
 2dc:	0007c783          	lbu	a5,0(a5)
 2e0:	2781                	sext.w	a5,a5
 2e2:	40f707bb          	subw	a5,a4,a5
 2e6:	2781                	sext.w	a5,a5
}
 2e8:	853e                	mv	a0,a5
 2ea:	6462                	ld	s0,24(sp)
 2ec:	6105                	addi	sp,sp,32
 2ee:	8082                	ret

00000000000002f0 <strlen>:

uint
strlen(const char *s)
{
 2f0:	7179                	addi	sp,sp,-48
 2f2:	f422                	sd	s0,40(sp)
 2f4:	1800                	addi	s0,sp,48
 2f6:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 2fa:	fe042623          	sw	zero,-20(s0)
 2fe:	a031                	j	30a <strlen+0x1a>
 300:	fec42783          	lw	a5,-20(s0)
 304:	2785                	addiw	a5,a5,1
 306:	fef42623          	sw	a5,-20(s0)
 30a:	fec42783          	lw	a5,-20(s0)
 30e:	fd843703          	ld	a4,-40(s0)
 312:	97ba                	add	a5,a5,a4
 314:	0007c783          	lbu	a5,0(a5)
 318:	f7e5                	bnez	a5,300 <strlen+0x10>
    ;
  return n;
 31a:	fec42783          	lw	a5,-20(s0)
}
 31e:	853e                	mv	a0,a5
 320:	7422                	ld	s0,40(sp)
 322:	6145                	addi	sp,sp,48
 324:	8082                	ret

0000000000000326 <memset>:

void*
memset(void *dst, int c, uint n)
{
 326:	7179                	addi	sp,sp,-48
 328:	f422                	sd	s0,40(sp)
 32a:	1800                	addi	s0,sp,48
 32c:	fca43c23          	sd	a0,-40(s0)
 330:	87ae                	mv	a5,a1
 332:	8732                	mv	a4,a2
 334:	fcf42a23          	sw	a5,-44(s0)
 338:	87ba                	mv	a5,a4
 33a:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 33e:	fd843783          	ld	a5,-40(s0)
 342:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 346:	fe042623          	sw	zero,-20(s0)
 34a:	a00d                	j	36c <memset+0x46>
    cdst[i] = c;
 34c:	fec42783          	lw	a5,-20(s0)
 350:	fe043703          	ld	a4,-32(s0)
 354:	97ba                	add	a5,a5,a4
 356:	fd442703          	lw	a4,-44(s0)
 35a:	0ff77713          	zext.b	a4,a4
 35e:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 362:	fec42783          	lw	a5,-20(s0)
 366:	2785                	addiw	a5,a5,1
 368:	fef42623          	sw	a5,-20(s0)
 36c:	fec42703          	lw	a4,-20(s0)
 370:	fd042783          	lw	a5,-48(s0)
 374:	2781                	sext.w	a5,a5
 376:	fcf76be3          	bltu	a4,a5,34c <memset+0x26>
  }
  return dst;
 37a:	fd843783          	ld	a5,-40(s0)
}
 37e:	853e                	mv	a0,a5
 380:	7422                	ld	s0,40(sp)
 382:	6145                	addi	sp,sp,48
 384:	8082                	ret

0000000000000386 <strchr>:

char*
strchr(const char *s, char c)
{
 386:	1101                	addi	sp,sp,-32
 388:	ec22                	sd	s0,24(sp)
 38a:	1000                	addi	s0,sp,32
 38c:	fea43423          	sd	a0,-24(s0)
 390:	87ae                	mv	a5,a1
 392:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 396:	a01d                	j	3bc <strchr+0x36>
    if(*s == c)
 398:	fe843783          	ld	a5,-24(s0)
 39c:	0007c703          	lbu	a4,0(a5)
 3a0:	fe744783          	lbu	a5,-25(s0)
 3a4:	0ff7f793          	zext.b	a5,a5
 3a8:	00e79563          	bne	a5,a4,3b2 <strchr+0x2c>
      return (char*)s;
 3ac:	fe843783          	ld	a5,-24(s0)
 3b0:	a821                	j	3c8 <strchr+0x42>
  for(; *s; s++)
 3b2:	fe843783          	ld	a5,-24(s0)
 3b6:	0785                	addi	a5,a5,1
 3b8:	fef43423          	sd	a5,-24(s0)
 3bc:	fe843783          	ld	a5,-24(s0)
 3c0:	0007c783          	lbu	a5,0(a5)
 3c4:	fbf1                	bnez	a5,398 <strchr+0x12>
  return 0;
 3c6:	4781                	li	a5,0
}
 3c8:	853e                	mv	a0,a5
 3ca:	6462                	ld	s0,24(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret

00000000000003d0 <gets>:

char*
gets(char *buf, int max)
{
 3d0:	7179                	addi	sp,sp,-48
 3d2:	f406                	sd	ra,40(sp)
 3d4:	f022                	sd	s0,32(sp)
 3d6:	1800                	addi	s0,sp,48
 3d8:	fca43c23          	sd	a0,-40(s0)
 3dc:	87ae                	mv	a5,a1
 3de:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e2:	fe042623          	sw	zero,-20(s0)
 3e6:	a8a1                	j	43e <gets+0x6e>
    cc = read(0, &c, 1);
 3e8:	fe740793          	addi	a5,s0,-25
 3ec:	4605                	li	a2,1
 3ee:	85be                	mv	a1,a5
 3f0:	4501                	li	a0,0
 3f2:	00000097          	auipc	ra,0x0
 3f6:	2f8080e7          	jalr	760(ra) # 6ea <read>
 3fa:	87aa                	mv	a5,a0
 3fc:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 400:	fe842783          	lw	a5,-24(s0)
 404:	2781                	sext.w	a5,a5
 406:	04f05763          	blez	a5,454 <gets+0x84>
      break;
    buf[i++] = c;
 40a:	fec42783          	lw	a5,-20(s0)
 40e:	0017871b          	addiw	a4,a5,1
 412:	fee42623          	sw	a4,-20(s0)
 416:	873e                	mv	a4,a5
 418:	fd843783          	ld	a5,-40(s0)
 41c:	97ba                	add	a5,a5,a4
 41e:	fe744703          	lbu	a4,-25(s0)
 422:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 426:	fe744783          	lbu	a5,-25(s0)
 42a:	873e                	mv	a4,a5
 42c:	47a9                	li	a5,10
 42e:	02f70463          	beq	a4,a5,456 <gets+0x86>
 432:	fe744783          	lbu	a5,-25(s0)
 436:	873e                	mv	a4,a5
 438:	47b5                	li	a5,13
 43a:	00f70e63          	beq	a4,a5,456 <gets+0x86>
  for(i=0; i+1 < max; ){
 43e:	fec42783          	lw	a5,-20(s0)
 442:	2785                	addiw	a5,a5,1
 444:	0007871b          	sext.w	a4,a5
 448:	fd442783          	lw	a5,-44(s0)
 44c:	2781                	sext.w	a5,a5
 44e:	f8f74de3          	blt	a4,a5,3e8 <gets+0x18>
 452:	a011                	j	456 <gets+0x86>
      break;
 454:	0001                	nop
      break;
  }
  buf[i] = '\0';
 456:	fec42783          	lw	a5,-20(s0)
 45a:	fd843703          	ld	a4,-40(s0)
 45e:	97ba                	add	a5,a5,a4
 460:	00078023          	sb	zero,0(a5)
  return buf;
 464:	fd843783          	ld	a5,-40(s0)
}
 468:	853e                	mv	a0,a5
 46a:	70a2                	ld	ra,40(sp)
 46c:	7402                	ld	s0,32(sp)
 46e:	6145                	addi	sp,sp,48
 470:	8082                	ret

0000000000000472 <stat>:

int
stat(const char *n, struct stat *st)
{
 472:	7179                	addi	sp,sp,-48
 474:	f406                	sd	ra,40(sp)
 476:	f022                	sd	s0,32(sp)
 478:	1800                	addi	s0,sp,48
 47a:	fca43c23          	sd	a0,-40(s0)
 47e:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 482:	4581                	li	a1,0
 484:	fd843503          	ld	a0,-40(s0)
 488:	00000097          	auipc	ra,0x0
 48c:	28a080e7          	jalr	650(ra) # 712 <open>
 490:	87aa                	mv	a5,a0
 492:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 496:	fec42783          	lw	a5,-20(s0)
 49a:	2781                	sext.w	a5,a5
 49c:	0007d463          	bgez	a5,4a4 <stat+0x32>
    return -1;
 4a0:	57fd                	li	a5,-1
 4a2:	a035                	j	4ce <stat+0x5c>
  r = fstat(fd, st);
 4a4:	fec42783          	lw	a5,-20(s0)
 4a8:	fd043583          	ld	a1,-48(s0)
 4ac:	853e                	mv	a0,a5
 4ae:	00000097          	auipc	ra,0x0
 4b2:	27c080e7          	jalr	636(ra) # 72a <fstat>
 4b6:	87aa                	mv	a5,a0
 4b8:	fef42423          	sw	a5,-24(s0)
  close(fd);
 4bc:	fec42783          	lw	a5,-20(s0)
 4c0:	853e                	mv	a0,a5
 4c2:	00000097          	auipc	ra,0x0
 4c6:	238080e7          	jalr	568(ra) # 6fa <close>
  return r;
 4ca:	fe842783          	lw	a5,-24(s0)
}
 4ce:	853e                	mv	a0,a5
 4d0:	70a2                	ld	ra,40(sp)
 4d2:	7402                	ld	s0,32(sp)
 4d4:	6145                	addi	sp,sp,48
 4d6:	8082                	ret

00000000000004d8 <atoi>:

int
atoi(const char *s)
{
 4d8:	7179                	addi	sp,sp,-48
 4da:	f422                	sd	s0,40(sp)
 4dc:	1800                	addi	s0,sp,48
 4de:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 4e2:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 4e6:	a81d                	j	51c <atoi+0x44>
    n = n*10 + *s++ - '0';
 4e8:	fec42783          	lw	a5,-20(s0)
 4ec:	873e                	mv	a4,a5
 4ee:	87ba                	mv	a5,a4
 4f0:	0027979b          	slliw	a5,a5,0x2
 4f4:	9fb9                	addw	a5,a5,a4
 4f6:	0017979b          	slliw	a5,a5,0x1
 4fa:	0007871b          	sext.w	a4,a5
 4fe:	fd843783          	ld	a5,-40(s0)
 502:	00178693          	addi	a3,a5,1
 506:	fcd43c23          	sd	a3,-40(s0)
 50a:	0007c783          	lbu	a5,0(a5)
 50e:	2781                	sext.w	a5,a5
 510:	9fb9                	addw	a5,a5,a4
 512:	2781                	sext.w	a5,a5
 514:	fd07879b          	addiw	a5,a5,-48
 518:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 51c:	fd843783          	ld	a5,-40(s0)
 520:	0007c783          	lbu	a5,0(a5)
 524:	873e                	mv	a4,a5
 526:	02f00793          	li	a5,47
 52a:	00e7fb63          	bgeu	a5,a4,540 <atoi+0x68>
 52e:	fd843783          	ld	a5,-40(s0)
 532:	0007c783          	lbu	a5,0(a5)
 536:	873e                	mv	a4,a5
 538:	03900793          	li	a5,57
 53c:	fae7f6e3          	bgeu	a5,a4,4e8 <atoi+0x10>
  return n;
 540:	fec42783          	lw	a5,-20(s0)
}
 544:	853e                	mv	a0,a5
 546:	7422                	ld	s0,40(sp)
 548:	6145                	addi	sp,sp,48
 54a:	8082                	ret

000000000000054c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 54c:	7139                	addi	sp,sp,-64
 54e:	fc22                	sd	s0,56(sp)
 550:	0080                	addi	s0,sp,64
 552:	fca43c23          	sd	a0,-40(s0)
 556:	fcb43823          	sd	a1,-48(s0)
 55a:	87b2                	mv	a5,a2
 55c:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 560:	fd843783          	ld	a5,-40(s0)
 564:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 568:	fd043783          	ld	a5,-48(s0)
 56c:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 570:	fe043703          	ld	a4,-32(s0)
 574:	fe843783          	ld	a5,-24(s0)
 578:	02e7fc63          	bgeu	a5,a4,5b0 <memmove+0x64>
    while(n-- > 0)
 57c:	a00d                	j	59e <memmove+0x52>
      *dst++ = *src++;
 57e:	fe043703          	ld	a4,-32(s0)
 582:	00170793          	addi	a5,a4,1
 586:	fef43023          	sd	a5,-32(s0)
 58a:	fe843783          	ld	a5,-24(s0)
 58e:	00178693          	addi	a3,a5,1
 592:	fed43423          	sd	a3,-24(s0)
 596:	00074703          	lbu	a4,0(a4)
 59a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 59e:	fcc42783          	lw	a5,-52(s0)
 5a2:	fff7871b          	addiw	a4,a5,-1
 5a6:	fce42623          	sw	a4,-52(s0)
 5aa:	fcf04ae3          	bgtz	a5,57e <memmove+0x32>
 5ae:	a891                	j	602 <memmove+0xb6>
  } else {
    dst += n;
 5b0:	fcc42783          	lw	a5,-52(s0)
 5b4:	fe843703          	ld	a4,-24(s0)
 5b8:	97ba                	add	a5,a5,a4
 5ba:	fef43423          	sd	a5,-24(s0)
    src += n;
 5be:	fcc42783          	lw	a5,-52(s0)
 5c2:	fe043703          	ld	a4,-32(s0)
 5c6:	97ba                	add	a5,a5,a4
 5c8:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 5cc:	a01d                	j	5f2 <memmove+0xa6>
      *--dst = *--src;
 5ce:	fe043783          	ld	a5,-32(s0)
 5d2:	17fd                	addi	a5,a5,-1
 5d4:	fef43023          	sd	a5,-32(s0)
 5d8:	fe843783          	ld	a5,-24(s0)
 5dc:	17fd                	addi	a5,a5,-1
 5de:	fef43423          	sd	a5,-24(s0)
 5e2:	fe043783          	ld	a5,-32(s0)
 5e6:	0007c703          	lbu	a4,0(a5)
 5ea:	fe843783          	ld	a5,-24(s0)
 5ee:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 5f2:	fcc42783          	lw	a5,-52(s0)
 5f6:	fff7871b          	addiw	a4,a5,-1
 5fa:	fce42623          	sw	a4,-52(s0)
 5fe:	fcf048e3          	bgtz	a5,5ce <memmove+0x82>
  }
  return vdst;
 602:	fd843783          	ld	a5,-40(s0)
}
 606:	853e                	mv	a0,a5
 608:	7462                	ld	s0,56(sp)
 60a:	6121                	addi	sp,sp,64
 60c:	8082                	ret

000000000000060e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 60e:	7139                	addi	sp,sp,-64
 610:	fc22                	sd	s0,56(sp)
 612:	0080                	addi	s0,sp,64
 614:	fca43c23          	sd	a0,-40(s0)
 618:	fcb43823          	sd	a1,-48(s0)
 61c:	87b2                	mv	a5,a2
 61e:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 622:	fd843783          	ld	a5,-40(s0)
 626:	fef43423          	sd	a5,-24(s0)
 62a:	fd043783          	ld	a5,-48(s0)
 62e:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 632:	a0a1                	j	67a <memcmp+0x6c>
    if (*p1 != *p2) {
 634:	fe843783          	ld	a5,-24(s0)
 638:	0007c703          	lbu	a4,0(a5)
 63c:	fe043783          	ld	a5,-32(s0)
 640:	0007c783          	lbu	a5,0(a5)
 644:	02f70163          	beq	a4,a5,666 <memcmp+0x58>
      return *p1 - *p2;
 648:	fe843783          	ld	a5,-24(s0)
 64c:	0007c783          	lbu	a5,0(a5)
 650:	0007871b          	sext.w	a4,a5
 654:	fe043783          	ld	a5,-32(s0)
 658:	0007c783          	lbu	a5,0(a5)
 65c:	2781                	sext.w	a5,a5
 65e:	40f707bb          	subw	a5,a4,a5
 662:	2781                	sext.w	a5,a5
 664:	a01d                	j	68a <memcmp+0x7c>
    }
    p1++;
 666:	fe843783          	ld	a5,-24(s0)
 66a:	0785                	addi	a5,a5,1
 66c:	fef43423          	sd	a5,-24(s0)
    p2++;
 670:	fe043783          	ld	a5,-32(s0)
 674:	0785                	addi	a5,a5,1
 676:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 67a:	fcc42783          	lw	a5,-52(s0)
 67e:	fff7871b          	addiw	a4,a5,-1
 682:	fce42623          	sw	a4,-52(s0)
 686:	f7dd                	bnez	a5,634 <memcmp+0x26>
  }
  return 0;
 688:	4781                	li	a5,0
}
 68a:	853e                	mv	a0,a5
 68c:	7462                	ld	s0,56(sp)
 68e:	6121                	addi	sp,sp,64
 690:	8082                	ret

0000000000000692 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 692:	7179                	addi	sp,sp,-48
 694:	f406                	sd	ra,40(sp)
 696:	f022                	sd	s0,32(sp)
 698:	1800                	addi	s0,sp,48
 69a:	fea43423          	sd	a0,-24(s0)
 69e:	feb43023          	sd	a1,-32(s0)
 6a2:	87b2                	mv	a5,a2
 6a4:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 6a8:	fdc42783          	lw	a5,-36(s0)
 6ac:	863e                	mv	a2,a5
 6ae:	fe043583          	ld	a1,-32(s0)
 6b2:	fe843503          	ld	a0,-24(s0)
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e96080e7          	jalr	-362(ra) # 54c <memmove>
 6be:	87aa                	mv	a5,a0
}
 6c0:	853e                	mv	a0,a5
 6c2:	70a2                	ld	ra,40(sp)
 6c4:	7402                	ld	s0,32(sp)
 6c6:	6145                	addi	sp,sp,48
 6c8:	8082                	ret

00000000000006ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ca:	4885                	li	a7,1
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6d2:	4889                	li	a7,2
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <wait>:
.global wait
wait:
 li a7, SYS_wait
 6da:	488d                	li	a7,3
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6e2:	4891                	li	a7,4
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <read>:
.global read
read:
 li a7, SYS_read
 6ea:	4895                	li	a7,5
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <write>:
.global write
write:
 li a7, SYS_write
 6f2:	48c1                	li	a7,16
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <close>:
.global close
close:
 li a7, SYS_close
 6fa:	48d5                	li	a7,21
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <kill>:
.global kill
kill:
 li a7, SYS_kill
 702:	4899                	li	a7,6
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <exec>:
.global exec
exec:
 li a7, SYS_exec
 70a:	489d                	li	a7,7
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <open>:
.global open
open:
 li a7, SYS_open
 712:	48bd                	li	a7,15
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 71a:	48c5                	li	a7,17
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 722:	48c9                	li	a7,18
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 72a:	48a1                	li	a7,8
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <link>:
.global link
link:
 li a7, SYS_link
 732:	48cd                	li	a7,19
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 73a:	48d1                	li	a7,20
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 742:	48a5                	li	a7,9
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <dup>:
.global dup
dup:
 li a7, SYS_dup
 74a:	48a9                	li	a7,10
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 752:	48ad                	li	a7,11
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 75a:	48b1                	li	a7,12
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 762:	48b5                	li	a7,13
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 76a:	48b9                	li	a7,14
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 772:	1101                	addi	sp,sp,-32
 774:	ec06                	sd	ra,24(sp)
 776:	e822                	sd	s0,16(sp)
 778:	1000                	addi	s0,sp,32
 77a:	87aa                	mv	a5,a0
 77c:	872e                	mv	a4,a1
 77e:	fef42623          	sw	a5,-20(s0)
 782:	87ba                	mv	a5,a4
 784:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 788:	feb40713          	addi	a4,s0,-21
 78c:	fec42783          	lw	a5,-20(s0)
 790:	4605                	li	a2,1
 792:	85ba                	mv	a1,a4
 794:	853e                	mv	a0,a5
 796:	00000097          	auipc	ra,0x0
 79a:	f5c080e7          	jalr	-164(ra) # 6f2 <write>
}
 79e:	0001                	nop
 7a0:	60e2                	ld	ra,24(sp)
 7a2:	6442                	ld	s0,16(sp)
 7a4:	6105                	addi	sp,sp,32
 7a6:	8082                	ret

00000000000007a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7a8:	7139                	addi	sp,sp,-64
 7aa:	fc06                	sd	ra,56(sp)
 7ac:	f822                	sd	s0,48(sp)
 7ae:	0080                	addi	s0,sp,64
 7b0:	87aa                	mv	a5,a0
 7b2:	8736                	mv	a4,a3
 7b4:	fcf42623          	sw	a5,-52(s0)
 7b8:	87ae                	mv	a5,a1
 7ba:	fcf42423          	sw	a5,-56(s0)
 7be:	87b2                	mv	a5,a2
 7c0:	fcf42223          	sw	a5,-60(s0)
 7c4:	87ba                	mv	a5,a4
 7c6:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7ca:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 7ce:	fc042783          	lw	a5,-64(s0)
 7d2:	2781                	sext.w	a5,a5
 7d4:	c38d                	beqz	a5,7f6 <printint+0x4e>
 7d6:	fc842783          	lw	a5,-56(s0)
 7da:	2781                	sext.w	a5,a5
 7dc:	0007dd63          	bgez	a5,7f6 <printint+0x4e>
    neg = 1;
 7e0:	4785                	li	a5,1
 7e2:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 7e6:	fc842783          	lw	a5,-56(s0)
 7ea:	40f007bb          	negw	a5,a5
 7ee:	2781                	sext.w	a5,a5
 7f0:	fef42223          	sw	a5,-28(s0)
 7f4:	a029                	j	7fe <printint+0x56>
  } else {
    x = xx;
 7f6:	fc842783          	lw	a5,-56(s0)
 7fa:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 7fe:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 802:	fc442783          	lw	a5,-60(s0)
 806:	fe442703          	lw	a4,-28(s0)
 80a:	02f777bb          	remuw	a5,a4,a5
 80e:	0007861b          	sext.w	a2,a5
 812:	fec42783          	lw	a5,-20(s0)
 816:	0017871b          	addiw	a4,a5,1
 81a:	fee42623          	sw	a4,-20(s0)
 81e:	00001697          	auipc	a3,0x1
 822:	b7268693          	addi	a3,a3,-1166 # 1390 <digits>
 826:	02061713          	slli	a4,a2,0x20
 82a:	9301                	srli	a4,a4,0x20
 82c:	9736                	add	a4,a4,a3
 82e:	00074703          	lbu	a4,0(a4)
 832:	17c1                	addi	a5,a5,-16
 834:	97a2                	add	a5,a5,s0
 836:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 83a:	fc442783          	lw	a5,-60(s0)
 83e:	fe442703          	lw	a4,-28(s0)
 842:	02f757bb          	divuw	a5,a4,a5
 846:	fef42223          	sw	a5,-28(s0)
 84a:	fe442783          	lw	a5,-28(s0)
 84e:	2781                	sext.w	a5,a5
 850:	fbcd                	bnez	a5,802 <printint+0x5a>
  if(neg)
 852:	fe842783          	lw	a5,-24(s0)
 856:	2781                	sext.w	a5,a5
 858:	cf85                	beqz	a5,890 <printint+0xe8>
    buf[i++] = '-';
 85a:	fec42783          	lw	a5,-20(s0)
 85e:	0017871b          	addiw	a4,a5,1
 862:	fee42623          	sw	a4,-20(s0)
 866:	17c1                	addi	a5,a5,-16
 868:	97a2                	add	a5,a5,s0
 86a:	02d00713          	li	a4,45
 86e:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 872:	a839                	j	890 <printint+0xe8>
    putc(fd, buf[i]);
 874:	fec42783          	lw	a5,-20(s0)
 878:	17c1                	addi	a5,a5,-16
 87a:	97a2                	add	a5,a5,s0
 87c:	fe07c703          	lbu	a4,-32(a5)
 880:	fcc42783          	lw	a5,-52(s0)
 884:	85ba                	mv	a1,a4
 886:	853e                	mv	a0,a5
 888:	00000097          	auipc	ra,0x0
 88c:	eea080e7          	jalr	-278(ra) # 772 <putc>
  while(--i >= 0)
 890:	fec42783          	lw	a5,-20(s0)
 894:	37fd                	addiw	a5,a5,-1
 896:	fef42623          	sw	a5,-20(s0)
 89a:	fec42783          	lw	a5,-20(s0)
 89e:	2781                	sext.w	a5,a5
 8a0:	fc07dae3          	bgez	a5,874 <printint+0xcc>
}
 8a4:	0001                	nop
 8a6:	0001                	nop
 8a8:	70e2                	ld	ra,56(sp)
 8aa:	7442                	ld	s0,48(sp)
 8ac:	6121                	addi	sp,sp,64
 8ae:	8082                	ret

00000000000008b0 <printptr>:

static void
printptr(int fd, uint64 x) {
 8b0:	7179                	addi	sp,sp,-48
 8b2:	f406                	sd	ra,40(sp)
 8b4:	f022                	sd	s0,32(sp)
 8b6:	1800                	addi	s0,sp,48
 8b8:	87aa                	mv	a5,a0
 8ba:	fcb43823          	sd	a1,-48(s0)
 8be:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 8c2:	fdc42783          	lw	a5,-36(s0)
 8c6:	03000593          	li	a1,48
 8ca:	853e                	mv	a0,a5
 8cc:	00000097          	auipc	ra,0x0
 8d0:	ea6080e7          	jalr	-346(ra) # 772 <putc>
  putc(fd, 'x');
 8d4:	fdc42783          	lw	a5,-36(s0)
 8d8:	07800593          	li	a1,120
 8dc:	853e                	mv	a0,a5
 8de:	00000097          	auipc	ra,0x0
 8e2:	e94080e7          	jalr	-364(ra) # 772 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8e6:	fe042623          	sw	zero,-20(s0)
 8ea:	a82d                	j	924 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8ec:	fd043783          	ld	a5,-48(s0)
 8f0:	93f1                	srli	a5,a5,0x3c
 8f2:	00001717          	auipc	a4,0x1
 8f6:	a9e70713          	addi	a4,a4,-1378 # 1390 <digits>
 8fa:	97ba                	add	a5,a5,a4
 8fc:	0007c703          	lbu	a4,0(a5)
 900:	fdc42783          	lw	a5,-36(s0)
 904:	85ba                	mv	a1,a4
 906:	853e                	mv	a0,a5
 908:	00000097          	auipc	ra,0x0
 90c:	e6a080e7          	jalr	-406(ra) # 772 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 910:	fec42783          	lw	a5,-20(s0)
 914:	2785                	addiw	a5,a5,1
 916:	fef42623          	sw	a5,-20(s0)
 91a:	fd043783          	ld	a5,-48(s0)
 91e:	0792                	slli	a5,a5,0x4
 920:	fcf43823          	sd	a5,-48(s0)
 924:	fec42783          	lw	a5,-20(s0)
 928:	873e                	mv	a4,a5
 92a:	47bd                	li	a5,15
 92c:	fce7f0e3          	bgeu	a5,a4,8ec <printptr+0x3c>
}
 930:	0001                	nop
 932:	0001                	nop
 934:	70a2                	ld	ra,40(sp)
 936:	7402                	ld	s0,32(sp)
 938:	6145                	addi	sp,sp,48
 93a:	8082                	ret

000000000000093c <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 93c:	715d                	addi	sp,sp,-80
 93e:	e486                	sd	ra,72(sp)
 940:	e0a2                	sd	s0,64(sp)
 942:	0880                	addi	s0,sp,80
 944:	87aa                	mv	a5,a0
 946:	fcb43023          	sd	a1,-64(s0)
 94a:	fac43c23          	sd	a2,-72(s0)
 94e:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 952:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 956:	fe042223          	sw	zero,-28(s0)
 95a:	a42d                	j	b84 <vprintf+0x248>
    c = fmt[i] & 0xff;
 95c:	fe442783          	lw	a5,-28(s0)
 960:	fc043703          	ld	a4,-64(s0)
 964:	97ba                	add	a5,a5,a4
 966:	0007c783          	lbu	a5,0(a5)
 96a:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 96e:	fe042783          	lw	a5,-32(s0)
 972:	2781                	sext.w	a5,a5
 974:	eb9d                	bnez	a5,9aa <vprintf+0x6e>
      if(c == '%'){
 976:	fdc42783          	lw	a5,-36(s0)
 97a:	0007871b          	sext.w	a4,a5
 97e:	02500793          	li	a5,37
 982:	00f71763          	bne	a4,a5,990 <vprintf+0x54>
        state = '%';
 986:	02500793          	li	a5,37
 98a:	fef42023          	sw	a5,-32(s0)
 98e:	a2f5                	j	b7a <vprintf+0x23e>
      } else {
        putc(fd, c);
 990:	fdc42783          	lw	a5,-36(s0)
 994:	0ff7f713          	zext.b	a4,a5
 998:	fcc42783          	lw	a5,-52(s0)
 99c:	85ba                	mv	a1,a4
 99e:	853e                	mv	a0,a5
 9a0:	00000097          	auipc	ra,0x0
 9a4:	dd2080e7          	jalr	-558(ra) # 772 <putc>
 9a8:	aac9                	j	b7a <vprintf+0x23e>
      }
    } else if(state == '%'){
 9aa:	fe042783          	lw	a5,-32(s0)
 9ae:	0007871b          	sext.w	a4,a5
 9b2:	02500793          	li	a5,37
 9b6:	1cf71263          	bne	a4,a5,b7a <vprintf+0x23e>
      if(c == 'd'){
 9ba:	fdc42783          	lw	a5,-36(s0)
 9be:	0007871b          	sext.w	a4,a5
 9c2:	06400793          	li	a5,100
 9c6:	02f71463          	bne	a4,a5,9ee <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 9ca:	fb843783          	ld	a5,-72(s0)
 9ce:	00878713          	addi	a4,a5,8
 9d2:	fae43c23          	sd	a4,-72(s0)
 9d6:	4398                	lw	a4,0(a5)
 9d8:	fcc42783          	lw	a5,-52(s0)
 9dc:	4685                	li	a3,1
 9de:	4629                	li	a2,10
 9e0:	85ba                	mv	a1,a4
 9e2:	853e                	mv	a0,a5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	dc4080e7          	jalr	-572(ra) # 7a8 <printint>
 9ec:	a269                	j	b76 <vprintf+0x23a>
      } else if(c == 'l') {
 9ee:	fdc42783          	lw	a5,-36(s0)
 9f2:	0007871b          	sext.w	a4,a5
 9f6:	06c00793          	li	a5,108
 9fa:	02f71663          	bne	a4,a5,a26 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9fe:	fb843783          	ld	a5,-72(s0)
 a02:	00878713          	addi	a4,a5,8
 a06:	fae43c23          	sd	a4,-72(s0)
 a0a:	639c                	ld	a5,0(a5)
 a0c:	0007871b          	sext.w	a4,a5
 a10:	fcc42783          	lw	a5,-52(s0)
 a14:	4681                	li	a3,0
 a16:	4629                	li	a2,10
 a18:	85ba                	mv	a1,a4
 a1a:	853e                	mv	a0,a5
 a1c:	00000097          	auipc	ra,0x0
 a20:	d8c080e7          	jalr	-628(ra) # 7a8 <printint>
 a24:	aa89                	j	b76 <vprintf+0x23a>
      } else if(c == 'x') {
 a26:	fdc42783          	lw	a5,-36(s0)
 a2a:	0007871b          	sext.w	a4,a5
 a2e:	07800793          	li	a5,120
 a32:	02f71463          	bne	a4,a5,a5a <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 a36:	fb843783          	ld	a5,-72(s0)
 a3a:	00878713          	addi	a4,a5,8
 a3e:	fae43c23          	sd	a4,-72(s0)
 a42:	4398                	lw	a4,0(a5)
 a44:	fcc42783          	lw	a5,-52(s0)
 a48:	4681                	li	a3,0
 a4a:	4641                	li	a2,16
 a4c:	85ba                	mv	a1,a4
 a4e:	853e                	mv	a0,a5
 a50:	00000097          	auipc	ra,0x0
 a54:	d58080e7          	jalr	-680(ra) # 7a8 <printint>
 a58:	aa39                	j	b76 <vprintf+0x23a>
      } else if(c == 'p') {
 a5a:	fdc42783          	lw	a5,-36(s0)
 a5e:	0007871b          	sext.w	a4,a5
 a62:	07000793          	li	a5,112
 a66:	02f71263          	bne	a4,a5,a8a <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 a6a:	fb843783          	ld	a5,-72(s0)
 a6e:	00878713          	addi	a4,a5,8
 a72:	fae43c23          	sd	a4,-72(s0)
 a76:	6398                	ld	a4,0(a5)
 a78:	fcc42783          	lw	a5,-52(s0)
 a7c:	85ba                	mv	a1,a4
 a7e:	853e                	mv	a0,a5
 a80:	00000097          	auipc	ra,0x0
 a84:	e30080e7          	jalr	-464(ra) # 8b0 <printptr>
 a88:	a0fd                	j	b76 <vprintf+0x23a>
      } else if(c == 's'){
 a8a:	fdc42783          	lw	a5,-36(s0)
 a8e:	0007871b          	sext.w	a4,a5
 a92:	07300793          	li	a5,115
 a96:	04f71c63          	bne	a4,a5,aee <vprintf+0x1b2>
        s = va_arg(ap, char*);
 a9a:	fb843783          	ld	a5,-72(s0)
 a9e:	00878713          	addi	a4,a5,8
 aa2:	fae43c23          	sd	a4,-72(s0)
 aa6:	639c                	ld	a5,0(a5)
 aa8:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 aac:	fe843783          	ld	a5,-24(s0)
 ab0:	eb8d                	bnez	a5,ae2 <vprintf+0x1a6>
          s = "(null)";
 ab2:	00000797          	auipc	a5,0x0
 ab6:	4c678793          	addi	a5,a5,1222 # f78 <malloc+0x18c>
 aba:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 abe:	a015                	j	ae2 <vprintf+0x1a6>
          putc(fd, *s);
 ac0:	fe843783          	ld	a5,-24(s0)
 ac4:	0007c703          	lbu	a4,0(a5)
 ac8:	fcc42783          	lw	a5,-52(s0)
 acc:	85ba                	mv	a1,a4
 ace:	853e                	mv	a0,a5
 ad0:	00000097          	auipc	ra,0x0
 ad4:	ca2080e7          	jalr	-862(ra) # 772 <putc>
          s++;
 ad8:	fe843783          	ld	a5,-24(s0)
 adc:	0785                	addi	a5,a5,1
 ade:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 ae2:	fe843783          	ld	a5,-24(s0)
 ae6:	0007c783          	lbu	a5,0(a5)
 aea:	fbf9                	bnez	a5,ac0 <vprintf+0x184>
 aec:	a069                	j	b76 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 aee:	fdc42783          	lw	a5,-36(s0)
 af2:	0007871b          	sext.w	a4,a5
 af6:	06300793          	li	a5,99
 afa:	02f71463          	bne	a4,a5,b22 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 afe:	fb843783          	ld	a5,-72(s0)
 b02:	00878713          	addi	a4,a5,8
 b06:	fae43c23          	sd	a4,-72(s0)
 b0a:	439c                	lw	a5,0(a5)
 b0c:	0ff7f713          	zext.b	a4,a5
 b10:	fcc42783          	lw	a5,-52(s0)
 b14:	85ba                	mv	a1,a4
 b16:	853e                	mv	a0,a5
 b18:	00000097          	auipc	ra,0x0
 b1c:	c5a080e7          	jalr	-934(ra) # 772 <putc>
 b20:	a899                	j	b76 <vprintf+0x23a>
      } else if(c == '%'){
 b22:	fdc42783          	lw	a5,-36(s0)
 b26:	0007871b          	sext.w	a4,a5
 b2a:	02500793          	li	a5,37
 b2e:	00f71f63          	bne	a4,a5,b4c <vprintf+0x210>
        putc(fd, c);
 b32:	fdc42783          	lw	a5,-36(s0)
 b36:	0ff7f713          	zext.b	a4,a5
 b3a:	fcc42783          	lw	a5,-52(s0)
 b3e:	85ba                	mv	a1,a4
 b40:	853e                	mv	a0,a5
 b42:	00000097          	auipc	ra,0x0
 b46:	c30080e7          	jalr	-976(ra) # 772 <putc>
 b4a:	a035                	j	b76 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b4c:	fcc42783          	lw	a5,-52(s0)
 b50:	02500593          	li	a1,37
 b54:	853e                	mv	a0,a5
 b56:	00000097          	auipc	ra,0x0
 b5a:	c1c080e7          	jalr	-996(ra) # 772 <putc>
        putc(fd, c);
 b5e:	fdc42783          	lw	a5,-36(s0)
 b62:	0ff7f713          	zext.b	a4,a5
 b66:	fcc42783          	lw	a5,-52(s0)
 b6a:	85ba                	mv	a1,a4
 b6c:	853e                	mv	a0,a5
 b6e:	00000097          	auipc	ra,0x0
 b72:	c04080e7          	jalr	-1020(ra) # 772 <putc>
      }
      state = 0;
 b76:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 b7a:	fe442783          	lw	a5,-28(s0)
 b7e:	2785                	addiw	a5,a5,1
 b80:	fef42223          	sw	a5,-28(s0)
 b84:	fe442783          	lw	a5,-28(s0)
 b88:	fc043703          	ld	a4,-64(s0)
 b8c:	97ba                	add	a5,a5,a4
 b8e:	0007c783          	lbu	a5,0(a5)
 b92:	dc0795e3          	bnez	a5,95c <vprintf+0x20>
    }
  }
}
 b96:	0001                	nop
 b98:	0001                	nop
 b9a:	60a6                	ld	ra,72(sp)
 b9c:	6406                	ld	s0,64(sp)
 b9e:	6161                	addi	sp,sp,80
 ba0:	8082                	ret

0000000000000ba2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 ba2:	7159                	addi	sp,sp,-112
 ba4:	fc06                	sd	ra,56(sp)
 ba6:	f822                	sd	s0,48(sp)
 ba8:	0080                	addi	s0,sp,64
 baa:	fcb43823          	sd	a1,-48(s0)
 bae:	e010                	sd	a2,0(s0)
 bb0:	e414                	sd	a3,8(s0)
 bb2:	e818                	sd	a4,16(s0)
 bb4:	ec1c                	sd	a5,24(s0)
 bb6:	03043023          	sd	a6,32(s0)
 bba:	03143423          	sd	a7,40(s0)
 bbe:	87aa                	mv	a5,a0
 bc0:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 bc4:	03040793          	addi	a5,s0,48
 bc8:	fcf43423          	sd	a5,-56(s0)
 bcc:	fc843783          	ld	a5,-56(s0)
 bd0:	fd078793          	addi	a5,a5,-48
 bd4:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 bd8:	fe843703          	ld	a4,-24(s0)
 bdc:	fdc42783          	lw	a5,-36(s0)
 be0:	863a                	mv	a2,a4
 be2:	fd043583          	ld	a1,-48(s0)
 be6:	853e                	mv	a0,a5
 be8:	00000097          	auipc	ra,0x0
 bec:	d54080e7          	jalr	-684(ra) # 93c <vprintf>
}
 bf0:	0001                	nop
 bf2:	70e2                	ld	ra,56(sp)
 bf4:	7442                	ld	s0,48(sp)
 bf6:	6165                	addi	sp,sp,112
 bf8:	8082                	ret

0000000000000bfa <printf>:

void
printf(const char *fmt, ...)
{
 bfa:	7159                	addi	sp,sp,-112
 bfc:	f406                	sd	ra,40(sp)
 bfe:	f022                	sd	s0,32(sp)
 c00:	1800                	addi	s0,sp,48
 c02:	fca43c23          	sd	a0,-40(s0)
 c06:	e40c                	sd	a1,8(s0)
 c08:	e810                	sd	a2,16(s0)
 c0a:	ec14                	sd	a3,24(s0)
 c0c:	f018                	sd	a4,32(s0)
 c0e:	f41c                	sd	a5,40(s0)
 c10:	03043823          	sd	a6,48(s0)
 c14:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c18:	04040793          	addi	a5,s0,64
 c1c:	fcf43823          	sd	a5,-48(s0)
 c20:	fd043783          	ld	a5,-48(s0)
 c24:	fc878793          	addi	a5,a5,-56
 c28:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 c2c:	fe843783          	ld	a5,-24(s0)
 c30:	863e                	mv	a2,a5
 c32:	fd843583          	ld	a1,-40(s0)
 c36:	4505                	li	a0,1
 c38:	00000097          	auipc	ra,0x0
 c3c:	d04080e7          	jalr	-764(ra) # 93c <vprintf>
}
 c40:	0001                	nop
 c42:	70a2                	ld	ra,40(sp)
 c44:	7402                	ld	s0,32(sp)
 c46:	6165                	addi	sp,sp,112
 c48:	8082                	ret

0000000000000c4a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c4a:	7179                	addi	sp,sp,-48
 c4c:	f422                	sd	s0,40(sp)
 c4e:	1800                	addi	s0,sp,48
 c50:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c54:	fd843783          	ld	a5,-40(s0)
 c58:	17c1                	addi	a5,a5,-16
 c5a:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c5e:	00001797          	auipc	a5,0x1
 c62:	96278793          	addi	a5,a5,-1694 # 15c0 <freep>
 c66:	639c                	ld	a5,0(a5)
 c68:	fef43423          	sd	a5,-24(s0)
 c6c:	a815                	j	ca0 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c6e:	fe843783          	ld	a5,-24(s0)
 c72:	639c                	ld	a5,0(a5)
 c74:	fe843703          	ld	a4,-24(s0)
 c78:	00f76f63          	bltu	a4,a5,c96 <free+0x4c>
 c7c:	fe043703          	ld	a4,-32(s0)
 c80:	fe843783          	ld	a5,-24(s0)
 c84:	02e7eb63          	bltu	a5,a4,cba <free+0x70>
 c88:	fe843783          	ld	a5,-24(s0)
 c8c:	639c                	ld	a5,0(a5)
 c8e:	fe043703          	ld	a4,-32(s0)
 c92:	02f76463          	bltu	a4,a5,cba <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c96:	fe843783          	ld	a5,-24(s0)
 c9a:	639c                	ld	a5,0(a5)
 c9c:	fef43423          	sd	a5,-24(s0)
 ca0:	fe043703          	ld	a4,-32(s0)
 ca4:	fe843783          	ld	a5,-24(s0)
 ca8:	fce7f3e3          	bgeu	a5,a4,c6e <free+0x24>
 cac:	fe843783          	ld	a5,-24(s0)
 cb0:	639c                	ld	a5,0(a5)
 cb2:	fe043703          	ld	a4,-32(s0)
 cb6:	faf77ce3          	bgeu	a4,a5,c6e <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cba:	fe043783          	ld	a5,-32(s0)
 cbe:	479c                	lw	a5,8(a5)
 cc0:	1782                	slli	a5,a5,0x20
 cc2:	9381                	srli	a5,a5,0x20
 cc4:	0792                	slli	a5,a5,0x4
 cc6:	fe043703          	ld	a4,-32(s0)
 cca:	973e                	add	a4,a4,a5
 ccc:	fe843783          	ld	a5,-24(s0)
 cd0:	639c                	ld	a5,0(a5)
 cd2:	02f71763          	bne	a4,a5,d00 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 cd6:	fe043783          	ld	a5,-32(s0)
 cda:	4798                	lw	a4,8(a5)
 cdc:	fe843783          	ld	a5,-24(s0)
 ce0:	639c                	ld	a5,0(a5)
 ce2:	479c                	lw	a5,8(a5)
 ce4:	9fb9                	addw	a5,a5,a4
 ce6:	0007871b          	sext.w	a4,a5
 cea:	fe043783          	ld	a5,-32(s0)
 cee:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 cf0:	fe843783          	ld	a5,-24(s0)
 cf4:	639c                	ld	a5,0(a5)
 cf6:	6398                	ld	a4,0(a5)
 cf8:	fe043783          	ld	a5,-32(s0)
 cfc:	e398                	sd	a4,0(a5)
 cfe:	a039                	j	d0c <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 d00:	fe843783          	ld	a5,-24(s0)
 d04:	6398                	ld	a4,0(a5)
 d06:	fe043783          	ld	a5,-32(s0)
 d0a:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 d0c:	fe843783          	ld	a5,-24(s0)
 d10:	479c                	lw	a5,8(a5)
 d12:	1782                	slli	a5,a5,0x20
 d14:	9381                	srli	a5,a5,0x20
 d16:	0792                	slli	a5,a5,0x4
 d18:	fe843703          	ld	a4,-24(s0)
 d1c:	97ba                	add	a5,a5,a4
 d1e:	fe043703          	ld	a4,-32(s0)
 d22:	02f71563          	bne	a4,a5,d4c <free+0x102>
    p->s.size += bp->s.size;
 d26:	fe843783          	ld	a5,-24(s0)
 d2a:	4798                	lw	a4,8(a5)
 d2c:	fe043783          	ld	a5,-32(s0)
 d30:	479c                	lw	a5,8(a5)
 d32:	9fb9                	addw	a5,a5,a4
 d34:	0007871b          	sext.w	a4,a5
 d38:	fe843783          	ld	a5,-24(s0)
 d3c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d3e:	fe043783          	ld	a5,-32(s0)
 d42:	6398                	ld	a4,0(a5)
 d44:	fe843783          	ld	a5,-24(s0)
 d48:	e398                	sd	a4,0(a5)
 d4a:	a031                	j	d56 <free+0x10c>
  } else
    p->s.ptr = bp;
 d4c:	fe843783          	ld	a5,-24(s0)
 d50:	fe043703          	ld	a4,-32(s0)
 d54:	e398                	sd	a4,0(a5)
  freep = p;
 d56:	00001797          	auipc	a5,0x1
 d5a:	86a78793          	addi	a5,a5,-1942 # 15c0 <freep>
 d5e:	fe843703          	ld	a4,-24(s0)
 d62:	e398                	sd	a4,0(a5)
}
 d64:	0001                	nop
 d66:	7422                	ld	s0,40(sp)
 d68:	6145                	addi	sp,sp,48
 d6a:	8082                	ret

0000000000000d6c <morecore>:

static Header*
morecore(uint nu)
{
 d6c:	7179                	addi	sp,sp,-48
 d6e:	f406                	sd	ra,40(sp)
 d70:	f022                	sd	s0,32(sp)
 d72:	1800                	addi	s0,sp,48
 d74:	87aa                	mv	a5,a0
 d76:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 d7a:	fdc42783          	lw	a5,-36(s0)
 d7e:	0007871b          	sext.w	a4,a5
 d82:	6785                	lui	a5,0x1
 d84:	00f77563          	bgeu	a4,a5,d8e <morecore+0x22>
    nu = 4096;
 d88:	6785                	lui	a5,0x1
 d8a:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 d8e:	fdc42783          	lw	a5,-36(s0)
 d92:	0047979b          	slliw	a5,a5,0x4
 d96:	2781                	sext.w	a5,a5
 d98:	2781                	sext.w	a5,a5
 d9a:	853e                	mv	a0,a5
 d9c:	00000097          	auipc	ra,0x0
 da0:	9be080e7          	jalr	-1602(ra) # 75a <sbrk>
 da4:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 da8:	fe843703          	ld	a4,-24(s0)
 dac:	57fd                	li	a5,-1
 dae:	00f71463          	bne	a4,a5,db6 <morecore+0x4a>
    return 0;
 db2:	4781                	li	a5,0
 db4:	a03d                	j	de2 <morecore+0x76>
  hp = (Header*)p;
 db6:	fe843783          	ld	a5,-24(s0)
 dba:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 dbe:	fe043783          	ld	a5,-32(s0)
 dc2:	fdc42703          	lw	a4,-36(s0)
 dc6:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 dc8:	fe043783          	ld	a5,-32(s0)
 dcc:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x224>
 dce:	853e                	mv	a0,a5
 dd0:	00000097          	auipc	ra,0x0
 dd4:	e7a080e7          	jalr	-390(ra) # c4a <free>
  return freep;
 dd8:	00000797          	auipc	a5,0x0
 ddc:	7e878793          	addi	a5,a5,2024 # 15c0 <freep>
 de0:	639c                	ld	a5,0(a5)
}
 de2:	853e                	mv	a0,a5
 de4:	70a2                	ld	ra,40(sp)
 de6:	7402                	ld	s0,32(sp)
 de8:	6145                	addi	sp,sp,48
 dea:	8082                	ret

0000000000000dec <malloc>:

void*
malloc(uint nbytes)
{
 dec:	7139                	addi	sp,sp,-64
 dee:	fc06                	sd	ra,56(sp)
 df0:	f822                	sd	s0,48(sp)
 df2:	0080                	addi	s0,sp,64
 df4:	87aa                	mv	a5,a0
 df6:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 dfa:	fcc46783          	lwu	a5,-52(s0)
 dfe:	07bd                	addi	a5,a5,15
 e00:	8391                	srli	a5,a5,0x4
 e02:	2781                	sext.w	a5,a5
 e04:	2785                	addiw	a5,a5,1
 e06:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 e0a:	00000797          	auipc	a5,0x0
 e0e:	7b678793          	addi	a5,a5,1974 # 15c0 <freep>
 e12:	639c                	ld	a5,0(a5)
 e14:	fef43023          	sd	a5,-32(s0)
 e18:	fe043783          	ld	a5,-32(s0)
 e1c:	ef95                	bnez	a5,e58 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 e1e:	00000797          	auipc	a5,0x0
 e22:	79278793          	addi	a5,a5,1938 # 15b0 <base>
 e26:	fef43023          	sd	a5,-32(s0)
 e2a:	00000797          	auipc	a5,0x0
 e2e:	79678793          	addi	a5,a5,1942 # 15c0 <freep>
 e32:	fe043703          	ld	a4,-32(s0)
 e36:	e398                	sd	a4,0(a5)
 e38:	00000797          	auipc	a5,0x0
 e3c:	78878793          	addi	a5,a5,1928 # 15c0 <freep>
 e40:	6398                	ld	a4,0(a5)
 e42:	00000797          	auipc	a5,0x0
 e46:	76e78793          	addi	a5,a5,1902 # 15b0 <base>
 e4a:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 e4c:	00000797          	auipc	a5,0x0
 e50:	76478793          	addi	a5,a5,1892 # 15b0 <base>
 e54:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e58:	fe043783          	ld	a5,-32(s0)
 e5c:	639c                	ld	a5,0(a5)
 e5e:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e62:	fe843783          	ld	a5,-24(s0)
 e66:	4798                	lw	a4,8(a5)
 e68:	fdc42783          	lw	a5,-36(s0)
 e6c:	2781                	sext.w	a5,a5
 e6e:	06f76763          	bltu	a4,a5,edc <malloc+0xf0>
      if(p->s.size == nunits)
 e72:	fe843783          	ld	a5,-24(s0)
 e76:	4798                	lw	a4,8(a5)
 e78:	fdc42783          	lw	a5,-36(s0)
 e7c:	2781                	sext.w	a5,a5
 e7e:	00e79963          	bne	a5,a4,e90 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 e82:	fe843783          	ld	a5,-24(s0)
 e86:	6398                	ld	a4,0(a5)
 e88:	fe043783          	ld	a5,-32(s0)
 e8c:	e398                	sd	a4,0(a5)
 e8e:	a825                	j	ec6 <malloc+0xda>
      else {
        p->s.size -= nunits;
 e90:	fe843783          	ld	a5,-24(s0)
 e94:	479c                	lw	a5,8(a5)
 e96:	fdc42703          	lw	a4,-36(s0)
 e9a:	9f99                	subw	a5,a5,a4
 e9c:	0007871b          	sext.w	a4,a5
 ea0:	fe843783          	ld	a5,-24(s0)
 ea4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ea6:	fe843783          	ld	a5,-24(s0)
 eaa:	479c                	lw	a5,8(a5)
 eac:	1782                	slli	a5,a5,0x20
 eae:	9381                	srli	a5,a5,0x20
 eb0:	0792                	slli	a5,a5,0x4
 eb2:	fe843703          	ld	a4,-24(s0)
 eb6:	97ba                	add	a5,a5,a4
 eb8:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 ebc:	fe843783          	ld	a5,-24(s0)
 ec0:	fdc42703          	lw	a4,-36(s0)
 ec4:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 ec6:	00000797          	auipc	a5,0x0
 eca:	6fa78793          	addi	a5,a5,1786 # 15c0 <freep>
 ece:	fe043703          	ld	a4,-32(s0)
 ed2:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 ed4:	fe843783          	ld	a5,-24(s0)
 ed8:	07c1                	addi	a5,a5,16
 eda:	a091                	j	f1e <malloc+0x132>
    }
    if(p == freep)
 edc:	00000797          	auipc	a5,0x0
 ee0:	6e478793          	addi	a5,a5,1764 # 15c0 <freep>
 ee4:	639c                	ld	a5,0(a5)
 ee6:	fe843703          	ld	a4,-24(s0)
 eea:	02f71063          	bne	a4,a5,f0a <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 eee:	fdc42783          	lw	a5,-36(s0)
 ef2:	853e                	mv	a0,a5
 ef4:	00000097          	auipc	ra,0x0
 ef8:	e78080e7          	jalr	-392(ra) # d6c <morecore>
 efc:	fea43423          	sd	a0,-24(s0)
 f00:	fe843783          	ld	a5,-24(s0)
 f04:	e399                	bnez	a5,f0a <malloc+0x11e>
        return 0;
 f06:	4781                	li	a5,0
 f08:	a819                	j	f1e <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f0a:	fe843783          	ld	a5,-24(s0)
 f0e:	fef43023          	sd	a5,-32(s0)
 f12:	fe843783          	ld	a5,-24(s0)
 f16:	639c                	ld	a5,0(a5)
 f18:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 f1c:	b799                	j	e62 <malloc+0x76>
  }
}
 f1e:	853e                	mv	a0,a5
 f20:	70e2                	ld	ra,56(sp)
 f22:	7442                	ld	s0,48(sp)
 f24:	6121                	addi	sp,sp,64
 f26:	8082                	ret
