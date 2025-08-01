/* Part of RMARaceBench, under BSD-3-Clause License
 * See https://github.com/RWTH-HPC/RMARaceBench/LICENSE for license information.
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <shmem.h>
#include <stdio.h>
#include <unistd.h>

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

    if (my_pe == 0) {
#pragma omp parallel num_threads(2)
        {
#pragma omp sections
            {
#pragma omp section
                {
                    int value = 42;
                    // CONFLICT
                    shmem_int_put(&remote, &value, 1, 1); // Put on win_base[0] at process 1
                    shmem_quiet();
                }

#pragma omp section
                {
                    sleep(1); // force that shmem_put goes through first
                    shmem_sync_all();
                }
            }
        }
    }

    if (my_pe == 1) {
        shmem_sync_all();
        // CONFLICT
        printf("remote is %d\n", remote);
    }

    shmem_barrier_all();
    printf("Process %d: Execution finished, variable contents: remote = %d, localbuf = %d\n", my_pe, remote, localbuf);
    shmem_finalize();

    return 0;
}
