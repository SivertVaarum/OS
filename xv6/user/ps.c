#include <user/user.h>
#include <kernel/types.h>
#include <kernel/stat.h>
#include <kernel/proc.h>


int main(){

    struct pInfo procs[64];
    int count = getprocs(procs);

    for (int i = 0; i < count; i++)
    {
        printf(1, "PID: %d | Name: %s | State: %d\n", procs[i].name, procs[i].PID, procs[i].state);
    }
    

    exit(0);
}

struct pInfo{
    int PID;
    int state;
    char name[16];
};