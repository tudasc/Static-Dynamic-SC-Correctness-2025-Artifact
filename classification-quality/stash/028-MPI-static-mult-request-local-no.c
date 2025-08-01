/* Part of RMARaceBench, under BSD-3-Clause License
 * See https://github.com/RWTH-HPC/RMARaceBench/LICENSE for license information.
 * SPDX-License-Identifier: BSD-3-Clause
 */
 
#include <mpi.h>
#include <stdio.h>

#define PROC_NUM 2
#define ARR_SIZE 100

int main(int argc, char** argv) {
    int rank;
    int arr[ARR_SIZE];
    int packet_size = ARR_SIZE / 4;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    for (int i = 0; i < ARR_SIZE; i++) {
        arr[i] = i * rank;
    }

    MPI_Request req0, req1, req2;
    MPI_Status stat;

    MPI_Barrier(MPI_COMM_WORLD);

    if (rank == 0) {
        MPI_Irecv(arr, packet_size, MPI_INT, 1, 0, MPI_COMM_WORLD, &req0);
        MPI_Irecv(arr+packet_size, packet_size, MPI_INT, 1, 0, MPI_COMM_WORLD, &req1);
        MPI_Wait(&req0, &stat);

        /* no data race, reqs[0] is guaranteed to have finished here */
        MPI_Irecv(arr, packet_size, MPI_INT, 1, 0, MPI_COMM_WORLD, &req2);

    } else {
        MPI_Isend(arr, packet_size, MPI_INT, 0, 0, MPI_COMM_WORLD, &req0);
        MPI_Isend(arr+packet_size, packet_size, MPI_INT, 0, 0, MPI_COMM_WORLD, &req1);
        MPI_Wait(&req0, &stat);
        MPI_Isend(arr, packet_size, MPI_INT, 0, 0, MPI_COMM_WORLD, &req2);
    }

    MPI_Barrier(MPI_COMM_WORLD);

    int sum = 0;
    for (int i = 0; i < ARR_SIZE; i++) {
        sum += arr[i];
    }
    printf("Process %d finished. Array sum %d\n", rank, sum);

    MPI_Finalize();

    return 0;
}
