/* Part of RMARaceBench, under BSD-3-Clause License
 * See https://github.com/RWTH-HPC/RMARaceBench/LICENSE for license information.
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <shmem.h>
#include <stdio.h>

__attribute__((noinline)) int* aliasgenerator(int** x) { return *x; }

#define PROC_NUM 2

int main(int argc, char** argv)
{
    static int remote = 0;
    int localbuf = 1;

    shmem_init();

    int num_pe = shmem_n_pes();
    int my_pe = shmem_my_pe();

    if (num_pe != PROC_NUM) {
        printf("Got %d PEs, expected %d\n", num_pe, PROC_NUM);
        shmem_global_exit(1);
    }

    shmem_barrier_all();

    int* rem_ptr = &remote;
    int* lbuf_ptr = &localbuf;
    int* rem_ptr_alias;
    int* lbuf_ptr_alias;

    rem_ptr_alias = aliasgenerator(&rem_ptr);
    lbuf_ptr_alias = aliasgenerator(&lbuf_ptr);

    if (my_pe == 0) {
        /* conflicting get and store */
        // CONFLICT
        shmem_int_get(lbuf_ptr, rem_ptr, 1, 1);
    } else {
        // CONFLICT
        *rem_ptr_alias = 42;
    }

    shmem_barrier_all();
    printf("Process %d: Execution finished, variable contents: remote = %d, localbuf = %d\n", my_pe, remote, localbuf);
    shmem_finalize();

    return 0;
}
