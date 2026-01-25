#include "kernel/types.h"
#include "kernel/stat.h"
#include <user/user.h>


int main(int argc, int * argv[]){

    if(argc != 1){
        printf("Hello %s, nice to meet you!\n", argv[1]);
        exit(0);
    }
    
    printf("Hello World\n");
    exit(0);
}