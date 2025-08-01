/* Part of RMARaceBench, under BSD-3-Clause License
 * See https://github.com/RWTH-HPC/RMARaceBench/LICENSE for license information.
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <cuda.h>
#include <nvshmem.h>
#include <nvshmemx.h>
#include <stdio.h>

// Number of processing elements
#define PROC_NUM 2

int main(int argc, char **argv) {
    int remote0, remote1, remote2,
        localbuf0, localbuf1;

    // Initialize NVSHMEM
    nvshmem_init();
    int mype_node = nvshmem_team_my_pe(NVSHMEMX_TEAM_NODE);
    cudaSetDevice(mype_node);

    // Get the number of PEs and the current PE's rank
    int my_pe = nvshmem_my_pe();
    int num_pe = nvshmem_n_pes();

    // Ensure the required number of PEs
    if (num_pe != PROC_NUM) {
        printf("Got %d PEs, expected %d\n", num_pe, PROC_NUM);
        nvshmem_global_exit(1);
    }

    // Allocate symmetric memory on the device
    int *remote_d0 = (int *)nvshmem_malloc(sizeof(int));
    int *remote_d1 = (int *)nvshmem_malloc(sizeof(int));
    int *remote_d2 = (int *)nvshmem_malloc(sizeof(int));
    int *localbuf_d0 = (int *)nvshmem_malloc(sizeof(int));
    int *localbuf_d1 = (int *)nvshmem_malloc(sizeof(int));

    // Initialize memory
    cudaMemset(remote_d0, 0, sizeof(int));
    cudaMemset(remote_d1, 1, sizeof(int));
    cudaMemset(remote_d2, 4, sizeof(int));
    cudaMemset(localbuf_d0, 2, sizeof(int));
    cudaMemset(localbuf_d1, 3, sizeof(int));

    // Synchronize across all PEs
    nvshmem_barrier_all();

    int *target_pe1 = {1};
    int *target_pe2 = {2};
    if (my_pe == 0) {
        // CONFLICT
        nvshmem_int_get_nbi(localbuf_d0, remote_d0, 1, 1);
        nvshmem_int_get_nbi(localbuf_d1, remote_d1, 1, 2);
        nvshmem_pe_quiet(target_pe2, 1);
        // CONFLICT
        nvshmem_int_get_nbi(localbuf_d0, remote_d2, 1, 1);
    }

    // Synchronize across all PEs
    nvshmem_barrier_all();

    // Copy data back to host
    cudaMemcpy(&remote0, remote_d0, sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy(&remote1, remote_d1, sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy(&remote2, remote_d2, sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy(&localbuf0, localbuf_d0, sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy(&localbuf1, localbuf_d1, sizeof(int), cudaMemcpyDeviceToHost);

    // Synchronize again
    nvshmem_barrier_all();

    printf("Process %d: Execution finished, variable contents: remotes = %d, %d, %d, localbufs: %d, %d\n",
           my_pe, remote0, remote1, remote2, localbuf0, localbuf1);

    // Free NVSHMEM symmetric memory
    nvshmem_free(remote_d0);
    nvshmem_free(remote_d1);
    nvshmem_free(remote_d2);
    nvshmem_free(localbuf_d0);
    nvshmem_free(localbuf_d1);

    // Finalize NVSHMEM
    nvshmem_finalize();

    return 0;
}