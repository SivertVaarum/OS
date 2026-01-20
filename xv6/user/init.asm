
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   8:	4589                	li	a1,2
   a:	00001517          	auipc	a0,0x1
   e:	e2e50513          	addi	a0,a0,-466 # e38 <malloc+0x152>
  12:	00000097          	auipc	ra,0x0
  16:	5fa080e7          	jalr	1530(ra) # 60c <open>
  1a:	87aa                	mv	a5,a0
  1c:	0207d563          	bgez	a5,46 <main+0x46>
    mknod("console", CONSOLE, 0);
  20:	4601                	li	a2,0
  22:	4585                	li	a1,1
  24:	00001517          	auipc	a0,0x1
  28:	e1450513          	addi	a0,a0,-492 # e38 <malloc+0x152>
  2c:	00000097          	auipc	ra,0x0
  30:	5e8080e7          	jalr	1512(ra) # 614 <mknod>
    open("console", O_RDWR);
  34:	4589                	li	a1,2
  36:	00001517          	auipc	a0,0x1
  3a:	e0250513          	addi	a0,a0,-510 # e38 <malloc+0x152>
  3e:	00000097          	auipc	ra,0x0
  42:	5ce080e7          	jalr	1486(ra) # 60c <open>
  }
  dup(0);  // stdout
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	5fc080e7          	jalr	1532(ra) # 644 <dup>
  dup(0);  // stderr
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	5f2080e7          	jalr	1522(ra) # 644 <dup>

  for(;;){
    printf("init: starting sh\n");
  5a:	00001517          	auipc	a0,0x1
  5e:	de650513          	addi	a0,a0,-538 # e40 <malloc+0x15a>
  62:	00001097          	auipc	ra,0x1
  66:	a92080e7          	jalr	-1390(ra) # af4 <printf>
    pid = fork();
  6a:	00000097          	auipc	ra,0x0
  6e:	55a080e7          	jalr	1370(ra) # 5c4 <fork>
  72:	87aa                	mv	a5,a0
  74:	fef42623          	sw	a5,-20(s0)
    if(pid < 0){
  78:	fec42783          	lw	a5,-20(s0)
  7c:	2781                	sext.w	a5,a5
  7e:	0007df63          	bgez	a5,9c <main+0x9c>
      printf("init: fork failed\n");
  82:	00001517          	auipc	a0,0x1
  86:	dd650513          	addi	a0,a0,-554 # e58 <malloc+0x172>
  8a:	00001097          	auipc	ra,0x1
  8e:	a6a080e7          	jalr	-1430(ra) # af4 <printf>
      exit(1);
  92:	4505                	li	a0,1
  94:	00000097          	auipc	ra,0x0
  98:	538080e7          	jalr	1336(ra) # 5cc <exit>
    }
    if(pid == 0){
  9c:	fec42783          	lw	a5,-20(s0)
  a0:	2781                	sext.w	a5,a5
  a2:	eb95                	bnez	a5,d6 <main+0xd6>
      exec("sh", argv);
  a4:	00001597          	auipc	a1,0x1
  a8:	2cc58593          	addi	a1,a1,716 # 1370 <argv>
  ac:	00001517          	auipc	a0,0x1
  b0:	d8450513          	addi	a0,a0,-636 # e30 <malloc+0x14a>
  b4:	00000097          	auipc	ra,0x0
  b8:	550080e7          	jalr	1360(ra) # 604 <exec>
      printf("init: exec sh failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	db450513          	addi	a0,a0,-588 # e70 <malloc+0x18a>
  c4:	00001097          	auipc	ra,0x1
  c8:	a30080e7          	jalr	-1488(ra) # af4 <printf>
      exit(1);
  cc:	4505                	li	a0,1
  ce:	00000097          	auipc	ra,0x0
  d2:	4fe080e7          	jalr	1278(ra) # 5cc <exit>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	4fc080e7          	jalr	1276(ra) # 5d4 <wait>
  e0:	87aa                	mv	a5,a0
  e2:	fef42423          	sw	a5,-24(s0)
      if(wpid == pid){
  e6:	fe842783          	lw	a5,-24(s0)
  ea:	873e                	mv	a4,a5
  ec:	fec42783          	lw	a5,-20(s0)
  f0:	2701                	sext.w	a4,a4
  f2:	2781                	sext.w	a5,a5
  f4:	02f70463          	beq	a4,a5,11c <main+0x11c>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  f8:	fe842783          	lw	a5,-24(s0)
  fc:	2781                	sext.w	a5,a5
  fe:	fc07dce3          	bgez	a5,d6 <main+0xd6>
        printf("init: wait returned an error\n");
 102:	00001517          	auipc	a0,0x1
 106:	d8650513          	addi	a0,a0,-634 # e88 <malloc+0x1a2>
 10a:	00001097          	auipc	ra,0x1
 10e:	9ea080e7          	jalr	-1558(ra) # af4 <printf>
        exit(1);
 112:	4505                	li	a0,1
 114:	00000097          	auipc	ra,0x0
 118:	4b8080e7          	jalr	1208(ra) # 5cc <exit>
        break;
 11c:	0001                	nop
    printf("init: starting sh\n");
 11e:	bf35                	j	5a <main+0x5a>

0000000000000120 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 120:	1141                	addi	sp,sp,-16
 122:	e406                	sd	ra,8(sp)
 124:	e022                	sd	s0,0(sp)
 126:	0800                	addi	s0,sp,16
  extern int main();
  main();
 128:	00000097          	auipc	ra,0x0
 12c:	ed8080e7          	jalr	-296(ra) # 0 <main>
  exit(0);
 130:	4501                	li	a0,0
 132:	00000097          	auipc	ra,0x0
 136:	49a080e7          	jalr	1178(ra) # 5cc <exit>

000000000000013a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13a:	7179                	addi	sp,sp,-48
 13c:	f422                	sd	s0,40(sp)
 13e:	1800                	addi	s0,sp,48
 140:	fca43c23          	sd	a0,-40(s0)
 144:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 148:	fd843783          	ld	a5,-40(s0)
 14c:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 150:	0001                	nop
 152:	fd043703          	ld	a4,-48(s0)
 156:	00170793          	addi	a5,a4,1
 15a:	fcf43823          	sd	a5,-48(s0)
 15e:	fd843783          	ld	a5,-40(s0)
 162:	00178693          	addi	a3,a5,1
 166:	fcd43c23          	sd	a3,-40(s0)
 16a:	00074703          	lbu	a4,0(a4)
 16e:	00e78023          	sb	a4,0(a5)
 172:	0007c783          	lbu	a5,0(a5)
 176:	fff1                	bnez	a5,152 <strcpy+0x18>
    ;
  return os;
 178:	fe843783          	ld	a5,-24(s0)
}
 17c:	853e                	mv	a0,a5
 17e:	7422                	ld	s0,40(sp)
 180:	6145                	addi	sp,sp,48
 182:	8082                	ret

0000000000000184 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 184:	1101                	addi	sp,sp,-32
 186:	ec22                	sd	s0,24(sp)
 188:	1000                	addi	s0,sp,32
 18a:	fea43423          	sd	a0,-24(s0)
 18e:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 192:	a819                	j	1a8 <strcmp+0x24>
    p++, q++;
 194:	fe843783          	ld	a5,-24(s0)
 198:	0785                	addi	a5,a5,1
 19a:	fef43423          	sd	a5,-24(s0)
 19e:	fe043783          	ld	a5,-32(s0)
 1a2:	0785                	addi	a5,a5,1
 1a4:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 1a8:	fe843783          	ld	a5,-24(s0)
 1ac:	0007c783          	lbu	a5,0(a5)
 1b0:	cb99                	beqz	a5,1c6 <strcmp+0x42>
 1b2:	fe843783          	ld	a5,-24(s0)
 1b6:	0007c703          	lbu	a4,0(a5)
 1ba:	fe043783          	ld	a5,-32(s0)
 1be:	0007c783          	lbu	a5,0(a5)
 1c2:	fcf709e3          	beq	a4,a5,194 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 1c6:	fe843783          	ld	a5,-24(s0)
 1ca:	0007c783          	lbu	a5,0(a5)
 1ce:	0007871b          	sext.w	a4,a5
 1d2:	fe043783          	ld	a5,-32(s0)
 1d6:	0007c783          	lbu	a5,0(a5)
 1da:	2781                	sext.w	a5,a5
 1dc:	40f707bb          	subw	a5,a4,a5
 1e0:	2781                	sext.w	a5,a5
}
 1e2:	853e                	mv	a0,a5
 1e4:	6462                	ld	s0,24(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret

00000000000001ea <strlen>:

uint
strlen(const char *s)
{
 1ea:	7179                	addi	sp,sp,-48
 1ec:	f422                	sd	s0,40(sp)
 1ee:	1800                	addi	s0,sp,48
 1f0:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 1f4:	fe042623          	sw	zero,-20(s0)
 1f8:	a031                	j	204 <strlen+0x1a>
 1fa:	fec42783          	lw	a5,-20(s0)
 1fe:	2785                	addiw	a5,a5,1
 200:	fef42623          	sw	a5,-20(s0)
 204:	fec42783          	lw	a5,-20(s0)
 208:	fd843703          	ld	a4,-40(s0)
 20c:	97ba                	add	a5,a5,a4
 20e:	0007c783          	lbu	a5,0(a5)
 212:	f7e5                	bnez	a5,1fa <strlen+0x10>
    ;
  return n;
 214:	fec42783          	lw	a5,-20(s0)
}
 218:	853e                	mv	a0,a5
 21a:	7422                	ld	s0,40(sp)
 21c:	6145                	addi	sp,sp,48
 21e:	8082                	ret

0000000000000220 <memset>:

void*
memset(void *dst, int c, uint n)
{
 220:	7179                	addi	sp,sp,-48
 222:	f422                	sd	s0,40(sp)
 224:	1800                	addi	s0,sp,48
 226:	fca43c23          	sd	a0,-40(s0)
 22a:	87ae                	mv	a5,a1
 22c:	8732                	mv	a4,a2
 22e:	fcf42a23          	sw	a5,-44(s0)
 232:	87ba                	mv	a5,a4
 234:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 238:	fd843783          	ld	a5,-40(s0)
 23c:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 240:	fe042623          	sw	zero,-20(s0)
 244:	a00d                	j	266 <memset+0x46>
    cdst[i] = c;
 246:	fec42783          	lw	a5,-20(s0)
 24a:	fe043703          	ld	a4,-32(s0)
 24e:	97ba                	add	a5,a5,a4
 250:	fd442703          	lw	a4,-44(s0)
 254:	0ff77713          	zext.b	a4,a4
 258:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 25c:	fec42783          	lw	a5,-20(s0)
 260:	2785                	addiw	a5,a5,1
 262:	fef42623          	sw	a5,-20(s0)
 266:	fec42703          	lw	a4,-20(s0)
 26a:	fd042783          	lw	a5,-48(s0)
 26e:	2781                	sext.w	a5,a5
 270:	fcf76be3          	bltu	a4,a5,246 <memset+0x26>
  }
  return dst;
 274:	fd843783          	ld	a5,-40(s0)
}
 278:	853e                	mv	a0,a5
 27a:	7422                	ld	s0,40(sp)
 27c:	6145                	addi	sp,sp,48
 27e:	8082                	ret

0000000000000280 <strchr>:

char*
strchr(const char *s, char c)
{
 280:	1101                	addi	sp,sp,-32
 282:	ec22                	sd	s0,24(sp)
 284:	1000                	addi	s0,sp,32
 286:	fea43423          	sd	a0,-24(s0)
 28a:	87ae                	mv	a5,a1
 28c:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 290:	a01d                	j	2b6 <strchr+0x36>
    if(*s == c)
 292:	fe843783          	ld	a5,-24(s0)
 296:	0007c703          	lbu	a4,0(a5)
 29a:	fe744783          	lbu	a5,-25(s0)
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	00e79563          	bne	a5,a4,2ac <strchr+0x2c>
      return (char*)s;
 2a6:	fe843783          	ld	a5,-24(s0)
 2aa:	a821                	j	2c2 <strchr+0x42>
  for(; *s; s++)
 2ac:	fe843783          	ld	a5,-24(s0)
 2b0:	0785                	addi	a5,a5,1
 2b2:	fef43423          	sd	a5,-24(s0)
 2b6:	fe843783          	ld	a5,-24(s0)
 2ba:	0007c783          	lbu	a5,0(a5)
 2be:	fbf1                	bnez	a5,292 <strchr+0x12>
  return 0;
 2c0:	4781                	li	a5,0
}
 2c2:	853e                	mv	a0,a5
 2c4:	6462                	ld	s0,24(sp)
 2c6:	6105                	addi	sp,sp,32
 2c8:	8082                	ret

00000000000002ca <gets>:

char*
gets(char *buf, int max)
{
 2ca:	7179                	addi	sp,sp,-48
 2cc:	f406                	sd	ra,40(sp)
 2ce:	f022                	sd	s0,32(sp)
 2d0:	1800                	addi	s0,sp,48
 2d2:	fca43c23          	sd	a0,-40(s0)
 2d6:	87ae                	mv	a5,a1
 2d8:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2dc:	fe042623          	sw	zero,-20(s0)
 2e0:	a8a1                	j	338 <gets+0x6e>
    cc = read(0, &c, 1);
 2e2:	fe740793          	addi	a5,s0,-25
 2e6:	4605                	li	a2,1
 2e8:	85be                	mv	a1,a5
 2ea:	4501                	li	a0,0
 2ec:	00000097          	auipc	ra,0x0
 2f0:	2f8080e7          	jalr	760(ra) # 5e4 <read>
 2f4:	87aa                	mv	a5,a0
 2f6:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 2fa:	fe842783          	lw	a5,-24(s0)
 2fe:	2781                	sext.w	a5,a5
 300:	04f05763          	blez	a5,34e <gets+0x84>
      break;
    buf[i++] = c;
 304:	fec42783          	lw	a5,-20(s0)
 308:	0017871b          	addiw	a4,a5,1
 30c:	fee42623          	sw	a4,-20(s0)
 310:	873e                	mv	a4,a5
 312:	fd843783          	ld	a5,-40(s0)
 316:	97ba                	add	a5,a5,a4
 318:	fe744703          	lbu	a4,-25(s0)
 31c:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 320:	fe744783          	lbu	a5,-25(s0)
 324:	873e                	mv	a4,a5
 326:	47a9                	li	a5,10
 328:	02f70463          	beq	a4,a5,350 <gets+0x86>
 32c:	fe744783          	lbu	a5,-25(s0)
 330:	873e                	mv	a4,a5
 332:	47b5                	li	a5,13
 334:	00f70e63          	beq	a4,a5,350 <gets+0x86>
  for(i=0; i+1 < max; ){
 338:	fec42783          	lw	a5,-20(s0)
 33c:	2785                	addiw	a5,a5,1
 33e:	0007871b          	sext.w	a4,a5
 342:	fd442783          	lw	a5,-44(s0)
 346:	2781                	sext.w	a5,a5
 348:	f8f74de3          	blt	a4,a5,2e2 <gets+0x18>
 34c:	a011                	j	350 <gets+0x86>
      break;
 34e:	0001                	nop
      break;
  }
  buf[i] = '\0';
 350:	fec42783          	lw	a5,-20(s0)
 354:	fd843703          	ld	a4,-40(s0)
 358:	97ba                	add	a5,a5,a4
 35a:	00078023          	sb	zero,0(a5)
  return buf;
 35e:	fd843783          	ld	a5,-40(s0)
}
 362:	853e                	mv	a0,a5
 364:	70a2                	ld	ra,40(sp)
 366:	7402                	ld	s0,32(sp)
 368:	6145                	addi	sp,sp,48
 36a:	8082                	ret

000000000000036c <stat>:

int
stat(const char *n, struct stat *st)
{
 36c:	7179                	addi	sp,sp,-48
 36e:	f406                	sd	ra,40(sp)
 370:	f022                	sd	s0,32(sp)
 372:	1800                	addi	s0,sp,48
 374:	fca43c23          	sd	a0,-40(s0)
 378:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37c:	4581                	li	a1,0
 37e:	fd843503          	ld	a0,-40(s0)
 382:	00000097          	auipc	ra,0x0
 386:	28a080e7          	jalr	650(ra) # 60c <open>
 38a:	87aa                	mv	a5,a0
 38c:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 390:	fec42783          	lw	a5,-20(s0)
 394:	2781                	sext.w	a5,a5
 396:	0007d463          	bgez	a5,39e <stat+0x32>
    return -1;
 39a:	57fd                	li	a5,-1
 39c:	a035                	j	3c8 <stat+0x5c>
  r = fstat(fd, st);
 39e:	fec42783          	lw	a5,-20(s0)
 3a2:	fd043583          	ld	a1,-48(s0)
 3a6:	853e                	mv	a0,a5
 3a8:	00000097          	auipc	ra,0x0
 3ac:	27c080e7          	jalr	636(ra) # 624 <fstat>
 3b0:	87aa                	mv	a5,a0
 3b2:	fef42423          	sw	a5,-24(s0)
  close(fd);
 3b6:	fec42783          	lw	a5,-20(s0)
 3ba:	853e                	mv	a0,a5
 3bc:	00000097          	auipc	ra,0x0
 3c0:	238080e7          	jalr	568(ra) # 5f4 <close>
  return r;
 3c4:	fe842783          	lw	a5,-24(s0)
}
 3c8:	853e                	mv	a0,a5
 3ca:	70a2                	ld	ra,40(sp)
 3cc:	7402                	ld	s0,32(sp)
 3ce:	6145                	addi	sp,sp,48
 3d0:	8082                	ret

00000000000003d2 <atoi>:

int
atoi(const char *s)
{
 3d2:	7179                	addi	sp,sp,-48
 3d4:	f422                	sd	s0,40(sp)
 3d6:	1800                	addi	s0,sp,48
 3d8:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 3dc:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 3e0:	a81d                	j	416 <atoi+0x44>
    n = n*10 + *s++ - '0';
 3e2:	fec42783          	lw	a5,-20(s0)
 3e6:	873e                	mv	a4,a5
 3e8:	87ba                	mv	a5,a4
 3ea:	0027979b          	slliw	a5,a5,0x2
 3ee:	9fb9                	addw	a5,a5,a4
 3f0:	0017979b          	slliw	a5,a5,0x1
 3f4:	0007871b          	sext.w	a4,a5
 3f8:	fd843783          	ld	a5,-40(s0)
 3fc:	00178693          	addi	a3,a5,1
 400:	fcd43c23          	sd	a3,-40(s0)
 404:	0007c783          	lbu	a5,0(a5)
 408:	2781                	sext.w	a5,a5
 40a:	9fb9                	addw	a5,a5,a4
 40c:	2781                	sext.w	a5,a5
 40e:	fd07879b          	addiw	a5,a5,-48
 412:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 416:	fd843783          	ld	a5,-40(s0)
 41a:	0007c783          	lbu	a5,0(a5)
 41e:	873e                	mv	a4,a5
 420:	02f00793          	li	a5,47
 424:	00e7fb63          	bgeu	a5,a4,43a <atoi+0x68>
 428:	fd843783          	ld	a5,-40(s0)
 42c:	0007c783          	lbu	a5,0(a5)
 430:	873e                	mv	a4,a5
 432:	03900793          	li	a5,57
 436:	fae7f6e3          	bgeu	a5,a4,3e2 <atoi+0x10>
  return n;
 43a:	fec42783          	lw	a5,-20(s0)
}
 43e:	853e                	mv	a0,a5
 440:	7422                	ld	s0,40(sp)
 442:	6145                	addi	sp,sp,48
 444:	8082                	ret

0000000000000446 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 446:	7139                	addi	sp,sp,-64
 448:	fc22                	sd	s0,56(sp)
 44a:	0080                	addi	s0,sp,64
 44c:	fca43c23          	sd	a0,-40(s0)
 450:	fcb43823          	sd	a1,-48(s0)
 454:	87b2                	mv	a5,a2
 456:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 45a:	fd843783          	ld	a5,-40(s0)
 45e:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 462:	fd043783          	ld	a5,-48(s0)
 466:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 46a:	fe043703          	ld	a4,-32(s0)
 46e:	fe843783          	ld	a5,-24(s0)
 472:	02e7fc63          	bgeu	a5,a4,4aa <memmove+0x64>
    while(n-- > 0)
 476:	a00d                	j	498 <memmove+0x52>
      *dst++ = *src++;
 478:	fe043703          	ld	a4,-32(s0)
 47c:	00170793          	addi	a5,a4,1
 480:	fef43023          	sd	a5,-32(s0)
 484:	fe843783          	ld	a5,-24(s0)
 488:	00178693          	addi	a3,a5,1
 48c:	fed43423          	sd	a3,-24(s0)
 490:	00074703          	lbu	a4,0(a4)
 494:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 498:	fcc42783          	lw	a5,-52(s0)
 49c:	fff7871b          	addiw	a4,a5,-1
 4a0:	fce42623          	sw	a4,-52(s0)
 4a4:	fcf04ae3          	bgtz	a5,478 <memmove+0x32>
 4a8:	a891                	j	4fc <memmove+0xb6>
  } else {
    dst += n;
 4aa:	fcc42783          	lw	a5,-52(s0)
 4ae:	fe843703          	ld	a4,-24(s0)
 4b2:	97ba                	add	a5,a5,a4
 4b4:	fef43423          	sd	a5,-24(s0)
    src += n;
 4b8:	fcc42783          	lw	a5,-52(s0)
 4bc:	fe043703          	ld	a4,-32(s0)
 4c0:	97ba                	add	a5,a5,a4
 4c2:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 4c6:	a01d                	j	4ec <memmove+0xa6>
      *--dst = *--src;
 4c8:	fe043783          	ld	a5,-32(s0)
 4cc:	17fd                	addi	a5,a5,-1
 4ce:	fef43023          	sd	a5,-32(s0)
 4d2:	fe843783          	ld	a5,-24(s0)
 4d6:	17fd                	addi	a5,a5,-1
 4d8:	fef43423          	sd	a5,-24(s0)
 4dc:	fe043783          	ld	a5,-32(s0)
 4e0:	0007c703          	lbu	a4,0(a5)
 4e4:	fe843783          	ld	a5,-24(s0)
 4e8:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 4ec:	fcc42783          	lw	a5,-52(s0)
 4f0:	fff7871b          	addiw	a4,a5,-1
 4f4:	fce42623          	sw	a4,-52(s0)
 4f8:	fcf048e3          	bgtz	a5,4c8 <memmove+0x82>
  }
  return vdst;
 4fc:	fd843783          	ld	a5,-40(s0)
}
 500:	853e                	mv	a0,a5
 502:	7462                	ld	s0,56(sp)
 504:	6121                	addi	sp,sp,64
 506:	8082                	ret

0000000000000508 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 508:	7139                	addi	sp,sp,-64
 50a:	fc22                	sd	s0,56(sp)
 50c:	0080                	addi	s0,sp,64
 50e:	fca43c23          	sd	a0,-40(s0)
 512:	fcb43823          	sd	a1,-48(s0)
 516:	87b2                	mv	a5,a2
 518:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 51c:	fd843783          	ld	a5,-40(s0)
 520:	fef43423          	sd	a5,-24(s0)
 524:	fd043783          	ld	a5,-48(s0)
 528:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 52c:	a0a1                	j	574 <memcmp+0x6c>
    if (*p1 != *p2) {
 52e:	fe843783          	ld	a5,-24(s0)
 532:	0007c703          	lbu	a4,0(a5)
 536:	fe043783          	ld	a5,-32(s0)
 53a:	0007c783          	lbu	a5,0(a5)
 53e:	02f70163          	beq	a4,a5,560 <memcmp+0x58>
      return *p1 - *p2;
 542:	fe843783          	ld	a5,-24(s0)
 546:	0007c783          	lbu	a5,0(a5)
 54a:	0007871b          	sext.w	a4,a5
 54e:	fe043783          	ld	a5,-32(s0)
 552:	0007c783          	lbu	a5,0(a5)
 556:	2781                	sext.w	a5,a5
 558:	40f707bb          	subw	a5,a4,a5
 55c:	2781                	sext.w	a5,a5
 55e:	a01d                	j	584 <memcmp+0x7c>
    }
    p1++;
 560:	fe843783          	ld	a5,-24(s0)
 564:	0785                	addi	a5,a5,1
 566:	fef43423          	sd	a5,-24(s0)
    p2++;
 56a:	fe043783          	ld	a5,-32(s0)
 56e:	0785                	addi	a5,a5,1
 570:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 574:	fcc42783          	lw	a5,-52(s0)
 578:	fff7871b          	addiw	a4,a5,-1
 57c:	fce42623          	sw	a4,-52(s0)
 580:	f7dd                	bnez	a5,52e <memcmp+0x26>
  }
  return 0;
 582:	4781                	li	a5,0
}
 584:	853e                	mv	a0,a5
 586:	7462                	ld	s0,56(sp)
 588:	6121                	addi	sp,sp,64
 58a:	8082                	ret

000000000000058c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 58c:	7179                	addi	sp,sp,-48
 58e:	f406                	sd	ra,40(sp)
 590:	f022                	sd	s0,32(sp)
 592:	1800                	addi	s0,sp,48
 594:	fea43423          	sd	a0,-24(s0)
 598:	feb43023          	sd	a1,-32(s0)
 59c:	87b2                	mv	a5,a2
 59e:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 5a2:	fdc42783          	lw	a5,-36(s0)
 5a6:	863e                	mv	a2,a5
 5a8:	fe043583          	ld	a1,-32(s0)
 5ac:	fe843503          	ld	a0,-24(s0)
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e96080e7          	jalr	-362(ra) # 446 <memmove>
 5b8:	87aa                	mv	a5,a0
}
 5ba:	853e                	mv	a0,a5
 5bc:	70a2                	ld	ra,40(sp)
 5be:	7402                	ld	s0,32(sp)
 5c0:	6145                	addi	sp,sp,48
 5c2:	8082                	ret

00000000000005c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5c4:	4885                	li	a7,1
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 5cc:	4889                	li	a7,2
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5d4:	488d                	li	a7,3
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5dc:	4891                	li	a7,4
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <read>:
.global read
read:
 li a7, SYS_read
 5e4:	4895                	li	a7,5
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <write>:
.global write
write:
 li a7, SYS_write
 5ec:	48c1                	li	a7,16
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <close>:
.global close
close:
 li a7, SYS_close
 5f4:	48d5                	li	a7,21
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5fc:	4899                	li	a7,6
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <exec>:
.global exec
exec:
 li a7, SYS_exec
 604:	489d                	li	a7,7
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <open>:
.global open
open:
 li a7, SYS_open
 60c:	48bd                	li	a7,15
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 614:	48c5                	li	a7,17
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 61c:	48c9                	li	a7,18
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 624:	48a1                	li	a7,8
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <link>:
.global link
link:
 li a7, SYS_link
 62c:	48cd                	li	a7,19
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 634:	48d1                	li	a7,20
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 63c:	48a5                	li	a7,9
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <dup>:
.global dup
dup:
 li a7, SYS_dup
 644:	48a9                	li	a7,10
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 64c:	48ad                	li	a7,11
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 654:	48b1                	li	a7,12
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 65c:	48b5                	li	a7,13
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 664:	48b9                	li	a7,14
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 66c:	1101                	addi	sp,sp,-32
 66e:	ec06                	sd	ra,24(sp)
 670:	e822                	sd	s0,16(sp)
 672:	1000                	addi	s0,sp,32
 674:	87aa                	mv	a5,a0
 676:	872e                	mv	a4,a1
 678:	fef42623          	sw	a5,-20(s0)
 67c:	87ba                	mv	a5,a4
 67e:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 682:	feb40713          	addi	a4,s0,-21
 686:	fec42783          	lw	a5,-20(s0)
 68a:	4605                	li	a2,1
 68c:	85ba                	mv	a1,a4
 68e:	853e                	mv	a0,a5
 690:	00000097          	auipc	ra,0x0
 694:	f5c080e7          	jalr	-164(ra) # 5ec <write>
}
 698:	0001                	nop
 69a:	60e2                	ld	ra,24(sp)
 69c:	6442                	ld	s0,16(sp)
 69e:	6105                	addi	sp,sp,32
 6a0:	8082                	ret

00000000000006a2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6a2:	7139                	addi	sp,sp,-64
 6a4:	fc06                	sd	ra,56(sp)
 6a6:	f822                	sd	s0,48(sp)
 6a8:	0080                	addi	s0,sp,64
 6aa:	87aa                	mv	a5,a0
 6ac:	8736                	mv	a4,a3
 6ae:	fcf42623          	sw	a5,-52(s0)
 6b2:	87ae                	mv	a5,a1
 6b4:	fcf42423          	sw	a5,-56(s0)
 6b8:	87b2                	mv	a5,a2
 6ba:	fcf42223          	sw	a5,-60(s0)
 6be:	87ba                	mv	a5,a4
 6c0:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6c4:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 6c8:	fc042783          	lw	a5,-64(s0)
 6cc:	2781                	sext.w	a5,a5
 6ce:	c38d                	beqz	a5,6f0 <printint+0x4e>
 6d0:	fc842783          	lw	a5,-56(s0)
 6d4:	2781                	sext.w	a5,a5
 6d6:	0007dd63          	bgez	a5,6f0 <printint+0x4e>
    neg = 1;
 6da:	4785                	li	a5,1
 6dc:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 6e0:	fc842783          	lw	a5,-56(s0)
 6e4:	40f007bb          	negw	a5,a5
 6e8:	2781                	sext.w	a5,a5
 6ea:	fef42223          	sw	a5,-28(s0)
 6ee:	a029                	j	6f8 <printint+0x56>
  } else {
    x = xx;
 6f0:	fc842783          	lw	a5,-56(s0)
 6f4:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 6f8:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 6fc:	fc442783          	lw	a5,-60(s0)
 700:	fe442703          	lw	a4,-28(s0)
 704:	02f777bb          	remuw	a5,a4,a5
 708:	0007861b          	sext.w	a2,a5
 70c:	fec42783          	lw	a5,-20(s0)
 710:	0017871b          	addiw	a4,a5,1
 714:	fee42623          	sw	a4,-20(s0)
 718:	00001697          	auipc	a3,0x1
 71c:	c6868693          	addi	a3,a3,-920 # 1380 <digits>
 720:	02061713          	slli	a4,a2,0x20
 724:	9301                	srli	a4,a4,0x20
 726:	9736                	add	a4,a4,a3
 728:	00074703          	lbu	a4,0(a4)
 72c:	17c1                	addi	a5,a5,-16
 72e:	97a2                	add	a5,a5,s0
 730:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 734:	fc442783          	lw	a5,-60(s0)
 738:	fe442703          	lw	a4,-28(s0)
 73c:	02f757bb          	divuw	a5,a4,a5
 740:	fef42223          	sw	a5,-28(s0)
 744:	fe442783          	lw	a5,-28(s0)
 748:	2781                	sext.w	a5,a5
 74a:	fbcd                	bnez	a5,6fc <printint+0x5a>
  if(neg)
 74c:	fe842783          	lw	a5,-24(s0)
 750:	2781                	sext.w	a5,a5
 752:	cf85                	beqz	a5,78a <printint+0xe8>
    buf[i++] = '-';
 754:	fec42783          	lw	a5,-20(s0)
 758:	0017871b          	addiw	a4,a5,1
 75c:	fee42623          	sw	a4,-20(s0)
 760:	17c1                	addi	a5,a5,-16
 762:	97a2                	add	a5,a5,s0
 764:	02d00713          	li	a4,45
 768:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 76c:	a839                	j	78a <printint+0xe8>
    putc(fd, buf[i]);
 76e:	fec42783          	lw	a5,-20(s0)
 772:	17c1                	addi	a5,a5,-16
 774:	97a2                	add	a5,a5,s0
 776:	fe07c703          	lbu	a4,-32(a5)
 77a:	fcc42783          	lw	a5,-52(s0)
 77e:	85ba                	mv	a1,a4
 780:	853e                	mv	a0,a5
 782:	00000097          	auipc	ra,0x0
 786:	eea080e7          	jalr	-278(ra) # 66c <putc>
  while(--i >= 0)
 78a:	fec42783          	lw	a5,-20(s0)
 78e:	37fd                	addiw	a5,a5,-1
 790:	fef42623          	sw	a5,-20(s0)
 794:	fec42783          	lw	a5,-20(s0)
 798:	2781                	sext.w	a5,a5
 79a:	fc07dae3          	bgez	a5,76e <printint+0xcc>
}
 79e:	0001                	nop
 7a0:	0001                	nop
 7a2:	70e2                	ld	ra,56(sp)
 7a4:	7442                	ld	s0,48(sp)
 7a6:	6121                	addi	sp,sp,64
 7a8:	8082                	ret

00000000000007aa <printptr>:

static void
printptr(int fd, uint64 x) {
 7aa:	7179                	addi	sp,sp,-48
 7ac:	f406                	sd	ra,40(sp)
 7ae:	f022                	sd	s0,32(sp)
 7b0:	1800                	addi	s0,sp,48
 7b2:	87aa                	mv	a5,a0
 7b4:	fcb43823          	sd	a1,-48(s0)
 7b8:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 7bc:	fdc42783          	lw	a5,-36(s0)
 7c0:	03000593          	li	a1,48
 7c4:	853e                	mv	a0,a5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	ea6080e7          	jalr	-346(ra) # 66c <putc>
  putc(fd, 'x');
 7ce:	fdc42783          	lw	a5,-36(s0)
 7d2:	07800593          	li	a1,120
 7d6:	853e                	mv	a0,a5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	e94080e7          	jalr	-364(ra) # 66c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e0:	fe042623          	sw	zero,-20(s0)
 7e4:	a82d                	j	81e <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e6:	fd043783          	ld	a5,-48(s0)
 7ea:	93f1                	srli	a5,a5,0x3c
 7ec:	00001717          	auipc	a4,0x1
 7f0:	b9470713          	addi	a4,a4,-1132 # 1380 <digits>
 7f4:	97ba                	add	a5,a5,a4
 7f6:	0007c703          	lbu	a4,0(a5)
 7fa:	fdc42783          	lw	a5,-36(s0)
 7fe:	85ba                	mv	a1,a4
 800:	853e                	mv	a0,a5
 802:	00000097          	auipc	ra,0x0
 806:	e6a080e7          	jalr	-406(ra) # 66c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 80a:	fec42783          	lw	a5,-20(s0)
 80e:	2785                	addiw	a5,a5,1
 810:	fef42623          	sw	a5,-20(s0)
 814:	fd043783          	ld	a5,-48(s0)
 818:	0792                	slli	a5,a5,0x4
 81a:	fcf43823          	sd	a5,-48(s0)
 81e:	fec42783          	lw	a5,-20(s0)
 822:	873e                	mv	a4,a5
 824:	47bd                	li	a5,15
 826:	fce7f0e3          	bgeu	a5,a4,7e6 <printptr+0x3c>
}
 82a:	0001                	nop
 82c:	0001                	nop
 82e:	70a2                	ld	ra,40(sp)
 830:	7402                	ld	s0,32(sp)
 832:	6145                	addi	sp,sp,48
 834:	8082                	ret

0000000000000836 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 836:	715d                	addi	sp,sp,-80
 838:	e486                	sd	ra,72(sp)
 83a:	e0a2                	sd	s0,64(sp)
 83c:	0880                	addi	s0,sp,80
 83e:	87aa                	mv	a5,a0
 840:	fcb43023          	sd	a1,-64(s0)
 844:	fac43c23          	sd	a2,-72(s0)
 848:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 84c:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 850:	fe042223          	sw	zero,-28(s0)
 854:	a42d                	j	a7e <vprintf+0x248>
    c = fmt[i] & 0xff;
 856:	fe442783          	lw	a5,-28(s0)
 85a:	fc043703          	ld	a4,-64(s0)
 85e:	97ba                	add	a5,a5,a4
 860:	0007c783          	lbu	a5,0(a5)
 864:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 868:	fe042783          	lw	a5,-32(s0)
 86c:	2781                	sext.w	a5,a5
 86e:	eb9d                	bnez	a5,8a4 <vprintf+0x6e>
      if(c == '%'){
 870:	fdc42783          	lw	a5,-36(s0)
 874:	0007871b          	sext.w	a4,a5
 878:	02500793          	li	a5,37
 87c:	00f71763          	bne	a4,a5,88a <vprintf+0x54>
        state = '%';
 880:	02500793          	li	a5,37
 884:	fef42023          	sw	a5,-32(s0)
 888:	a2f5                	j	a74 <vprintf+0x23e>
      } else {
        putc(fd, c);
 88a:	fdc42783          	lw	a5,-36(s0)
 88e:	0ff7f713          	zext.b	a4,a5
 892:	fcc42783          	lw	a5,-52(s0)
 896:	85ba                	mv	a1,a4
 898:	853e                	mv	a0,a5
 89a:	00000097          	auipc	ra,0x0
 89e:	dd2080e7          	jalr	-558(ra) # 66c <putc>
 8a2:	aac9                	j	a74 <vprintf+0x23e>
      }
    } else if(state == '%'){
 8a4:	fe042783          	lw	a5,-32(s0)
 8a8:	0007871b          	sext.w	a4,a5
 8ac:	02500793          	li	a5,37
 8b0:	1cf71263          	bne	a4,a5,a74 <vprintf+0x23e>
      if(c == 'd'){
 8b4:	fdc42783          	lw	a5,-36(s0)
 8b8:	0007871b          	sext.w	a4,a5
 8bc:	06400793          	li	a5,100
 8c0:	02f71463          	bne	a4,a5,8e8 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 8c4:	fb843783          	ld	a5,-72(s0)
 8c8:	00878713          	addi	a4,a5,8
 8cc:	fae43c23          	sd	a4,-72(s0)
 8d0:	4398                	lw	a4,0(a5)
 8d2:	fcc42783          	lw	a5,-52(s0)
 8d6:	4685                	li	a3,1
 8d8:	4629                	li	a2,10
 8da:	85ba                	mv	a1,a4
 8dc:	853e                	mv	a0,a5
 8de:	00000097          	auipc	ra,0x0
 8e2:	dc4080e7          	jalr	-572(ra) # 6a2 <printint>
 8e6:	a269                	j	a70 <vprintf+0x23a>
      } else if(c == 'l') {
 8e8:	fdc42783          	lw	a5,-36(s0)
 8ec:	0007871b          	sext.w	a4,a5
 8f0:	06c00793          	li	a5,108
 8f4:	02f71663          	bne	a4,a5,920 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8f8:	fb843783          	ld	a5,-72(s0)
 8fc:	00878713          	addi	a4,a5,8
 900:	fae43c23          	sd	a4,-72(s0)
 904:	639c                	ld	a5,0(a5)
 906:	0007871b          	sext.w	a4,a5
 90a:	fcc42783          	lw	a5,-52(s0)
 90e:	4681                	li	a3,0
 910:	4629                	li	a2,10
 912:	85ba                	mv	a1,a4
 914:	853e                	mv	a0,a5
 916:	00000097          	auipc	ra,0x0
 91a:	d8c080e7          	jalr	-628(ra) # 6a2 <printint>
 91e:	aa89                	j	a70 <vprintf+0x23a>
      } else if(c == 'x') {
 920:	fdc42783          	lw	a5,-36(s0)
 924:	0007871b          	sext.w	a4,a5
 928:	07800793          	li	a5,120
 92c:	02f71463          	bne	a4,a5,954 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 930:	fb843783          	ld	a5,-72(s0)
 934:	00878713          	addi	a4,a5,8
 938:	fae43c23          	sd	a4,-72(s0)
 93c:	4398                	lw	a4,0(a5)
 93e:	fcc42783          	lw	a5,-52(s0)
 942:	4681                	li	a3,0
 944:	4641                	li	a2,16
 946:	85ba                	mv	a1,a4
 948:	853e                	mv	a0,a5
 94a:	00000097          	auipc	ra,0x0
 94e:	d58080e7          	jalr	-680(ra) # 6a2 <printint>
 952:	aa39                	j	a70 <vprintf+0x23a>
      } else if(c == 'p') {
 954:	fdc42783          	lw	a5,-36(s0)
 958:	0007871b          	sext.w	a4,a5
 95c:	07000793          	li	a5,112
 960:	02f71263          	bne	a4,a5,984 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 964:	fb843783          	ld	a5,-72(s0)
 968:	00878713          	addi	a4,a5,8
 96c:	fae43c23          	sd	a4,-72(s0)
 970:	6398                	ld	a4,0(a5)
 972:	fcc42783          	lw	a5,-52(s0)
 976:	85ba                	mv	a1,a4
 978:	853e                	mv	a0,a5
 97a:	00000097          	auipc	ra,0x0
 97e:	e30080e7          	jalr	-464(ra) # 7aa <printptr>
 982:	a0fd                	j	a70 <vprintf+0x23a>
      } else if(c == 's'){
 984:	fdc42783          	lw	a5,-36(s0)
 988:	0007871b          	sext.w	a4,a5
 98c:	07300793          	li	a5,115
 990:	04f71c63          	bne	a4,a5,9e8 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 994:	fb843783          	ld	a5,-72(s0)
 998:	00878713          	addi	a4,a5,8
 99c:	fae43c23          	sd	a4,-72(s0)
 9a0:	639c                	ld	a5,0(a5)
 9a2:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 9a6:	fe843783          	ld	a5,-24(s0)
 9aa:	eb8d                	bnez	a5,9dc <vprintf+0x1a6>
          s = "(null)";
 9ac:	00000797          	auipc	a5,0x0
 9b0:	4fc78793          	addi	a5,a5,1276 # ea8 <malloc+0x1c2>
 9b4:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 9b8:	a015                	j	9dc <vprintf+0x1a6>
          putc(fd, *s);
 9ba:	fe843783          	ld	a5,-24(s0)
 9be:	0007c703          	lbu	a4,0(a5)
 9c2:	fcc42783          	lw	a5,-52(s0)
 9c6:	85ba                	mv	a1,a4
 9c8:	853e                	mv	a0,a5
 9ca:	00000097          	auipc	ra,0x0
 9ce:	ca2080e7          	jalr	-862(ra) # 66c <putc>
          s++;
 9d2:	fe843783          	ld	a5,-24(s0)
 9d6:	0785                	addi	a5,a5,1
 9d8:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 9dc:	fe843783          	ld	a5,-24(s0)
 9e0:	0007c783          	lbu	a5,0(a5)
 9e4:	fbf9                	bnez	a5,9ba <vprintf+0x184>
 9e6:	a069                	j	a70 <vprintf+0x23a>
        }
      } else if(c == 'c'){
 9e8:	fdc42783          	lw	a5,-36(s0)
 9ec:	0007871b          	sext.w	a4,a5
 9f0:	06300793          	li	a5,99
 9f4:	02f71463          	bne	a4,a5,a1c <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 9f8:	fb843783          	ld	a5,-72(s0)
 9fc:	00878713          	addi	a4,a5,8
 a00:	fae43c23          	sd	a4,-72(s0)
 a04:	439c                	lw	a5,0(a5)
 a06:	0ff7f713          	zext.b	a4,a5
 a0a:	fcc42783          	lw	a5,-52(s0)
 a0e:	85ba                	mv	a1,a4
 a10:	853e                	mv	a0,a5
 a12:	00000097          	auipc	ra,0x0
 a16:	c5a080e7          	jalr	-934(ra) # 66c <putc>
 a1a:	a899                	j	a70 <vprintf+0x23a>
      } else if(c == '%'){
 a1c:	fdc42783          	lw	a5,-36(s0)
 a20:	0007871b          	sext.w	a4,a5
 a24:	02500793          	li	a5,37
 a28:	00f71f63          	bne	a4,a5,a46 <vprintf+0x210>
        putc(fd, c);
 a2c:	fdc42783          	lw	a5,-36(s0)
 a30:	0ff7f713          	zext.b	a4,a5
 a34:	fcc42783          	lw	a5,-52(s0)
 a38:	85ba                	mv	a1,a4
 a3a:	853e                	mv	a0,a5
 a3c:	00000097          	auipc	ra,0x0
 a40:	c30080e7          	jalr	-976(ra) # 66c <putc>
 a44:	a035                	j	a70 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a46:	fcc42783          	lw	a5,-52(s0)
 a4a:	02500593          	li	a1,37
 a4e:	853e                	mv	a0,a5
 a50:	00000097          	auipc	ra,0x0
 a54:	c1c080e7          	jalr	-996(ra) # 66c <putc>
        putc(fd, c);
 a58:	fdc42783          	lw	a5,-36(s0)
 a5c:	0ff7f713          	zext.b	a4,a5
 a60:	fcc42783          	lw	a5,-52(s0)
 a64:	85ba                	mv	a1,a4
 a66:	853e                	mv	a0,a5
 a68:	00000097          	auipc	ra,0x0
 a6c:	c04080e7          	jalr	-1020(ra) # 66c <putc>
      }
      state = 0;
 a70:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a74:	fe442783          	lw	a5,-28(s0)
 a78:	2785                	addiw	a5,a5,1
 a7a:	fef42223          	sw	a5,-28(s0)
 a7e:	fe442783          	lw	a5,-28(s0)
 a82:	fc043703          	ld	a4,-64(s0)
 a86:	97ba                	add	a5,a5,a4
 a88:	0007c783          	lbu	a5,0(a5)
 a8c:	dc0795e3          	bnez	a5,856 <vprintf+0x20>
    }
  }
}
 a90:	0001                	nop
 a92:	0001                	nop
 a94:	60a6                	ld	ra,72(sp)
 a96:	6406                	ld	s0,64(sp)
 a98:	6161                	addi	sp,sp,80
 a9a:	8082                	ret

0000000000000a9c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a9c:	7159                	addi	sp,sp,-112
 a9e:	fc06                	sd	ra,56(sp)
 aa0:	f822                	sd	s0,48(sp)
 aa2:	0080                	addi	s0,sp,64
 aa4:	fcb43823          	sd	a1,-48(s0)
 aa8:	e010                	sd	a2,0(s0)
 aaa:	e414                	sd	a3,8(s0)
 aac:	e818                	sd	a4,16(s0)
 aae:	ec1c                	sd	a5,24(s0)
 ab0:	03043023          	sd	a6,32(s0)
 ab4:	03143423          	sd	a7,40(s0)
 ab8:	87aa                	mv	a5,a0
 aba:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 abe:	03040793          	addi	a5,s0,48
 ac2:	fcf43423          	sd	a5,-56(s0)
 ac6:	fc843783          	ld	a5,-56(s0)
 aca:	fd078793          	addi	a5,a5,-48
 ace:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 ad2:	fe843703          	ld	a4,-24(s0)
 ad6:	fdc42783          	lw	a5,-36(s0)
 ada:	863a                	mv	a2,a4
 adc:	fd043583          	ld	a1,-48(s0)
 ae0:	853e                	mv	a0,a5
 ae2:	00000097          	auipc	ra,0x0
 ae6:	d54080e7          	jalr	-684(ra) # 836 <vprintf>
}
 aea:	0001                	nop
 aec:	70e2                	ld	ra,56(sp)
 aee:	7442                	ld	s0,48(sp)
 af0:	6165                	addi	sp,sp,112
 af2:	8082                	ret

0000000000000af4 <printf>:

void
printf(const char *fmt, ...)
{
 af4:	7159                	addi	sp,sp,-112
 af6:	f406                	sd	ra,40(sp)
 af8:	f022                	sd	s0,32(sp)
 afa:	1800                	addi	s0,sp,48
 afc:	fca43c23          	sd	a0,-40(s0)
 b00:	e40c                	sd	a1,8(s0)
 b02:	e810                	sd	a2,16(s0)
 b04:	ec14                	sd	a3,24(s0)
 b06:	f018                	sd	a4,32(s0)
 b08:	f41c                	sd	a5,40(s0)
 b0a:	03043823          	sd	a6,48(s0)
 b0e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b12:	04040793          	addi	a5,s0,64
 b16:	fcf43823          	sd	a5,-48(s0)
 b1a:	fd043783          	ld	a5,-48(s0)
 b1e:	fc878793          	addi	a5,a5,-56
 b22:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 b26:	fe843783          	ld	a5,-24(s0)
 b2a:	863e                	mv	a2,a5
 b2c:	fd843583          	ld	a1,-40(s0)
 b30:	4505                	li	a0,1
 b32:	00000097          	auipc	ra,0x0
 b36:	d04080e7          	jalr	-764(ra) # 836 <vprintf>
}
 b3a:	0001                	nop
 b3c:	70a2                	ld	ra,40(sp)
 b3e:	7402                	ld	s0,32(sp)
 b40:	6165                	addi	sp,sp,112
 b42:	8082                	ret

0000000000000b44 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b44:	7179                	addi	sp,sp,-48
 b46:	f422                	sd	s0,40(sp)
 b48:	1800                	addi	s0,sp,48
 b4a:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b4e:	fd843783          	ld	a5,-40(s0)
 b52:	17c1                	addi	a5,a5,-16
 b54:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b58:	00001797          	auipc	a5,0x1
 b5c:	85878793          	addi	a5,a5,-1960 # 13b0 <freep>
 b60:	639c                	ld	a5,0(a5)
 b62:	fef43423          	sd	a5,-24(s0)
 b66:	a815                	j	b9a <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b68:	fe843783          	ld	a5,-24(s0)
 b6c:	639c                	ld	a5,0(a5)
 b6e:	fe843703          	ld	a4,-24(s0)
 b72:	00f76f63          	bltu	a4,a5,b90 <free+0x4c>
 b76:	fe043703          	ld	a4,-32(s0)
 b7a:	fe843783          	ld	a5,-24(s0)
 b7e:	02e7eb63          	bltu	a5,a4,bb4 <free+0x70>
 b82:	fe843783          	ld	a5,-24(s0)
 b86:	639c                	ld	a5,0(a5)
 b88:	fe043703          	ld	a4,-32(s0)
 b8c:	02f76463          	bltu	a4,a5,bb4 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b90:	fe843783          	ld	a5,-24(s0)
 b94:	639c                	ld	a5,0(a5)
 b96:	fef43423          	sd	a5,-24(s0)
 b9a:	fe043703          	ld	a4,-32(s0)
 b9e:	fe843783          	ld	a5,-24(s0)
 ba2:	fce7f3e3          	bgeu	a5,a4,b68 <free+0x24>
 ba6:	fe843783          	ld	a5,-24(s0)
 baa:	639c                	ld	a5,0(a5)
 bac:	fe043703          	ld	a4,-32(s0)
 bb0:	faf77ce3          	bgeu	a4,a5,b68 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 bb4:	fe043783          	ld	a5,-32(s0)
 bb8:	479c                	lw	a5,8(a5)
 bba:	1782                	slli	a5,a5,0x20
 bbc:	9381                	srli	a5,a5,0x20
 bbe:	0792                	slli	a5,a5,0x4
 bc0:	fe043703          	ld	a4,-32(s0)
 bc4:	973e                	add	a4,a4,a5
 bc6:	fe843783          	ld	a5,-24(s0)
 bca:	639c                	ld	a5,0(a5)
 bcc:	02f71763          	bne	a4,a5,bfa <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 bd0:	fe043783          	ld	a5,-32(s0)
 bd4:	4798                	lw	a4,8(a5)
 bd6:	fe843783          	ld	a5,-24(s0)
 bda:	639c                	ld	a5,0(a5)
 bdc:	479c                	lw	a5,8(a5)
 bde:	9fb9                	addw	a5,a5,a4
 be0:	0007871b          	sext.w	a4,a5
 be4:	fe043783          	ld	a5,-32(s0)
 be8:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 bea:	fe843783          	ld	a5,-24(s0)
 bee:	639c                	ld	a5,0(a5)
 bf0:	6398                	ld	a4,0(a5)
 bf2:	fe043783          	ld	a5,-32(s0)
 bf6:	e398                	sd	a4,0(a5)
 bf8:	a039                	j	c06 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 bfa:	fe843783          	ld	a5,-24(s0)
 bfe:	6398                	ld	a4,0(a5)
 c00:	fe043783          	ld	a5,-32(s0)
 c04:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 c06:	fe843783          	ld	a5,-24(s0)
 c0a:	479c                	lw	a5,8(a5)
 c0c:	1782                	slli	a5,a5,0x20
 c0e:	9381                	srli	a5,a5,0x20
 c10:	0792                	slli	a5,a5,0x4
 c12:	fe843703          	ld	a4,-24(s0)
 c16:	97ba                	add	a5,a5,a4
 c18:	fe043703          	ld	a4,-32(s0)
 c1c:	02f71563          	bne	a4,a5,c46 <free+0x102>
    p->s.size += bp->s.size;
 c20:	fe843783          	ld	a5,-24(s0)
 c24:	4798                	lw	a4,8(a5)
 c26:	fe043783          	ld	a5,-32(s0)
 c2a:	479c                	lw	a5,8(a5)
 c2c:	9fb9                	addw	a5,a5,a4
 c2e:	0007871b          	sext.w	a4,a5
 c32:	fe843783          	ld	a5,-24(s0)
 c36:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c38:	fe043783          	ld	a5,-32(s0)
 c3c:	6398                	ld	a4,0(a5)
 c3e:	fe843783          	ld	a5,-24(s0)
 c42:	e398                	sd	a4,0(a5)
 c44:	a031                	j	c50 <free+0x10c>
  } else
    p->s.ptr = bp;
 c46:	fe843783          	ld	a5,-24(s0)
 c4a:	fe043703          	ld	a4,-32(s0)
 c4e:	e398                	sd	a4,0(a5)
  freep = p;
 c50:	00000797          	auipc	a5,0x0
 c54:	76078793          	addi	a5,a5,1888 # 13b0 <freep>
 c58:	fe843703          	ld	a4,-24(s0)
 c5c:	e398                	sd	a4,0(a5)
}
 c5e:	0001                	nop
 c60:	7422                	ld	s0,40(sp)
 c62:	6145                	addi	sp,sp,48
 c64:	8082                	ret

0000000000000c66 <morecore>:

static Header*
morecore(uint nu)
{
 c66:	7179                	addi	sp,sp,-48
 c68:	f406                	sd	ra,40(sp)
 c6a:	f022                	sd	s0,32(sp)
 c6c:	1800                	addi	s0,sp,48
 c6e:	87aa                	mv	a5,a0
 c70:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 c74:	fdc42783          	lw	a5,-36(s0)
 c78:	0007871b          	sext.w	a4,a5
 c7c:	6785                	lui	a5,0x1
 c7e:	00f77563          	bgeu	a4,a5,c88 <morecore+0x22>
    nu = 4096;
 c82:	6785                	lui	a5,0x1
 c84:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 c88:	fdc42783          	lw	a5,-36(s0)
 c8c:	0047979b          	slliw	a5,a5,0x4
 c90:	2781                	sext.w	a5,a5
 c92:	2781                	sext.w	a5,a5
 c94:	853e                	mv	a0,a5
 c96:	00000097          	auipc	ra,0x0
 c9a:	9be080e7          	jalr	-1602(ra) # 654 <sbrk>
 c9e:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 ca2:	fe843703          	ld	a4,-24(s0)
 ca6:	57fd                	li	a5,-1
 ca8:	00f71463          	bne	a4,a5,cb0 <morecore+0x4a>
    return 0;
 cac:	4781                	li	a5,0
 cae:	a03d                	j	cdc <morecore+0x76>
  hp = (Header*)p;
 cb0:	fe843783          	ld	a5,-24(s0)
 cb4:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 cb8:	fe043783          	ld	a5,-32(s0)
 cbc:	fdc42703          	lw	a4,-36(s0)
 cc0:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 cc2:	fe043783          	ld	a5,-32(s0)
 cc6:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x32a>
 cc8:	853e                	mv	a0,a5
 cca:	00000097          	auipc	ra,0x0
 cce:	e7a080e7          	jalr	-390(ra) # b44 <free>
  return freep;
 cd2:	00000797          	auipc	a5,0x0
 cd6:	6de78793          	addi	a5,a5,1758 # 13b0 <freep>
 cda:	639c                	ld	a5,0(a5)
}
 cdc:	853e                	mv	a0,a5
 cde:	70a2                	ld	ra,40(sp)
 ce0:	7402                	ld	s0,32(sp)
 ce2:	6145                	addi	sp,sp,48
 ce4:	8082                	ret

0000000000000ce6 <malloc>:

void*
malloc(uint nbytes)
{
 ce6:	7139                	addi	sp,sp,-64
 ce8:	fc06                	sd	ra,56(sp)
 cea:	f822                	sd	s0,48(sp)
 cec:	0080                	addi	s0,sp,64
 cee:	87aa                	mv	a5,a0
 cf0:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cf4:	fcc46783          	lwu	a5,-52(s0)
 cf8:	07bd                	addi	a5,a5,15
 cfa:	8391                	srli	a5,a5,0x4
 cfc:	2781                	sext.w	a5,a5
 cfe:	2785                	addiw	a5,a5,1
 d00:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 d04:	00000797          	auipc	a5,0x0
 d08:	6ac78793          	addi	a5,a5,1708 # 13b0 <freep>
 d0c:	639c                	ld	a5,0(a5)
 d0e:	fef43023          	sd	a5,-32(s0)
 d12:	fe043783          	ld	a5,-32(s0)
 d16:	ef95                	bnez	a5,d52 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 d18:	00000797          	auipc	a5,0x0
 d1c:	68878793          	addi	a5,a5,1672 # 13a0 <base>
 d20:	fef43023          	sd	a5,-32(s0)
 d24:	00000797          	auipc	a5,0x0
 d28:	68c78793          	addi	a5,a5,1676 # 13b0 <freep>
 d2c:	fe043703          	ld	a4,-32(s0)
 d30:	e398                	sd	a4,0(a5)
 d32:	00000797          	auipc	a5,0x0
 d36:	67e78793          	addi	a5,a5,1662 # 13b0 <freep>
 d3a:	6398                	ld	a4,0(a5)
 d3c:	00000797          	auipc	a5,0x0
 d40:	66478793          	addi	a5,a5,1636 # 13a0 <base>
 d44:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 d46:	00000797          	auipc	a5,0x0
 d4a:	65a78793          	addi	a5,a5,1626 # 13a0 <base>
 d4e:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d52:	fe043783          	ld	a5,-32(s0)
 d56:	639c                	ld	a5,0(a5)
 d58:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 d5c:	fe843783          	ld	a5,-24(s0)
 d60:	4798                	lw	a4,8(a5)
 d62:	fdc42783          	lw	a5,-36(s0)
 d66:	2781                	sext.w	a5,a5
 d68:	06f76763          	bltu	a4,a5,dd6 <malloc+0xf0>
      if(p->s.size == nunits)
 d6c:	fe843783          	ld	a5,-24(s0)
 d70:	4798                	lw	a4,8(a5)
 d72:	fdc42783          	lw	a5,-36(s0)
 d76:	2781                	sext.w	a5,a5
 d78:	00e79963          	bne	a5,a4,d8a <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 d7c:	fe843783          	ld	a5,-24(s0)
 d80:	6398                	ld	a4,0(a5)
 d82:	fe043783          	ld	a5,-32(s0)
 d86:	e398                	sd	a4,0(a5)
 d88:	a825                	j	dc0 <malloc+0xda>
      else {
        p->s.size -= nunits;
 d8a:	fe843783          	ld	a5,-24(s0)
 d8e:	479c                	lw	a5,8(a5)
 d90:	fdc42703          	lw	a4,-36(s0)
 d94:	9f99                	subw	a5,a5,a4
 d96:	0007871b          	sext.w	a4,a5
 d9a:	fe843783          	ld	a5,-24(s0)
 d9e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 da0:	fe843783          	ld	a5,-24(s0)
 da4:	479c                	lw	a5,8(a5)
 da6:	1782                	slli	a5,a5,0x20
 da8:	9381                	srli	a5,a5,0x20
 daa:	0792                	slli	a5,a5,0x4
 dac:	fe843703          	ld	a4,-24(s0)
 db0:	97ba                	add	a5,a5,a4
 db2:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 db6:	fe843783          	ld	a5,-24(s0)
 dba:	fdc42703          	lw	a4,-36(s0)
 dbe:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 dc0:	00000797          	auipc	a5,0x0
 dc4:	5f078793          	addi	a5,a5,1520 # 13b0 <freep>
 dc8:	fe043703          	ld	a4,-32(s0)
 dcc:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 dce:	fe843783          	ld	a5,-24(s0)
 dd2:	07c1                	addi	a5,a5,16
 dd4:	a091                	j	e18 <malloc+0x132>
    }
    if(p == freep)
 dd6:	00000797          	auipc	a5,0x0
 dda:	5da78793          	addi	a5,a5,1498 # 13b0 <freep>
 dde:	639c                	ld	a5,0(a5)
 de0:	fe843703          	ld	a4,-24(s0)
 de4:	02f71063          	bne	a4,a5,e04 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 de8:	fdc42783          	lw	a5,-36(s0)
 dec:	853e                	mv	a0,a5
 dee:	00000097          	auipc	ra,0x0
 df2:	e78080e7          	jalr	-392(ra) # c66 <morecore>
 df6:	fea43423          	sd	a0,-24(s0)
 dfa:	fe843783          	ld	a5,-24(s0)
 dfe:	e399                	bnez	a5,e04 <malloc+0x11e>
        return 0;
 e00:	4781                	li	a5,0
 e02:	a819                	j	e18 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e04:	fe843783          	ld	a5,-24(s0)
 e08:	fef43023          	sd	a5,-32(s0)
 e0c:	fe843783          	ld	a5,-24(s0)
 e10:	639c                	ld	a5,0(a5)
 e12:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 e16:	b799                	j	d5c <malloc+0x76>
  }
}
 e18:	853e                	mv	a0,a5
 e1a:	70e2                	ld	ra,56(sp)
 e1c:	7442                	ld	s0,48(sp)
 e1e:	6121                	addi	sp,sp,64
 e20:	8082                	ret
