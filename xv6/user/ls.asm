
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
     13c:	f7858593          	addi	a1,a1,-136 # 10b0 <malloc+0x148>
     140:	4509                	li	a0,2
     142:	00001097          	auipc	ra,0x1
     146:	bdc080e7          	jalr	-1060(ra) # d1e <fprintf>
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
     16e:	f5e58593          	addi	a1,a1,-162 # 10c8 <malloc+0x160>
     172:	4509                	li	a0,2
     174:	00001097          	auipc	ra,0x1
     178:	baa080e7          	jalr	-1110(ra) # d1e <fprintf>
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
     1d2:	f1250513          	addi	a0,a0,-238 # 10e0 <malloc+0x178>
     1d6:	00001097          	auipc	ra,0x1
     1da:	ba0080e7          	jalr	-1120(ra) # d76 <printf>
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
     202:	ef250513          	addi	a0,a0,-270 # 10f0 <malloc+0x188>
     206:	00001097          	auipc	ra,0x1
     20a:	b70080e7          	jalr	-1168(ra) # d76 <printf>
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
     2a2:	e2a50513          	addi	a0,a0,-470 # 10c8 <malloc+0x160>
     2a6:	00001097          	auipc	ra,0x1
     2aa:	ad0080e7          	jalr	-1328(ra) # d76 <printf>
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
     2d4:	e3850513          	addi	a0,a0,-456 # 1108 <malloc+0x1a0>
     2d8:	00001097          	auipc	ra,0x1
     2dc:	a9e080e7          	jalr	-1378(ra) # d76 <printf>
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
     346:	dd650513          	addi	a0,a0,-554 # 1118 <malloc+0x1b0>
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

00000000000008ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     8ee:	1101                	addi	sp,sp,-32
     8f0:	ec06                	sd	ra,24(sp)
     8f2:	e822                	sd	s0,16(sp)
     8f4:	1000                	addi	s0,sp,32
     8f6:	87aa                	mv	a5,a0
     8f8:	872e                	mv	a4,a1
     8fa:	fef42623          	sw	a5,-20(s0)
     8fe:	87ba                	mv	a5,a4
     900:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
     904:	feb40713          	addi	a4,s0,-21
     908:	fec42783          	lw	a5,-20(s0)
     90c:	4605                	li	a2,1
     90e:	85ba                	mv	a1,a4
     910:	853e                	mv	a0,a5
     912:	00000097          	auipc	ra,0x0
     916:	f5c080e7          	jalr	-164(ra) # 86e <write>
}
     91a:	0001                	nop
     91c:	60e2                	ld	ra,24(sp)
     91e:	6442                	ld	s0,16(sp)
     920:	6105                	addi	sp,sp,32
     922:	8082                	ret

0000000000000924 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     924:	7139                	addi	sp,sp,-64
     926:	fc06                	sd	ra,56(sp)
     928:	f822                	sd	s0,48(sp)
     92a:	0080                	addi	s0,sp,64
     92c:	87aa                	mv	a5,a0
     92e:	8736                	mv	a4,a3
     930:	fcf42623          	sw	a5,-52(s0)
     934:	87ae                	mv	a5,a1
     936:	fcf42423          	sw	a5,-56(s0)
     93a:	87b2                	mv	a5,a2
     93c:	fcf42223          	sw	a5,-60(s0)
     940:	87ba                	mv	a5,a4
     942:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     946:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
     94a:	fc042783          	lw	a5,-64(s0)
     94e:	2781                	sext.w	a5,a5
     950:	c38d                	beqz	a5,972 <printint+0x4e>
     952:	fc842783          	lw	a5,-56(s0)
     956:	2781                	sext.w	a5,a5
     958:	0007dd63          	bgez	a5,972 <printint+0x4e>
    neg = 1;
     95c:	4785                	li	a5,1
     95e:	fef42423          	sw	a5,-24(s0)
    x = -xx;
     962:	fc842783          	lw	a5,-56(s0)
     966:	40f007bb          	negw	a5,a5
     96a:	2781                	sext.w	a5,a5
     96c:	fef42223          	sw	a5,-28(s0)
     970:	a029                	j	97a <printint+0x56>
  } else {
    x = xx;
     972:	fc842783          	lw	a5,-56(s0)
     976:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
     97a:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
     97e:	fc442783          	lw	a5,-60(s0)
     982:	fe442703          	lw	a4,-28(s0)
     986:	02f777bb          	remuw	a5,a4,a5
     98a:	0007861b          	sext.w	a2,a5
     98e:	fec42783          	lw	a5,-20(s0)
     992:	0017871b          	addiw	a4,a5,1
     996:	fee42623          	sw	a4,-20(s0)
     99a:	00002697          	auipc	a3,0x2
     99e:	a2668693          	addi	a3,a3,-1498 # 23c0 <digits>
     9a2:	02061713          	slli	a4,a2,0x20
     9a6:	9301                	srli	a4,a4,0x20
     9a8:	9736                	add	a4,a4,a3
     9aa:	00074703          	lbu	a4,0(a4)
     9ae:	17c1                	addi	a5,a5,-16
     9b0:	97a2                	add	a5,a5,s0
     9b2:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
     9b6:	fc442783          	lw	a5,-60(s0)
     9ba:	fe442703          	lw	a4,-28(s0)
     9be:	02f757bb          	divuw	a5,a4,a5
     9c2:	fef42223          	sw	a5,-28(s0)
     9c6:	fe442783          	lw	a5,-28(s0)
     9ca:	2781                	sext.w	a5,a5
     9cc:	fbcd                	bnez	a5,97e <printint+0x5a>
  if(neg)
     9ce:	fe842783          	lw	a5,-24(s0)
     9d2:	2781                	sext.w	a5,a5
     9d4:	cf85                	beqz	a5,a0c <printint+0xe8>
    buf[i++] = '-';
     9d6:	fec42783          	lw	a5,-20(s0)
     9da:	0017871b          	addiw	a4,a5,1
     9de:	fee42623          	sw	a4,-20(s0)
     9e2:	17c1                	addi	a5,a5,-16
     9e4:	97a2                	add	a5,a5,s0
     9e6:	02d00713          	li	a4,45
     9ea:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
     9ee:	a839                	j	a0c <printint+0xe8>
    putc(fd, buf[i]);
     9f0:	fec42783          	lw	a5,-20(s0)
     9f4:	17c1                	addi	a5,a5,-16
     9f6:	97a2                	add	a5,a5,s0
     9f8:	fe07c703          	lbu	a4,-32(a5)
     9fc:	fcc42783          	lw	a5,-52(s0)
     a00:	85ba                	mv	a1,a4
     a02:	853e                	mv	a0,a5
     a04:	00000097          	auipc	ra,0x0
     a08:	eea080e7          	jalr	-278(ra) # 8ee <putc>
  while(--i >= 0)
     a0c:	fec42783          	lw	a5,-20(s0)
     a10:	37fd                	addiw	a5,a5,-1
     a12:	fef42623          	sw	a5,-20(s0)
     a16:	fec42783          	lw	a5,-20(s0)
     a1a:	2781                	sext.w	a5,a5
     a1c:	fc07dae3          	bgez	a5,9f0 <printint+0xcc>
}
     a20:	0001                	nop
     a22:	0001                	nop
     a24:	70e2                	ld	ra,56(sp)
     a26:	7442                	ld	s0,48(sp)
     a28:	6121                	addi	sp,sp,64
     a2a:	8082                	ret

0000000000000a2c <printptr>:

static void
printptr(int fd, uint64 x) {
     a2c:	7179                	addi	sp,sp,-48
     a2e:	f406                	sd	ra,40(sp)
     a30:	f022                	sd	s0,32(sp)
     a32:	1800                	addi	s0,sp,48
     a34:	87aa                	mv	a5,a0
     a36:	fcb43823          	sd	a1,-48(s0)
     a3a:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
     a3e:	fdc42783          	lw	a5,-36(s0)
     a42:	03000593          	li	a1,48
     a46:	853e                	mv	a0,a5
     a48:	00000097          	auipc	ra,0x0
     a4c:	ea6080e7          	jalr	-346(ra) # 8ee <putc>
  putc(fd, 'x');
     a50:	fdc42783          	lw	a5,-36(s0)
     a54:	07800593          	li	a1,120
     a58:	853e                	mv	a0,a5
     a5a:	00000097          	auipc	ra,0x0
     a5e:	e94080e7          	jalr	-364(ra) # 8ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     a62:	fe042623          	sw	zero,-20(s0)
     a66:	a82d                	j	aa0 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     a68:	fd043783          	ld	a5,-48(s0)
     a6c:	93f1                	srli	a5,a5,0x3c
     a6e:	00002717          	auipc	a4,0x2
     a72:	95270713          	addi	a4,a4,-1710 # 23c0 <digits>
     a76:	97ba                	add	a5,a5,a4
     a78:	0007c703          	lbu	a4,0(a5)
     a7c:	fdc42783          	lw	a5,-36(s0)
     a80:	85ba                	mv	a1,a4
     a82:	853e                	mv	a0,a5
     a84:	00000097          	auipc	ra,0x0
     a88:	e6a080e7          	jalr	-406(ra) # 8ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     a8c:	fec42783          	lw	a5,-20(s0)
     a90:	2785                	addiw	a5,a5,1
     a92:	fef42623          	sw	a5,-20(s0)
     a96:	fd043783          	ld	a5,-48(s0)
     a9a:	0792                	slli	a5,a5,0x4
     a9c:	fcf43823          	sd	a5,-48(s0)
     aa0:	fec42783          	lw	a5,-20(s0)
     aa4:	873e                	mv	a4,a5
     aa6:	47bd                	li	a5,15
     aa8:	fce7f0e3          	bgeu	a5,a4,a68 <printptr+0x3c>
}
     aac:	0001                	nop
     aae:	0001                	nop
     ab0:	70a2                	ld	ra,40(sp)
     ab2:	7402                	ld	s0,32(sp)
     ab4:	6145                	addi	sp,sp,48
     ab6:	8082                	ret

0000000000000ab8 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ab8:	715d                	addi	sp,sp,-80
     aba:	e486                	sd	ra,72(sp)
     abc:	e0a2                	sd	s0,64(sp)
     abe:	0880                	addi	s0,sp,80
     ac0:	87aa                	mv	a5,a0
     ac2:	fcb43023          	sd	a1,-64(s0)
     ac6:	fac43c23          	sd	a2,-72(s0)
     aca:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
     ace:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     ad2:	fe042223          	sw	zero,-28(s0)
     ad6:	a42d                	j	d00 <vprintf+0x248>
    c = fmt[i] & 0xff;
     ad8:	fe442783          	lw	a5,-28(s0)
     adc:	fc043703          	ld	a4,-64(s0)
     ae0:	97ba                	add	a5,a5,a4
     ae2:	0007c783          	lbu	a5,0(a5)
     ae6:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
     aea:	fe042783          	lw	a5,-32(s0)
     aee:	2781                	sext.w	a5,a5
     af0:	eb9d                	bnez	a5,b26 <vprintf+0x6e>
      if(c == '%'){
     af2:	fdc42783          	lw	a5,-36(s0)
     af6:	0007871b          	sext.w	a4,a5
     afa:	02500793          	li	a5,37
     afe:	00f71763          	bne	a4,a5,b0c <vprintf+0x54>
        state = '%';
     b02:	02500793          	li	a5,37
     b06:	fef42023          	sw	a5,-32(s0)
     b0a:	a2f5                	j	cf6 <vprintf+0x23e>
      } else {
        putc(fd, c);
     b0c:	fdc42783          	lw	a5,-36(s0)
     b10:	0ff7f713          	zext.b	a4,a5
     b14:	fcc42783          	lw	a5,-52(s0)
     b18:	85ba                	mv	a1,a4
     b1a:	853e                	mv	a0,a5
     b1c:	00000097          	auipc	ra,0x0
     b20:	dd2080e7          	jalr	-558(ra) # 8ee <putc>
     b24:	aac9                	j	cf6 <vprintf+0x23e>
      }
    } else if(state == '%'){
     b26:	fe042783          	lw	a5,-32(s0)
     b2a:	0007871b          	sext.w	a4,a5
     b2e:	02500793          	li	a5,37
     b32:	1cf71263          	bne	a4,a5,cf6 <vprintf+0x23e>
      if(c == 'd'){
     b36:	fdc42783          	lw	a5,-36(s0)
     b3a:	0007871b          	sext.w	a4,a5
     b3e:	06400793          	li	a5,100
     b42:	02f71463          	bne	a4,a5,b6a <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
     b46:	fb843783          	ld	a5,-72(s0)
     b4a:	00878713          	addi	a4,a5,8
     b4e:	fae43c23          	sd	a4,-72(s0)
     b52:	4398                	lw	a4,0(a5)
     b54:	fcc42783          	lw	a5,-52(s0)
     b58:	4685                	li	a3,1
     b5a:	4629                	li	a2,10
     b5c:	85ba                	mv	a1,a4
     b5e:	853e                	mv	a0,a5
     b60:	00000097          	auipc	ra,0x0
     b64:	dc4080e7          	jalr	-572(ra) # 924 <printint>
     b68:	a269                	j	cf2 <vprintf+0x23a>
      } else if(c == 'l') {
     b6a:	fdc42783          	lw	a5,-36(s0)
     b6e:	0007871b          	sext.w	a4,a5
     b72:	06c00793          	li	a5,108
     b76:	02f71663          	bne	a4,a5,ba2 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
     b7a:	fb843783          	ld	a5,-72(s0)
     b7e:	00878713          	addi	a4,a5,8
     b82:	fae43c23          	sd	a4,-72(s0)
     b86:	639c                	ld	a5,0(a5)
     b88:	0007871b          	sext.w	a4,a5
     b8c:	fcc42783          	lw	a5,-52(s0)
     b90:	4681                	li	a3,0
     b92:	4629                	li	a2,10
     b94:	85ba                	mv	a1,a4
     b96:	853e                	mv	a0,a5
     b98:	00000097          	auipc	ra,0x0
     b9c:	d8c080e7          	jalr	-628(ra) # 924 <printint>
     ba0:	aa89                	j	cf2 <vprintf+0x23a>
      } else if(c == 'x') {
     ba2:	fdc42783          	lw	a5,-36(s0)
     ba6:	0007871b          	sext.w	a4,a5
     baa:	07800793          	li	a5,120
     bae:	02f71463          	bne	a4,a5,bd6 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
     bb2:	fb843783          	ld	a5,-72(s0)
     bb6:	00878713          	addi	a4,a5,8
     bba:	fae43c23          	sd	a4,-72(s0)
     bbe:	4398                	lw	a4,0(a5)
     bc0:	fcc42783          	lw	a5,-52(s0)
     bc4:	4681                	li	a3,0
     bc6:	4641                	li	a2,16
     bc8:	85ba                	mv	a1,a4
     bca:	853e                	mv	a0,a5
     bcc:	00000097          	auipc	ra,0x0
     bd0:	d58080e7          	jalr	-680(ra) # 924 <printint>
     bd4:	aa39                	j	cf2 <vprintf+0x23a>
      } else if(c == 'p') {
     bd6:	fdc42783          	lw	a5,-36(s0)
     bda:	0007871b          	sext.w	a4,a5
     bde:	07000793          	li	a5,112
     be2:	02f71263          	bne	a4,a5,c06 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
     be6:	fb843783          	ld	a5,-72(s0)
     bea:	00878713          	addi	a4,a5,8
     bee:	fae43c23          	sd	a4,-72(s0)
     bf2:	6398                	ld	a4,0(a5)
     bf4:	fcc42783          	lw	a5,-52(s0)
     bf8:	85ba                	mv	a1,a4
     bfa:	853e                	mv	a0,a5
     bfc:	00000097          	auipc	ra,0x0
     c00:	e30080e7          	jalr	-464(ra) # a2c <printptr>
     c04:	a0fd                	j	cf2 <vprintf+0x23a>
      } else if(c == 's'){
     c06:	fdc42783          	lw	a5,-36(s0)
     c0a:	0007871b          	sext.w	a4,a5
     c0e:	07300793          	li	a5,115
     c12:	04f71c63          	bne	a4,a5,c6a <vprintf+0x1b2>
        s = va_arg(ap, char*);
     c16:	fb843783          	ld	a5,-72(s0)
     c1a:	00878713          	addi	a4,a5,8
     c1e:	fae43c23          	sd	a4,-72(s0)
     c22:	639c                	ld	a5,0(a5)
     c24:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
     c28:	fe843783          	ld	a5,-24(s0)
     c2c:	eb8d                	bnez	a5,c5e <vprintf+0x1a6>
          s = "(null)";
     c2e:	00000797          	auipc	a5,0x0
     c32:	4f278793          	addi	a5,a5,1266 # 1120 <malloc+0x1b8>
     c36:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     c3a:	a015                	j	c5e <vprintf+0x1a6>
          putc(fd, *s);
     c3c:	fe843783          	ld	a5,-24(s0)
     c40:	0007c703          	lbu	a4,0(a5)
     c44:	fcc42783          	lw	a5,-52(s0)
     c48:	85ba                	mv	a1,a4
     c4a:	853e                	mv	a0,a5
     c4c:	00000097          	auipc	ra,0x0
     c50:	ca2080e7          	jalr	-862(ra) # 8ee <putc>
          s++;
     c54:	fe843783          	ld	a5,-24(s0)
     c58:	0785                	addi	a5,a5,1
     c5a:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     c5e:	fe843783          	ld	a5,-24(s0)
     c62:	0007c783          	lbu	a5,0(a5)
     c66:	fbf9                	bnez	a5,c3c <vprintf+0x184>
     c68:	a069                	j	cf2 <vprintf+0x23a>
        }
      } else if(c == 'c'){
     c6a:	fdc42783          	lw	a5,-36(s0)
     c6e:	0007871b          	sext.w	a4,a5
     c72:	06300793          	li	a5,99
     c76:	02f71463          	bne	a4,a5,c9e <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
     c7a:	fb843783          	ld	a5,-72(s0)
     c7e:	00878713          	addi	a4,a5,8
     c82:	fae43c23          	sd	a4,-72(s0)
     c86:	439c                	lw	a5,0(a5)
     c88:	0ff7f713          	zext.b	a4,a5
     c8c:	fcc42783          	lw	a5,-52(s0)
     c90:	85ba                	mv	a1,a4
     c92:	853e                	mv	a0,a5
     c94:	00000097          	auipc	ra,0x0
     c98:	c5a080e7          	jalr	-934(ra) # 8ee <putc>
     c9c:	a899                	j	cf2 <vprintf+0x23a>
      } else if(c == '%'){
     c9e:	fdc42783          	lw	a5,-36(s0)
     ca2:	0007871b          	sext.w	a4,a5
     ca6:	02500793          	li	a5,37
     caa:	00f71f63          	bne	a4,a5,cc8 <vprintf+0x210>
        putc(fd, c);
     cae:	fdc42783          	lw	a5,-36(s0)
     cb2:	0ff7f713          	zext.b	a4,a5
     cb6:	fcc42783          	lw	a5,-52(s0)
     cba:	85ba                	mv	a1,a4
     cbc:	853e                	mv	a0,a5
     cbe:	00000097          	auipc	ra,0x0
     cc2:	c30080e7          	jalr	-976(ra) # 8ee <putc>
     cc6:	a035                	j	cf2 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     cc8:	fcc42783          	lw	a5,-52(s0)
     ccc:	02500593          	li	a1,37
     cd0:	853e                	mv	a0,a5
     cd2:	00000097          	auipc	ra,0x0
     cd6:	c1c080e7          	jalr	-996(ra) # 8ee <putc>
        putc(fd, c);
     cda:	fdc42783          	lw	a5,-36(s0)
     cde:	0ff7f713          	zext.b	a4,a5
     ce2:	fcc42783          	lw	a5,-52(s0)
     ce6:	85ba                	mv	a1,a4
     ce8:	853e                	mv	a0,a5
     cea:	00000097          	auipc	ra,0x0
     cee:	c04080e7          	jalr	-1020(ra) # 8ee <putc>
      }
      state = 0;
     cf2:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     cf6:	fe442783          	lw	a5,-28(s0)
     cfa:	2785                	addiw	a5,a5,1
     cfc:	fef42223          	sw	a5,-28(s0)
     d00:	fe442783          	lw	a5,-28(s0)
     d04:	fc043703          	ld	a4,-64(s0)
     d08:	97ba                	add	a5,a5,a4
     d0a:	0007c783          	lbu	a5,0(a5)
     d0e:	dc0795e3          	bnez	a5,ad8 <vprintf+0x20>
    }
  }
}
     d12:	0001                	nop
     d14:	0001                	nop
     d16:	60a6                	ld	ra,72(sp)
     d18:	6406                	ld	s0,64(sp)
     d1a:	6161                	addi	sp,sp,80
     d1c:	8082                	ret

0000000000000d1e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d1e:	7159                	addi	sp,sp,-112
     d20:	fc06                	sd	ra,56(sp)
     d22:	f822                	sd	s0,48(sp)
     d24:	0080                	addi	s0,sp,64
     d26:	fcb43823          	sd	a1,-48(s0)
     d2a:	e010                	sd	a2,0(s0)
     d2c:	e414                	sd	a3,8(s0)
     d2e:	e818                	sd	a4,16(s0)
     d30:	ec1c                	sd	a5,24(s0)
     d32:	03043023          	sd	a6,32(s0)
     d36:	03143423          	sd	a7,40(s0)
     d3a:	87aa                	mv	a5,a0
     d3c:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
     d40:	03040793          	addi	a5,s0,48
     d44:	fcf43423          	sd	a5,-56(s0)
     d48:	fc843783          	ld	a5,-56(s0)
     d4c:	fd078793          	addi	a5,a5,-48
     d50:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
     d54:	fe843703          	ld	a4,-24(s0)
     d58:	fdc42783          	lw	a5,-36(s0)
     d5c:	863a                	mv	a2,a4
     d5e:	fd043583          	ld	a1,-48(s0)
     d62:	853e                	mv	a0,a5
     d64:	00000097          	auipc	ra,0x0
     d68:	d54080e7          	jalr	-684(ra) # ab8 <vprintf>
}
     d6c:	0001                	nop
     d6e:	70e2                	ld	ra,56(sp)
     d70:	7442                	ld	s0,48(sp)
     d72:	6165                	addi	sp,sp,112
     d74:	8082                	ret

0000000000000d76 <printf>:

void
printf(const char *fmt, ...)
{
     d76:	7159                	addi	sp,sp,-112
     d78:	f406                	sd	ra,40(sp)
     d7a:	f022                	sd	s0,32(sp)
     d7c:	1800                	addi	s0,sp,48
     d7e:	fca43c23          	sd	a0,-40(s0)
     d82:	e40c                	sd	a1,8(s0)
     d84:	e810                	sd	a2,16(s0)
     d86:	ec14                	sd	a3,24(s0)
     d88:	f018                	sd	a4,32(s0)
     d8a:	f41c                	sd	a5,40(s0)
     d8c:	03043823          	sd	a6,48(s0)
     d90:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     d94:	04040793          	addi	a5,s0,64
     d98:	fcf43823          	sd	a5,-48(s0)
     d9c:	fd043783          	ld	a5,-48(s0)
     da0:	fc878793          	addi	a5,a5,-56
     da4:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
     da8:	fe843783          	ld	a5,-24(s0)
     dac:	863e                	mv	a2,a5
     dae:	fd843583          	ld	a1,-40(s0)
     db2:	4505                	li	a0,1
     db4:	00000097          	auipc	ra,0x0
     db8:	d04080e7          	jalr	-764(ra) # ab8 <vprintf>
}
     dbc:	0001                	nop
     dbe:	70a2                	ld	ra,40(sp)
     dc0:	7402                	ld	s0,32(sp)
     dc2:	6165                	addi	sp,sp,112
     dc4:	8082                	ret

0000000000000dc6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     dc6:	7179                	addi	sp,sp,-48
     dc8:	f422                	sd	s0,40(sp)
     dca:	1800                	addi	s0,sp,48
     dcc:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
     dd0:	fd843783          	ld	a5,-40(s0)
     dd4:	17c1                	addi	a5,a5,-16
     dd6:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     dda:	00001797          	auipc	a5,0x1
     dde:	62678793          	addi	a5,a5,1574 # 2400 <freep>
     de2:	639c                	ld	a5,0(a5)
     de4:	fef43423          	sd	a5,-24(s0)
     de8:	a815                	j	e1c <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     dea:	fe843783          	ld	a5,-24(s0)
     dee:	639c                	ld	a5,0(a5)
     df0:	fe843703          	ld	a4,-24(s0)
     df4:	00f76f63          	bltu	a4,a5,e12 <free+0x4c>
     df8:	fe043703          	ld	a4,-32(s0)
     dfc:	fe843783          	ld	a5,-24(s0)
     e00:	02e7eb63          	bltu	a5,a4,e36 <free+0x70>
     e04:	fe843783          	ld	a5,-24(s0)
     e08:	639c                	ld	a5,0(a5)
     e0a:	fe043703          	ld	a4,-32(s0)
     e0e:	02f76463          	bltu	a4,a5,e36 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e12:	fe843783          	ld	a5,-24(s0)
     e16:	639c                	ld	a5,0(a5)
     e18:	fef43423          	sd	a5,-24(s0)
     e1c:	fe043703          	ld	a4,-32(s0)
     e20:	fe843783          	ld	a5,-24(s0)
     e24:	fce7f3e3          	bgeu	a5,a4,dea <free+0x24>
     e28:	fe843783          	ld	a5,-24(s0)
     e2c:	639c                	ld	a5,0(a5)
     e2e:	fe043703          	ld	a4,-32(s0)
     e32:	faf77ce3          	bgeu	a4,a5,dea <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
     e36:	fe043783          	ld	a5,-32(s0)
     e3a:	479c                	lw	a5,8(a5)
     e3c:	1782                	slli	a5,a5,0x20
     e3e:	9381                	srli	a5,a5,0x20
     e40:	0792                	slli	a5,a5,0x4
     e42:	fe043703          	ld	a4,-32(s0)
     e46:	973e                	add	a4,a4,a5
     e48:	fe843783          	ld	a5,-24(s0)
     e4c:	639c                	ld	a5,0(a5)
     e4e:	02f71763          	bne	a4,a5,e7c <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
     e52:	fe043783          	ld	a5,-32(s0)
     e56:	4798                	lw	a4,8(a5)
     e58:	fe843783          	ld	a5,-24(s0)
     e5c:	639c                	ld	a5,0(a5)
     e5e:	479c                	lw	a5,8(a5)
     e60:	9fb9                	addw	a5,a5,a4
     e62:	0007871b          	sext.w	a4,a5
     e66:	fe043783          	ld	a5,-32(s0)
     e6a:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
     e6c:	fe843783          	ld	a5,-24(s0)
     e70:	639c                	ld	a5,0(a5)
     e72:	6398                	ld	a4,0(a5)
     e74:	fe043783          	ld	a5,-32(s0)
     e78:	e398                	sd	a4,0(a5)
     e7a:	a039                	j	e88 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
     e7c:	fe843783          	ld	a5,-24(s0)
     e80:	6398                	ld	a4,0(a5)
     e82:	fe043783          	ld	a5,-32(s0)
     e86:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
     e88:	fe843783          	ld	a5,-24(s0)
     e8c:	479c                	lw	a5,8(a5)
     e8e:	1782                	slli	a5,a5,0x20
     e90:	9381                	srli	a5,a5,0x20
     e92:	0792                	slli	a5,a5,0x4
     e94:	fe843703          	ld	a4,-24(s0)
     e98:	97ba                	add	a5,a5,a4
     e9a:	fe043703          	ld	a4,-32(s0)
     e9e:	02f71563          	bne	a4,a5,ec8 <free+0x102>
    p->s.size += bp->s.size;
     ea2:	fe843783          	ld	a5,-24(s0)
     ea6:	4798                	lw	a4,8(a5)
     ea8:	fe043783          	ld	a5,-32(s0)
     eac:	479c                	lw	a5,8(a5)
     eae:	9fb9                	addw	a5,a5,a4
     eb0:	0007871b          	sext.w	a4,a5
     eb4:	fe843783          	ld	a5,-24(s0)
     eb8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     eba:	fe043783          	ld	a5,-32(s0)
     ebe:	6398                	ld	a4,0(a5)
     ec0:	fe843783          	ld	a5,-24(s0)
     ec4:	e398                	sd	a4,0(a5)
     ec6:	a031                	j	ed2 <free+0x10c>
  } else
    p->s.ptr = bp;
     ec8:	fe843783          	ld	a5,-24(s0)
     ecc:	fe043703          	ld	a4,-32(s0)
     ed0:	e398                	sd	a4,0(a5)
  freep = p;
     ed2:	00001797          	auipc	a5,0x1
     ed6:	52e78793          	addi	a5,a5,1326 # 2400 <freep>
     eda:	fe843703          	ld	a4,-24(s0)
     ede:	e398                	sd	a4,0(a5)
}
     ee0:	0001                	nop
     ee2:	7422                	ld	s0,40(sp)
     ee4:	6145                	addi	sp,sp,48
     ee6:	8082                	ret

0000000000000ee8 <morecore>:

static Header*
morecore(uint nu)
{
     ee8:	7179                	addi	sp,sp,-48
     eea:	f406                	sd	ra,40(sp)
     eec:	f022                	sd	s0,32(sp)
     eee:	1800                	addi	s0,sp,48
     ef0:	87aa                	mv	a5,a0
     ef2:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
     ef6:	fdc42783          	lw	a5,-36(s0)
     efa:	0007871b          	sext.w	a4,a5
     efe:	6785                	lui	a5,0x1
     f00:	00f77563          	bgeu	a4,a5,f0a <morecore+0x22>
    nu = 4096;
     f04:	6785                	lui	a5,0x1
     f06:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
     f0a:	fdc42783          	lw	a5,-36(s0)
     f0e:	0047979b          	slliw	a5,a5,0x4
     f12:	2781                	sext.w	a5,a5
     f14:	2781                	sext.w	a5,a5
     f16:	853e                	mv	a0,a5
     f18:	00000097          	auipc	ra,0x0
     f1c:	9be080e7          	jalr	-1602(ra) # 8d6 <sbrk>
     f20:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
     f24:	fe843703          	ld	a4,-24(s0)
     f28:	57fd                	li	a5,-1
     f2a:	00f71463          	bne	a4,a5,f32 <morecore+0x4a>
    return 0;
     f2e:	4781                	li	a5,0
     f30:	a03d                	j	f5e <morecore+0x76>
  hp = (Header*)p;
     f32:	fe843783          	ld	a5,-24(s0)
     f36:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
     f3a:	fe043783          	ld	a5,-32(s0)
     f3e:	fdc42703          	lw	a4,-36(s0)
     f42:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
     f44:	fe043783          	ld	a5,-32(s0)
     f48:	07c1                	addi	a5,a5,16 # 1010 <malloc+0xa8>
     f4a:	853e                	mv	a0,a5
     f4c:	00000097          	auipc	ra,0x0
     f50:	e7a080e7          	jalr	-390(ra) # dc6 <free>
  return freep;
     f54:	00001797          	auipc	a5,0x1
     f58:	4ac78793          	addi	a5,a5,1196 # 2400 <freep>
     f5c:	639c                	ld	a5,0(a5)
}
     f5e:	853e                	mv	a0,a5
     f60:	70a2                	ld	ra,40(sp)
     f62:	7402                	ld	s0,32(sp)
     f64:	6145                	addi	sp,sp,48
     f66:	8082                	ret

0000000000000f68 <malloc>:

void*
malloc(uint nbytes)
{
     f68:	7139                	addi	sp,sp,-64
     f6a:	fc06                	sd	ra,56(sp)
     f6c:	f822                	sd	s0,48(sp)
     f6e:	0080                	addi	s0,sp,64
     f70:	87aa                	mv	a5,a0
     f72:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f76:	fcc46783          	lwu	a5,-52(s0)
     f7a:	07bd                	addi	a5,a5,15
     f7c:	8391                	srli	a5,a5,0x4
     f7e:	2781                	sext.w	a5,a5
     f80:	2785                	addiw	a5,a5,1
     f82:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
     f86:	00001797          	auipc	a5,0x1
     f8a:	47a78793          	addi	a5,a5,1146 # 2400 <freep>
     f8e:	639c                	ld	a5,0(a5)
     f90:	fef43023          	sd	a5,-32(s0)
     f94:	fe043783          	ld	a5,-32(s0)
     f98:	ef95                	bnez	a5,fd4 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
     f9a:	00001797          	auipc	a5,0x1
     f9e:	45678793          	addi	a5,a5,1110 # 23f0 <base>
     fa2:	fef43023          	sd	a5,-32(s0)
     fa6:	00001797          	auipc	a5,0x1
     faa:	45a78793          	addi	a5,a5,1114 # 2400 <freep>
     fae:	fe043703          	ld	a4,-32(s0)
     fb2:	e398                	sd	a4,0(a5)
     fb4:	00001797          	auipc	a5,0x1
     fb8:	44c78793          	addi	a5,a5,1100 # 2400 <freep>
     fbc:	6398                	ld	a4,0(a5)
     fbe:	00001797          	auipc	a5,0x1
     fc2:	43278793          	addi	a5,a5,1074 # 23f0 <base>
     fc6:	e398                	sd	a4,0(a5)
    base.s.size = 0;
     fc8:	00001797          	auipc	a5,0x1
     fcc:	42878793          	addi	a5,a5,1064 # 23f0 <base>
     fd0:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fd4:	fe043783          	ld	a5,-32(s0)
     fd8:	639c                	ld	a5,0(a5)
     fda:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
     fde:	fe843783          	ld	a5,-24(s0)
     fe2:	4798                	lw	a4,8(a5)
     fe4:	fdc42783          	lw	a5,-36(s0)
     fe8:	2781                	sext.w	a5,a5
     fea:	06f76763          	bltu	a4,a5,1058 <malloc+0xf0>
      if(p->s.size == nunits)
     fee:	fe843783          	ld	a5,-24(s0)
     ff2:	4798                	lw	a4,8(a5)
     ff4:	fdc42783          	lw	a5,-36(s0)
     ff8:	2781                	sext.w	a5,a5
     ffa:	00e79963          	bne	a5,a4,100c <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
     ffe:	fe843783          	ld	a5,-24(s0)
    1002:	6398                	ld	a4,0(a5)
    1004:	fe043783          	ld	a5,-32(s0)
    1008:	e398                	sd	a4,0(a5)
    100a:	a825                	j	1042 <malloc+0xda>
      else {
        p->s.size -= nunits;
    100c:	fe843783          	ld	a5,-24(s0)
    1010:	479c                	lw	a5,8(a5)
    1012:	fdc42703          	lw	a4,-36(s0)
    1016:	9f99                	subw	a5,a5,a4
    1018:	0007871b          	sext.w	a4,a5
    101c:	fe843783          	ld	a5,-24(s0)
    1020:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1022:	fe843783          	ld	a5,-24(s0)
    1026:	479c                	lw	a5,8(a5)
    1028:	1782                	slli	a5,a5,0x20
    102a:	9381                	srli	a5,a5,0x20
    102c:	0792                	slli	a5,a5,0x4
    102e:	fe843703          	ld	a4,-24(s0)
    1032:	97ba                	add	a5,a5,a4
    1034:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    1038:	fe843783          	ld	a5,-24(s0)
    103c:	fdc42703          	lw	a4,-36(s0)
    1040:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    1042:	00001797          	auipc	a5,0x1
    1046:	3be78793          	addi	a5,a5,958 # 2400 <freep>
    104a:	fe043703          	ld	a4,-32(s0)
    104e:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    1050:	fe843783          	ld	a5,-24(s0)
    1054:	07c1                	addi	a5,a5,16
    1056:	a091                	j	109a <malloc+0x132>
    }
    if(p == freep)
    1058:	00001797          	auipc	a5,0x1
    105c:	3a878793          	addi	a5,a5,936 # 2400 <freep>
    1060:	639c                	ld	a5,0(a5)
    1062:	fe843703          	ld	a4,-24(s0)
    1066:	02f71063          	bne	a4,a5,1086 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    106a:	fdc42783          	lw	a5,-36(s0)
    106e:	853e                	mv	a0,a5
    1070:	00000097          	auipc	ra,0x0
    1074:	e78080e7          	jalr	-392(ra) # ee8 <morecore>
    1078:	fea43423          	sd	a0,-24(s0)
    107c:	fe843783          	ld	a5,-24(s0)
    1080:	e399                	bnez	a5,1086 <malloc+0x11e>
        return 0;
    1082:	4781                	li	a5,0
    1084:	a819                	j	109a <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1086:	fe843783          	ld	a5,-24(s0)
    108a:	fef43023          	sd	a5,-32(s0)
    108e:	fe843783          	ld	a5,-24(s0)
    1092:	639c                	ld	a5,0(a5)
    1094:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    1098:	b799                	j	fde <malloc+0x76>
  }
}
    109a:	853e                	mv	a0,a5
    109c:	70e2                	ld	ra,56(sp)
    109e:	7442                	ld	s0,48(sp)
    10a0:	6121                	addi	sp,sp,64
    10a2:	8082                	ret
