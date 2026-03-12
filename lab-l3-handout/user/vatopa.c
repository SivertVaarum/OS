#include "user/user.h"
#include "kernel/syscall.h"
#include "kernel/types.h"
#include "kernel/stat.h"

int main(int argc, char *argv[]){

    int pid;
    char vaddr;

    if(argc != 3 && argc != 2){
        printf("Usage: vatopa virtual_address [pid]");
        exit(0);
    }
    if(argc == 3){
        vaddr = atoi(argv[1]);
        pid = atoi(argv[2]);
    }
    if(argc == 2){
        pid = 0;
        vaddr = atoi(argv[1]);
    }

    printf("0x%x\n", va2pa(vaddr, pid));
    
}