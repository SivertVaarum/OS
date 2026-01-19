#include <stdio.h>
#include <windows.h>
#include <string.h>
#include <stdlib.h>


int main(int argc, char *argv[]){

    if(argv[1] == NULL){
        //TODO if argv is null: get working dir.
    }

    char path[MAX_PATH] = argv[1]; //MAX PATH is constant for max path length of 260 characters.
    int fileCount = 0;
    char **fileNames = NULL;

    fileNames = malloc(sizeof(char *));

    

}



