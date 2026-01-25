
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	0080                	addi	s0,sp,64
       a:	fca43423          	sd	a0,-56(s0)
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
       e:	fc843503          	ld	a0,-56(s0)
      12:	00000097          	auipc	ra,0x0
      16:	45a080e7          	jalr	1114(ra) # 46c <strlen>
      1a:	87aa                	mv	a5,a0
      1c:	2781                	sext.w	a5,a5
      1e:	1782                	slli	a5,a5,0x20
      20:	9381                	srli	a5,a5,0x20
      22:	fc843703          	ld	a4,-56(s0)
      26:	97ba                	add	a5,a5,a4
      28:	fcf43c23          	sd	a5,-40(s0)
      2c:	a031                	j	38 <fmtname+0x38>
      2e:	fd843783          	ld	a5,-40(s0)
      32:	17fd                	addi	a5,a5,-1
      34:	fcf43c23          	sd	a5,-40(s0)
      38:	fd843703          	ld	a4,-40(s0)
      3c:	fc843783          	ld	a5,-56(s0)
      40:	00f76b63          	bltu	a4,a5,56 <fmtname+0x56>
      44:	fd843783          	ld	a5,-40(s0)
      48:	0007c783          	lbu	a5,0(a5)
      4c:	873e                	mv	a4,a5
      4e:	02f00793          	li	a5,47
      52:	fcf71ee3          	bne	a4,a5,2e <fmtname+0x2e>
    ;
  p++;
      56:	fd843783          	ld	a5,-40(s0)
      5a:	0785                	addi	a5,a5,1
      5c:	fcf43c23          	sd	a5,-40(s0)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
      60:	fd843503          	ld	a0,-40(s0)
      64:	00000097          	auipc	ra,0x0
      68:	408080e7          	jalr	1032(ra) # 46c <strlen>
      6c:	87aa                	mv	a5,a0
      6e:	2781                	sext.w	a5,a5
      70:	873e                	mv	a4,a5
      72:	47b5                	li	a5,13
      74:	00e7f563          	bgeu	a5,a4,7e <fmtname+0x7e>
    return p;
      78:	fd843783          	ld	a5,-40(s0)
      7c:	a8b5                	j	f8 <fmtname+0xf8>
  memmove(buf, p, strlen(p));
      7e:	fd843503          	ld	a0,-40(s0)
      82:	00000097          	auipc	ra,0x0
      86:	3ea080e7          	jalr	1002(ra) # 46c <strlen>
      8a:	87aa                	mv	a5,a0
      8c:	2781                	sext.w	a5,a5
      8e:	2781                	sext.w	a5,a5
      90:	863e                	mv	a2,a5
      92:	fd843583          	ld	a1,-40(s0)
      96:	00002517          	auipc	a0,0x2
      9a:	34a50513          	addi	a0,a0,842 # 23e0 <buf.0>
      9e:	00000097          	auipc	ra,0x0
      a2:	62a080e7          	jalr	1578(ra) # 6c8 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
      a6:	fd843503          	ld	a0,-40(s0)
      aa:	00000097          	auipc	ra,0x0
      ae:	3c2080e7          	jalr	962(ra) # 46c <strlen>
      b2:	87aa                	mv	a5,a0
      b4:	2781                	sext.w	a5,a5
      b6:	02079713          	slli	a4,a5,0x20
      ba:	9301                	srli	a4,a4,0x20
      bc:	00002797          	auipc	a5,0x2
      c0:	32478793          	addi	a5,a5,804 # 23e0 <buf.0>
      c4:	00f704b3          	add	s1,a4,a5
      c8:	fd843503          	ld	a0,-40(s0)
      cc:	00000097          	auipc	ra,0x0
      d0:	3a0080e7          	jalr	928(ra) # 46c <strlen>
      d4:	87aa                	mv	a5,a0
      d6:	2781                	sext.w	a5,a5
      d8:	4739                	li	a4,14
      da:	40f707bb          	subw	a5,a4,a5
      de:	2781                	sext.w	a5,a5
      e0:	863e                	mv	a2,a5
      e2:	02000593          	li	a1,32
      e6:	8526                	mv	a0,s1
      e8:	00000097          	auipc	ra,0x0
      ec:	3ba080e7          	jalr	954(ra) # 4a2 <memset>
  return buf;
      f0:	00002797          	auipc	a5,0x2
      f4:	2f078793          	addi	a5,a5,752 # 23e0 <buf.0>
}
      f8:	853e                	mv	a0,a5
      fa:	70e2                	ld	ra,56(sp)
      fc:	7442                	ld	s0,48(sp)
      fe:	74a2                	ld	s1,40(sp)
     100:	6121                	addi	sp,sp,64
     102:	8082                	ret

0000000000000104 <ls>:

void
ls(char *path)
{
     104:	da010113          	addi	sp,sp,-608
     108:	24113c23          	sd	ra,600(sp)
     10c:	24813823          	sd	s0,592(sp)
     110:	1480                	addi	s0,sp,608
     112:	daa43423          	sd	a0,-600(s0)
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
     116:	4581                	li	a1,0
     118:	da843503          	ld	a0,-600(s0)
     11c:	00000097          	auipc	ra,0x0
     120:	772080e7          	jalr	1906(ra) # 88e <open>
     124:	87aa                	mv	a5,a0
     126:	fef42623          	sw	a5,-20(s0)
     12a:	fec42783          	lw	a5,-20(s0)
     12e:	2781                	sext.w	a5,a5
     130:	0007de63          	bgez	a5,14c <ls+0x48>
    fprintf(2, "ls: cannot open %s\n", path);
     134:	da843603          	ld	a2,-600(s0)
     138:	00001597          	auipc	a1,0x1
     13c:	f7858593          	addi	a1,a1,-136 # 10b0 <malloc+0x140>
     140:	4509                	li	a0,2
     142:	00001097          	auipc	ra,0x1
     146:	be4080e7          	jalr	-1052(ra) # d26 <fprintf>
    return;
     14a:	a2e9                	j	314 <ls+0x210>
  }

  if(fstat(fd, &st) < 0){
     14c:	db840713          	addi	a4,s0,-584
     150:	fec42783          	lw	a5,-20(s0)
     154:	85ba                	mv	a1,a4
     156:	853e                	mv	a0,a5
     158:	00000097          	auipc	ra,0x0
     15c:	74e080e7          	jalr	1870(ra) # 8a6 <fstat>
     160:	87aa                	mv	a5,a0
     162:	0207d563          	bgez	a5,18c <ls+0x88>
    fprintf(2, "ls: cannot stat %s\n", path);
     166:	da843603          	ld	a2,-600(s0)
     16a:	00001597          	auipc	a1,0x1
     16e:	f5e58593          	addi	a1,a1,-162 # 10c8 <malloc+0x158>
     172:	4509                	li	a0,2
     174:	00001097          	auipc	ra,0x1
     178:	bb2080e7          	jalr	-1102(ra) # d26 <fprintf>
    close(fd);
     17c:	fec42783          	lw	a5,-20(s0)
     180:	853e                	mv	a0,a5
     182:	00000097          	auipc	ra,0x0
     186:	6f4080e7          	jalr	1780(ra) # 876 <close>
    return;
     18a:	a269                	j	314 <ls+0x210>
  }

  switch(st.type){
     18c:	dc041783          	lh	a5,-576(s0)
     190:	873e                	mv	a4,a5
     192:	86ba                	mv	a3,a4
     194:	4785                	li	a5,1
     196:	04f68563          	beq	a3,a5,1e0 <ls+0xdc>
     19a:	87ba                	mv	a5,a4
     19c:	16f05563          	blez	a5,306 <ls+0x202>
     1a0:	0007079b          	sext.w	a5,a4
     1a4:	37f9                	addiw	a5,a5,-2
     1a6:	2781                	sext.w	a5,a5
     1a8:	873e                	mv	a4,a5
     1aa:	4785                	li	a5,1
     1ac:	14e7ed63          	bltu	a5,a4,306 <ls+0x202>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
     1b0:	da843503          	ld	a0,-600(s0)
     1b4:	00000097          	auipc	ra,0x0
     1b8:	e4c080e7          	jalr	-436(ra) # 0 <fmtname>
     1bc:	85aa                	mv	a1,a0
     1be:	dc041783          	lh	a5,-576(s0)
     1c2:	863e                	mv	a2,a5
     1c4:	dbc42783          	lw	a5,-580(s0)
     1c8:	dc843703          	ld	a4,-568(s0)
     1cc:	86be                	mv	a3,a5
     1ce:	00001517          	auipc	a0,0x1
     1d2:	f1250513          	addi	a0,a0,-238 # 10e0 <malloc+0x170>
     1d6:	00001097          	auipc	ra,0x1
     1da:	ba8080e7          	jalr	-1112(ra) # d7e <printf>
    break;
     1de:	a225                	j	306 <ls+0x202>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
     1e0:	da843503          	ld	a0,-600(s0)
     1e4:	00000097          	auipc	ra,0x0
     1e8:	288080e7          	jalr	648(ra) # 46c <strlen>
     1ec:	87aa                	mv	a5,a0
     1ee:	2781                	sext.w	a5,a5
     1f0:	27c1                	addiw	a5,a5,16
     1f2:	2781                	sext.w	a5,a5
     1f4:	873e                	mv	a4,a5
     1f6:	20000793          	li	a5,512
     1fa:	00e7fb63          	bgeu	a5,a4,210 <ls+0x10c>
      printf("ls: path too long\n");
     1fe:	00001517          	auipc	a0,0x1
     202:	ef250513          	addi	a0,a0,-270 # 10f0 <malloc+0x180>
     206:	00001097          	auipc	ra,0x1
     20a:	b78080e7          	jalr	-1160(ra) # d7e <printf>
      break;
     20e:	a8e5                	j	306 <ls+0x202>
    }
    strcpy(buf, path);
     210:	de040793          	addi	a5,s0,-544
     214:	da843583          	ld	a1,-600(s0)
     218:	853e                	mv	a0,a5
     21a:	00000097          	auipc	ra,0x0
     21e:	1a2080e7          	jalr	418(ra) # 3bc <strcpy>
    p = buf+strlen(buf);
     222:	de040793          	addi	a5,s0,-544
     226:	853e                	mv	a0,a5
     228:	00000097          	auipc	ra,0x0
     22c:	244080e7          	jalr	580(ra) # 46c <strlen>
     230:	87aa                	mv	a5,a0
     232:	2781                	sext.w	a5,a5
     234:	1782                	slli	a5,a5,0x20
     236:	9381                	srli	a5,a5,0x20
     238:	de040713          	addi	a4,s0,-544
     23c:	97ba                	add	a5,a5,a4
     23e:	fef43023          	sd	a5,-32(s0)
    *p++ = '/';
     242:	fe043783          	ld	a5,-32(s0)
     246:	00178713          	addi	a4,a5,1
     24a:	fee43023          	sd	a4,-32(s0)
     24e:	02f00713          	li	a4,47
     252:	00e78023          	sb	a4,0(a5)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     256:	a079                	j	2e4 <ls+0x1e0>
      if(de.inum == 0)
     258:	dd045783          	lhu	a5,-560(s0)
     25c:	c3d9                	beqz	a5,2e2 <ls+0x1de>
        continue;
      memmove(p, de.name, DIRSIZ);
     25e:	dd040793          	addi	a5,s0,-560
     262:	0789                	addi	a5,a5,2
     264:	4639                	li	a2,14
     266:	85be                	mv	a1,a5
     268:	fe043503          	ld	a0,-32(s0)
     26c:	00000097          	auipc	ra,0x0
     270:	45c080e7          	jalr	1116(ra) # 6c8 <memmove>
      p[DIRSIZ] = 0;
     274:	fe043783          	ld	a5,-32(s0)
     278:	07b9                	addi	a5,a5,14
     27a:	00078023          	sb	zero,0(a5)
      if(stat(buf, &st) < 0){
     27e:	db840713          	addi	a4,s0,-584
     282:	de040793          	addi	a5,s0,-544
     286:	85ba                	mv	a1,a4
     288:	853e                	mv	a0,a5
     28a:	00000097          	auipc	ra,0x0
     28e:	364080e7          	jalr	868(ra) # 5ee <stat>
     292:	87aa                	mv	a5,a0
     294:	0007de63          	bgez	a5,2b0 <ls+0x1ac>
        printf("ls: cannot stat %s\n", buf);
     298:	de040793          	addi	a5,s0,-544
     29c:	85be                	mv	a1,a5
     29e:	00001517          	auipc	a0,0x1
     2a2:	e2a50513          	addi	a0,a0,-470 # 10c8 <malloc+0x158>
     2a6:	00001097          	auipc	ra,0x1
     2aa:	ad8080e7          	jalr	-1320(ra) # d7e <printf>
        continue;
     2ae:	a81d                	j	2e4 <ls+0x1e0>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
     2b0:	de040793          	addi	a5,s0,-544
     2b4:	853e                	mv	a0,a5
     2b6:	00000097          	auipc	ra,0x0
     2ba:	d4a080e7          	jalr	-694(ra) # 0 <fmtname>
     2be:	85aa                	mv	a1,a0
     2c0:	dc041783          	lh	a5,-576(s0)
     2c4:	863e                	mv	a2,a5
     2c6:	dbc42783          	lw	a5,-580(s0)
     2ca:	dc843703          	ld	a4,-568(s0)
     2ce:	86be                	mv	a3,a5
     2d0:	00001517          	auipc	a0,0x1
     2d4:	e3850513          	addi	a0,a0,-456 # 1108 <malloc+0x198>
     2d8:	00001097          	auipc	ra,0x1
     2dc:	aa6080e7          	jalr	-1370(ra) # d7e <printf>
     2e0:	a011                	j	2e4 <ls+0x1e0>
        continue;
     2e2:	0001                	nop
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     2e4:	dd040713          	addi	a4,s0,-560
     2e8:	fec42783          	lw	a5,-20(s0)
     2ec:	4641                	li	a2,16
     2ee:	85ba                	mv	a1,a4
     2f0:	853e                	mv	a0,a5
     2f2:	00000097          	auipc	ra,0x0
     2f6:	574080e7          	jalr	1396(ra) # 866 <read>
     2fa:	87aa                	mv	a5,a0
     2fc:	873e                	mv	a4,a5
     2fe:	47c1                	li	a5,16
     300:	f4f70ce3          	beq	a4,a5,258 <ls+0x154>
    }
    break;
     304:	0001                	nop
  }
  close(fd);
     306:	fec42783          	lw	a5,-20(s0)
     30a:	853e                	mv	a0,a5
     30c:	00000097          	auipc	ra,0x0
     310:	56a080e7          	jalr	1386(ra) # 876 <close>
}
     314:	25813083          	ld	ra,600(sp)
     318:	25013403          	ld	s0,592(sp)
     31c:	26010113          	addi	sp,sp,608
     320:	8082                	ret

0000000000000322 <main>:

int
main(int argc, char *argv[])
{
     322:	7179                	addi	sp,sp,-48
     324:	f406                	sd	ra,40(sp)
     326:	f022                	sd	s0,32(sp)
     328:	1800                	addi	s0,sp,48
     32a:	87aa                	mv	a5,a0
     32c:	fcb43823          	sd	a1,-48(s0)
     330:	fcf42e23          	sw	a5,-36(s0)
  int i;

  if(argc < 2){
     334:	fdc42783          	lw	a5,-36(s0)
     338:	0007871b          	sext.w	a4,a5
     33c:	4785                	li	a5,1
     33e:	00e7cf63          	blt	a5,a4,35c <main+0x3a>
    ls(".");
     342:	00001517          	auipc	a0,0x1
     346:	dd650513          	addi	a0,a0,-554 # 1118 <malloc+0x1a8>
     34a:	00000097          	auipc	ra,0x0
     34e:	dba080e7          	jalr	-582(ra) # 104 <ls>
    exit(0);
     352:	4501                	li	a0,0
     354:	00000097          	auipc	ra,0x0
     358:	4fa080e7          	jalr	1274(ra) # 84e <exit>
  }
  for(i=1; i<argc; i++)
     35c:	4785                	li	a5,1
     35e:	fef42623          	sw	a5,-20(s0)
     362:	a015                	j	386 <main+0x64>
    ls(argv[i]);
     364:	fec42783          	lw	a5,-20(s0)
     368:	078e                	slli	a5,a5,0x3
     36a:	fd043703          	ld	a4,-48(s0)
     36e:	97ba                	add	a5,a5,a4
     370:	639c                	ld	a5,0(a5)
     372:	853e                	mv	a0,a5
     374:	00000097          	auipc	ra,0x0
     378:	d90080e7          	jalr	-624(ra) # 104 <ls>
  for(i=1; i<argc; i++)
     37c:	fec42783          	lw	a5,-20(s0)
     380:	2785                	addiw	a5,a5,1
     382:	fef42623          	sw	a5,-20(s0)
     386:	fec42783          	lw	a5,-20(s0)
     38a:	873e                	mv	a4,a5
     38c:	fdc42783          	lw	a5,-36(s0)
     390:	2701                	sext.w	a4,a4
     392:	2781                	sext.w	a5,a5
     394:	fcf748e3          	blt	a4,a5,364 <main+0x42>
  exit(0);
     398:	4501                	li	a0,0
     39a:	00000097          	auipc	ra,0x0
     39e:	4b4080e7          	jalr	1204(ra) # 84e <exit>

00000000000003a2 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     3a2:	1141                	addi	sp,sp,-16
     3a4:	e406                	sd	ra,8(sp)
     3a6:	e022                	sd	s0,0(sp)
     3a8:	0800                	addi	s0,sp,16
  extern int main();
  main();
     3aa:	00000097          	auipc	ra,0x0
     3ae:	f78080e7          	jalr	-136(ra) # 322 <main>
  exit(0);
     3b2:	4501                	li	a0,0
     3b4:	00000097          	auipc	ra,0x0
     3b8:	49a080e7          	jalr	1178(ra) # 84e <exit>

00000000000003bc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     3bc:	7179                	addi	sp,sp,-48
     3be:	f422                	sd	s0,40(sp)
     3c0:	1800                	addi	s0,sp,48
     3c2:	fca43c23          	sd	a0,-40(s0)
     3c6:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
     3ca:	fd843783          	ld	a5,-40(s0)
     3ce:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
     3d2:	0001                	nop
     3d4:	fd043703          	ld	a4,-48(s0)
     3d8:	00170793          	addi	a5,a4,1
     3dc:	fcf43823          	sd	a5,-48(s0)
     3e0:	fd843783          	ld	a5,-40(s0)
     3e4:	00178693          	addi	a3,a5,1
     3e8:	fcd43c23          	sd	a3,-40(s0)
     3ec:	00074703          	lbu	a4,0(a4)
     3f0:	00e78023          	sb	a4,0(a5)
     3f4:	0007c783          	lbu	a5,0(a5)
     3f8:	fff1                	bnez	a5,3d4 <strcpy+0x18>
    ;
  return os;
     3fa:	fe843783          	ld	a5,-24(s0)
}
     3fe:	853e                	mv	a0,a5
     400:	7422                	ld	s0,40(sp)
     402:	6145                	addi	sp,sp,48
     404:	8082                	ret

0000000000000406 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     406:	1101                	addi	sp,sp,-32
     408:	ec22                	sd	s0,24(sp)
     40a:	1000                	addi	s0,sp,32
     40c:	fea43423          	sd	a0,-24(s0)
     410:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
     414:	a819                	j	42a <strcmp+0x24>
    p++, q++;
     416:	fe843783          	ld	a5,-24(s0)
     41a:	0785                	addi	a5,a5,1
     41c:	fef43423          	sd	a5,-24(s0)
     420:	fe043783          	ld	a5,-32(s0)
     424:	0785                	addi	a5,a5,1
     426:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
     42a:	fe843783          	ld	a5,-24(s0)
     42e:	0007c783          	lbu	a5,0(a5)
     432:	cb99                	beqz	a5,448 <strcmp+0x42>
     434:	fe843783          	ld	a5,-24(s0)
     438:	0007c703          	lbu	a4,0(a5)
     43c:	fe043783          	ld	a5,-32(s0)
     440:	0007c783          	lbu	a5,0(a5)
     444:	fcf709e3          	beq	a4,a5,416 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
     448:	fe843783          	ld	a5,-24(s0)
     44c:	0007c783          	lbu	a5,0(a5)
     450:	0007871b          	sext.w	a4,a5
     454:	fe043783          	ld	a5,-32(s0)
     458:	0007c783          	lbu	a5,0(a5)
     45c:	2781                	sext.w	a5,a5
     45e:	40f707bb          	subw	a5,a4,a5
     462:	2781                	sext.w	a5,a5
}
     464:	853e                	mv	a0,a5
     466:	6462                	ld	s0,24(sp)
     468:	6105                	addi	sp,sp,32
     46a:	8082                	ret

000000000000046c <strlen>:

uint
strlen(const char *s)
{
     46c:	7179                	addi	sp,sp,-48
     46e:	f422                	sd	s0,40(sp)
     470:	1800                	addi	s0,sp,48
     472:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
     476:	fe042623          	sw	zero,-20(s0)
     47a:	a031                	j	486 <strlen+0x1a>
     47c:	fec42783          	lw	a5,-20(s0)
     480:	2785                	addiw	a5,a5,1
     482:	fef42623          	sw	a5,-20(s0)
     486:	fec42783          	lw	a5,-20(s0)
     48a:	fd843703          	ld	a4,-40(s0)
     48e:	97ba                	add	a5,a5,a4
     490:	0007c783          	lbu	a5,0(a5)
     494:	f7e5                	bnez	a5,47c <strlen+0x10>
    ;
  return n;
     496:	fec42783          	lw	a5,-20(s0)
}
     49a:	853e                	mv	a0,a5
     49c:	7422                	ld	s0,40(sp)
     49e:	6145                	addi	sp,sp,48
     4a0:	8082                	ret

00000000000004a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
     4a2:	7179                	addi	sp,sp,-48
     4a4:	f422                	sd	s0,40(sp)
     4a6:	1800                	addi	s0,sp,48
     4a8:	fca43c23          	sd	a0,-40(s0)
     4ac:	87ae                	mv	a5,a1
     4ae:	8732                	mv	a4,a2
     4b0:	fcf42a23          	sw	a5,-44(s0)
     4b4:	87ba                	mv	a5,a4
     4b6:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
     4ba:	fd843783          	ld	a5,-40(s0)
     4be:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
     4c2:	fe042623          	sw	zero,-20(s0)
     4c6:	a00d                	j	4e8 <memset+0x46>
    cdst[i] = c;
     4c8:	fec42783          	lw	a5,-20(s0)
     4cc:	fe043703          	ld	a4,-32(s0)
     4d0:	97ba                	add	a5,a5,a4
     4d2:	fd442703          	lw	a4,-44(s0)
     4d6:	0ff77713          	zext.b	a4,a4
     4da:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
     4de:	fec42783          	lw	a5,-20(s0)
     4e2:	2785                	addiw	a5,a5,1
     4e4:	fef42623          	sw	a5,-20(s0)
     4e8:	fec42703          	lw	a4,-20(s0)
     4ec:	fd042783          	lw	a5,-48(s0)
     4f0:	2781                	sext.w	a5,a5
     4f2:	fcf76be3          	bltu	a4,a5,4c8 <memset+0x26>
  }
  return dst;
     4f6:	fd843783          	ld	a5,-40(s0)
}
     4fa:	853e                	mv	a0,a5
     4fc:	7422                	ld	s0,40(sp)
     4fe:	6145                	addi	sp,sp,48
     500:	8082                	ret

0000000000000502 <strchr>:

char*
strchr(const char *s, char c)
{
     502:	1101                	addi	sp,sp,-32
     504:	ec22                	sd	s0,24(sp)
     506:	1000                	addi	s0,sp,32
     508:	fea43423          	sd	a0,-24(s0)
     50c:	87ae                	mv	a5,a1
     50e:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
     512:	a01d                	j	538 <strchr+0x36>
    if(*s == c)
     514:	fe843783          	ld	a5,-24(s0)
     518:	0007c703          	lbu	a4,0(a5)
     51c:	fe744783          	lbu	a5,-25(s0)
     520:	0ff7f793          	zext.b	a5,a5
     524:	00e79563          	bne	a5,a4,52e <strchr+0x2c>
      return (char*)s;
     528:	fe843783          	ld	a5,-24(s0)
     52c:	a821                	j	544 <strchr+0x42>
  for(; *s; s++)
     52e:	fe843783          	ld	a5,-24(s0)
     532:	0785                	addi	a5,a5,1
     534:	fef43423          	sd	a5,-24(s0)
     538:	fe843783          	ld	a5,-24(s0)
     53c:	0007c783          	lbu	a5,0(a5)
     540:	fbf1                	bnez	a5,514 <strchr+0x12>
  return 0;
     542:	4781                	li	a5,0
}
     544:	853e                	mv	a0,a5
     546:	6462                	ld	s0,24(sp)
     548:	6105                	addi	sp,sp,32
     54a:	8082                	ret

000000000000054c <gets>:

char*
gets(char *buf, int max)
{
     54c:	7179                	addi	sp,sp,-48
     54e:	f406                	sd	ra,40(sp)
     550:	f022                	sd	s0,32(sp)
     552:	1800                	addi	s0,sp,48
     554:	fca43c23          	sd	a0,-40(s0)
     558:	87ae                	mv	a5,a1
     55a:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     55e:	fe042623          	sw	zero,-20(s0)
     562:	a8a1                	j	5ba <gets+0x6e>
    cc = read(0, &c, 1);
     564:	fe740793          	addi	a5,s0,-25
     568:	4605                	li	a2,1
     56a:	85be                	mv	a1,a5
     56c:	4501                	li	a0,0
     56e:	00000097          	auipc	ra,0x0
     572:	2f8080e7          	jalr	760(ra) # 866 <read>
     576:	87aa                	mv	a5,a0
     578:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
     57c:	fe842783          	lw	a5,-24(s0)
     580:	2781                	sext.w	a5,a5
     582:	04f05763          	blez	a5,5d0 <gets+0x84>
      break;
    buf[i++] = c;
     586:	fec42783          	lw	a5,-20(s0)
     58a:	0017871b          	addiw	a4,a5,1
     58e:	fee42623          	sw	a4,-20(s0)
     592:	873e                	mv	a4,a5
     594:	fd843783          	ld	a5,-40(s0)
     598:	97ba                	add	a5,a5,a4
     59a:	fe744703          	lbu	a4,-25(s0)
     59e:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
     5a2:	fe744783          	lbu	a5,-25(s0)
     5a6:	873e                	mv	a4,a5
     5a8:	47a9                	li	a5,10
     5aa:	02f70463          	beq	a4,a5,5d2 <gets+0x86>
     5ae:	fe744783          	lbu	a5,-25(s0)
     5b2:	873e                	mv	a4,a5
     5b4:	47b5                	li	a5,13
     5b6:	00f70e63          	beq	a4,a5,5d2 <gets+0x86>
  for(i=0; i+1 < max; ){
     5ba:	fec42783          	lw	a5,-20(s0)
     5be:	2785                	addiw	a5,a5,1
     5c0:	0007871b          	sext.w	a4,a5
     5c4:	fd442783          	lw	a5,-44(s0)
     5c8:	2781                	sext.w	a5,a5
     5ca:	f8f74de3          	blt	a4,a5,564 <gets+0x18>
     5ce:	a011                	j	5d2 <gets+0x86>
      break;
     5d0:	0001                	nop
      break;
  }
  buf[i] = '\0';
     5d2:	fec42783          	lw	a5,-20(s0)
     5d6:	fd843703          	ld	a4,-40(s0)
     5da:	97ba                	add	a5,a5,a4
     5dc:	00078023          	sb	zero,0(a5)
  return buf;
     5e0:	fd843783          	ld	a5,-40(s0)
}
     5e4:	853e                	mv	a0,a5
     5e6:	70a2                	ld	ra,40(sp)
     5e8:	7402                	ld	s0,32(sp)
     5ea:	6145                	addi	sp,sp,48
     5ec:	8082                	ret

00000000000005ee <stat>:

int
stat(const char *n, struct stat *st)
{
     5ee:	7179                	addi	sp,sp,-48
     5f0:	f406                	sd	ra,40(sp)
     5f2:	f022                	sd	s0,32(sp)
     5f4:	1800                	addi	s0,sp,48
     5f6:	fca43c23          	sd	a0,-40(s0)
     5fa:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     5fe:	4581                	li	a1,0
     600:	fd843503          	ld	a0,-40(s0)
     604:	00000097          	auipc	ra,0x0
     608:	28a080e7          	jalr	650(ra) # 88e <open>
     60c:	87aa                	mv	a5,a0
     60e:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
     612:	fec42783          	lw	a5,-20(s0)
     616:	2781                	sext.w	a5,a5
     618:	0007d463          	bgez	a5,620 <stat+0x32>
    return -1;
     61c:	57fd                	li	a5,-1
     61e:	a035                	j	64a <stat+0x5c>
  r = fstat(fd, st);
     620:	fec42783          	lw	a5,-20(s0)
     624:	fd043583          	ld	a1,-48(s0)
     628:	853e                	mv	a0,a5
     62a:	00000097          	auipc	ra,0x0
     62e:	27c080e7          	jalr	636(ra) # 8a6 <fstat>
     632:	87aa                	mv	a5,a0
     634:	fef42423          	sw	a5,-24(s0)
  close(fd);
     638:	fec42783          	lw	a5,-20(s0)
     63c:	853e                	mv	a0,a5
     63e:	00000097          	auipc	ra,0x0
     642:	238080e7          	jalr	568(ra) # 876 <close>
  return r;
     646:	fe842783          	lw	a5,-24(s0)
}
     64a:	853e                	mv	a0,a5
     64c:	70a2                	ld	ra,40(sp)
     64e:	7402                	ld	s0,32(sp)
     650:	6145                	addi	sp,sp,48
     652:	8082                	ret

0000000000000654 <atoi>:

int
atoi(const char *s)
{
     654:	7179                	addi	sp,sp,-48
     656:	f422                	sd	s0,40(sp)
     658:	1800                	addi	s0,sp,48
     65a:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
     65e:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
     662:	a81d                	j	698 <atoi+0x44>
    n = n*10 + *s++ - '0';
     664:	fec42783          	lw	a5,-20(s0)
     668:	873e                	mv	a4,a5
     66a:	87ba                	mv	a5,a4
     66c:	0027979b          	slliw	a5,a5,0x2
     670:	9fb9                	addw	a5,a5,a4
     672:	0017979b          	slliw	a5,a5,0x1
     676:	0007871b          	sext.w	a4,a5
     67a:	fd843783          	ld	a5,-40(s0)
     67e:	00178693          	addi	a3,a5,1
     682:	fcd43c23          	sd	a3,-40(s0)
     686:	0007c783          	lbu	a5,0(a5)
     68a:	2781                	sext.w	a5,a5
     68c:	9fb9                	addw	a5,a5,a4
     68e:	2781                	sext.w	a5,a5
     690:	fd07879b          	addiw	a5,a5,-48
     694:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
     698:	fd843783          	ld	a5,-40(s0)
     69c:	0007c783          	lbu	a5,0(a5)
     6a0:	873e                	mv	a4,a5
     6a2:	02f00793          	li	a5,47
     6a6:	00e7fb63          	bgeu	a5,a4,6bc <atoi+0x68>
     6aa:	fd843783          	ld	a5,-40(s0)
     6ae:	0007c783          	lbu	a5,0(a5)
     6b2:	873e                	mv	a4,a5
     6b4:	03900793          	li	a5,57
     6b8:	fae7f6e3          	bgeu	a5,a4,664 <atoi+0x10>
  return n;
     6bc:	fec42783          	lw	a5,-20(s0)
}
     6c0:	853e                	mv	a0,a5
     6c2:	7422                	ld	s0,40(sp)
     6c4:	6145                	addi	sp,sp,48
     6c6:	8082                	ret

00000000000006c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     6c8:	7139                	addi	sp,sp,-64
     6ca:	fc22                	sd	s0,56(sp)
     6cc:	0080                	addi	s0,sp,64
     6ce:	fca43c23          	sd	a0,-40(s0)
     6d2:	fcb43823          	sd	a1,-48(s0)
     6d6:	87b2                	mv	a5,a2
     6d8:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
     6dc:	fd843783          	ld	a5,-40(s0)
     6e0:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
     6e4:	fd043783          	ld	a5,-48(s0)
     6e8:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
     6ec:	fe043703          	ld	a4,-32(s0)
     6f0:	fe843783          	ld	a5,-24(s0)
     6f4:	02e7fc63          	bgeu	a5,a4,72c <memmove+0x64>
    while(n-- > 0)
     6f8:	a00d                	j	71a <memmove+0x52>
      *dst++ = *src++;
     6fa:	fe043703          	ld	a4,-32(s0)
     6fe:	00170793          	addi	a5,a4,1
     702:	fef43023          	sd	a5,-32(s0)
     706:	fe843783          	ld	a5,-24(s0)
     70a:	00178693          	addi	a3,a5,1
     70e:	fed43423          	sd	a3,-24(s0)
     712:	00074703          	lbu	a4,0(a4)
     716:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     71a:	fcc42783          	lw	a5,-52(s0)
     71e:	fff7871b          	addiw	a4,a5,-1
     722:	fce42623          	sw	a4,-52(s0)
     726:	fcf04ae3          	bgtz	a5,6fa <memmove+0x32>
     72a:	a891                	j	77e <memmove+0xb6>
  } else {
    dst += n;
     72c:	fcc42783          	lw	a5,-52(s0)
     730:	fe843703          	ld	a4,-24(s0)
     734:	97ba                	add	a5,a5,a4
     736:	fef43423          	sd	a5,-24(s0)
    src += n;
     73a:	fcc42783          	lw	a5,-52(s0)
     73e:	fe043703          	ld	a4,-32(s0)
     742:	97ba                	add	a5,a5,a4
     744:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
     748:	a01d                	j	76e <memmove+0xa6>
      *--dst = *--src;
     74a:	fe043783          	ld	a5,-32(s0)
     74e:	17fd                	addi	a5,a5,-1
     750:	fef43023          	sd	a5,-32(s0)
     754:	fe843783          	ld	a5,-24(s0)
     758:	17fd                	addi	a5,a5,-1
     75a:	fef43423          	sd	a5,-24(s0)
     75e:	fe043783          	ld	a5,-32(s0)
     762:	0007c703          	lbu	a4,0(a5)
     766:	fe843783          	ld	a5,-24(s0)
     76a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     76e:	fcc42783          	lw	a5,-52(s0)
     772:	fff7871b          	addiw	a4,a5,-1
     776:	fce42623          	sw	a4,-52(s0)
     77a:	fcf048e3          	bgtz	a5,74a <memmove+0x82>
  }
  return vdst;
     77e:	fd843783          	ld	a5,-40(s0)
}
     782:	853e                	mv	a0,a5
     784:	7462                	ld	s0,56(sp)
     786:	6121                	addi	sp,sp,64
     788:	8082                	ret

000000000000078a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     78a:	7139                	addi	sp,sp,-64
     78c:	fc22                	sd	s0,56(sp)
     78e:	0080                	addi	s0,sp,64
     790:	fca43c23          	sd	a0,-40(s0)
     794:	fcb43823          	sd	a1,-48(s0)
     798:	87b2                	mv	a5,a2
     79a:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
     79e:	fd843783          	ld	a5,-40(s0)
     7a2:	fef43423          	sd	a5,-24(s0)
     7a6:	fd043783          	ld	a5,-48(s0)
     7aa:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     7ae:	a0a1                	j	7f6 <memcmp+0x6c>
    if (*p1 != *p2) {
     7b0:	fe843783          	ld	a5,-24(s0)
     7b4:	0007c703          	lbu	a4,0(a5)
     7b8:	fe043783          	ld	a5,-32(s0)
     7bc:	0007c783          	lbu	a5,0(a5)
     7c0:	02f70163          	beq	a4,a5,7e2 <memcmp+0x58>
      return *p1 - *p2;
     7c4:	fe843783          	ld	a5,-24(s0)
     7c8:	0007c783          	lbu	a5,0(a5)
     7cc:	0007871b          	sext.w	a4,a5
     7d0:	fe043783          	ld	a5,-32(s0)
     7d4:	0007c783          	lbu	a5,0(a5)
     7d8:	2781                	sext.w	a5,a5
     7da:	40f707bb          	subw	a5,a4,a5
     7de:	2781                	sext.w	a5,a5
     7e0:	a01d                	j	806 <memcmp+0x7c>
    }
    p1++;
     7e2:	fe843783          	ld	a5,-24(s0)
     7e6:	0785                	addi	a5,a5,1
     7e8:	fef43423          	sd	a5,-24(s0)
    p2++;
     7ec:	fe043783          	ld	a5,-32(s0)
     7f0:	0785                	addi	a5,a5,1
     7f2:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     7f6:	fcc42783          	lw	a5,-52(s0)
     7fa:	fff7871b          	addiw	a4,a5,-1
     7fe:	fce42623          	sw	a4,-52(s0)
     802:	f7dd                	bnez	a5,7b0 <memcmp+0x26>
  }
  return 0;
     804:	4781                	li	a5,0
}
     806:	853e                	mv	a0,a5
     808:	7462                	ld	s0,56(sp)
     80a:	6121                	addi	sp,sp,64
     80c:	8082                	ret

000000000000080e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     80e:	7179                	addi	sp,sp,-48
     810:	f406                	sd	ra,40(sp)
     812:	f022                	sd	s0,32(sp)
     814:	1800                	addi	s0,sp,48
     816:	fea43423          	sd	a0,-24(s0)
     81a:	feb43023          	sd	a1,-32(s0)
     81e:	87b2                	mv	a5,a2
     820:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
     824:	fdc42783          	lw	a5,-36(s0)
     828:	863e                	mv	a2,a5
     82a:	fe043583          	ld	a1,-32(s0)
     82e:	fe843503          	ld	a0,-24(s0)
     832:	00000097          	auipc	ra,0x0
     836:	e96080e7          	jalr	-362(ra) # 6c8 <memmove>
     83a:	87aa                	mv	a5,a0
}
     83c:	853e                	mv	a0,a5
     83e:	70a2                	ld	ra,40(sp)
     840:	7402                	ld	s0,32(sp)
     842:	6145                	addi	sp,sp,48
     844:	8082                	ret

0000000000000846 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     846:	4885                	li	a7,1
 ecall
     848:	00000073          	ecall
 ret
     84c:	8082                	ret

000000000000084e <exit>:
.global exit
exit:
 li a7, SYS_exit
     84e:	4889                	li	a7,2
 ecall
     850:	00000073          	ecall
 ret
     854:	8082                	ret

0000000000000856 <wait>:
.global wait
wait:
 li a7, SYS_wait
     856:	488d                	li	a7,3
 ecall
     858:	00000073          	ecall
 ret
     85c:	8082                	ret

000000000000085e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     85e:	4891                	li	a7,4
 ecall
     860:	00000073          	ecall
 ret
     864:	8082                	ret

0000000000000866 <read>:
.global read
read:
 li a7, SYS_read
     866:	4895                	li	a7,5
 ecall
     868:	00000073          	ecall
 ret
     86c:	8082                	ret

000000000000086e <write>:
.global write
write:
 li a7, SYS_write
     86e:	48c1                	li	a7,16
 ecall
     870:	00000073          	ecall
 ret
     874:	8082                	ret

0000000000000876 <close>:
.global close
close:
 li a7, SYS_close
     876:	48d5                	li	a7,21
 ecall
     878:	00000073          	ecall
 ret
     87c:	8082                	ret

000000000000087e <kill>:
.global kill
kill:
 li a7, SYS_kill
     87e:	4899                	li	a7,6
 ecall
     880:	00000073          	ecall
 ret
     884:	8082                	ret

0000000000000886 <exec>:
.global exec
exec:
 li a7, SYS_exec
     886:	489d                	li	a7,7
 ecall
     888:	00000073          	ecall
 ret
     88c:	8082                	ret

000000000000088e <open>:
.global open
open:
 li a7, SYS_open
     88e:	48bd                	li	a7,15
 ecall
     890:	00000073          	ecall
 ret
     894:	8082                	ret

0000000000000896 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     896:	48c5                	li	a7,17
 ecall
     898:	00000073          	ecall
 ret
     89c:	8082                	ret

000000000000089e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     89e:	48c9                	li	a7,18
 ecall
     8a0:	00000073          	ecall
 ret
     8a4:	8082                	ret

00000000000008a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     8a6:	48a1                	li	a7,8
 ecall
     8a8:	00000073          	ecall
 ret
     8ac:	8082                	ret

00000000000008ae <link>:
.global link
link:
 li a7, SYS_link
     8ae:	48cd                	li	a7,19
 ecall
     8b0:	00000073          	ecall
 ret
     8b4:	8082                	ret

00000000000008b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     8b6:	48d1                	li	a7,20
 ecall
     8b8:	00000073          	ecall
 ret
     8bc:	8082                	ret

00000000000008be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     8be:	48a5                	li	a7,9
 ecall
     8c0:	00000073          	ecall
 ret
     8c4:	8082                	ret

00000000000008c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     8c6:	48a9                	li	a7,10
 ecall
     8c8:	00000073          	ecall
 ret
     8cc:	8082                	ret

00000000000008ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     8ce:	48ad                	li	a7,11
 ecall
     8d0:	00000073          	ecall
 ret
     8d4:	8082                	ret

00000000000008d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     8d6:	48b1                	li	a7,12
 ecall
     8d8:	00000073          	ecall
 ret
     8dc:	8082                	ret

00000000000008de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     8de:	48b5                	li	a7,13
 ecall
     8e0:	00000073          	ecall
 ret
     8e4:	8082                	ret

00000000000008e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     8e6:	48b9                	li	a7,14
 ecall
     8e8:	00000073          	ecall
 ret
     8ec:	8082                	ret

00000000000008ee <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
     8ee:	48d9                	li	a7,22
 ecall
     8f0:	00000073          	ecall
 ret
     8f4:	8082                	ret

00000000000008f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     8f6:	1101                	addi	sp,sp,-32
     8f8:	ec06                	sd	ra,24(sp)
     8fa:	e822                	sd	s0,16(sp)
     8fc:	1000                	addi	s0,sp,32
     8fe:	87aa                	mv	a5,a0
     900:	872e                	mv	a4,a1
     902:	fef42623          	sw	a5,-20(s0)
     906:	87ba                	mv	a5,a4
     908:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
     90c:	feb40713          	addi	a4,s0,-21
     910:	fec42783          	lw	a5,-20(s0)
     914:	4605                	li	a2,1
     916:	85ba                	mv	a1,a4
     918:	853e                	mv	a0,a5
     91a:	00000097          	auipc	ra,0x0
     91e:	f54080e7          	jalr	-172(ra) # 86e <write>
}
     922:	0001                	nop
     924:	60e2                	ld	ra,24(sp)
     926:	6442                	ld	s0,16(sp)
     928:	6105                	addi	sp,sp,32
     92a:	8082                	ret

000000000000092c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     92c:	7139                	addi	sp,sp,-64
     92e:	fc06                	sd	ra,56(sp)
     930:	f822                	sd	s0,48(sp)
     932:	0080                	addi	s0,sp,64
     934:	87aa                	mv	a5,a0
     936:	8736                	mv	a4,a3
     938:	fcf42623          	sw	a5,-52(s0)
     93c:	87ae                	mv	a5,a1
     93e:	fcf42423          	sw	a5,-56(s0)
     942:	87b2                	mv	a5,a2
     944:	fcf42223          	sw	a5,-60(s0)
     948:	87ba                	mv	a5,a4
     94a:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     94e:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
     952:	fc042783          	lw	a5,-64(s0)
     956:	2781                	sext.w	a5,a5
     958:	c38d                	beqz	a5,97a <printint+0x4e>
     95a:	fc842783          	lw	a5,-56(s0)
     95e:	2781                	sext.w	a5,a5
     960:	0007dd63          	bgez	a5,97a <printint+0x4e>
    neg = 1;
     964:	4785                	li	a5,1
     966:	fef42423          	sw	a5,-24(s0)
    x = -xx;
     96a:	fc842783          	lw	a5,-56(s0)
     96e:	40f007bb          	negw	a5,a5
     972:	2781                	sext.w	a5,a5
     974:	fef42223          	sw	a5,-28(s0)
     978:	a029                	j	982 <printint+0x56>
  } else {
    x = xx;
     97a:	fc842783          	lw	a5,-56(s0)
     97e:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
     982:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
     986:	fc442783          	lw	a5,-60(s0)
     98a:	fe442703          	lw	a4,-28(s0)
     98e:	02f777bb          	remuw	a5,a4,a5
     992:	0007861b          	sext.w	a2,a5
     996:	fec42783          	lw	a5,-20(s0)
     99a:	0017871b          	addiw	a4,a5,1
     99e:	fee42623          	sw	a4,-20(s0)
     9a2:	00002697          	auipc	a3,0x2
     9a6:	a1e68693          	addi	a3,a3,-1506 # 23c0 <digits>
     9aa:	02061713          	slli	a4,a2,0x20
     9ae:	9301                	srli	a4,a4,0x20
     9b0:	9736                	add	a4,a4,a3
     9b2:	00074703          	lbu	a4,0(a4)
     9b6:	17c1                	addi	a5,a5,-16
     9b8:	97a2                	add	a5,a5,s0
     9ba:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
     9be:	fc442783          	lw	a5,-60(s0)
     9c2:	fe442703          	lw	a4,-28(s0)
     9c6:	02f757bb          	divuw	a5,a4,a5
     9ca:	fef42223          	sw	a5,-28(s0)
     9ce:	fe442783          	lw	a5,-28(s0)
     9d2:	2781                	sext.w	a5,a5
     9d4:	fbcd                	bnez	a5,986 <printint+0x5a>
  if(neg)
     9d6:	fe842783          	lw	a5,-24(s0)
     9da:	2781                	sext.w	a5,a5
     9dc:	cf85                	beqz	a5,a14 <printint+0xe8>
    buf[i++] = '-';
     9de:	fec42783          	lw	a5,-20(s0)
     9e2:	0017871b          	addiw	a4,a5,1
     9e6:	fee42623          	sw	a4,-20(s0)
     9ea:	17c1                	addi	a5,a5,-16
     9ec:	97a2                	add	a5,a5,s0
     9ee:	02d00713          	li	a4,45
     9f2:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
     9f6:	a839                	j	a14 <printint+0xe8>
    putc(fd, buf[i]);
     9f8:	fec42783          	lw	a5,-20(s0)
     9fc:	17c1                	addi	a5,a5,-16
     9fe:	97a2                	add	a5,a5,s0
     a00:	fe07c703          	lbu	a4,-32(a5)
     a04:	fcc42783          	lw	a5,-52(s0)
     a08:	85ba                	mv	a1,a4
     a0a:	853e                	mv	a0,a5
     a0c:	00000097          	auipc	ra,0x0
     a10:	eea080e7          	jalr	-278(ra) # 8f6 <putc>
  while(--i >= 0)
     a14:	fec42783          	lw	a5,-20(s0)
     a18:	37fd                	addiw	a5,a5,-1
     a1a:	fef42623          	sw	a5,-20(s0)
     a1e:	fec42783          	lw	a5,-20(s0)
     a22:	2781                	sext.w	a5,a5
     a24:	fc07dae3          	bgez	a5,9f8 <printint+0xcc>
}
     a28:	0001                	nop
     a2a:	0001                	nop
     a2c:	70e2                	ld	ra,56(sp)
     a2e:	7442                	ld	s0,48(sp)
     a30:	6121                	addi	sp,sp,64
     a32:	8082                	ret

0000000000000a34 <printptr>:

static void
printptr(int fd, uint64 x) {
     a34:	7179                	addi	sp,sp,-48
     a36:	f406                	sd	ra,40(sp)
     a38:	f022                	sd	s0,32(sp)
     a3a:	1800                	addi	s0,sp,48
     a3c:	87aa                	mv	a5,a0
     a3e:	fcb43823          	sd	a1,-48(s0)
     a42:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
     a46:	fdc42783          	lw	a5,-36(s0)
     a4a:	03000593          	li	a1,48
     a4e:	853e                	mv	a0,a5
     a50:	00000097          	auipc	ra,0x0
     a54:	ea6080e7          	jalr	-346(ra) # 8f6 <putc>
  putc(fd, 'x');
     a58:	fdc42783          	lw	a5,-36(s0)
     a5c:	07800593          	li	a1,120
     a60:	853e                	mv	a0,a5
     a62:	00000097          	auipc	ra,0x0
     a66:	e94080e7          	jalr	-364(ra) # 8f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     a6a:	fe042623          	sw	zero,-20(s0)
     a6e:	a82d                	j	aa8 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     a70:	fd043783          	ld	a5,-48(s0)
     a74:	93f1                	srli	a5,a5,0x3c
     a76:	00002717          	auipc	a4,0x2
     a7a:	94a70713          	addi	a4,a4,-1718 # 23c0 <digits>
     a7e:	97ba                	add	a5,a5,a4
     a80:	0007c703          	lbu	a4,0(a5)
     a84:	fdc42783          	lw	a5,-36(s0)
     a88:	85ba                	mv	a1,a4
     a8a:	853e                	mv	a0,a5
     a8c:	00000097          	auipc	ra,0x0
     a90:	e6a080e7          	jalr	-406(ra) # 8f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     a94:	fec42783          	lw	a5,-20(s0)
     a98:	2785                	addiw	a5,a5,1
     a9a:	fef42623          	sw	a5,-20(s0)
     a9e:	fd043783          	ld	a5,-48(s0)
     aa2:	0792                	slli	a5,a5,0x4
     aa4:	fcf43823          	sd	a5,-48(s0)
     aa8:	fec42783          	lw	a5,-20(s0)
     aac:	873e                	mv	a4,a5
     aae:	47bd                	li	a5,15
     ab0:	fce7f0e3          	bgeu	a5,a4,a70 <printptr+0x3c>
}
     ab4:	0001                	nop
     ab6:	0001                	nop
     ab8:	70a2                	ld	ra,40(sp)
     aba:	7402                	ld	s0,32(sp)
     abc:	6145                	addi	sp,sp,48
     abe:	8082                	ret

0000000000000ac0 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ac0:	715d                	addi	sp,sp,-80
     ac2:	e486                	sd	ra,72(sp)
     ac4:	e0a2                	sd	s0,64(sp)
     ac6:	0880                	addi	s0,sp,80
     ac8:	87aa                	mv	a5,a0
     aca:	fcb43023          	sd	a1,-64(s0)
     ace:	fac43c23          	sd	a2,-72(s0)
     ad2:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
     ad6:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     ada:	fe042223          	sw	zero,-28(s0)
     ade:	a42d                	j	d08 <vprintf+0x248>
    c = fmt[i] & 0xff;
     ae0:	fe442783          	lw	a5,-28(s0)
     ae4:	fc043703          	ld	a4,-64(s0)
     ae8:	97ba                	add	a5,a5,a4
     aea:	0007c783          	lbu	a5,0(a5)
     aee:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
     af2:	fe042783          	lw	a5,-32(s0)
     af6:	2781                	sext.w	a5,a5
     af8:	eb9d                	bnez	a5,b2e <vprintf+0x6e>
      if(c == '%'){
     afa:	fdc42783          	lw	a5,-36(s0)
     afe:	0007871b          	sext.w	a4,a5
     b02:	02500793          	li	a5,37
     b06:	00f71763          	bne	a4,a5,b14 <vprintf+0x54>
        state = '%';
     b0a:	02500793          	li	a5,37
     b0e:	fef42023          	sw	a5,-32(s0)
     b12:	a2f5                	j	cfe <vprintf+0x23e>
      } else {
        putc(fd, c);
     b14:	fdc42783          	lw	a5,-36(s0)
     b18:	0ff7f713          	zext.b	a4,a5
     b1c:	fcc42783          	lw	a5,-52(s0)
     b20:	85ba                	mv	a1,a4
     b22:	853e                	mv	a0,a5
     b24:	00000097          	auipc	ra,0x0
     b28:	dd2080e7          	jalr	-558(ra) # 8f6 <putc>
     b2c:	aac9                	j	cfe <vprintf+0x23e>
      }
    } else if(state == '%'){
     b2e:	fe042783          	lw	a5,-32(s0)
     b32:	0007871b          	sext.w	a4,a5
     b36:	02500793          	li	a5,37
     b3a:	1cf71263          	bne	a4,a5,cfe <vprintf+0x23e>
      if(c == 'd'){
     b3e:	fdc42783          	lw	a5,-36(s0)
     b42:	0007871b          	sext.w	a4,a5
     b46:	06400793          	li	a5,100
     b4a:	02f71463          	bne	a4,a5,b72 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
     b4e:	fb843783          	ld	a5,-72(s0)
     b52:	00878713          	addi	a4,a5,8
     b56:	fae43c23          	sd	a4,-72(s0)
     b5a:	4398                	lw	a4,0(a5)
     b5c:	fcc42783          	lw	a5,-52(s0)
     b60:	4685                	li	a3,1
     b62:	4629                	li	a2,10
     b64:	85ba                	mv	a1,a4
     b66:	853e                	mv	a0,a5
     b68:	00000097          	auipc	ra,0x0
     b6c:	dc4080e7          	jalr	-572(ra) # 92c <printint>
     b70:	a269                	j	cfa <vprintf+0x23a>
      } else if(c == 'l') {
     b72:	fdc42783          	lw	a5,-36(s0)
     b76:	0007871b          	sext.w	a4,a5
     b7a:	06c00793          	li	a5,108
     b7e:	02f71663          	bne	a4,a5,baa <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
     b82:	fb843783          	ld	a5,-72(s0)
     b86:	00878713          	addi	a4,a5,8
     b8a:	fae43c23          	sd	a4,-72(s0)
     b8e:	639c                	ld	a5,0(a5)
     b90:	0007871b          	sext.w	a4,a5
     b94:	fcc42783          	lw	a5,-52(s0)
     b98:	4681                	li	a3,0
     b9a:	4629                	li	a2,10
     b9c:	85ba                	mv	a1,a4
     b9e:	853e                	mv	a0,a5
     ba0:	00000097          	auipc	ra,0x0
     ba4:	d8c080e7          	jalr	-628(ra) # 92c <printint>
     ba8:	aa89                	j	cfa <vprintf+0x23a>
      } else if(c == 'x') {
     baa:	fdc42783          	lw	a5,-36(s0)
     bae:	0007871b          	sext.w	a4,a5
     bb2:	07800793          	li	a5,120
     bb6:	02f71463          	bne	a4,a5,bde <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
     bba:	fb843783          	ld	a5,-72(s0)
     bbe:	00878713          	addi	a4,a5,8
     bc2:	fae43c23          	sd	a4,-72(s0)
     bc6:	4398                	lw	a4,0(a5)
     bc8:	fcc42783          	lw	a5,-52(s0)
     bcc:	4681                	li	a3,0
     bce:	4641                	li	a2,16
     bd0:	85ba                	mv	a1,a4
     bd2:	853e                	mv	a0,a5
     bd4:	00000097          	auipc	ra,0x0
     bd8:	d58080e7          	jalr	-680(ra) # 92c <printint>
     bdc:	aa39                	j	cfa <vprintf+0x23a>
      } else if(c == 'p') {
     bde:	fdc42783          	lw	a5,-36(s0)
     be2:	0007871b          	sext.w	a4,a5
     be6:	07000793          	li	a5,112
     bea:	02f71263          	bne	a4,a5,c0e <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
     bee:	fb843783          	ld	a5,-72(s0)
     bf2:	00878713          	addi	a4,a5,8
     bf6:	fae43c23          	sd	a4,-72(s0)
     bfa:	6398                	ld	a4,0(a5)
     bfc:	fcc42783          	lw	a5,-52(s0)
     c00:	85ba                	mv	a1,a4
     c02:	853e                	mv	a0,a5
     c04:	00000097          	auipc	ra,0x0
     c08:	e30080e7          	jalr	-464(ra) # a34 <printptr>
     c0c:	a0fd                	j	cfa <vprintf+0x23a>
      } else if(c == 's'){
     c0e:	fdc42783          	lw	a5,-36(s0)
     c12:	0007871b          	sext.w	a4,a5
     c16:	07300793          	li	a5,115
     c1a:	04f71c63          	bne	a4,a5,c72 <vprintf+0x1b2>
        s = va_arg(ap, char*);
     c1e:	fb843783          	ld	a5,-72(s0)
     c22:	00878713          	addi	a4,a5,8
     c26:	fae43c23          	sd	a4,-72(s0)
     c2a:	639c                	ld	a5,0(a5)
     c2c:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
     c30:	fe843783          	ld	a5,-24(s0)
     c34:	eb8d                	bnez	a5,c66 <vprintf+0x1a6>
          s = "(null)";
     c36:	00000797          	auipc	a5,0x0
     c3a:	4ea78793          	addi	a5,a5,1258 # 1120 <malloc+0x1b0>
     c3e:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     c42:	a015                	j	c66 <vprintf+0x1a6>
          putc(fd, *s);
     c44:	fe843783          	ld	a5,-24(s0)
     c48:	0007c703          	lbu	a4,0(a5)
     c4c:	fcc42783          	lw	a5,-52(s0)
     c50:	85ba                	mv	a1,a4
     c52:	853e                	mv	a0,a5
     c54:	00000097          	auipc	ra,0x0
     c58:	ca2080e7          	jalr	-862(ra) # 8f6 <putc>
          s++;
     c5c:	fe843783          	ld	a5,-24(s0)
     c60:	0785                	addi	a5,a5,1
     c62:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     c66:	fe843783          	ld	a5,-24(s0)
     c6a:	0007c783          	lbu	a5,0(a5)
     c6e:	fbf9                	bnez	a5,c44 <vprintf+0x184>
     c70:	a069                	j	cfa <vprintf+0x23a>
        }
      } else if(c == 'c'){
     c72:	fdc42783          	lw	a5,-36(s0)
     c76:	0007871b          	sext.w	a4,a5
     c7a:	06300793          	li	a5,99
     c7e:	02f71463          	bne	a4,a5,ca6 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
     c82:	fb843783          	ld	a5,-72(s0)
     c86:	00878713          	addi	a4,a5,8
     c8a:	fae43c23          	sd	a4,-72(s0)
     c8e:	439c                	lw	a5,0(a5)
     c90:	0ff7f713          	zext.b	a4,a5
     c94:	fcc42783          	lw	a5,-52(s0)
     c98:	85ba                	mv	a1,a4
     c9a:	853e                	mv	a0,a5
     c9c:	00000097          	auipc	ra,0x0
     ca0:	c5a080e7          	jalr	-934(ra) # 8f6 <putc>
     ca4:	a899                	j	cfa <vprintf+0x23a>
      } else if(c == '%'){
     ca6:	fdc42783          	lw	a5,-36(s0)
     caa:	0007871b          	sext.w	a4,a5
     cae:	02500793          	li	a5,37
     cb2:	00f71f63          	bne	a4,a5,cd0 <vprintf+0x210>
        putc(fd, c);
     cb6:	fdc42783          	lw	a5,-36(s0)
     cba:	0ff7f713          	zext.b	a4,a5
     cbe:	fcc42783          	lw	a5,-52(s0)
     cc2:	85ba                	mv	a1,a4
     cc4:	853e                	mv	a0,a5
     cc6:	00000097          	auipc	ra,0x0
     cca:	c30080e7          	jalr	-976(ra) # 8f6 <putc>
     cce:	a035                	j	cfa <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     cd0:	fcc42783          	lw	a5,-52(s0)
     cd4:	02500593          	li	a1,37
     cd8:	853e                	mv	a0,a5
     cda:	00000097          	auipc	ra,0x0
     cde:	c1c080e7          	jalr	-996(ra) # 8f6 <putc>
        putc(fd, c);
     ce2:	fdc42783          	lw	a5,-36(s0)
     ce6:	0ff7f713          	zext.b	a4,a5
     cea:	fcc42783          	lw	a5,-52(s0)
     cee:	85ba                	mv	a1,a4
     cf0:	853e                	mv	a0,a5
     cf2:	00000097          	auipc	ra,0x0
     cf6:	c04080e7          	jalr	-1020(ra) # 8f6 <putc>
      }
      state = 0;
     cfa:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     cfe:	fe442783          	lw	a5,-28(s0)
     d02:	2785                	addiw	a5,a5,1
     d04:	fef42223          	sw	a5,-28(s0)
     d08:	fe442783          	lw	a5,-28(s0)
     d0c:	fc043703          	ld	a4,-64(s0)
     d10:	97ba                	add	a5,a5,a4
     d12:	0007c783          	lbu	a5,0(a5)
     d16:	dc0795e3          	bnez	a5,ae0 <vprintf+0x20>
    }
  }
}
     d1a:	0001                	nop
     d1c:	0001                	nop
     d1e:	60a6                	ld	ra,72(sp)
     d20:	6406                	ld	s0,64(sp)
     d22:	6161                	addi	sp,sp,80
     d24:	8082                	ret

0000000000000d26 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d26:	7159                	addi	sp,sp,-112
     d28:	fc06                	sd	ra,56(sp)
     d2a:	f822                	sd	s0,48(sp)
     d2c:	0080                	addi	s0,sp,64
     d2e:	fcb43823          	sd	a1,-48(s0)
     d32:	e010                	sd	a2,0(s0)
     d34:	e414                	sd	a3,8(s0)
     d36:	e818                	sd	a4,16(s0)
     d38:	ec1c                	sd	a5,24(s0)
     d3a:	03043023          	sd	a6,32(s0)
     d3e:	03143423          	sd	a7,40(s0)
     d42:	87aa                	mv	a5,a0
     d44:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
     d48:	03040793          	addi	a5,s0,48
     d4c:	fcf43423          	sd	a5,-56(s0)
     d50:	fc843783          	ld	a5,-56(s0)
     d54:	fd078793          	addi	a5,a5,-48
     d58:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
     d5c:	fe843703          	ld	a4,-24(s0)
     d60:	fdc42783          	lw	a5,-36(s0)
     d64:	863a                	mv	a2,a4
     d66:	fd043583          	ld	a1,-48(s0)
     d6a:	853e                	mv	a0,a5
     d6c:	00000097          	auipc	ra,0x0
     d70:	d54080e7          	jalr	-684(ra) # ac0 <vprintf>
}
     d74:	0001                	nop
     d76:	70e2                	ld	ra,56(sp)
     d78:	7442                	ld	s0,48(sp)
     d7a:	6165                	addi	sp,sp,112
     d7c:	8082                	ret

0000000000000d7e <printf>:

void
printf(const char *fmt, ...)
{
     d7e:	7159                	addi	sp,sp,-112
     d80:	f406                	sd	ra,40(sp)
     d82:	f022                	sd	s0,32(sp)
     d84:	1800                	addi	s0,sp,48
     d86:	fca43c23          	sd	a0,-40(s0)
     d8a:	e40c                	sd	a1,8(s0)
     d8c:	e810                	sd	a2,16(s0)
     d8e:	ec14                	sd	a3,24(s0)
     d90:	f018                	sd	a4,32(s0)
     d92:	f41c                	sd	a5,40(s0)
     d94:	03043823          	sd	a6,48(s0)
     d98:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     d9c:	04040793          	addi	a5,s0,64
     da0:	fcf43823          	sd	a5,-48(s0)
     da4:	fd043783          	ld	a5,-48(s0)
     da8:	fc878793          	addi	a5,a5,-56
     dac:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
     db0:	fe843783          	ld	a5,-24(s0)
     db4:	863e                	mv	a2,a5
     db6:	fd843583          	ld	a1,-40(s0)
     dba:	4505                	li	a0,1
     dbc:	00000097          	auipc	ra,0x0
     dc0:	d04080e7          	jalr	-764(ra) # ac0 <vprintf>
}
     dc4:	0001                	nop
     dc6:	70a2                	ld	ra,40(sp)
     dc8:	7402                	ld	s0,32(sp)
     dca:	6165                	addi	sp,sp,112
     dcc:	8082                	ret

0000000000000dce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     dce:	7179                	addi	sp,sp,-48
     dd0:	f422                	sd	s0,40(sp)
     dd2:	1800                	addi	s0,sp,48
     dd4:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
     dd8:	fd843783          	ld	a5,-40(s0)
     ddc:	17c1                	addi	a5,a5,-16
     dde:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     de2:	00001797          	auipc	a5,0x1
     de6:	61e78793          	addi	a5,a5,1566 # 2400 <freep>
     dea:	639c                	ld	a5,0(a5)
     dec:	fef43423          	sd	a5,-24(s0)
     df0:	a815                	j	e24 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     df2:	fe843783          	ld	a5,-24(s0)
     df6:	639c                	ld	a5,0(a5)
     df8:	fe843703          	ld	a4,-24(s0)
     dfc:	00f76f63          	bltu	a4,a5,e1a <free+0x4c>
     e00:	fe043703          	ld	a4,-32(s0)
     e04:	fe843783          	ld	a5,-24(s0)
     e08:	02e7eb63          	bltu	a5,a4,e3e <free+0x70>
     e0c:	fe843783          	ld	a5,-24(s0)
     e10:	639c                	ld	a5,0(a5)
     e12:	fe043703          	ld	a4,-32(s0)
     e16:	02f76463          	bltu	a4,a5,e3e <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e1a:	fe843783          	ld	a5,-24(s0)
     e1e:	639c                	ld	a5,0(a5)
     e20:	fef43423          	sd	a5,-24(s0)
     e24:	fe043703          	ld	a4,-32(s0)
     e28:	fe843783          	ld	a5,-24(s0)
     e2c:	fce7f3e3          	bgeu	a5,a4,df2 <free+0x24>
     e30:	fe843783          	ld	a5,-24(s0)
     e34:	639c                	ld	a5,0(a5)
     e36:	fe043703          	ld	a4,-32(s0)
     e3a:	faf77ce3          	bgeu	a4,a5,df2 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
     e3e:	fe043783          	ld	a5,-32(s0)
     e42:	479c                	lw	a5,8(a5)
     e44:	1782                	slli	a5,a5,0x20
     e46:	9381                	srli	a5,a5,0x20
     e48:	0792                	slli	a5,a5,0x4
     e4a:	fe043703          	ld	a4,-32(s0)
     e4e:	973e                	add	a4,a4,a5
     e50:	fe843783          	ld	a5,-24(s0)
     e54:	639c                	ld	a5,0(a5)
     e56:	02f71763          	bne	a4,a5,e84 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
     e5a:	fe043783          	ld	a5,-32(s0)
     e5e:	4798                	lw	a4,8(a5)
     e60:	fe843783          	ld	a5,-24(s0)
     e64:	639c                	ld	a5,0(a5)
     e66:	479c                	lw	a5,8(a5)
     e68:	9fb9                	addw	a5,a5,a4
     e6a:	0007871b          	sext.w	a4,a5
     e6e:	fe043783          	ld	a5,-32(s0)
     e72:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
     e74:	fe843783          	ld	a5,-24(s0)
     e78:	639c                	ld	a5,0(a5)
     e7a:	6398                	ld	a4,0(a5)
     e7c:	fe043783          	ld	a5,-32(s0)
     e80:	e398                	sd	a4,0(a5)
     e82:	a039                	j	e90 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
     e84:	fe843783          	ld	a5,-24(s0)
     e88:	6398                	ld	a4,0(a5)
     e8a:	fe043783          	ld	a5,-32(s0)
     e8e:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
     e90:	fe843783          	ld	a5,-24(s0)
     e94:	479c                	lw	a5,8(a5)
     e96:	1782                	slli	a5,a5,0x20
     e98:	9381                	srli	a5,a5,0x20
     e9a:	0792                	slli	a5,a5,0x4
     e9c:	fe843703          	ld	a4,-24(s0)
     ea0:	97ba                	add	a5,a5,a4
     ea2:	fe043703          	ld	a4,-32(s0)
     ea6:	02f71563          	bne	a4,a5,ed0 <free+0x102>
    p->s.size += bp->s.size;
     eaa:	fe843783          	ld	a5,-24(s0)
     eae:	4798                	lw	a4,8(a5)
     eb0:	fe043783          	ld	a5,-32(s0)
     eb4:	479c                	lw	a5,8(a5)
     eb6:	9fb9                	addw	a5,a5,a4
     eb8:	0007871b          	sext.w	a4,a5
     ebc:	fe843783          	ld	a5,-24(s0)
     ec0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     ec2:	fe043783          	ld	a5,-32(s0)
     ec6:	6398                	ld	a4,0(a5)
     ec8:	fe843783          	ld	a5,-24(s0)
     ecc:	e398                	sd	a4,0(a5)
     ece:	a031                	j	eda <free+0x10c>
  } else
    p->s.ptr = bp;
     ed0:	fe843783          	ld	a5,-24(s0)
     ed4:	fe043703          	ld	a4,-32(s0)
     ed8:	e398                	sd	a4,0(a5)
  freep = p;
     eda:	00001797          	auipc	a5,0x1
     ede:	52678793          	addi	a5,a5,1318 # 2400 <freep>
     ee2:	fe843703          	ld	a4,-24(s0)
     ee6:	e398                	sd	a4,0(a5)
}
     ee8:	0001                	nop
     eea:	7422                	ld	s0,40(sp)
     eec:	6145                	addi	sp,sp,48
     eee:	8082                	ret

0000000000000ef0 <morecore>:

static Header*
morecore(uint nu)
{
     ef0:	7179                	addi	sp,sp,-48
     ef2:	f406                	sd	ra,40(sp)
     ef4:	f022                	sd	s0,32(sp)
     ef6:	1800                	addi	s0,sp,48
     ef8:	87aa                	mv	a5,a0
     efa:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
     efe:	fdc42783          	lw	a5,-36(s0)
     f02:	0007871b          	sext.w	a4,a5
     f06:	6785                	lui	a5,0x1
     f08:	00f77563          	bgeu	a4,a5,f12 <morecore+0x22>
    nu = 4096;
     f0c:	6785                	lui	a5,0x1
     f0e:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
     f12:	fdc42783          	lw	a5,-36(s0)
     f16:	0047979b          	slliw	a5,a5,0x4
     f1a:	2781                	sext.w	a5,a5
     f1c:	2781                	sext.w	a5,a5
     f1e:	853e                	mv	a0,a5
     f20:	00000097          	auipc	ra,0x0
     f24:	9b6080e7          	jalr	-1610(ra) # 8d6 <sbrk>
     f28:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
     f2c:	fe843703          	ld	a4,-24(s0)
     f30:	57fd                	li	a5,-1
     f32:	00f71463          	bne	a4,a5,f3a <morecore+0x4a>
    return 0;
     f36:	4781                	li	a5,0
     f38:	a03d                	j	f66 <morecore+0x76>
  hp = (Header*)p;
     f3a:	fe843783          	ld	a5,-24(s0)
     f3e:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
     f42:	fe043783          	ld	a5,-32(s0)
     f46:	fdc42703          	lw	a4,-36(s0)
     f4a:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
     f4c:	fe043783          	ld	a5,-32(s0)
     f50:	07c1                	addi	a5,a5,16 # 1010 <malloc+0xa0>
     f52:	853e                	mv	a0,a5
     f54:	00000097          	auipc	ra,0x0
     f58:	e7a080e7          	jalr	-390(ra) # dce <free>
  return freep;
     f5c:	00001797          	auipc	a5,0x1
     f60:	4a478793          	addi	a5,a5,1188 # 2400 <freep>
     f64:	639c                	ld	a5,0(a5)
}
     f66:	853e                	mv	a0,a5
     f68:	70a2                	ld	ra,40(sp)
     f6a:	7402                	ld	s0,32(sp)
     f6c:	6145                	addi	sp,sp,48
     f6e:	8082                	ret

0000000000000f70 <malloc>:

void*
malloc(uint nbytes)
{
     f70:	7139                	addi	sp,sp,-64
     f72:	fc06                	sd	ra,56(sp)
     f74:	f822                	sd	s0,48(sp)
     f76:	0080                	addi	s0,sp,64
     f78:	87aa                	mv	a5,a0
     f7a:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f7e:	fcc46783          	lwu	a5,-52(s0)
     f82:	07bd                	addi	a5,a5,15
     f84:	8391                	srli	a5,a5,0x4
     f86:	2781                	sext.w	a5,a5
     f88:	2785                	addiw	a5,a5,1
     f8a:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
     f8e:	00001797          	auipc	a5,0x1
     f92:	47278793          	addi	a5,a5,1138 # 2400 <freep>
     f96:	639c                	ld	a5,0(a5)
     f98:	fef43023          	sd	a5,-32(s0)
     f9c:	fe043783          	ld	a5,-32(s0)
     fa0:	ef95                	bnez	a5,fdc <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
     fa2:	00001797          	auipc	a5,0x1
     fa6:	44e78793          	addi	a5,a5,1102 # 23f0 <base>
     faa:	fef43023          	sd	a5,-32(s0)
     fae:	00001797          	auipc	a5,0x1
     fb2:	45278793          	addi	a5,a5,1106 # 2400 <freep>
     fb6:	fe043703          	ld	a4,-32(s0)
     fba:	e398                	sd	a4,0(a5)
     fbc:	00001797          	auipc	a5,0x1
     fc0:	44478793          	addi	a5,a5,1092 # 2400 <freep>
     fc4:	6398                	ld	a4,0(a5)
     fc6:	00001797          	auipc	a5,0x1
     fca:	42a78793          	addi	a5,a5,1066 # 23f0 <base>
     fce:	e398                	sd	a4,0(a5)
    base.s.size = 0;
     fd0:	00001797          	auipc	a5,0x1
     fd4:	42078793          	addi	a5,a5,1056 # 23f0 <base>
     fd8:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fdc:	fe043783          	ld	a5,-32(s0)
     fe0:	639c                	ld	a5,0(a5)
     fe2:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
     fe6:	fe843783          	ld	a5,-24(s0)
     fea:	4798                	lw	a4,8(a5)
     fec:	fdc42783          	lw	a5,-36(s0)
     ff0:	2781                	sext.w	a5,a5
     ff2:	06f76763          	bltu	a4,a5,1060 <malloc+0xf0>
      if(p->s.size == nunits)
     ff6:	fe843783          	ld	a5,-24(s0)
     ffa:	4798                	lw	a4,8(a5)
     ffc:	fdc42783          	lw	a5,-36(s0)
    1000:	2781                	sext.w	a5,a5
    1002:	00e79963          	bne	a5,a4,1014 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    1006:	fe843783          	ld	a5,-24(s0)
    100a:	6398                	ld	a4,0(a5)
    100c:	fe043783          	ld	a5,-32(s0)
    1010:	e398                	sd	a4,0(a5)
    1012:	a825                	j	104a <malloc+0xda>
      else {
        p->s.size -= nunits;
    1014:	fe843783          	ld	a5,-24(s0)
    1018:	479c                	lw	a5,8(a5)
    101a:	fdc42703          	lw	a4,-36(s0)
    101e:	9f99                	subw	a5,a5,a4
    1020:	0007871b          	sext.w	a4,a5
    1024:	fe843783          	ld	a5,-24(s0)
    1028:	c798                	sw	a4,8(a5)
        p += p->s.size;
    102a:	fe843783          	ld	a5,-24(s0)
    102e:	479c                	lw	a5,8(a5)
    1030:	1782                	slli	a5,a5,0x20
    1032:	9381                	srli	a5,a5,0x20
    1034:	0792                	slli	a5,a5,0x4
    1036:	fe843703          	ld	a4,-24(s0)
    103a:	97ba                	add	a5,a5,a4
    103c:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    1040:	fe843783          	ld	a5,-24(s0)
    1044:	fdc42703          	lw	a4,-36(s0)
    1048:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    104a:	00001797          	auipc	a5,0x1
    104e:	3b678793          	addi	a5,a5,950 # 2400 <freep>
    1052:	fe043703          	ld	a4,-32(s0)
    1056:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    1058:	fe843783          	ld	a5,-24(s0)
    105c:	07c1                	addi	a5,a5,16
    105e:	a091                	j	10a2 <malloc+0x132>
    }
    if(p == freep)
    1060:	00001797          	auipc	a5,0x1
    1064:	3a078793          	addi	a5,a5,928 # 2400 <freep>
    1068:	639c                	ld	a5,0(a5)
    106a:	fe843703          	ld	a4,-24(s0)
    106e:	02f71063          	bne	a4,a5,108e <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    1072:	fdc42783          	lw	a5,-36(s0)
    1076:	853e                	mv	a0,a5
    1078:	00000097          	auipc	ra,0x0
    107c:	e78080e7          	jalr	-392(ra) # ef0 <morecore>
    1080:	fea43423          	sd	a0,-24(s0)
    1084:	fe843783          	ld	a5,-24(s0)
    1088:	e399                	bnez	a5,108e <malloc+0x11e>
        return 0;
    108a:	4781                	li	a5,0
    108c:	a819                	j	10a2 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    108e:	fe843783          	ld	a5,-24(s0)
    1092:	fef43023          	sd	a5,-32(s0)
    1096:	fe843783          	ld	a5,-24(s0)
    109a:	639c                	ld	a5,0(a5)
    109c:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    10a0:	b799                	j	fe6 <malloc+0x76>
  }
}
    10a2:	853e                	mv	a0,a5
    10a4:	70e2                	ld	ra,56(sp)
    10a6:	7442                	ld	s0,48(sp)
    10a8:	6121                	addi	sp,sp,64
    10aa:	8082                	ret
