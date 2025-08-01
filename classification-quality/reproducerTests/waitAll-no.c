#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    MPI_Init(&argc, &argv);

    int rank, size;
    const int N = 10;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int data[N];
    for (int i = 0; i < N; ++i)
        data[i] = rank * N + i;

    int *recv_vals = malloc(N * sizeof(int));
    int *send_vals = malloc(N * sizeof(int));
    MPI_Request *requests = malloc(2 * N * sizeof(MPI_Request));

    for (int i = 0; i < N; ++i) {
        send_vals[i] = data[i];
        int right = (rank + 1) % size;
        int left = (rank - 1 + size) % size;

        MPI_Irecv(&recv_vals[i], 1, MPI_INT, left, i, MPI_COMM_WORLD, &requests[2 * i]);
        MPI_Isend(&send_vals[i], 1, MPI_INT, right, i, MPI_COMM_WORLD, &requests[2 * i + 1]);
    }

    MPI_Waitall(2 * N, requests, MPI_STATUSES_IGNORE);

    printf("Rank %d received:", rank);
    for (int i = 0; i < N; ++i)
        printf(" %d", recv_vals[i]);
    printf("\n");

    printf("Rank %d sent:    ", rank);
    for (int i = 0; i < N; ++i)
        printf(" %d", send_vals[i]);
    printf("\n");

    free(recv_vals);
    free(send_vals);
    free(requests);

    MPI_Finalize();
    return 0;
}
