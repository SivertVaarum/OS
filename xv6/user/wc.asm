
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
  78:	ebc50513          	addi	a0,a0,-324 # f30 <malloc+0x13c>
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
  fa:	e4250513          	addi	a0,a0,-446 # f38 <malloc+0x144>
  fe:	00001097          	auipc	ra,0x1
 102:	b04080e7          	jalr	-1276(ra) # c02 <printf>
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
 126:	e2650513          	addi	a0,a0,-474 # f48 <malloc+0x154>
 12a:	00001097          	auipc	ra,0x1
 12e:	ad8080e7          	jalr	-1320(ra) # c02 <printf>
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
 160:	dfc58593          	addi	a1,a1,-516 # f58 <malloc+0x164>
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
 1be:	da650513          	addi	a0,a0,-602 # f60 <malloc+0x16c>
 1c2:	00001097          	auipc	ra,0x1
 1c6:	a40080e7          	jalr	-1472(ra) # c02 <printf>
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

0000000000000772 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 772:	48d9                	li	a7,22
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 77a:	1101                	addi	sp,sp,-32
 77c:	ec06                	sd	ra,24(sp)
 77e:	e822                	sd	s0,16(sp)
 780:	1000                	addi	s0,sp,32
 782:	87aa                	mv	a5,a0
 784:	872e                	mv	a4,a1
 786:	fef42623          	sw	a5,-20(s0)
 78a:	87ba                	mv	a5,a4
 78c:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 790:	feb40713          	addi	a4,s0,-21
 794:	fec42783          	lw	a5,-20(s0)
 798:	4605                	li	a2,1
 79a:	85ba                	mv	a1,a4
 79c:	853e                	mv	a0,a5
 79e:	00000097          	auipc	ra,0x0
 7a2:	f54080e7          	jalr	-172(ra) # 6f2 <write>
}
 7a6:	0001                	nop
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6105                	addi	sp,sp,32
 7ae:	8082                	ret

00000000000007b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7b0:	7139                	addi	sp,sp,-64
 7b2:	fc06                	sd	ra,56(sp)
 7b4:	f822                	sd	s0,48(sp)
 7b6:	0080                	addi	s0,sp,64
 7b8:	87aa                	mv	a5,a0
 7ba:	8736                	mv	a4,a3
 7bc:	fcf42623          	sw	a5,-52(s0)
 7c0:	87ae                	mv	a5,a1
 7c2:	fcf42423          	sw	a5,-56(s0)
 7c6:	87b2                	mv	a5,a2
 7c8:	fcf42223          	sw	a5,-60(s0)
 7cc:	87ba                	mv	a5,a4
 7ce:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7d2:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 7d6:	fc042783          	lw	a5,-64(s0)
 7da:	2781                	sext.w	a5,a5
 7dc:	c38d                	beqz	a5,7fe <printint+0x4e>
 7de:	fc842783          	lw	a5,-56(s0)
 7e2:	2781                	sext.w	a5,a5
 7e4:	0007dd63          	bgez	a5,7fe <printint+0x4e>
    neg = 1;
 7e8:	4785                	li	a5,1
 7ea:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 7ee:	fc842783          	lw	a5,-56(s0)
 7f2:	40f007bb          	negw	a5,a5
 7f6:	2781                	sext.w	a5,a5
 7f8:	fef42223          	sw	a5,-28(s0)
 7fc:	a029                	j	806 <printint+0x56>
  } else {
    x = xx;
 7fe:	fc842783          	lw	a5,-56(s0)
 802:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 806:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 80a:	fc442783          	lw	a5,-60(s0)
 80e:	fe442703          	lw	a4,-28(s0)
 812:	02f777bb          	remuw	a5,a4,a5
 816:	0007861b          	sext.w	a2,a5
 81a:	fec42783          	lw	a5,-20(s0)
 81e:	0017871b          	addiw	a4,a5,1
 822:	fee42623          	sw	a4,-20(s0)
 826:	00001697          	auipc	a3,0x1
 82a:	b6a68693          	addi	a3,a3,-1174 # 1390 <digits>
 82e:	02061713          	slli	a4,a2,0x20
 832:	9301                	srli	a4,a4,0x20
 834:	9736                	add	a4,a4,a3
 836:	00074703          	lbu	a4,0(a4)
 83a:	17c1                	addi	a5,a5,-16
 83c:	97a2                	add	a5,a5,s0
 83e:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 842:	fc442783          	lw	a5,-60(s0)
 846:	fe442703          	lw	a4,-28(s0)
 84a:	02f757bb          	divuw	a5,a4,a5
 84e:	fef42223          	sw	a5,-28(s0)
 852:	fe442783          	lw	a5,-28(s0)
 856:	2781                	sext.w	a5,a5
 858:	fbcd                	bnez	a5,80a <printint+0x5a>
  if(neg)
 85a:	fe842783          	lw	a5,-24(s0)
 85e:	2781                	sext.w	a5,a5
 860:	cf85                	beqz	a5,898 <printint+0xe8>
    buf[i++] = '-';
 862:	fec42783          	lw	a5,-20(s0)
 866:	0017871b          	addiw	a4,a5,1
 86a:	fee42623          	sw	a4,-20(s0)
 86e:	17c1                	addi	a5,a5,-16
 870:	97a2                	add	a5,a5,s0
 872:	02d00713          	li	a4,45
 876:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 87a:	a839                	j	898 <printint+0xe8>
    putc(fd, buf[i]);
 87c:	fec42783          	lw	a5,-20(s0)
 880:	17c1                	addi	a5,a5,-16
 882:	97a2                	add	a5,a5,s0
 884:	fe07c703          	lbu	a4,-32(a5)
 888:	fcc42783          	lw	a5,-52(s0)
 88c:	85ba                	mv	a1,a4
 88e:	853e                	mv	a0,a5
 890:	00000097          	auipc	ra,0x0
 894:	eea080e7          	jalr	-278(ra) # 77a <putc>
  while(--i >= 0)
 898:	fec42783          	lw	a5,-20(s0)
 89c:	37fd                	addiw	a5,a5,-1
 89e:	fef42623          	sw	a5,-20(s0)
 8a2:	fec42783          	lw	a5,-20(s0)
 8a6:	2781                	sext.w	a5,a5
 8a8:	fc07dae3          	bgez	a5,87c <printint+0xcc>
}
 8ac:	0001                	nop
 8ae:	0001                	nop
 8b0:	70e2                	ld	ra,56(sp)
 8b2:	7442                	ld	s0,48(sp)
 8b4:	6121                	addi	sp,sp,64
 8b6:	8082                	ret

00000000000008b8 <printptr>:

static void
printptr(int fd, uint64 x) {
 8b8:	7179                	addi	sp,sp,-48
 8ba:	f406                	sd	ra,40(sp)
 8bc:	f022                	sd	s0,32(sp)
 8be:	1800                	addi	s0,sp,48
 8c0:	87aa                	mv	a5,a0
 8c2:	fcb43823          	sd	a1,-48(s0)
 8c6:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 8ca:	fdc42783          	lw	a5,-36(s0)
 8ce:	03000593          	li	a1,48
 8d2:	853e                	mv	a0,a5
 8d4:	00000097          	auipc	ra,0x0
 8d8:	ea6080e7          	jalr	-346(ra) # 77a <putc>
  putc(fd, 'x');
 8dc:	fdc42783          	lw	a5,-36(s0)
 8e0:	07800593          	li	a1,120
 8e4:	853e                	mv	a0,a5
 8e6:	00000097          	auipc	ra,0x0
 8ea:	e94080e7          	jalr	-364(ra) # 77a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8ee:	fe042623          	sw	zero,-20(s0)
 8f2:	a82d                	j	92c <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8f4:	fd043783          	ld	a5,-48(s0)
 8f8:	93f1                	srli	a5,a5,0x3c
 8fa:	00001717          	auipc	a4,0x1
 8fe:	a9670713          	addi	a4,a4,-1386 # 1390 <digits>
 902:	97ba                	add	a5,a5,a4
 904:	0007c703          	lbu	a4,0(a5)
 908:	fdc42783          	lw	a5,-36(s0)
 90c:	85ba                	mv	a1,a4
 90e:	853e                	mv	a0,a5
 910:	00000097          	auipc	ra,0x0
 914:	e6a080e7          	jalr	-406(ra) # 77a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 918:	fec42783          	lw	a5,-20(s0)
 91c:	2785                	addiw	a5,a5,1
 91e:	fef42623          	sw	a5,-20(s0)
 922:	fd043783          	ld	a5,-48(s0)
 926:	0792                	slli	a5,a5,0x4
 928:	fcf43823          	sd	a5,-48(s0)
 92c:	fec42783          	lw	a5,-20(s0)
 930:	873e                	mv	a4,a5
 932:	47bd                	li	a5,15
 934:	fce7f0e3          	bgeu	a5,a4,8f4 <printptr+0x3c>
}
 938:	0001                	nop
 93a:	0001                	nop
 93c:	70a2                	ld	ra,40(sp)
 93e:	7402                	ld	s0,32(sp)
 940:	6145                	addi	sp,sp,48
 942:	8082                	ret

0000000000000944 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 944:	715d                	addi	sp,sp,-80
 946:	e486                	sd	ra,72(sp)
 948:	e0a2                	sd	s0,64(sp)
 94a:	0880                	addi	s0,sp,80
 94c:	87aa                	mv	a5,a0
 94e:	fcb43023          	sd	a1,-64(s0)
 952:	fac43c23          	sd	a2,-72(s0)
 956:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 95a:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 95e:	fe042223          	sw	zero,-28(s0)
 962:	a42d                	j	b8c <vprintf+0x248>
    c = fmt[i] & 0xff;
 964:	fe442783          	lw	a5,-28(s0)
 968:	fc043703          	ld	a4,-64(s0)
 96c:	97ba                	add	a5,a5,a4
 96e:	0007c783          	lbu	a5,0(a5)
 972:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 976:	fe042783          	lw	a5,-32(s0)
 97a:	2781                	sext.w	a5,a5
 97c:	eb9d                	bnez	a5,9b2 <vprintf+0x6e>
      if(c == '%'){
 97e:	fdc42783          	lw	a5,-36(s0)
 982:	0007871b          	sext.w	a4,a5
 986:	02500793          	li	a5,37
 98a:	00f71763          	bne	a4,a5,998 <vprintf+0x54>
        state = '%';
 98e:	02500793          	li	a5,37
 992:	fef42023          	sw	a5,-32(s0)
 996:	a2f5                	j	b82 <vprintf+0x23e>
      } else {
        putc(fd, c);
 998:	fdc42783          	lw	a5,-36(s0)
 99c:	0ff7f713          	zext.b	a4,a5
 9a0:	fcc42783          	lw	a5,-52(s0)
 9a4:	85ba                	mv	a1,a4
 9a6:	853e                	mv	a0,a5
 9a8:	00000097          	auipc	ra,0x0
 9ac:	dd2080e7          	jalr	-558(ra) # 77a <putc>
 9b0:	aac9                	j	b82 <vprintf+0x23e>
      }
    } else if(state == '%'){
 9b2:	fe042783          	lw	a5,-32(s0)
 9b6:	0007871b          	sext.w	a4,a5
 9ba:	02500793          	li	a5,37
 9be:	1cf71263          	bne	a4,a5,b82 <vprintf+0x23e>
      if(c == 'd'){
 9c2:	fdc42783          	lw	a5,-36(s0)
 9c6:	0007871b          	sext.w	a4,a5
 9ca:	06400793          	li	a5,100
 9ce:	02f71463          	bne	a4,a5,9f6 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 9d2:	fb843783          	ld	a5,-72(s0)
 9d6:	00878713          	addi	a4,a5,8
 9da:	fae43c23          	sd	a4,-72(s0)
 9de:	4398                	lw	a4,0(a5)
 9e0:	fcc42783          	lw	a5,-52(s0)
 9e4:	4685                	li	a3,1
 9e6:	4629                	li	a2,10
 9e8:	85ba                	mv	a1,a4
 9ea:	853e                	mv	a0,a5
 9ec:	00000097          	auipc	ra,0x0
 9f0:	dc4080e7          	jalr	-572(ra) # 7b0 <printint>
 9f4:	a269                	j	b7e <vprintf+0x23a>
      } else if(c == 'l') {
 9f6:	fdc42783          	lw	a5,-36(s0)
 9fa:	0007871b          	sext.w	a4,a5
 9fe:	06c00793          	li	a5,108
 a02:	02f71663          	bne	a4,a5,a2e <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a06:	fb843783          	ld	a5,-72(s0)
 a0a:	00878713          	addi	a4,a5,8
 a0e:	fae43c23          	sd	a4,-72(s0)
 a12:	639c                	ld	a5,0(a5)
 a14:	0007871b          	sext.w	a4,a5
 a18:	fcc42783          	lw	a5,-52(s0)
 a1c:	4681                	li	a3,0
 a1e:	4629                	li	a2,10
 a20:	85ba                	mv	a1,a4
 a22:	853e                	mv	a0,a5
 a24:	00000097          	auipc	ra,0x0
 a28:	d8c080e7          	jalr	-628(ra) # 7b0 <printint>
 a2c:	aa89                	j	b7e <vprintf+0x23a>
      } else if(c == 'x') {
 a2e:	fdc42783          	lw	a5,-36(s0)
 a32:	0007871b          	sext.w	a4,a5
 a36:	07800793          	li	a5,120
 a3a:	02f71463          	bne	a4,a5,a62 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 a3e:	fb843783          	ld	a5,-72(s0)
 a42:	00878713          	addi	a4,a5,8
 a46:	fae43c23          	sd	a4,-72(s0)
 a4a:	4398                	lw	a4,0(a5)
 a4c:	fcc42783          	lw	a5,-52(s0)
 a50:	4681                	li	a3,0
 a52:	4641                	li	a2,16
 a54:	85ba                	mv	a1,a4
 a56:	853e                	mv	a0,a5
 a58:	00000097          	auipc	ra,0x0
 a5c:	d58080e7          	jalr	-680(ra) # 7b0 <printint>
 a60:	aa39                	j	b7e <vprintf+0x23a>
      } else if(c == 'p') {
 a62:	fdc42783          	lw	a5,-36(s0)
 a66:	0007871b          	sext.w	a4,a5
 a6a:	07000793          	li	a5,112
 a6e:	02f71263          	bne	a4,a5,a92 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 a72:	fb843783          	ld	a5,-72(s0)
 a76:	00878713          	addi	a4,a5,8
 a7a:	fae43c23          	sd	a4,-72(s0)
 a7e:	6398                	ld	a4,0(a5)
 a80:	fcc42783          	lw	a5,-52(s0)
 a84:	85ba                	mv	a1,a4
 a86:	853e                	mv	a0,a5
 a88:	00000097          	auipc	ra,0x0
 a8c:	e30080e7          	jalr	-464(ra) # 8b8 <printptr>
 a90:	a0fd                	j	b7e <vprintf+0x23a>
      } else if(c == 's'){
 a92:	fdc42783          	lw	a5,-36(s0)
 a96:	0007871b          	sext.w	a4,a5
 a9a:	07300793          	li	a5,115
 a9e:	04f71c63          	bne	a4,a5,af6 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 aa2:	fb843783          	ld	a5,-72(s0)
 aa6:	00878713          	addi	a4,a5,8
 aaa:	fae43c23          	sd	a4,-72(s0)
 aae:	639c                	ld	a5,0(a5)
 ab0:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 ab4:	fe843783          	ld	a5,-24(s0)
 ab8:	eb8d                	bnez	a5,aea <vprintf+0x1a6>
          s = "(null)";
 aba:	00000797          	auipc	a5,0x0
 abe:	4be78793          	addi	a5,a5,1214 # f78 <malloc+0x184>
 ac2:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 ac6:	a015                	j	aea <vprintf+0x1a6>
          putc(fd, *s);
 ac8:	fe843783          	ld	a5,-24(s0)
 acc:	0007c703          	lbu	a4,0(a5)
 ad0:	fcc42783          	lw	a5,-52(s0)
 ad4:	85ba                	mv	a1,a4
 ad6:	853e                	mv	a0,a5
 ad8:	00000097          	auipc	ra,0x0
 adc:	ca2080e7          	jalr	-862(ra) # 77a <putc>
          s++;
 ae0:	fe843783          	ld	a5,-24(s0)
 ae4:	0785                	addi	a5,a5,1
 ae6:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 aea:	fe843783          	ld	a5,-24(s0)
 aee:	0007c783          	lbu	a5,0(a5)
 af2:	fbf9                	bnez	a5,ac8 <vprintf+0x184>
 af4:	a069                	j	b7e <vprintf+0x23a>
        }
      } else if(c == 'c'){
 af6:	fdc42783          	lw	a5,-36(s0)
 afa:	0007871b          	sext.w	a4,a5
 afe:	06300793          	li	a5,99
 b02:	02f71463          	bne	a4,a5,b2a <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 b06:	fb843783          	ld	a5,-72(s0)
 b0a:	00878713          	addi	a4,a5,8
 b0e:	fae43c23          	sd	a4,-72(s0)
 b12:	439c                	lw	a5,0(a5)
 b14:	0ff7f713          	zext.b	a4,a5
 b18:	fcc42783          	lw	a5,-52(s0)
 b1c:	85ba                	mv	a1,a4
 b1e:	853e                	mv	a0,a5
 b20:	00000097          	auipc	ra,0x0
 b24:	c5a080e7          	jalr	-934(ra) # 77a <putc>
 b28:	a899                	j	b7e <vprintf+0x23a>
      } else if(c == '%'){
 b2a:	fdc42783          	lw	a5,-36(s0)
 b2e:	0007871b          	sext.w	a4,a5
 b32:	02500793          	li	a5,37
 b36:	00f71f63          	bne	a4,a5,b54 <vprintf+0x210>
        putc(fd, c);
 b3a:	fdc42783          	lw	a5,-36(s0)
 b3e:	0ff7f713          	zext.b	a4,a5
 b42:	fcc42783          	lw	a5,-52(s0)
 b46:	85ba                	mv	a1,a4
 b48:	853e                	mv	a0,a5
 b4a:	00000097          	auipc	ra,0x0
 b4e:	c30080e7          	jalr	-976(ra) # 77a <putc>
 b52:	a035                	j	b7e <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b54:	fcc42783          	lw	a5,-52(s0)
 b58:	02500593          	li	a1,37
 b5c:	853e                	mv	a0,a5
 b5e:	00000097          	auipc	ra,0x0
 b62:	c1c080e7          	jalr	-996(ra) # 77a <putc>
        putc(fd, c);
 b66:	fdc42783          	lw	a5,-36(s0)
 b6a:	0ff7f713          	zext.b	a4,a5
 b6e:	fcc42783          	lw	a5,-52(s0)
 b72:	85ba                	mv	a1,a4
 b74:	853e                	mv	a0,a5
 b76:	00000097          	auipc	ra,0x0
 b7a:	c04080e7          	jalr	-1020(ra) # 77a <putc>
      }
      state = 0;
 b7e:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 b82:	fe442783          	lw	a5,-28(s0)
 b86:	2785                	addiw	a5,a5,1
 b88:	fef42223          	sw	a5,-28(s0)
 b8c:	fe442783          	lw	a5,-28(s0)
 b90:	fc043703          	ld	a4,-64(s0)
 b94:	97ba                	add	a5,a5,a4
 b96:	0007c783          	lbu	a5,0(a5)
 b9a:	dc0795e3          	bnez	a5,964 <vprintf+0x20>
    }
  }
}
 b9e:	0001                	nop
 ba0:	0001                	nop
 ba2:	60a6                	ld	ra,72(sp)
 ba4:	6406                	ld	s0,64(sp)
 ba6:	6161                	addi	sp,sp,80
 ba8:	8082                	ret

0000000000000baa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 baa:	7159                	addi	sp,sp,-112
 bac:	fc06                	sd	ra,56(sp)
 bae:	f822                	sd	s0,48(sp)
 bb0:	0080                	addi	s0,sp,64
 bb2:	fcb43823          	sd	a1,-48(s0)
 bb6:	e010                	sd	a2,0(s0)
 bb8:	e414                	sd	a3,8(s0)
 bba:	e818                	sd	a4,16(s0)
 bbc:	ec1c                	sd	a5,24(s0)
 bbe:	03043023          	sd	a6,32(s0)
 bc2:	03143423          	sd	a7,40(s0)
 bc6:	87aa                	mv	a5,a0
 bc8:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 bcc:	03040793          	addi	a5,s0,48
 bd0:	fcf43423          	sd	a5,-56(s0)
 bd4:	fc843783          	ld	a5,-56(s0)
 bd8:	fd078793          	addi	a5,a5,-48
 bdc:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 be0:	fe843703          	ld	a4,-24(s0)
 be4:	fdc42783          	lw	a5,-36(s0)
 be8:	863a                	mv	a2,a4
 bea:	fd043583          	ld	a1,-48(s0)
 bee:	853e                	mv	a0,a5
 bf0:	00000097          	auipc	ra,0x0
 bf4:	d54080e7          	jalr	-684(ra) # 944 <vprintf>
}
 bf8:	0001                	nop
 bfa:	70e2                	ld	ra,56(sp)
 bfc:	7442                	ld	s0,48(sp)
 bfe:	6165                	addi	sp,sp,112
 c00:	8082                	ret

0000000000000c02 <printf>:

void
printf(const char *fmt, ...)
{
 c02:	7159                	addi	sp,sp,-112
 c04:	f406                	sd	ra,40(sp)
 c06:	f022                	sd	s0,32(sp)
 c08:	1800                	addi	s0,sp,48
 c0a:	fca43c23          	sd	a0,-40(s0)
 c0e:	e40c                	sd	a1,8(s0)
 c10:	e810                	sd	a2,16(s0)
 c12:	ec14                	sd	a3,24(s0)
 c14:	f018                	sd	a4,32(s0)
 c16:	f41c                	sd	a5,40(s0)
 c18:	03043823          	sd	a6,48(s0)
 c1c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c20:	04040793          	addi	a5,s0,64
 c24:	fcf43823          	sd	a5,-48(s0)
 c28:	fd043783          	ld	a5,-48(s0)
 c2c:	fc878793          	addi	a5,a5,-56
 c30:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 c34:	fe843783          	ld	a5,-24(s0)
 c38:	863e                	mv	a2,a5
 c3a:	fd843583          	ld	a1,-40(s0)
 c3e:	4505                	li	a0,1
 c40:	00000097          	auipc	ra,0x0
 c44:	d04080e7          	jalr	-764(ra) # 944 <vprintf>
}
 c48:	0001                	nop
 c4a:	70a2                	ld	ra,40(sp)
 c4c:	7402                	ld	s0,32(sp)
 c4e:	6165                	addi	sp,sp,112
 c50:	8082                	ret

0000000000000c52 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c52:	7179                	addi	sp,sp,-48
 c54:	f422                	sd	s0,40(sp)
 c56:	1800                	addi	s0,sp,48
 c58:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c5c:	fd843783          	ld	a5,-40(s0)
 c60:	17c1                	addi	a5,a5,-16
 c62:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c66:	00001797          	auipc	a5,0x1
 c6a:	95a78793          	addi	a5,a5,-1702 # 15c0 <freep>
 c6e:	639c                	ld	a5,0(a5)
 c70:	fef43423          	sd	a5,-24(s0)
 c74:	a815                	j	ca8 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c76:	fe843783          	ld	a5,-24(s0)
 c7a:	639c                	ld	a5,0(a5)
 c7c:	fe843703          	ld	a4,-24(s0)
 c80:	00f76f63          	bltu	a4,a5,c9e <free+0x4c>
 c84:	fe043703          	ld	a4,-32(s0)
 c88:	fe843783          	ld	a5,-24(s0)
 c8c:	02e7eb63          	bltu	a5,a4,cc2 <free+0x70>
 c90:	fe843783          	ld	a5,-24(s0)
 c94:	639c                	ld	a5,0(a5)
 c96:	fe043703          	ld	a4,-32(s0)
 c9a:	02f76463          	bltu	a4,a5,cc2 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c9e:	fe843783          	ld	a5,-24(s0)
 ca2:	639c                	ld	a5,0(a5)
 ca4:	fef43423          	sd	a5,-24(s0)
 ca8:	fe043703          	ld	a4,-32(s0)
 cac:	fe843783          	ld	a5,-24(s0)
 cb0:	fce7f3e3          	bgeu	a5,a4,c76 <free+0x24>
 cb4:	fe843783          	ld	a5,-24(s0)
 cb8:	639c                	ld	a5,0(a5)
 cba:	fe043703          	ld	a4,-32(s0)
 cbe:	faf77ce3          	bgeu	a4,a5,c76 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cc2:	fe043783          	ld	a5,-32(s0)
 cc6:	479c                	lw	a5,8(a5)
 cc8:	1782                	slli	a5,a5,0x20
 cca:	9381                	srli	a5,a5,0x20
 ccc:	0792                	slli	a5,a5,0x4
 cce:	fe043703          	ld	a4,-32(s0)
 cd2:	973e                	add	a4,a4,a5
 cd4:	fe843783          	ld	a5,-24(s0)
 cd8:	639c                	ld	a5,0(a5)
 cda:	02f71763          	bne	a4,a5,d08 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 cde:	fe043783          	ld	a5,-32(s0)
 ce2:	4798                	lw	a4,8(a5)
 ce4:	fe843783          	ld	a5,-24(s0)
 ce8:	639c                	ld	a5,0(a5)
 cea:	479c                	lw	a5,8(a5)
 cec:	9fb9                	addw	a5,a5,a4
 cee:	0007871b          	sext.w	a4,a5
 cf2:	fe043783          	ld	a5,-32(s0)
 cf6:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 cf8:	fe843783          	ld	a5,-24(s0)
 cfc:	639c                	ld	a5,0(a5)
 cfe:	6398                	ld	a4,0(a5)
 d00:	fe043783          	ld	a5,-32(s0)
 d04:	e398                	sd	a4,0(a5)
 d06:	a039                	j	d14 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 d08:	fe843783          	ld	a5,-24(s0)
 d0c:	6398                	ld	a4,0(a5)
 d0e:	fe043783          	ld	a5,-32(s0)
 d12:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 d14:	fe843783          	ld	a5,-24(s0)
 d18:	479c                	lw	a5,8(a5)
 d1a:	1782                	slli	a5,a5,0x20
 d1c:	9381                	srli	a5,a5,0x20
 d1e:	0792                	slli	a5,a5,0x4
 d20:	fe843703          	ld	a4,-24(s0)
 d24:	97ba                	add	a5,a5,a4
 d26:	fe043703          	ld	a4,-32(s0)
 d2a:	02f71563          	bne	a4,a5,d54 <free+0x102>
    p->s.size += bp->s.size;
 d2e:	fe843783          	ld	a5,-24(s0)
 d32:	4798                	lw	a4,8(a5)
 d34:	fe043783          	ld	a5,-32(s0)
 d38:	479c                	lw	a5,8(a5)
 d3a:	9fb9                	addw	a5,a5,a4
 d3c:	0007871b          	sext.w	a4,a5
 d40:	fe843783          	ld	a5,-24(s0)
 d44:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d46:	fe043783          	ld	a5,-32(s0)
 d4a:	6398                	ld	a4,0(a5)
 d4c:	fe843783          	ld	a5,-24(s0)
 d50:	e398                	sd	a4,0(a5)
 d52:	a031                	j	d5e <free+0x10c>
  } else
    p->s.ptr = bp;
 d54:	fe843783          	ld	a5,-24(s0)
 d58:	fe043703          	ld	a4,-32(s0)
 d5c:	e398                	sd	a4,0(a5)
  freep = p;
 d5e:	00001797          	auipc	a5,0x1
 d62:	86278793          	addi	a5,a5,-1950 # 15c0 <freep>
 d66:	fe843703          	ld	a4,-24(s0)
 d6a:	e398                	sd	a4,0(a5)
}
 d6c:	0001                	nop
 d6e:	7422                	ld	s0,40(sp)
 d70:	6145                	addi	sp,sp,48
 d72:	8082                	ret

0000000000000d74 <morecore>:

static Header*
morecore(uint nu)
{
 d74:	7179                	addi	sp,sp,-48
 d76:	f406                	sd	ra,40(sp)
 d78:	f022                	sd	s0,32(sp)
 d7a:	1800                	addi	s0,sp,48
 d7c:	87aa                	mv	a5,a0
 d7e:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 d82:	fdc42783          	lw	a5,-36(s0)
 d86:	0007871b          	sext.w	a4,a5
 d8a:	6785                	lui	a5,0x1
 d8c:	00f77563          	bgeu	a4,a5,d96 <morecore+0x22>
    nu = 4096;
 d90:	6785                	lui	a5,0x1
 d92:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 d96:	fdc42783          	lw	a5,-36(s0)
 d9a:	0047979b          	slliw	a5,a5,0x4
 d9e:	2781                	sext.w	a5,a5
 da0:	2781                	sext.w	a5,a5
 da2:	853e                	mv	a0,a5
 da4:	00000097          	auipc	ra,0x0
 da8:	9b6080e7          	jalr	-1610(ra) # 75a <sbrk>
 dac:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 db0:	fe843703          	ld	a4,-24(s0)
 db4:	57fd                	li	a5,-1
 db6:	00f71463          	bne	a4,a5,dbe <morecore+0x4a>
    return 0;
 dba:	4781                	li	a5,0
 dbc:	a03d                	j	dea <morecore+0x76>
  hp = (Header*)p;
 dbe:	fe843783          	ld	a5,-24(s0)
 dc2:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 dc6:	fe043783          	ld	a5,-32(s0)
 dca:	fdc42703          	lw	a4,-36(s0)
 dce:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 dd0:	fe043783          	ld	a5,-32(s0)
 dd4:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x21c>
 dd6:	853e                	mv	a0,a5
 dd8:	00000097          	auipc	ra,0x0
 ddc:	e7a080e7          	jalr	-390(ra) # c52 <free>
  return freep;
 de0:	00000797          	auipc	a5,0x0
 de4:	7e078793          	addi	a5,a5,2016 # 15c0 <freep>
 de8:	639c                	ld	a5,0(a5)
}
 dea:	853e                	mv	a0,a5
 dec:	70a2                	ld	ra,40(sp)
 dee:	7402                	ld	s0,32(sp)
 df0:	6145                	addi	sp,sp,48
 df2:	8082                	ret

0000000000000df4 <malloc>:

void*
malloc(uint nbytes)
{
 df4:	7139                	addi	sp,sp,-64
 df6:	fc06                	sd	ra,56(sp)
 df8:	f822                	sd	s0,48(sp)
 dfa:	0080                	addi	s0,sp,64
 dfc:	87aa                	mv	a5,a0
 dfe:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e02:	fcc46783          	lwu	a5,-52(s0)
 e06:	07bd                	addi	a5,a5,15
 e08:	8391                	srli	a5,a5,0x4
 e0a:	2781                	sext.w	a5,a5
 e0c:	2785                	addiw	a5,a5,1
 e0e:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 e12:	00000797          	auipc	a5,0x0
 e16:	7ae78793          	addi	a5,a5,1966 # 15c0 <freep>
 e1a:	639c                	ld	a5,0(a5)
 e1c:	fef43023          	sd	a5,-32(s0)
 e20:	fe043783          	ld	a5,-32(s0)
 e24:	ef95                	bnez	a5,e60 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 e26:	00000797          	auipc	a5,0x0
 e2a:	78a78793          	addi	a5,a5,1930 # 15b0 <base>
 e2e:	fef43023          	sd	a5,-32(s0)
 e32:	00000797          	auipc	a5,0x0
 e36:	78e78793          	addi	a5,a5,1934 # 15c0 <freep>
 e3a:	fe043703          	ld	a4,-32(s0)
 e3e:	e398                	sd	a4,0(a5)
 e40:	00000797          	auipc	a5,0x0
 e44:	78078793          	addi	a5,a5,1920 # 15c0 <freep>
 e48:	6398                	ld	a4,0(a5)
 e4a:	00000797          	auipc	a5,0x0
 e4e:	76678793          	addi	a5,a5,1894 # 15b0 <base>
 e52:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 e54:	00000797          	auipc	a5,0x0
 e58:	75c78793          	addi	a5,a5,1884 # 15b0 <base>
 e5c:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e60:	fe043783          	ld	a5,-32(s0)
 e64:	639c                	ld	a5,0(a5)
 e66:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e6a:	fe843783          	ld	a5,-24(s0)
 e6e:	4798                	lw	a4,8(a5)
 e70:	fdc42783          	lw	a5,-36(s0)
 e74:	2781                	sext.w	a5,a5
 e76:	06f76763          	bltu	a4,a5,ee4 <malloc+0xf0>
      if(p->s.size == nunits)
 e7a:	fe843783          	ld	a5,-24(s0)
 e7e:	4798                	lw	a4,8(a5)
 e80:	fdc42783          	lw	a5,-36(s0)
 e84:	2781                	sext.w	a5,a5
 e86:	00e79963          	bne	a5,a4,e98 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 e8a:	fe843783          	ld	a5,-24(s0)
 e8e:	6398                	ld	a4,0(a5)
 e90:	fe043783          	ld	a5,-32(s0)
 e94:	e398                	sd	a4,0(a5)
 e96:	a825                	j	ece <malloc+0xda>
      else {
        p->s.size -= nunits;
 e98:	fe843783          	ld	a5,-24(s0)
 e9c:	479c                	lw	a5,8(a5)
 e9e:	fdc42703          	lw	a4,-36(s0)
 ea2:	9f99                	subw	a5,a5,a4
 ea4:	0007871b          	sext.w	a4,a5
 ea8:	fe843783          	ld	a5,-24(s0)
 eac:	c798                	sw	a4,8(a5)
        p += p->s.size;
 eae:	fe843783          	ld	a5,-24(s0)
 eb2:	479c                	lw	a5,8(a5)
 eb4:	1782                	slli	a5,a5,0x20
 eb6:	9381                	srli	a5,a5,0x20
 eb8:	0792                	slli	a5,a5,0x4
 eba:	fe843703          	ld	a4,-24(s0)
 ebe:	97ba                	add	a5,a5,a4
 ec0:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 ec4:	fe843783          	ld	a5,-24(s0)
 ec8:	fdc42703          	lw	a4,-36(s0)
 ecc:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 ece:	00000797          	auipc	a5,0x0
 ed2:	6f278793          	addi	a5,a5,1778 # 15c0 <freep>
 ed6:	fe043703          	ld	a4,-32(s0)
 eda:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 edc:	fe843783          	ld	a5,-24(s0)
 ee0:	07c1                	addi	a5,a5,16
 ee2:	a091                	j	f26 <malloc+0x132>
    }
    if(p == freep)
 ee4:	00000797          	auipc	a5,0x0
 ee8:	6dc78793          	addi	a5,a5,1756 # 15c0 <freep>
 eec:	639c                	ld	a5,0(a5)
 eee:	fe843703          	ld	a4,-24(s0)
 ef2:	02f71063          	bne	a4,a5,f12 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 ef6:	fdc42783          	lw	a5,-36(s0)
 efa:	853e                	mv	a0,a5
 efc:	00000097          	auipc	ra,0x0
 f00:	e78080e7          	jalr	-392(ra) # d74 <morecore>
 f04:	fea43423          	sd	a0,-24(s0)
 f08:	fe843783          	ld	a5,-24(s0)
 f0c:	e399                	bnez	a5,f12 <malloc+0x11e>
        return 0;
 f0e:	4781                	li	a5,0
 f10:	a819                	j	f26 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f12:	fe843783          	ld	a5,-24(s0)
 f16:	fef43023          	sd	a5,-32(s0)
 f1a:	fe843783          	ld	a5,-24(s0)
 f1e:	639c                	ld	a5,0(a5)
 f20:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 f24:	b799                	j	e6a <malloc+0x76>
  }
}
 f26:	853e                	mv	a0,a5
 f28:	70e2                	ld	ra,56(sp)
 f2a:	7442                	ld	s0,48(sp)
 f2c:	6121                	addi	sp,sp,64
 f2e:	8082                	ret
